# Design: Reagendar Inscripción - Endpoint API

## Technical Approach

Agregar un endpoint POST a `InscripcionesController` siguiendo el patrón exacto de `CancelarInscripcion`. Crear un DTO request específico `ReagendarInscripcionRequest` con DataAnnotations. El servicio `ReagendarInscripcionAsync` ya existe en `IInscripcionesService`.

## Architecture Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| DTO separado vs reutilizar | Nuevo `ReagendarInscripcionRequest` | CancelarInscripcionRequest solo tiene IdInscripcion; este necesita 3 campos distintos |
| DataAnnotations + guard clauses | Ambas | DataAnnotations validan modelo binding; guard clauses dan errores específicos por campo |
| this.Responder() | Usar método existente | Sigue el patrón exacto del controller y evita duplicar lógica de respuesta |

## Data Flow

```
Cliente HTTP → POST api/inscripciones/reagendar
  → [Authorize(Roles = "empleado")]
  → InscripcionesController.ReagendarInscripcion()
    → Validar GUID usuario autenticado
    → Validar usuario existe en BD (IValidadorUsuarioExistente)
    → Validar request body (model binding + guard clauses)
    → _service.ReagendarInscripcionAsync(idInscripcion, idClaseProgramada, idCliente)
    → this.Responder(result)
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `DTO/Dtos/ReagendarInscripcionRequest.cs` | Create | Request DTO con IdInscripcion, IdClaseProgramada, IdCliente |
| `API/Controllers/InscripcionesController.cs` | Modify | Agregar método ReagendarInscripcion |

## Interfaces / Contracts

### ReagendarInscripcionRequest (DTO)

```csharp
public class ReagendarInscripcionRequest
{
    [Required(ErrorMessage = "El ID de inscripción es requerido")]
    [Range(1, int.MaxValue, ErrorMessage = "El ID de inscripción debe ser mayor a 0")]
    public int IdInscripcion { get; set; }

    [Required(ErrorMessage = "El ID de clase programada es requerido")]
    [Range(1, int.MaxValue, ErrorMessage = "El ID de clase programada debe ser mayor a 0")]
    public int IdClaseProgramada { get; set; }

    [Required(ErrorMessage = "El ID del cliente es requerido")]
    public string IdCliente { get; set; } = string.Empty;
}
```

### Endpoint (controller)

```csharp
[HttpPost]
[Authorize(Roles = "empleado")]
[Route("api/inscripciones/reagendar")]
public async Task<IActionResult> ReagendarInscripcion([FromBody] ReagendarInscripcionRequest request)
```

### Service (already exists)

```csharp
Task<DTOResponse<bool>> ReagendarInscripcionAsync(int idInscripcion, int idClaseProgramada, string idCliente);
```

## Testing Strategy

No se requieren tests nuevos (el spec indica solo crear el endpoint). Los tests del servicio ya existen en:
- `GymWebApp.Tests/Integration/Features/Inscripciones/ServiceReagendarInscripcionTests.cs`
- `GymWebApp.Tests/Unit/Inscripciones/ServiceReagendarInscripcionGuardClauseTests.cs`

## Migration / Rollout

No migration required. Rollback: `git revert` del commit.

## Open Questions

None.
