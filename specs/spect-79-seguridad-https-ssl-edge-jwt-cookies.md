# Spec: HTTPS con SSL Termination en nginx - Seguridad JWT y Cookies

## 1. Resumen

Se establece el modelo de despliegue con HTTPS terminando en un proxy reverso nginx (host en producción), permitiendo que el tráfico interno entre contenedores siga siendo HTTP. Para que este modelo sea seguro y coherente, se realizan ajustes en la autenticación JWT y en las cookies:

- Las audiencias JWT se fijan **siempre** en las variantes HTTP (sin SSL), tanto en generación como en validación. El HTTPS externo nunca debe influir en las audiencias.
- La redirección HTTPS se elimina de las aplicaciones (la realiza únicamente nginx).
- `UseSsl` queda en `false` en todas las configuraciones y deja de ser usado para decidir redirección o audiencias.
- El estado HTTPS efectivo del request (via `X-Forwarded-Proto` procesado por `ForwardedHeaders`) se usa **únicamente** para determinar si la cookie de autenticación lleva el flag `Secure`.

## 2. Contexto

- **Capa:** Multi-capa: API, GymFrontend y BL (utilidad compartida de generación/validación JWT)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Utilidad | `BL/Utils/JwtTokenGenerator.cs` | Generación y validación de tokens JWT, compartida entre API y GymFrontend | — |
| Configuración | `API/Program.cs` | Configuración del middleware JWT, ForwardedHeaders y pipeline HTTP de la API | — |
| Configuración | `GymFrontend/Program.cs` | Configuración del middleware JWT, ForwardedHeaders y pipeline HTTP del frontend | — |
| Servicio | `GymFrontend/Services/CookieService.cs` | Define las opciones de las cookies de autenticación (no se modifica, se referencia) | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| nginx reverso proxy | Externo | Termina TLS en el host; envía `X-Forwarded-*` mediante `proxy_set_header`. Fuera del alcance de este spec (config actualizada ya contemplada, pendiente de agregar al repositorio) |
| Middleware `ForwardedHeaders` | Infraestructura | Propaga el scheme original del cliente (`X-Forwarded-Proto`) a `Request.IsHttps` cuando el proxy es confiable |
| JWT Bearer | Autenticación | Validación de tokens con audiencias fijas en ambas aplicaciones |

## 3. Cambios a realizar

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `BL/Utils/JwtTokenGenerator.cs` | Fijar modo sin SSL en generación y audiencias HTTP en validación |
| `API/Program.cs` | Audiencia fija HTTP y eliminación de la redirección HTTPS |
| `GymFrontend/Program.cs` | Audiencia fija HTTP, agregar IP del proxy a los conocidos y eliminación de la redirección HTTPS |
| `GymFrontend/Services/CookieService.cs` | Sin cambios (ya resuelve `Secure` según el estado HTTPS efectivo del request) |

### 3.2 Contrato

- **Generación de tokens:** ambos métodos (AccessToken e IdToken) generan con audiencias HTTP internas sin importar variables de entorno ni scheme del request.
- **Validación manual de tokens:** ambos métodos de validación (AccessToken e IdToken) validan con audiencias HTTP internas sin importar `Request.IsHttps`.
- **Middleware JWT (API y GymFrontend):** la audiencia configurada es siempre la variante HTTP (`BackendAudiencie` / `FrontAudiencie`).
- **Redirección HTTPS:** ninguna aplicación redirige HTTP a HTTPS; sola función de nginx.
- **Cookie `Secure`:** se activa cuando el request efectivo es HTTPS (es decir, cuando `ForwardedHeaders` procesó `X-Forwarded-Proto`) y se desactiva en caso contrario.
- **`UseSsl`:** permanece `false` en todas las configuraciones y no condiciona ninguna decisión de código.

### 3.3 Flujo de decisión

| Decisión | Fuente | Dónde |
|----------|--------|-------|
| Audiencia del token generado | Fija: audiencia HTTP interna | `JwtTokenGenerator` (generación) |
| Audiencia del token validado | Fija: audiencia HTTP interna | `JwtTokenGenerator` (validación) y middlewares JWT de ambas apps |
| Redirección HTTP → HTTPS | nginx (externa) | Configuración de nginx, fuera de alcance |
| Cookie `Secure = true` | `Request.IsHttps` efectivo (gracias a `ForwardedHeaders` confiable) | `CookieService` |

