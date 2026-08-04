# Design: Frontend — POST Reagendar Inscripción (Proxy)

## Technical Approach

Agregar un endpoint proxy POST en `GymFrontend/Controllers/InscripcionesController.cs` que reciba la petición de reagendación desde JavaScript, la reenvíe al API backend `api/inscripciones/reagendar` y devuelva la respuesta tal cual (passthrough). Sigue EXACTAMENTE el patrón de `CancelarInscripcion` en el mismo controller.

El DTO `ReagendarInscripcionRequest` ya existe en `DTO/Dtos/` y no requiere cambios.

## Architecture Decisions

| Decision | Choice | Alternative | Rationale |
|----------|--------|-------------|-----------|
| Pattern | Proxy puro (passthrough) | Validar en frontend | CancelarInscripcion ya usa proxy; la UI JS necesita respuesta directa del API |
| User ID handling | No se extrae del claim | Extraer userId del JWT | El userId no se usa para nada; `idCliente` viene del body JS |
| Request DTO | Reutilizar `ReagendarInscripcionRequest` existente | Crear DTO frontend | Ya existe en DTO, usado por API endpoint, mismo contrato |
| Auth | `[Authorize(Roles = "empleado")]` | Solo `[Authorize]` | Sigue patrón de CancelarInscripcion; solo empleados reagendan |
| Response | `Content(apiResponse, "application/json")` | `this.Responder()` | Proxy puro — no deserializa ni transforma; status y body se pasan directo |

## Data Flow

```
JavaScript (fetch) → POST /inscripciones/reagendar
  │ Body: { idInscripcion, idClaseProgramada, idCliente }
  │ Cookie: AuthToken (JWT)
  ▼
[Authorize(Roles = "empleado")]  → 401/403 si falla
  ▼
InscripcionesController.ReagendarInscripcion()
  │ 1. Serializa request → JsonContent.Create(request)
  │ 2. Reenvía → _httpClient.post("api/inscripciones/reagendar", jsonContent)
  ▼
API Backend → api/inscripciones/reagendar (con JWT del frontend)
  ▼
Response passthrough → Content(apiResponse, "application/json")
  │ Mismo status code + body que devolvió el API
  ▼
JavaScript recibe la respuesta del API directamente
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `GymFrontend/Controllers/InscripcionesController.cs` | Modify | Agregar método `ReagendarInscripcion` (POST proxy) |

Sin cambios en DTO (ya existe), BL, DataAccess ni API.

## Interfaces / Contracts

### Endpoint

```
POST /inscripciones/reagendar
Authorization: Bearer <jwt> (cookie)
Content-Type: application/json

Body:
{
  "idInscripcion": int,       // required, > 0
  "idClaseProgramada": int,   // required, > 0
  "idCliente": string         // required, non-empty
}
```

### Método

```csharp
[Authorize(Roles = "empleado")]
[HttpPost]
[Route("reagendar")]
public async Task<IActionResult> ReagendarInscripcion(
    [FromBody] ReagendarInscripcionRequest request)
{
    try
    {
        _logger.LogInformation("Start InscripcionesController.ReagendarInscripcion (POST)");

        var jsonContent = JsonContent.Create(request);
        var apiResponse = await _httpClient.post("api/inscripciones/reagendar", jsonContent);

        return Content(apiResponse ?? "{}", "application/json");
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Error ReagendarInscripcion (InscripcionesController)");
        return StatusCode(500, new { success = false, message = "Error al reagendar inscripción" });
    }
}
```

## Error Handling

| Caso | HTTP | Comportamiento |
|------|------|----------------|
| Sin auth | 401 | `[Authorize]` rechaza antes de entrar al método |
| Sin rol empleado | 403 | `[Authorize(Roles = "empleado")]` rechaza |
| Model binding inválido | 400 | ASP.NET Core devuelve error de validación automático |
| API responde error | *passthrough* | Se devuelve el mismo status y body del API |
| Excepción en proxy | 500 | Catch con `Status Code(500, { success, message })` |
| apiResponse null | 200 con "{}" | Mismo fallback que CancelarInscripcion |

## Testing Strategy

No se requieren tests específicos para este cambio:
- El endpoint es un proxy sin lógica de negocio
- La cobertura de integración del API endpoint ya existe en `GymWebApp.Tests/Integration/Features/Inscripciones/InscripcionesReagendarTests.cs`
- Tests E2E del flujo completo desde UI están en spec 49 (separado)

## Migration / Rollout

No migration required. Rollback: `git revert` del commit.

## Open Questions

None.
