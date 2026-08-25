# Tasks: Pre-Reserva de Horario Inscripción — BL Manager + Frontend Endpoint

> TDD: false (sdd-init/gym #142 — "no strict TDD mode detected"). Order follows natural dependency graph: Manager → Tests → Frontend.

## Phase 1: Foundation — BL Manager Method (Spec 72)

- [ ] 1.1 Add `preReservarHorarioInscripcion` to `BL/HorariosManager.cs`: `public async Task<DTOResponse<object?>>` receiving `DTOPreReservaDeHorarioInscripcion preReserva`. Clone of `PreReservarHorario` (líneas 69-87) with path `api/Horarios/preReservarHorarioInscripcion` and `Deserialize<DTOResponse<object?>>`.
- [ ] 1.2 Body via `JsonContent.Create(preReserva)`; deserialize with `PropertyNameCaseInsensitive=true`; `??` fallback synthetic `success=false` message "Error de deserialización…"; catch-all `Console.WriteLine` (método/línea/causa/stack) → synthetic `DTOResponse<object?>` `success=false`.

**Verify (Spec 72 §5):** Compiles; POSTs to `api/Horarios/preReservarHorarioInscripcion`; survives 400 with `payload:null` sin `JsonException`; catch returns synthetic `success=false`.

## Phase 2: Integration Tests BL→API (Spec 73)

- [ ] 2.1 Create `GymWebApp.Tests/Integration/Features/Horarios/PreReservarHorarioInscripcionManagerTests.cs`: class `PreReservarHorarioInscripcionManagerTests`, inherits `IntegrationTestBase`, `[Collection("IntegrationTests")]`, ctor receives `CitasApiWebApplicationFactory<Program>` + `TestContainerHelper`.
- [ ] 2.2 Common setup: `SetAuthHeaderAsync()` → `new HorariosManager(new HttpCustomClient(Client))` → seed slot via `SlotDisponibleParaClaseProgramadaHelper` → fetch `idClase`/`idClaseProgramada` via `DatabaseHelper.ExecuteQuerySingleAsync`.
- [ ] 2.3 `ConTodosLosDatosCorrectos_Devuelve200`: valid DTO → `success=true`, `httpCode=200`, payload ID `>0` via `JsonElement.GetInt32()`; cleanup in `finally` con `PreReservarHorarioApiTestHelper.LimpiarPreReservasDeHorarioAsync` (sobrecarga `DTOPreReservaDeHorarioInscripcion`).
- [ ] 2.4 `SinIdUsuarioQueReserva_Devuelve400`: `idUsuarioQueReserva=null` → `success=false`, `httpCode=400`, `payload=null`, `errors` contiene `propiedad="idUsuarioQueReserva"`.
- [ ] 2.5 `ConIdEntrenadorVacio_Devuelve400`: `idEntrenador=""` → asserts ídem, `propiedad="idEntrenador"`.
- [ ] 2.6 `ConIdClaseCero_Devuelve400`: `idClase=0` → asserts ídem, `propiedad="idClase"`.
- [ ] 2.7 `SinIdClaseProgramada_Devuelve400`: `idClaseProgramada=0` → asserts ídem, `propiedad="idClaseProgramada"`.
- [ ] 2.8 `ConFechaInvalida_Devuelve400`: `fechaTentativa=default(DateOnly)` → asserts ídem, `propiedad="fechaTentativa"`. Divergencia spec 69 documentada: falla `FechaMinimaValida(1890)` no `Required`.

**Verify (Spec 73 §5):** 6 tests pasan; manager wired via `HttpCustomClient(Client)`; happy path limpia datos; sad paths asertan `httpCode=400` + `errors.propiedad`.

## Phase 3: Frontend Endpoint (Spec 71)

- [ ] 3.1 Add `registrarPreReservaDeHorarioInscripcion` to `GymFrontend/Controllers/HorariosController.cs`: `async Task<IActionResult>`, `[FromBody] DTOPreReservaDeHorarioInscripcion preReserva`, segmento ruta `preReservarHorarioInscripcion`, sin `[Authorize]`.
- [ ] 3.2 Auth flow (clone `PreReservarHorario` 100-142): cookie `AuthToken` → `jwtTokenGenerator.ValidateIdToken` → claim `NameIdentifier`/`Sub` → override `preReserva.idUsuarioQueReserva`.
- [ ] 3.3 Call `_horariosManager.preReservarHorarioInscripcion(preReserva)` → `Ok(result)` si `success=true` / `BadRequest(result)` si `success=false`. Catch: `Console.WriteLine` log + `StatusCode(500, DTOResponse<string>)` synthetic `success=false`.

**Verify (Spec 71 §5):** `POST /Horarios/preReservarHorarioInscripcion` responde; cookie→claims→override `idUsuarioQueReserva`; delega al manager; catch 500 synthetic.

## Phase 4: Verification

- [ ] 4.1 `dotnet test` — los 6 tests del manager pasan, sin regresiones en el suite existente.
- [ ] 4.2 Happy path crea y limpia registro en `preReservasDeHorario`; sad paths no crean registros (validación falla antes del SP).
