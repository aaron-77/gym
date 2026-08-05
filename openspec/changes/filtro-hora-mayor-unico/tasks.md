# Tasks: Filtro de hora único (filtro-hora-mayor-unico)

Refactor de infraestructura de tests: un único filtro de hora (`FiltroHora.Mayor`) con referencia ceil a la próxima hora completa + guard de fin de jornada, ambos en el choke point `HorariosHelper.ObtenerHorariosDisponiblesFiltrados`. Cero cambios en producción (SP, validadores, servicios). Orden de dependencia: enum → helper → caller. El borrado del enum rompe la compilación hasta que aterricen las fases 1-3 (enforcement compile-time, spec 3.2).

## Phase 1: Contrato — Enum `FiltroHora`

- [ ] 1.1 **BL/Utils/Enums/FiltroHorarioEnums.cs** — Eliminar `Igual` (22-23) y `MayorIgual` (26-27) del enum `FiltroHora`; quedan solo `Mayor` y `SinFiltro`. Actualizar XML doc (línea 18): referencia ceil + guard de fin de jornada. | **Aceptación**: el enum expone únicamente `Mayor`/`SinFiltro` (spec 3.2); cualquier uso remanente rompe el build (esperado hasta Phase 3). | **Verificación**: `dotnet build BL/BL.csproj` (debe fallar por usos remanentes → gate de enforcement). | **Commit**: Work Unit 1

## Phase 2: Core — Ceil + guard en `HorariosHelper`

- [ ] 2.1 **GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs** — Reemplazar floor (línea 74) por `horaRef` ceil: fecha explícita → `TimeSpan(fecha.Value.Hour, 0, 0)` (sin ceil, preserva 00:00); fecha null → `CeilHoraActual(DateTime.Now)` (Minute>0 || Second>0 → `TimeSpan(Hour+1,0,0)`, si no hora exacta). Colapsar el switch de hora (76-91) a filtro único `Mayor`: `horaInicio > horaRef` (elimina cases `Igual`/`MayorIgual`). Agregar static helper privado `CeilHoraActual`. | **Aceptación**: spec 4 — 16:35→ref 17:00 con slots > 17:00; 16:00:00 exacto→ref 16:00; fecha explícita→00:00 preservado; switch sin cases `Igual`/`MayorIgual`. | **Verificación**: `dotnet build GymWebApp.Tests/GymWebApp.Tests.csproj` + tests Phase 4. | **Commit**: Work Unit 1
- [ ] 2.2 **GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs** — Agregar método privado estático `GetRangoHoraInicioAsync(connectionString)` (D3): `SELECT MIN(horaInicio) AS MinHora, MAX(horaInicio) AS MaxHora FROM horasLaborales` vía `DatabaseHelper.ExecuteQuerySingleAsync` (1 round-trip), devuelve `(TimeSpan MinHora, TimeSpan MaxHora)`. NO reutilizar `InscripcionTestHelper.GetMaxHoraInicioAsync` (acoplamiento Helpers→Helpers, D3). | **Aceptación**: 1 sola query; columnas verificadas contra `bd/esquemaBdsDeReferenciaParaIa/FitnessGymSchemaActual.sql` (`horasLaborales.horaInicio time NOT NULL`); `GetMaxHoraInicioAsync` intacto (lo usan ServiceReagendarInscripcionTests:186, InscripcionesReagendarTests:38, ObtenerClasesProgramadasPorIdApiTests:37, E2E:178). | **Verificación**: `dotnet build GymWebApp.Tests/GymWebApp.Tests.csproj`. | **Commit**: Work Unit 1
- [ ] 2.3 **GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs** — Integrar guard de fin de jornada (D1 opción c, D2 orden): corre SOLO si `filtroHora != SinFiltro` (único restante: `Mayor`); si `horaRef > maxHora` → `fechaRef = NormalizarFechaReferencia(fechaRef.AddDays(1))` y `horaRef = minHora`. Pasar la `fechaRef` final (posiblemente desplazada) al SP (línea 51); `FiltroFecha` se aplica contra `fechaRef` efectiva (switch 54-69 sin cambios). | **Aceptación**: casos borde del diseño — 23:35→ceil 24:00 > maxHora → día siguiente con horaRef=minHora; último día del mes + shift → re-normalización regenera el mes; `horaRef == maxHora` exacto sin shift; `Igual`+guard → fechaRef=mañana → query NO vacía (D1c); `SinFiltro` sin guard (Igual+SinFiltro en InscripcionTestHelper:659 preserva "hoy"). | **Verificación**: `dotnet build GymWebApp.Tests/GymWebApp.Tests.csproj` + tests Phase 4. | **Commit**: Work Unit 1
- [ ] 2.4 **GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs** — Actualizar XML docs 34-41 de `ObtenerHorariosDisponiblesFiltrados` (comportamiento ceil + guard + fechaRef desplazable). | **Aceptación**: docs reflejan contrato nuevo; sin cambios de lógica. | **Verificación**: revisión de diff (apply no ejecuta builds). | **Commit**: Work Unit 1

## Phase 3: Migración del caller

