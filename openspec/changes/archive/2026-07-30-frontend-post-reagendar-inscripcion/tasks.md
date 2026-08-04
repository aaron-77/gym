# Tasks: Frontend — POST Reagendar Inscripción (Proxy)

## Phase 1: Implementation

- [x] 1.1 Add `ReagendarInscripcion` POST proxy method to `GymFrontend/Controllers/InscripcionesController.cs` following `CancelarInscripcion` pattern:
  - `[Authorize(Roles = "empleado")]` + `[HttpPost]` + `[Route("reagendar")]`
  - Accept `[FromBody] ReagendarInscripcionRequest` (already exists in DTO)
  - Log start, serialize with `JsonContent.Create`, proxy via `_httpClient.post("api/inscripciones/reagendar", jsonContent)`
  - Return `Content(apiResponse ?? "{}", "application/json")`
  - Catch block with `_logger.LogError` and `return StatusCode(500, ...)`
  - No userId extraction from JWT claim

## Phase 2: Verification

- [x] 2.1 Build solution to verify compilation (`dotnet build GymFrontend/GymFrontend.csproj`)

---

### Review Workload Forecast

**Total lines added**: ~25-30 (method body + attributes)
**Files modified**: 1
**Files created**: 0
**Review effort**: Minimal — pure proxy passthrough, no logic, exact `CancelarInscripcion` mirror
