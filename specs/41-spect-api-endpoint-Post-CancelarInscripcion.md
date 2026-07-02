# Spec: API - Endpoint Cancelar Inscripción

## 1. Resumen

Crear un endpoint POST en la API que cancele una inscripción,
validando el ID del usuario autenticado y llamando al servicio de cancelación.

## 2. Contexto

- **Capa:** API Controllers

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Servicio | `ServiceCancelarInscripcion` | Servicio que ejecuta la cancelación | 37 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `UserManager<ApplicationUser>` | Identity | Validar existencia de usuario |
| `ILogger` | Logging | Logear errores y eventos |

## 3. Endpoint a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `API/Controllers/InscripcionesController.cs` | Controlador con el endpoint (modificar existente) |

### 3.2 Ruta y método

| Método HTTP | Ruta | Descripción |
|-------------|------|-------------|
| POST | `api/inscripciones/cancelar` | Cancelar una inscripción |

### 3.3 Autenticación y autorización

- **Requiere autenticación:** Sí
- **Roles permitidos:** `empleado`
- **Atributo:** `[Authorize(Roles = "empleado")]`

### 3.4 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | ID del usuario autenticado tiene formato GUID válido | `Guid.TryParse` | 400 |
| 2 | Usuario autenticado existe en BD | `UserManager.FindByIdAsync` | 404 |
| 3 | Request body no es NULL | Model binding | 400 |
| 4 | idInscripcion es mayor a 0 | Guard clause | 400 |

### 3.5 Acciones que debe realizar

1. Obtener el ID del usuario autenticado desde el token JWT
2. Validar que el ID del usuario tenga formato GUID válido
3. Buscar el usuario en la BD usando `UserManager.FindByIdAsync`
4. Si el usuario no existe, retornar error 404
5. Recibir el request body con `idInscripcion`
6. Validar que el request body no sea NULL
7. Validar que `idInscripcion` sea mayor a 0
8. Llamar al servicio `ServiceCancelarInscripcion` con el `idInscripcion`
9. Retornar respuesta exitosa sin data

### 3.6 Patrones a aplicar

- **Guard clauses:** Validaciones tempranas al inicio del método
- **ResponseManager:** Usar `ResponseManager.BuildResponse<T>()` para construir respuestas
- **ErrorModel:** Crear lista de `ErrorModel` con propiedad y mensaje descriptivo
- **Logging:** Usar `ILogger` con `LogInformation` al inicio y `LogError` en catch
- **Try/Catch:** Envolver la lógica principal en try/catch

### 3.7 Respuesta

El endpoint debe devolver una respuesta exitosa sin data.

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `API/Controllers/InscripcionesController.cs` | Modificar para agregar endpoint |

## 5. Criterios de aceptación

- [ ] Endpoint POST con ruta `api/inscripciones/cancelar`
- [ ] Autenticación JWT requerida
- [ ] Solo rol `empleado` puede acceder
- [ ] Validación de ID de usuario con GUID format
- [ ] Validación de existencia de usuario en BD
- [ ] Validación de request body
- [ ] Validación de idInscripcion > 0
- [ ] Llamada al servicio `ServiceCancelarInscripcion`
- [ ] Respuesta exitosa sin data
- [ ] Manejo de errores con ResponseManager
- [ ] Logging de errores con ILogger
