# Design: `CancelarInscripcionEndpoint`

## Resumen técnico

Endpoint POST que recibe un `idInscripcion`, valida la identidad del usuario autenticado y delega la cancelación al servicio existente `InscripcionesService.CancelarInscripcionAsync`.

## Arquitectura

```
[Cliente] POST /api/inscripciones/cancelar { "idInscripcion": 123 }
  ↓ JWT Bearer (rol: empleado)
[InscripcionesController.CancelarInscripcion]
  ↓
  1. User.FindFirstValue(ClaimTypes.NameIdentifier) → ID del usuario autenticado
  2. Guid.TryParse → validar formato GUID (400 si falla)
  3. IValidadorUsuarioExistente.ValidarAsync → existe en BD? (404 si no)
  4. Model binding → CancelarInscripcionRequest (400 si null/inválido)
  5. IInscripcionesService.CancelarInscripcionAsync(idInscripcion) → DTOResponse<bool>
  6. Responder(result) → mapea httpCode del DTO a IActionResult
```

## Decisiones técnicas

### 1. Validación de idInscripcion en DTO vs Controller
Se usa `[Range(1, int.MaxValue)]` en el DTO (`CancelarInscripcionRequest`) para que ASP.NET Core valide automáticamente antes de entrar al método del controller. Esto:
- Evita código boilerplate de guard clause en el controller
- Sigue el patrón existente del proyecto (DataAnnotations en DTOs)
- El service también valida por si se llama desde otro lado

### 2. Helper `Responder<T>` existente
Se reutiliza el método privado `Responder<T>(DTOResponse<T>)` que ya existe en el controller. Este helper mapea el `httpCode` del DTO al `IActionResult` correspondiente, manteniendo sincronizados ambos códigos.

### 3. Reutilización de `IValidadorUsuarioExistente`
Se usa el mismo validador que el endpoint `ObtenerInscripcionesDelCliente`, evitando duplicar lógica de validación de usuario.

### 4. Manejo de errores con ResponseManager
Todas las respuestas de error usan `ResponseManager.BuildResponse<object>()`, consistente con los demás endpoints.

## Flujo de datos

```
Request: POST /api/inscripciones/cancelar
Body: { "idInscripcion": 123 }
Header: Authorization: Bearer <token>
  ↓
Model binding → CancelarInscripcionRequest { IdInscripcion = 123 }
  ↓
Validación usuario (GUID + BD)
  ↓
Service.CancelarInscripcionAsync(123)
  ↓
DTOResponse<bool> { success: true, httpCode: 200, message: "Inscripción cancelada exitosamente", payload: true }
  ↓
Responder(result) → 200 OK
```

## Casos borde

| Caso | HTTP | Comportamiento |
|------|------|---------------|
| Request body es NULL | 400 | Model binding automático de ASP.NET |
| IdInscripcion = 0 | 400 | `[Range(1, int.MaxValue)]` en DTO |
| IdInscripcion negativo | 400 | `[Range(1, int.MaxValue)]` en DTO |
| Token sin NameIdentifier | 400 | Guid.TryParse falla |
| Usuario autenticado no existe en BD | 404 | ValidadorUsuarioExistente |
| Error interno | 500 | Catch con ResponseManager |

## Archivos de salida

| Archivo | Acción |
|---------|--------|
| `API/Controllers/InscripcionesController.cs` | Agregar endpoint `CancelarInscripcion` |
| `DTO/Dtos/CancelarInscripcionRequest.cs` | Crear DTO request |
