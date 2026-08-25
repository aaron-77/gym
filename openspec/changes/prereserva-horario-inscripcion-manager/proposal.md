# Proposal: Pre-Reserva de Horario Inscripción — BL Manager + Frontend Endpoint

## Intent

El endpoint backend `POST /api/horarios/preReservarHorarioInscripcion` ya existe y está testeado, pero NO tiene capa BL (`HorariosManager`) ni endpoint frontend que lo consuma. Este cambio agrega ambas piezas + tests de integración del manager contra el API real (gap confirmado: ningún test existente ejercita un Manager BL contra el API).

## Scope

### In Scope
- Método `preReservarHorarioInscripcion` en `BL/HorariosManager.cs` → `Task<DTOResponse<object?>>`.
- Endpoint `registrarPreReservaDeHorarioInscripcion` en `GymFrontend/Controllers/HorariosController.cs`.
- Tests de integración del manager en `GymWebApp.Tests/Integration/Features/Horarios/` (happy + 5 sad paths).

### Out of Scope
- `horariosDelDia.js` y cualquier otro archivo frontend (vistas, CSS, JS, Razor).
- Cambios al API backend, DTO, DataAccess.
- `ClasesManager` y otros managers.
- Bug latente en `PreReservarHorario` (BL) con `payload:null` — documentado, no se toca.

## Capabilities

### New Capabilities
- `prereserva-horario-inscripcion-manager`: Método BL en `HorariosManager` que deserializa `DTOResponse<object?>` y POSTea a `api/Horarios/preReservarHorarioInscripcion`.
- `prereserva-horario-inscripcion-frontend`: Endpoint MVC en `HorariosController` con auth cookie → claims → override `idUsuarioQueReserva` → manager.
- `prereserva-horario-inscripcion-manager-tests`: Tests de integración del manager contra API real (`IntegrationTestBase` + `HttpCustomClient(Client)`).

### Modified Capabilities
None — no existen specs previos en `openspec/specs/`.

## Approach

**Manager (BL)**: Clonar `PreReservarHorario` (líneas 69-87) con dos diferencias: (1) target `api/Horarios/preReservarHorarioInscripcion`; (2) `Deserialize<DTOResponse<object?>>` en vez de `<int>`. Sobrevive `payload:null` de los 400 de model-validation (verificado empíricamente) — mismo patrón que los tests del endpoint. catch-all → log Console → DTOResponse sintético `success=false`.

**Frontend**: Clonar `PreReservarHorario` (HorariosController.cs 100-142) EXACTAMENTE: cookie `AuthToken` → `jwtTokenGenerator.ValidateIdToken` → claim `NameIdentifier`/`Sub` → sobrescribe `idUsuarioQueReserva` → `manager.preReservarHorarioInscripcion(dto)` → `Ok(result)` / `BadRequest(result)` → catch `StatusCode(500, DTOResponse<string>)`. Sin `[Authorize]` (sigue al template). Sin tests de controller.

**Tests**: Heredar `IntegrationTestBase` + `[Collection("IntegrationTests")]`. Tras `SetAuthHeaderAsync()`, construir `new HorariosManager(new HttpCustomClient(Client))` — `Client.BaseAddress` = servidor in-memory, paths relativos funcionan, Bearer fluye. Happy path: DTO válido → `success=true`, `payload > 0` (vía `JsonElement.GetInt32()`), cleanup. 5 sad paths replicando los del endpoint:
- sin `idUsuarioQueReserva` (null/empty), `idEntrenador` vacío, `idClase` 0, `idClaseProgramada` 0 → 400 con `errors` conteniendo la propiedad.
- fecha inválida: `default(DateOnly)` (0001-01-01) → 400 con error `FechaMinimaValida` (NO `Required` — divergencia aceptada: `DateOnly` es struct non-nullable, el campo no es omisible vía DTO tipado).
- Asertar `success=false`, `httpCode=400`, `errors` contiene la propiedad fallida.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `BL/HorariosManager.cs` | Modified | Nuevo método ~20 líneas |
| `GymFrontend/Controllers/HorariosController.cs` | Modified | Nuevo endpoint ~40 líneas |
| `GymWebApp.Tests/Integration/Features/Horarios/` | New | Nueva clase de tests (happy + 5 sad) |
| `GymWebApp.Tests/Integration/Helpers/` | Modified | Helper de cleanup extendido/nuevo para DTO inscripción |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| `DTOResponse<object?>` en éxito → payload es `JsonElement` (requiere `GetInt32()`) | Low | Tests documentan extracción; manager pasa-through al frontend |
| Wiring de manager tests sin precedente en el repo | Medium | `IntegrationTestBase` + `HttpCustomClient(Client)` — bloques existentes, BaseAddress in-memory |
| Sad path fecha divergente (`FechaMinimaValida` vs `Required`) | Low | Aceptada y documentada en spec — `DateOnly` non-nullable struct |
| Bug latente `PreReservarHorario` (BL) con `payload:null` | Low | Fuera de scope; flag en exploration |

## Rollback Plan

Eliminar el método de `HorariosManager.cs`, el endpoint de `HorariosController.cs`, y la clase de tests + helper. Sin migraciones de BD ni cambios de schema. Revertir el commit.

## Dependencies

- Endpoint backend `POST /api/horarios/preReservarHorarioInscripcion` (existente, testeado).
- `GymWebApp.Tests.csproj` ya referencia BL.
- Testcontainers + SQL Server corriendo para tests de integración.

## Success Criteria

- [ ] `preReservarHorarioInscripcion` en BL deserializa `DTOResponse<object?>` y sobrevive 400s de model-validation.
- [ ] Endpoint frontend clona el patrón de auth de `PreReservarHorario` (cookie → claims → override `idUsuarioQueReserva`).
- [ ] Tests del manager: happy path pasa, 5 sad paths asertan `httpCode=400` + `errors`.
- [ ] `dotnet test` pasa sin regresiones.
