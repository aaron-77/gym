# Spec: API - Endpoint Reagendar Inscripción

## 1. Resumen

Crear un endpoint POST en la API que reagende una inscripción,
validando el ID del usuario autenticado y llamando al servicio de reagendación.

## 2. Contexto

- **Capa:** API Controllers
- **Controller:** `InscripcionesController`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Servicio | `ServiceReagendarInscripcion` | Servicio que ejecuta la reagendación | 39 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `ServiceReagendarInscripcion` | Servicio | Ejecutar reagendación |
| `UserManager<ApplicationUser>` | Identity | Validar existencia de usuario |
| `ILogger` | Logging | Logear errores y eventos |

## 3. Endpoint a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `API/Controllers/InscripcionesController.cs` | Controlador con el endpoint (modificar existente) |

### 3.2 Request

| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| `idInscripcion` | `int` | Sí | ID de la inscripción a reagendar |
| `idClaseProgramada` | `int` | Sí | ID de la clase programada destino |
| `idCliente` | `string` | Sí | ID del cliente |

### 3.3 Ruta y método

| Método HTTP | Ruta | Descripción |
|-------------|------|-------------|
| POST | `api/inscripciones/reagendar` | Reagendar una inscripción |

### 3.4 Autenticación y autorización

- **Requiere autenticación:** Sí
- **Roles permitidos:** `empleado`
- **Atributo:** `[Authorize(Roles = "empleado")]`

### 3.5 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | ID del usuario autenticado tiene formato GUID válido | `Guid.TryParse` | 400 |
| 2 | Usuario autenticado existe en BD | `UserManager.FindByIdAsync` | 404 |
| 3 | Request body no es NULL | Model binding | 400 |
| 4 | `idInscripcion` es mayor a 0 | Guard clause | 400 |
| 5 | `idClaseProgramada` es mayor a 0 | Guard clause | 400 |
| 6 | `idCliente` no es NULL, vacío o whitespace | Guard clause | 400 |

### 3.6 Acciones que debe realizar

1. Obtener el ID del usuario autenticado desde el token JWT
2. Validar que el ID del usuario tenga formato GUID válido
3. Buscar el usuario en la BD usando `UserManager.FindByIdAsync`
4. Si el usuario no existe, retornar error 404
5. Recibir el request body con `idInscripcion`, `idClaseProgramada`, `idCliente`
6. Validar que el request body no sea NULL
7. Validar que `idInscripcion` sea mayor a 0
8. Validar que `idClaseProgramada` sea mayor a 0
9. Validar que `idCliente` no sea NULL, vacío o whitespace
10. Llamar al servicio `ServiceReagendarInscripcion` con los parámetros
11. Retornar respuesta exitosa sin data

### 3.7 Patrones a aplicar

- **Guard clauses:** Validaciones tempranas al inicio del método
- **ResponseManager:** Usar `ResponseManager.BuildResponse<T>()` para construir respuestas
- **ErrorModel:** Crear lista de `ErrorModel` con propiedad y mensaje descriptivo
- **Logging:** Usar `ILogger` con `LogInformation` al inicio y `LogError` en catch
- **Try/Catch:** Envolver la lógica principal en try/catch

### 3.8 Respuesta

El endpoint debe devolver una respuesta exitosa sin data.

## 4. Criterios de aceptación

- [ ] Endpoint POST con ruta `api/inscripciones/reagendar`
- [ ] Autenticación JWT requerida
- [ ] Solo rol `empleado` puede acceder
- [ ] Validación de ID de usuario con GUID format
- [ ] Validación de existencia de usuario en BD
- [ ] Validación de request body
- [ ] Validación de idInscripcion > 0
- [ ] Validación de idClaseProgramada > 0
- [ ] Validación de idCliente no vacío
- [ ] Llamada al servicio `ServiceReagendarInscripcion`
- [ ] Respuesta exitosa sin data
- [ ] Manejo de errores con ResponseManager
- [ ] Logging de errores con ILogger
