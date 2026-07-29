# Tasks: E2E Tests for POST /Inscripciones/cancelar

## Phase 1: Helper — InscripcionE2EHelper

- [ ] 1.1 Create `GymWebApp.Tests/E2E/Helpers/InscripcionE2EHelper.cs` — static class with `ObtenerIdInscripcionValidaAsync(string hostConnectionString)` method. SQL: `SELECT TOP 1 i.idInscripcion FROM inscripcionesDeClases i INNER JOIN clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase WHERE cp.fechaDeLaClase >= CAST(GETDATE() AS DATE) AND i.fkEstadoInscripcion = 1 ORDER BY NEWID()`. Uses `DatabaseHelper.ExecuteScalarAsync<int>` from `GymWebApp.Tests.SharedHelpers`. Fallback: if no rows, insert into `clasesProgramadas`, `horariosDeClasesProgramadas`, `inscripcionesDeClases` to create a fresh inscripcion.

## Phase 2: Tests — InscripcionesCancelarE2ETests

- [ ] 2.1 Create `GymWebApp.Tests/E2E/Features/InscripcionesCancelarE2ETests.cs` with `[Collection("E2E HappyPaths")]`, inheriting `PlaywrightTestBase`. Constructor takes `(E2eContainerHelper, PlaywrightHelper)`. Private helpers: `LoginAsEmpleadoAsync()` and `LoginAsClienteAsync()` using `E2ETestSettings` credentials. Expose `BaseUrl => E2eContainerHelper.Instance.NginxBaseUrl`.

- [ ] 2.2 Test `Cancelar_InscripcionValida_RetornaOk` — LoginAsEmpleadoAsync, get valid `idInscripcion` from helper, `Page.GotoAsync(BaseUrl)`, `Page.WaitForResponseAsync(r => r.Request.Method == "POST" && r.Url.Contains("/Inscripciones/cancelar"))`, `Page.EvaluateAsync` with fetch POST, assert response OK.

- [ ] 2.3 Test `Cancelar_IdInscripcionCero_RetornaBadRequest` — LoginAsEmpleadoAsync, fetch with `idInscripcion: 0`, assert response body `success == false` or validation error.

- [ ] 2.4 Test `Cancelar_SinAutenticacion_RetornaRedirectToLogin` — No login. `Page.GotoAsync(BaseUrl)`, `WaitForResponseAsync` + `EvaluateAsync` fetch POST. Assert response `Status == 302`, `Location` contains `"signIn"`.

- [ ] 2.5 Test `Cancelar_UsuarioSinRolEmpleado_RetornaForbidden` — LoginAsClienteAsync. `WaitForResponseAsync` + `EvaluateAsync` fetch POST. Assert 302 redirect, `Location` contains `"AccesoDenegado"`.

- [ ] 2.6 Test `Cancelar_InscripcionNoExiste_RetornaNotFound` — LoginAsEmpleadoAsync. Fetch with `idInscripcion: 999999`. Assert response body `success == false`.
