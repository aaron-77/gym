# Proposal: Add E2E Tests for ReagendarInscripcion Frontend Endpoint

## Intent

Cover the frontend proxy POST `/inscripciones/reagendar` (spec 47) with E2E browser tests. The endpoint
is implemented but untested at the browser level. Existing coverage is limited to unit and integration
layers — no Playwright tests verify the full frontend flow through login, navigation, form interaction,
and SweetAlert2 feedback.

## Scope

### In Scope
- **Happy Path**: Full browser flow — login as employee, navigate to cancelarReagendar, select client
  + inscription, enable reagendar, pick schedule date/time, click btnEjecutar, verify success alert
- **Edge — No Auth**: Unauthenticated user accessing endpoint directly gets redirected to `/signIn`
- **Edge — Wrong Role**: Client user gets redirected to AccesoDenegado
- **Edge — No Schedule Selected**: Check reagendar without selecting schedule, verify SweetAlert2
  warning "Seleccione un horario en el calendario"
- **JS Bug Documentation**: Note in test class header about the bug where `idClaseProgramada` is
  sent instead of `idNuevaClase` (affects happy path API call)

### Out of Scope
- API-level validation tests (covered by `InscripcionesReagendarTests`)
- Unit tests (covered by `ServiceReagendarInscripcionGuardClauseTests`)
- API error simulation (requires mocking, better as integration test)

### Additional Work (outside test scope)
- **JS bug fix**: In `cancelarReagendarInscripcion.js`, `ejecutarReagendar` sends `idClaseProgramada` (original class) instead of `idNuevaClase` (selected schedule). Fix: change the request body to use `idNuevaClase` as `idClaseProgramada`. This is a prerequisite for the happy path E2E test to pass.

## Capabilities

### New Capabilities
- `e2e-reagendar-inscripcion-frontend`: E2E browser tests for the frontend reagendar flow via
  Playwright against the full Docker stack

### Modified Capabilities
None — pure test addition, no spec-level behavior change.

## Approach

Extend the existing E2E pattern (`InscripcionesCancelarE2ETests`, `CancelarReagendarE2ETests`).
New class `InscripcionesReagendarE2ETests` in the same `Features/` directory. Reuse
`PlaywrightTestBase` + `E2eContainerHelper` for Docker stack. Seed data via
`InscripcionEndpointHelper.SeedFreshInscripcionAsync` and
`InscripcionTestHelper.CreateValidDestinationClassForReagendarAsync`.
Follow AAA with `// Arrange` / `// Act` / `// Assert` comments. Add to "E2E HappyPaths" collection
with `DisableParallelization = true`.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `GymWebApp.Tests/E2E/Features/InscripcionesReagendarE2ETests.cs` | New | Main E2E test class (4 tests) |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| JS bug sends wrong `idClaseProgramada` → happy path fails on API response | High | Document in class header; test validates UI flow up to API call |
| Docker stack startup failure | Low | Reuse `E2eContainerHelper` with health checks |
| Flaky SweetAlert2 assertions | Low | Use `WaitForSelectorAsync` with generous timeouts |

## Rollback Plan

Revert the single file: `git rm GymWebApp.Tests/E2E/Features/InscripcionesReagendarE2ETests.cs`

## Dependencies

- Playwright browsers installed via `playwright.ps1 install`
- Existing infra: `PlaywrightTestBase`, `E2eContainerHelper`, `PlaywrightHelper`
- Existing helpers: `InscripcionEndpointHelper`, `InscripcionTestHelper`
- App credentials via `E2ETestSettings.TestUserEmail` (employee) and `TestUserClienteEmail`

## Success Criteria

- [ ] All 4 E2E tests pass against full Docker stack in CI-like conditions
- [ ] Tests belong to "E2E HappyPaths" collection with `DisableParallelization`
- [ ] JS bug is documented in the test class header with clear description
