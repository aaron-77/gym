# Tasks: fecha-referencia-peticiones-horarios

Un solo reloj manda: el browser. El JS envía SIEMPRE `fecha` (sv-SE `yyyy-MM-dd`) en peticiones de horarios y clases programadas; el frontend controller/manager la aceptan y propagan. Sin tests unit (D4). Sin E2E/SP/BL-validador. Sin cambios en `GymFrontend/Program.cs` (400 de `[ApiController]` aceptado, D3).

## Phase 1: Foundation — Helper JS compartido

- [x] 1.1 **GymFrontend/wwwroot/js/httpClient.js** — Agregar `obtenerFechaReferencia(fecha = new Date())` → `fecha.toLocaleDateString('sv-SE')` (extrae patrón existente, ej. agendarioDeHorarios.js:246,317; default = hoy del browser; `yyyy-MM-dd`); exportarla (línea 149) y exponerla en `window.obtenerFechaReferencia` (140-146, igual que `realizarPeticionAPI`). | **Aceptación**: disponible como ES module y global; sin arg → hoy `yyyy-MM-dd`; con `Date` → esa fecha. | **Commit**: Work Unit 1

## Phase 2: Core — Callers JS mandan `fecha`

- [x] 2.1 **GymFrontend/wwwroot/js/agendarioDeHorarios.js** — Importar `obtenerFechaReferencia` (línea 6); `obtenerHorariosNuevos(fecha = obtenerFechaReferencia())` (284); setear `params.fecha` SIEMPRE (quitar `if (fecha)` 287-289). 3 callers cubiertos: `inicializarAgendador()` (360), `handleChangeMonthOrYear(fechaParam)` (322), `recargarDatosDespuesReconexion()` (821). | **Aceptación**: ambos GETs `/Horarios/obtenerHorariosDisponibles` y `/Horarios/obtenerPreReservas` incluyen `?fecha=yyyy-MM-dd` (specs 05/06: init, navegación, reconexión). | **Commit**: Work Unit 1
- [x] 2.2 **GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js** — Importar `obtenerFechaReferencia` (línea 1); en `fetchClasesProgramadas` (114) enviar `{ idClase: fkClase, fecha: obtenerFechaReferencia() }` (120). Cubre 3 callers internos (85, 105, 304). | **Aceptación**: GET a `/clases/obtenerClasesProgramadasPorId` incluye `idClase` + `fecha` (spec 49); `inscriptorDeClases.js` NO se toca (fecha opcional). | **Commit**: Work Unit 1

## Phase 3: Backend — Controller + Manager aceptan y propagan

- [x] 3.1 **BL/ClasesManager.cs** — Firma `ObtenerClasesProgramadasPorId(int? idClase = null, DateOnly? fecha = null)` (121); agregar `fecha=yyyy-MM-dd` a la URL solo si `fecha.HasValue`, separador `?`/`&` según query existente (126-129); incluir `fecha` en el log (138). | **Aceptación**: URL `?idClase=X&fecha=Y` con ambos; solo `?idClase=X` con fecha null (spec 14); default server al omitir. | **Commit**: Work Unit 2
- [x] 3.2 **GymFrontend/Controllers/ClasesController.cs** — `ObtenerClasesProgramadasPorId([FromQuery] int? idClase = null, [FromQuery] DateOnly? fecha = null)` (152); chequeo defensivo `if (!ModelState.IsValid)` → `BadRequest(...DTOResponse...)` (patrón API:842-860) — fecha malformada: 400 cortocircuitado por `[ApiController]` antes del action, aceptado (D3); propagar `fecha` al manager (156); log (168). | **Aceptación**: fecha inválida → 400 (framework); GET válido con/sin `fecha` → 200 propagando (spec 14). | **Commit**: Work Unit 2

## Phase 4: Verification

- [ ] 4.1 `dotnet build` de la solución sin errores (firmas controller/manager consistentes). *(Gate del orquestador/verify — apply NO ejecuta builds)*
- [ ] 4.2 Verificación final E2E `Reagendar_InscripcionValida_RetornaExito` — NO modificar (set clock ya existe); sigue verde con el nuevo `fecha`. *(Gate del orquestador/verify — apply NO ejecuta tests)*
- [x] 4.3 Revisión de alcance: confirmar que NO se tocaron `inscriptorDeClases.js`, E2E, validador BL, API/SPs/TVF ni `GymFrontend/Program.cs`.

## Work Units (commits, skill work-unit-commits)

- **Work Unit 1** (Phase 1+2): `feat(frontend): enviar fecha de referencia en peticiones de horarios y clases programadas` — httpClient.js + agendarioDeHorarios.js + cancelarReagendarInscripcion.js. Independientemente revisable (endpoints ya aceptan/ignoran el param → rollback seguro).
- **Work Unit 2** (Phase 3): `feat(bl): aceptar y propagar fecha de referencia en obtenerClasesProgramadasPorId` — ClasesManager.cs + ClasesController.cs.
- Phase 4 = gate de verificación post-cambios, sin commit propio.

## Review Workload Forecast

- **Líneas estimadas**: ~35-45 (JS: ~+12/-5; C#: ~+15). **¿Supera 400?**: NO. **Chained PRs**: NO recomendado — un solo PR con 2 work-unit commits (Low risk).
- **delivery_strategy**: `ask-on-risk` → riesgo BAJO, no se dispara el guard. **chain_strategy**: none.