- [ ] 3.1 **GymWebApp.Tests/SharedHelpers/ClasesProgramadasHelper.cs** — Línea 317: `FiltroHora.Igual` → `FiltroHora.Mayor` en `RegistrarClaseProgramadaActual` (SIN rename — "Actual" refiere a la fecha, no a la hora). Actualizar XML doc 293-299. | **Aceptación**: compila con enum limpio; método sin rename (proposal, decisión resuelta). | **Verificación**: `dotnet build` de la solución — debe quedar VERDE (fin del enforcement). | **Commit**: Work Unit 1
- [ ] 3.2 **GymWebApp.Tests/SharedHelpers/ClasesProgramadasHelper.cs** — Limitar conocido (pregunta abierta del diseño): línea 338 usa `DateTime.Now` en `sp_obtenerEntrenadoresDisponibles` — si el guard desplaza la clase a mañana, el entrenador se elige por disponibilidad de HOY. Decisión default (diseño): **dejar como está** — el método NO tiene callers (verificado: solo definición en línea 309 y log en 362); documentar la limitación en el XML doc. | **Aceptación**: sin cambios de código; limitación documentada; confirmar con el usuario antes de apply (ask-on-risk). | **Verificación**: revisión de diff. | **Commit**: Work Unit 1

## Phase 4: Tests — Integración spec 51 (par de tests del spec 50)

- [ ] 4.1 **GymWebApp.Tests/Integration/Features/Horarios/HorariosHelperFiltroHoraTests.cs** (nuevo) — Tests de integración SOLO de spec 51 (regla: sin tests derivados), patrón xunit-integration: `[Collection("IntegrationTests")]` (DisableParallelization, `IntegrationTestCollections.cs`), Testcontainers + BD real vía `TestContainerHelper` (reset en constructor), sin factory Web. Escenarios: (a) referencia ceil runtime-relativa — capturar `DateTime.Now`, computar ceil esperado, assert slots de hoy con `horaInicio > ref` y no-vacío (~1h margen); (b) fecha explícita futura (DateOnly) → ref 00:00 y slots del día (sin ceil/guard); (c) fin de jornada — si `DateTime.Now.TimeOfDay > maxHora` (patrón E2E:182) assert día siguiente con `horaInicio >= minHora`; si no, assert día actual; (d) dentro de jornada → día actual no-vacío. | **Aceptación**: criterios del spec 51 — 4 pruebas implementadas (2 happy paths + 2 edge cases), asserts runtime-relativos, sin helper logic en la clase de test, BD reseteada por test, SOLO escenarios del spec (sin tests derivados). | **Verificación**: `dotnet test --filter "FullyQualifiedName~HorariosHelperFiltroHoraTests"`. | **Commit**: Work Unit 2

## Phase 5: Verification (gates del orquestador/verify — apply NO ejecuta builds ni tests)

- [ ] 5.1 `dotnet build` de la solución sin errores (firmas enum/helper/caller consistentes). *(Gate verify)*
- [ ] 5.2 Regresión: suite con `Mayor`/`SinFiltro` verde — `dotnet test --filter "FullyQualifiedName~Inscripciones|FullyQualifiedName~ObtenerClasesProgramadasPorIdApiTests"` (callers en InscripcionTestHelper:401, 599, 1071 y E2E:187). *(Gate verify)*
- [ ] 5.3 E2E `Reagendar_InscripcionValida_RetornaExito` (spec 10) en corridas repetidas — `dotnet test --filter "FullyQualifiedName~InscripcionesReagendarE2ETests.Reagendar_InscripcionValida_RetornaExito"` (el flake es el objetivo; guard propio E2E 177-202 intacto). *(Gate verify)*

## Work Units (commits, skill work-unit-commits)

- **Work Unit 1** (Phases 1-3): `refactor(bl,tests): unificar FiltroHora en Mayor con ceil y guard de fin de jornada` — enum + HorariosHelper + ClasesProgramadasHelper. Cambio ATÓMICO de contrato: el borrado del enum solo compila con las 3 fases juntas (enforcement compile-time). Único PR; ~30 líneas efectivas de cambio.
- **Work Unit 2** (Phase 4): `test: agregar tests de integración para filtro de hora único (spec 51)` — HorariosHelperFiltroHoraTests.cs.
- Phase 5 = gate de verificación post-cambios, sin commit propio.

## Review Workload Forecast

- **Líneas estimadas**: ~170-200 totales (enum ~-4; HorariosHelper ~+30/-20; ClasesProgramadasHelper ~+3/-1; tests nuevos ~140-160).
- **Chained PRs**: NO recomendado — un solo PR con 2 work-unit commits (cambio contenido y de infraestructura de tests).
- **Riesgo presupuesto 400 líneas**: LOW.
- **Decision needed before apply**: YES — confirmar con el usuario el destino de `RegistrarClaseProgramadaActual` (línea 338, `sp_obtenerEntrenadoresDisponibles` con `DateTime.Now`): default del diseño = dejar como está y documentar (sin callers); alternativa = pasar `fechaDisponible` del slot. Requiere OK explícito antes de Work Unit 1.
- **delivery_strategy**: `ask-on-risk` → decisión pendiente → el orquestador consulta antes de apply. **chain_strategy**: none.
