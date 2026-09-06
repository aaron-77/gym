# Spec: Configuración CORS por entorno con validación de orígenes locales - Infraestructura API

## 1. Resumen

Reestructurar la configuración de CORS del API para que sea una responsabilidad de infraestructura encapsulada en una clase de extensión de `IServiceCollection` dentro del proyecto API. En el entorno `Staging` (usado por los tests E2E), el API debe permitir cualquier origen cuyo host sea `localhost` o `127.0.0.1` sin importar el puerto ni el protocolo (`http`/`https`), ya que Testcontainers asigna puertos dinámicos al nginx. En los entornos restantes (`Development`/`Production`), el API mantiene la validación estricta por lista explícita `AllowedCorsOrigins`. Todo se debe preservar con `AllowCredentials()` porque los tokens JWT viajan en cookies.

## 2. Contexto

- **Capa:** API (infraestructura pura).
- **Motivo:** El browser E2E navega a `http://localhost:{puertoNginxDinamico}`. Su header `Origin` no está en `AllowedCorsOrigins`, por lo que tanto el middleware de CORS como el middleware manual de validación devuelven 403. La solución anterior (spec 80 original) intentó resolverlo inyectando orígenes dinámicos por variable de entorno (`E2E_TESTS_DINAMIC_ORIGINS`) y reordenando los contenedores, pero causó que el contenedor nginx no arrancara (Docker conflict) y fue revertido.

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Archivo | `API/Program.cs` | Composition root; registra políticas CORS y middleware manual de validación | - |
| Archivo | `API/Infraestructure/CorsServiceCollectionExtensions.cs` | Clase de extensión nueva con configuración CORS y matcher de orígenes locales | - |
| Archivo | `API/appsettings.json`, `appsettings.Development.json`, `appsettings.Staging.json`, `appsettings.Production.json` | Sección `AllowedCorsOrigins` | - |
| Archivo | `GymWebApp.Tests/E2E/Common/E2eContainerHelper.cs` | Orquestación de contenedores E2E (SQL, API, Frontend, Nginx) | - |
| Infraestructura | Testcontainers | Asignación de puertos externos dinámicos | spec-e2e-infraestructura |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| CookieService | Frontend | Transporta los tokens JWT en cookies (HttpOnly) |
| ReservacionesHub | API/SignalR | Hub de tiempo real accesible vía /reservacionesHub |
| nginx.conf (E2E) | Infraestructura | Reverse proxy que enruta /api al API y / al Frontend |
| ForwardedHeaders | API | Configuración de X-Forwarded-* para escenarios detrás de proxy |
| FrameworkReference Microsoft.AspNetCore.App | API | Provee la API de CORS (SetIsOriginAllowed, WithOrigins) |

## 3. Cambios a realizar

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `API/Infraestructure/CorsServiceCollectionExtensions.cs` | **Nuevo.** Clase de extensión con `AddCorsConfiguration` y `EsOrigenPermitido` |
| `API/Program.cs` | Reemplazar el bloque `AddCors` por el llamado a la extensión; simplificar el middleware manual reutilizando el matcher |
| `GymWebApp.Tests/E2E/Common/E2eContainerHelper.cs` | Cambiar el entorno de los contenedores API y Frontend de `Production` a `Staging` |

### 3.2 Contrato

La clase `API.Infraestructure.CorsServiceCollectionExtensions` (métodos estáticos):

| Método | Firma | Descripción |
|--------|-------|-------------|
| `AddCorsConfiguration` | `IServiceCollection AddCorsConfiguration(this IServiceCollection services, bool esStaging, string[] allowedOrigins)` | Registra las políticas `originsPolicyOne` y `public` |
| `EsOrigenPermitido` | `bool EsOrigenPermitido(string? origin)` | Determina si el origen tiene host `localhost` o `127.0.0.1`, ignorando puerto, con protocolo `http` o `https` |

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | Si el `Origin` es vacío o no es un `Uri` parseable válido | Fail-closed | Rechazo (403) |
| 2 | Si el host no es `localhost` ni `127.0.0.1` | Comparación case-insensitive del host | Rechazo (403) |
| 3 | Si el esquema no es `http` ni `https` | Comparación del esquema | Rechazo (403) |
| 4 | Si el host y esquema son válidos | Aceptación | Permis (200) |

El puerto se ignora por completo: cualquier `http(s)://localhost:<cualquierPuerto>` o `http(s)://127.0.0.1:<cualquierPuerto>` es permitido en `Staging`.

