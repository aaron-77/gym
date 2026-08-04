# Tasks: E2E Tests — Reagendar Inscripción Frontend

## Phase 1: Fix JS Bug (Prerequisite)

- [ ] 1.1 Fix `GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js` — change `ejecutarReagendar()` to send `idNuevaClase` (from `scheduleViewerInstance?.getSelectedScheduleId()`) as `idClaseProgramada` in the API request body

## Phase 2: Create E2E Test File — Foundation

- [ ] 2.1 Create `GymWebApp.Tests/E2E/Features/InscripcionesReagendarE2ETests.cs` — class structure with `[Collection("E2E HappyPaths")]`, inherit `PlaywrightTestBase`, constructor with `E2eContainerHelper` and `PlaywrightHelper`, `BaseUrl` property, XML header documenting the JS bug

## Phase 3: Implement Edge Case Tests

- [ ] 3.1 Implement `Reagendar_SinAutenticacion_RetornaRedirectToLogin` (E2E-REAG-02) — unauthenticated user navigates to `/Inscripciones/cancelarReagendar`, verify redirect to `/signIn`
- [ ] 3.2 Implement `Reagendar_UsuarioSinRolEmpleado_RetornaForbidden` (E2E-REAG-03) — login as client (`TestUserClienteEmail`), navigate to page, verify redirect to `AccesoDenegado`
- [ ] 3.3 Implement `Reagendar_SinHorarioSeleccionado_MuestraAdvertencia` (E2E-REAG-04) — seed via `InscripcionEndpointHelper.SeedFreshInscripcionAsync`, select client/inscription, enable reagendar, click `#btnEjecutar` without selecting schedule, verify `.swal2-title` = "Seleccione un horario en el calendario" and `.swal2-warning` visible

## Phase 4: Implement Happy Path (depends on Phase 1 — JS fix)

- [ ] 4.1 Implement `Reagendar_InscripcionValida_RetornaExito` (E2E-REAG-01) — full flow: login employee, seed data (inscription + destination class), select client in `#comboCliente`, select inscription in `#comboInscripcion`, tick `#checkReagendar`, pick date in `#contenedorCalendario`, pick time in `#contenedorScheduler`, click `#btnEjecutar`, verify `.swal2-title` = "Inscripción reagendada exitosamente" and `.swal2-success` visible

## Phase 5: Verify

- [ ] 5.1 Build solution — `dotnet build` compiles without errors
- [ ] 5.2 Run E2E tests — `dotnet test --filter "FullyQualifiedName~Reagendar"` passes all 4 tests
