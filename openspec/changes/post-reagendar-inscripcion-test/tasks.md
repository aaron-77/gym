# Tasks: Integration Tests for POST api/inscripciones/reagendar

## Phase 1: Create Test File

- [ ] 1.1 Create `InscripcionesReagendarTests.cs` at `GymWebApp.Tests/Integration/Features/Inscripciones/` with `[Collection("IntegrationTests")]`, inheriting `IntegrationTestBase`, constructor with factory + helper
- [ ] 1.2 Add usings: `System.Net`, `Http.Json`, `FluentAssertions`, `Common`, `Helpers`, `DTO.Dtos`, `Xunit`

## Phase 2: Implement Tests

- [ ] 2.1 **Happy path**: `Reagendar_InscripcionValida_RetornaOk` — seed via `InscripcionTestHelper` (not `InscripcionEndpointHelper`), create destination class via `CreateValidDestinationClassForReagendarAsync`, POST, assert 200 + `DTOResponse<bool>` with `success=true`, `payload=true`
- [ ] 2.2 **Edge case 1**: `Reagendar_IdInscripcionCero_RetornaBadRequest` — auth, POST with `IdInscripcion=0` + valid other fields, assert 400 + `DTOResponse<object>` with `success=false`, `errors` contains `propiedad == "IdInscripcion"`
- [ ] 2.3 **Edge case 2**: `Reagendar_IdClaseProgramadaCero_RetornaBadRequest` — auth, POST with `IdClaseProgramada=0` + valid other fields, assert 400 + `errors` contains `propiedad == "IdClaseProgramada"`
- [ ] 2.4 **Edge case 3**: `Reagendar_IdClienteVacio_RetornaBadRequest` — auth, POST with `IdCliente=""` + valid other fields, assert 400 + `errors` contains `propiedad == "IdCliente"`
- [ ] 2.5 **Edge case 4**: `Reagendar_InscripcionNoExiste_RetornaNotFound` — auth, POST with `IdInscripcion=999999`, assert 404 + `DTOResponse<bool>` with `success=false`
- [ ] 2.6 **Edge case 5**: `Reagendar_SinAutenticacion_RetornaUnauthorized` — `ClearAuthHeader()`, POST valid-ish request, assert 401 only

## Phase 3: Verify

- [ ] 3.1 Build solution (`dotnet build`) and run the 6 tests (`dotnet test --filter "InscripcionesReagendarTests"`), verify all pass

## Review Workload Forecast

| Metric | Value |
|--------|-------|
| Est. file size | ~260 lines (comparable to CancelarTests at 237) |
| Chained PRs needed | **0** — under 400-line threshold |
| Test count | 6 (all in 1 file, 1 class) |
| Helper deps | `InscripcionTestHelper` (seed + fallback + destination class), `IntegrationTestBase` (auth) |
| New infra needed | **0** — all helpers exist |

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| `InscripcionEndpointHelper` vs `InscripcionTestHelper` confusion | High | Wrong return type | Use `InscripcionTestHelper` which returns `(clienteId, idInscripcion)` — NOT `InscripcionEndpointHelper` which only returns `clienteId` |
| Seed returning null (no available slots) | Medium | Test flaky | Include `SeedFallbackAsync` fallback + null-guard per existing pattern |
| Validation error `propiedad` case mismatch | Low | Wrong assert | Design confirms PascalCase: `IdInscripcion`, `IdClaseProgramada`, `IdCliente` (from `kvp.Key` in ModelState) |
| `ReagendacionInscripcionFactory` confusion | Low | Used wrong DTO | Factory creates `DTOReagendacionDeInscripcion` (old endpoint) — create `ReagendarInscripcionRequest` inline for endpoint tests |
| Parallel execution conflict with other test classes | Low | Data race | `DisableParallelization=true` on the collection; `ResetDatabaseAsync` in `InitializeAsync` isolates state |

## Implementation Order

Sequential within each phase. Phase 1 (file creation) must complete before Phase 2 (test methods). Phase 2 tests are independent — can be implemented in any order. Phase 3 (verify) is last.

**Total changed lines**: ~260 (1 file created, 0 modified)