### 3.4 Acciones que debe realizar el componente CorsServiceCollectionExtensions

1. Definir el método `AddCorsConfiguration` que recibe la política CORS y si el entorno es `Staging`.
2. Registrar la política `originsPolicyOne` con `AllowAnyHeader()`, `AllowAnyMethod()` y `AllowCredentials()`.
3. Si es `Staging`: usar `SetIsOriginAllowed(EsOrigenPermitido)` para permitir dinámicamente cualquier localhost.
4. Si no es `Staging`: usar `WithOrigins(allowedOrigins)` con la lista explícita.
5. Registrar la política `public` con `AllowAnyOrigin()`, `AllowAnyMethod()` y `AllowAnyHeader()` (sin credenciales).
6. Definir el método estático `EsOrigenPermitido` que:
   - Parsea el origen con `Uri.TryCreate`.
   - Rechaza si el parseo falla, el esquema no es `http`/`https`, o el host no es `localhost`/`127.0.0.1`.
   - Devuelve `true` solo si host y esquema son válidos, ignorando el puerto.

> **Nota:** El matcher `EsOrigenPermitido` se expone público para que el middleware manual de `Program.cs` reutilice exactamente la misma regla (un único punto de verdad).

### 3.5 Acciones que debe realizar el componente Program.cs

1. Mantener la lectura de `allowedOrigins` desde la sección `AllowedCorsOrigins` y su log.
2. Reemplazar el bloque actual de `AddCors` (dos políticas) por un llamado a `builder.Services.AddCorsConfiguration(builder.Environment.IsStaging(), allowedOrigins)`.
3. Mantener el middleware manual de validación de origins, pero reutilizando `EsOrigenPermitido` cuando el entorno sea `Staging` y `allowedOrigins.Contains(origin)` en el resto.
4. Conservar la exclusión del path `/api/Clases/preview`.
5. Conservar el registro del uso de la política origen con `app.UseCors("originsPolicyOne")`.

### 3.6 Patrones a aplicar

- **Encapsulación de infraestructura:** la configuración de CORS deja de estar desparramada en `Program.cs` y se agrupa en una clase de extensión de `IServiceCollection` dentro de `API/Infraestructure/`, donde corresponde (infraestructura pura, ajena a la capa de negocio BL).
- **Fail-closed:** un origen malformado o no parseable se rechaza por defecto.
- **Composition root mínimo:** `Program.cs` solo delega en la extensión; la lógica de políticas y el matcher viven en un solo lugar.
- **Un único punto de verdad:** tanto la política CORS (`SetIsOriginAllowed`) como el middleware manual comparten el matcher `EsOrigenPermitido`.

## 4. Archivos a modificar

| Archivo | Descripción |
|---------|-------------|
| `API/Infraestructure/CorsServiceCollectionExtensions.cs` | **Crear.** Clase de extensión con `AddCorsConfiguration` y `EsOrigenPermitido` |
| `API/Program.cs` | Usar `AddCorsConfiguration`; simplificar middleware manual con `EsOrigenPermitido` en Staging |
| `GymWebApp.Tests/E2E/Common/E2eContainerHelper.cs` | Contenedores API y Frontend en `Staging` |

## 5. Criterios de aceptación

- [ ] `AddCorsConfiguration` registra `originsPolicyOne` con `AllowCredentials()` y `public` con `AllowAnyOrigin()`.
- [ ] En `Staging`, `originsPolicyOne` usa `SetIsOriginAllowed(EsOrigenPermitido)`.
- [ ] Fuera de `Staging`, `originsPolicyOne` usa `WithOrigins(allowedOrigins)`.
- [ ] `EsOrigenPermitido("http://localhost:1234")` retorna `true` (puerto ignorado).
- [ ] `EsOrigenPermitido("https://127.0.0.1:8080")` retorna `true`.
- [ ] `EsOrigenPermitido` de un origin malformado o vacío retorna `false` (fail-closed).
- [ ] `EsOrigenPermitido("https://ec2-algun-host.com")` retorna `false`.
- [ ] El middleware manual de `Program.cs` permite en `Staging` solo lo que `EsOrigenPermitido` acepta.
- [ ] El middleware manual de `Program.cs` preserva la validación con `allowedOrigins` fuera de `Staging`.
- [ ] Los contenedores E2E (API y Frontend) arrancan con `ASPNETCORE_ENVIRONMENT=Staging`.
- [ ] El browser E2E (`http://localhost:{puertoNginx}`) ya no recibe 403.