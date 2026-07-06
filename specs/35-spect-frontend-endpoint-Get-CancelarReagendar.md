# Spec: Frontend - Endpoint Cancelar/Reagendar

## 1. Resumen

Crear un endpoint GET en el frontend que muestre la vista de cancelar/reagendar inscripciones,
obteniendo el ID del usuario desde su token de identificación y consumiendo la API directamente.

## 2. Contexto

- **Capa:** GymFrontend Controllers

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| DTO | `DTOInscripcionDelCliente` | Modelo de datos de inscripciones | 30 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `IHttpCustomClient` | HTTP | Cliente HTTP con JWT automático para consumir API |
| `ILogger` | Logging | Logear errores y eventos |

## 3. Endpoint a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymFrontend/Controllers/InscripcionesController.cs` | Controlador frontend (si no existe) |
| `GymFrontend/Views/Inscripciones/CancelarReagendarInscripcion.cshtml` | Vista |

### 3.2 Ruta y método

| Método HTTP | Ruta | Descripción |
|-------------|------|-------------|
| GET | `/inscripciones/cancelarReagendar` | Mostrar vista de cancelar/reagendar |

### 3.3 Autenticación

- **Requiere autenticación:** Sí (cookie JWT)
- **Roles permitidos:** `empleado`
- **Obtención de ID:** Desde el token de identificación del usuario

### 3.4 Acciones que debe realizar

1. Obtener ID del usuario desde el token JWT
2. Validar que el ID del usuario tenga formato GUID válido (solo validación de forma, no de existencia — eso es responsabilidad de la API)
3. Hacer petición GET directa a la API para obtener todos los clientes (el `AuthHeaderHandler` de `IHttpCustomClient` inyecta el JWT automáticamente)
4. Pasar los datos de clientes a la vista `CancelarReagendarInscripcion`

> **Nota sobre validaciones:** La validación de existencia del usuario y la verificación del rol `empleado` son responsabilidad exclusiva de la API backend. El frontend solo verifica formato de GUID y la autenticación vía el `[Authorize(Roles = "empleado")]` que valida el claim del JWT.

### 3.5 Patrones a aplicar

- **Token Strategy:** Usar las estrategias ya implementadas para añadir tokens a peticiones API
- **Direct API Call:** Petición directa al API sin usar managers
- **MVC Pattern:** Controller devuelve View con ViewModels
- **Error Handling:** Try/catch con logging
- **Cookie Authentication:** Usar JWT de cookies

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `GymFrontend/Controllers/InscripcionesController.cs` | Controlador frontend (si no existe) |
| `GymFrontend/Views/Inscripciones/CancelarReagendarInscripcion.cshtml` | Vista |

## 5. Criterios de aceptación

- [ ] Endpoint GET con ruta `/inscripciones/cancelarReagendar`
- [ ] Autenticación requerida
- [ ] Solo rol `empleado` puede acceder
- [ ] ID del usuario obtenido desde token JWT
- [ ] Validación de formato GUID con `ValidadorStringId.Validar()`
- [ ] **NO** se valida existencia del usuario (responsabilidad de API)
- [ ] **NO** se valida rol explícitamente contra BD (responsabilidad de API; `[Authorize(Roles = "empleado")]` valida el claim del JWT)
- [ ] Petición directa a API via `IHttpCustomClient`
- [ ] Vista CancelarReagendarInscripcion muestra clientes
- [ ] Manejo de errores con logging
