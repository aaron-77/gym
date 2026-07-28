# Tasks: Reagendar Inscripción - Endpoint API

## Phase 1: Foundation

- [ ] 1.1 Create `DTO/Dtos/ReagendarInscripcionRequest.cs` with IdInscripcion, IdClaseProgramada, IdCliente + DataAnnotations

## Phase 2: Core Implementation

- [ ] 2.1 Add `ReagendarInscripcion` method to `API/Controllers/InscripcionesController.cs`:
  - POST `api/inscripciones/reagendar`, `[Authorize(Roles = "empleado")]`
  - Obtener userId del JWT, validar GUID, validar usuario existe en BD
  - Validar request body no null, idInscripcion > 0, idClaseProgramada > 0, idCliente no vacío
  - Llamar a `_service.ReagendarInscripcionAsync(request.IdInscripcion, request.IdClaseProgramada, request.IdCliente)`
  - Retornar con `this.Responder(result)`
  - Try/catch con logging

## Phase 3: Verify

- [ ] 3.1 `dotnet build` to verify compilation
