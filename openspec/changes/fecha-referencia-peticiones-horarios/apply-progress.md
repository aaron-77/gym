# Apply Progress: fecha-referencia-peticiones-horarios

**Status**: Implementación completa (5/5 tareas de código). Phase 4: 4.3 hecho; 4.1 (build) y 4.2 (E2E) pendientes de gates del orquestador/verify — apply NO ejecuta builds ni tests (regla del proyecto).

## Work Unit 1 — `feat(frontend): enviar fecha de referencia en peticiones de horarios y clases programadas`

- [x] **1.1 httpClient.js** — Helper `obtenerFechaReferencia(fecha = new Date())` → `fecha.toLocaleDateString('sv-SE')` (formato `yyyy-MM-dd`); si recibe string lo devuelve tal cual (cubre `handleChangeMonthOrYear` que ya pasa `fechaParam` formateado). Exportado como ES module + expuesto en `window.obtenerFechaReferencia` (consistente con `realizarPeticionAPI`).
- [x] **2.1 agendarioDeHorarios.js** — Import del helper; `obtenerHorariosNuevos(fecha = obtenerFechaReferencia())`; `params.fecha` seteado SIEMPRE (`const params = { fecha }`, quitado el `if (fecha)`). Los 3 callers (`inicializarAgendador`, `handleChangeMonthOrYear`, `recargarDatosDespuesReconexion`) quedan cubiertos sin tocarlos: ambos GETs (`obtenerHorariosDisponibles` y `obtenerPreReservas`) incluyen `?fecha=yyyy-MM-dd` (specs 05/06).
- [x] **2.2 cancelarReagendarInscripcion.js** — Import del helper; `fetchClasesProgramadas` envía `{ idClase: fkClase, fecha: obtenerFechaReferencia() }`. Cubre sus 3 callers internos (check Reagendar 85, comboInscripcion 105, SignalR 304). `inscriptorDeClases.js` NO se tocó.

## Work Unit 2 — `feat(bl): aceptar y propagar fecha de referencia en obtenerClasesProgramadasPorId`

- [x] **3.1 BL/ClasesManager.cs** — Firma `ObtenerClasesProgramadasPorId(int? idClase = null, DateOnly? fecha = null)`; agrega `fecha=yyyy-MM-dd` a la URL solo si `fecha.HasValue`, con separador `&` si ya hay query (`idClase`) o `?` si no; `fecha` incluida en el log. Si `fecha` es null → URL solo con `idClase` → el server aplica su fecha actual por defecto (spec 14, design D4).
- [x] **3.2 GymFrontend/Controllers/ClasesController.cs** — `ObtenerClasesProgramadasPorId([FromQuery] int? idClase = null, [FromQuery] DateOnly? fecha = null)`; chequeo defensivo `if (!ModelState.IsValid)` → `BadRequest(ResponseManager.BuildResponse<...>(false, 400, "Datos inválidos", ...))` (mismo patrón que API:842-860); propaga `fecha` al manager; `fecha` incluida en el log del catch. No se agregó config en `GymFrontend/Program.cs` (400 de binding inválido cortocircuitado por `[ApiController]`, aceptado — D3).

## Phase 4 — Verification

- [ ] **4.1** `dotnet build` de la solución — GATE del orquestador/verify (apply NO ejecuta builds). Firmas controller/manager consistentes entre sí (`DateOnly?` en ambos lados).
- [ ] **4.2** E2E `Reagendar_InscripcionValida_RetornaExito` — GATE del orquestador/verify (apply NO ejecuta tests). No modificado.
- [x] **4.3** Revisión de alcance (git status read-only): solo se tocaron los 5 archivos del alcance (`httpClient.js`, `agendarioDeHorarios.js`, `cancelarReagendarInscripcion.js`, `BL/ClasesManager.cs`, `GymFrontend/Controllers/ClasesController.cs`). NO tocados: `inscriptorDeClases.js`, E2E tests, validador BL, `API/`, SPs/TVF, `GymFrontend/Program.cs`.

## Notas / Descubrimientos

- **Working tree con cambios preexistentes**: `cancelarReagendarInscripcion.js` ya tenía modificaciones sin commitear de otro cambio en curso (uso de `fkClase`, `item.fechaDeLaClase`, poblado de hidden inputs `inputClase`/`inputEntrenador`, `idNuevaClase` en reagendar). El tasks.md se escribió contra ese estado (citaba `fkClase` en la línea 120), así que mi cambio aplicó sobre esa base tal cual estaba previsto. Los commits de este cambio NO deben incluir esas líneas preexistentes (pertenecen a otro work unit).
- El helper acepta `Date|string`: necesario porque `handleChangeMonthOrYear` (agendarioDeHorarios.js:317) ya formatea `fechaParam` a sv-SE antes de llamar a `obtenerHorariosNuevos`.
- El "fallback `DateTime.Today`" del manager (proposal) se resuelve omitiendo el param `fecha` en la URL cuando es null → el server/API usa su fecha actual. No se pasa `DateTime.Today` explícito porque la spec 14 exige URL solo con `idClase` en ese caso.

## Commits sugeridos (work-unit-commits)

1. `feat(frontend): enviar fecha de referencia en peticiones de horarios y clases programadas` — httpClient.js + agendarioDeHorarios.js + cancelarReagendarInscripcion.js (solo líneas de este cambio)
2. `feat(bl): aceptar y propagar fecha de referencia en obtenerClasesProgramadasPorId` — ClasesManager.cs + ClasesController.cs

No se crearon commits ni PR (instrucción del orquestador: implementar y documentar los work-unit commits; entrega con 1 solo PR, sin chained PRs — riesgo bajo, `ask-on-risk` no se dispara).
