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
| `IHttpClientFactory` | HTTP | Crear clientes HTTP para consumir API |
| `IJwtTokenGenerator` | Auth | Obtener token JWT para peticiones a la API |
| `UserManager<ApplicationUser>` | Identity | Validar existencia de usuario |
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
2. Validar que el ID del usuario tenga formato GUID válido
3. Buscar el usuario en la BD usando `UserManager.FindByIdAsync`
4. Si el usuario no existe, retornar error o redirect
5. Validar que el usuario tenga rol `empleado`
6. Crear cliente HTTP con token JWT para peticiones a la API
7. Hacer petición GET directa a la API para obtener todos los clientes
8. Pasar los datos de clientes a la vista `CancelarReagendarInscripcion`

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
- [ ] Petición directa a API sin usar managers
- [ ] Vista CancelarReagendarInscripcion muestra clientes
- [ ] Manejo de errores con logging
- [ ] Token JWT añadido a peticiones API correctamente