### 3.4 Acciones que debe realizar

Lista de pasos a ejecutar, sin código:

1. En la utilidad de tokens (`BL/Utils/JwtTokenGenerator.cs`): eliminar la detección de HTTPS por variable de entorno y fijar el modo sin SSL en los dos métodos que generan tokens.
2. En la misma utilidad: eliminar la detección por estado HTTP del request y fijar la audiencia HTTP en los dos métodos que validan tokens.
3. En la API (`API/Program.cs`): fijar la audiencia del middleware JWT a la variante HTTP, quitando la condición por URLs.
4. En la API: eliminar los bloques de redirección HTTPS correspondientes a los entornos Production y Development; conservar el middleware de encabezados reenviados (`UseForwardedHeaders`) en Production.
5. En el frontend (`GymFrontend/Program.cs`): agregar la IP del gateway del bridge Docker (verificada en el host con el comando de ruta del contenedor) al listado de proxies conocidos de `ForwardedHeaders`, conservando la IP local existente.
6. En el frontend: fijar la audiencia del middleware JWT a la variante HTTP, quitando la condición por URLs.
7. En el frontend: eliminar el bloque de redirección HTTPS del entorno Development.
8. No modificar el servicio de cookies (`CookieService`): su lógica ya decide el flag `Secure` según el estado HTTPS efectivo del request; queda operativa una vez que el paso 5 hace confiable el proxy.

### 3.5 Patrones a aplicar

- **SSL termination (edge):** el TLS termina solo en nginx; el tráfico interno entre contenedores es HTTP. Ninguna aplicación conoce el HTTPS como propio.
- **Fuente única para audiencias:** las audiencias JWT son invariantes al canal de comunicación (no dependen del scheme por request), evitando asimetrías entre generación y validación.
- **Confianza de proxy restringida:** solo se confían proxies o subredes conocidas en `ForwardedHeaders` (la IP del gateway y/o el rango de red del bridge); jamás se confía todo el tráfico (evita que clientes forjen encabezados `X-Forwarded-*`).

## 4. Archivos a modificar

| Archivo | Descripción |
|---------|-------------|
| `BL/Utils/JwtTokenGenerator.cs` | 4 puntos de decisión SSL reemplazados por valores/audiencias HTTP fijas |
| `API/Program.cs` | Audiencia JWT fija + eliminación de 2 bloques de redirección HTTPS |
| `GymFrontend/Program.cs` | Audiencia JWT fija + proxy conocido agregado + eliminación de 1 bloque de redirección HTTPS |

## 5. Criterios de aceptación

- [ ] Las audiencias JWT son siempre las variantes HTTP (`BackendAudiencie` / `FrontAudiencie`) en generación, validación manual y middlewares.
- [ ] Ningún método de generación o validación consulta variables de entorno o `Request.IsHttps` para elegir audiencia.
- [ ] Las propiedades de audiencia SSL (`BackendAudienceSsl` / `FrontendAudienceSsl`) quedan sin uso en la lógica (limpieza diferida, no bloqueante).
- [ ] `UseSsl` permanece en `false` y no condiciona ninguna ruta de código.
- [ ] No existe llamado a `UseHttpsRedirection` en `API/Program.cs` ni en `GymFrontend/Program.cs`.
- [ ] `UseForwardedHeaders` permanece activo en los entornos de producción/staging de ambas aplicaciones.
- [ ] `ForwardedHeaders` confía la IP del gateway del bridge (verificada en el host EC2) o el rango de red correspondiente.
- [ ] La cookie de autenticación se emite con `Secure = true` cuando el request efectivo es HTTPS (navegación real a través de nginx) y con `Secure = false` en desarrollo HTTP local.
- [ ] Un login completo a través de nginx (HTTPS) funciona sin errores de audiencia (401).
- [ ] La solución compila sin errores (las firmas de los métodos públicos no cambian).