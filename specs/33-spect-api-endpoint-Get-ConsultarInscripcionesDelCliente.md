# Spec: API - Endpoint Consultar Inscripciones del Cliente

## 1. Resumen

Crear un endpoint GET en la API que consulte las inscripciones de un cliente específico,
con autenticación de rol empleado, validaciones de GUID y existencia de usuarios.

## 2. Contexto

- **Capa:** API Controllers

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Servicio | `ServiceConsultarInscripcionesDeCliente` | Servicio que ejecuta la consulta | 31 |
| DTO | `DTOInscripcionDelCliente` | Modelo de datos de respuesta | 30 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `UserManager<ApplicationUser>` | Identity | Validar existencia de usuarios |
| `ILogger` | Logging | Logear errores y eventos |

## 3. Endpoint a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `API/Controllers/InscripcionesController.cs` | Controlador con el endpoint |

### 3.2 Ruta y método

| Método HTTP | Ruta | Descripción |
|-------------|------|-------------|
| GET | `api/inscripciones/obtenerInscripcionesDelCliente/{idUsuario}` | Obtener inscripciones de un cliente |

### 3.3 Autenticación y autorización

- **Requiere autenticación:** Sí
- **Roles permitidos:** `empleado`
- **Atributo:** `[Authorize(Roles = "empleado")]`

### 3.4 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | ID no es NULL, vacío o whitespace | Guard clause | 400 |
| 2 | ID tiene formato GUID válido | `Guid.TryParse` | 400 |
| 3 | Usuario que hace la petición existe | `UserManager.FindByIdAsync` | 404 |
| 4 | Cliente del que se consulta existe | `UserManager.FindByIdAsync` | 404 |

### 3.5 Acciones que debe realizar

1. Validar que el parámetro `idUsuario` no sea NULL, vacío o whitespace
2. Validar que `idUsuario` tenga formato GUID válido usando `Guid.TryParse`
3. Obtener el ID del usuario autenticado desde el token JWT
4. Buscar el usuario autenticado en la BD usando `UserManager.FindByIdAsync`
5. Si el usuario no existe, retornar error 404
6. Buscar el cliente en la BD usando `UserManager.FindByIdAsync`
7. Si el cliente no existe, retornar error 404
8. Llamar al servicio `ServiceConsultarInscripcionesDeCliente` con el `idUsuario`
9. Retornar la respuesta del servicio

### 3.6 Patrones a aplicar

- **Guard clauses:** Validaciones tempranas al inicio del método
- **ResponseManager:** Usar `ResponseManager.BuildResponse<T>()` para construir respuestas
- **ErrorModel:** Crear lista de `ErrorModel` con propiedad y mensaje descriptivo
- **Logging:** Usar `ILogger` con `LogInformation` al inicio y `LogError` en catch
- **Try/Catch:** Envolver la lógica principal en try/catch

### 3.6 Respuesta

El endpoint debe devolver la data devuelta por `ServiceConsultarInscripcionesDeCliente` envuelta en `DTOResponse<List<DTOInscripcionDelCliente>>`.

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `API/Controllers/InscripcionesController.cs` | Controlador (si no existe) o modificar existente |

## 5. Criterios de aceptación

- [ ] Endpoint GET con ruta `api/inscripciones/obtenerInscripcionesDelCliente/{idUsuario}`
- [ ] Autenticación JWT requerida
- [ ] Solo rol `empleado` puede acceder
- [ ] Validación de GUID con `Guid.TryParse`
- [ ] Validación de existencia del usuario que hace la petición
- [ ] Validación de existencia del cliente consultado
- [ ] Llamada al servicio `ServiceConsultarInscripcionesDeCliente`
- [ ] Respuesta con estructura `DTOResponse<List<DTOInscripcionDelCliente>>`
- [ ] Manejo de errores con ResponseManager
- [ ] Logging de errores con ILogger
