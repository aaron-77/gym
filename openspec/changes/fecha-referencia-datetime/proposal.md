# Proposal: fecha-referencia-datetime

## Intent

`HorariosHelper.ObtenerHorariosDisponiblesFiltrados` (GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs:52-113) recibe `DateTime? fecha` pero DESCARTALA hora: `fechaRef = NormalizarFechaReferencia(fecha?.Date ?? DateTime.Today)` (línea 60). El usuario exige que la fecha+hora recibida MANDE: la hora recibida debe disparar el salto al día siguiente cuando supera la última hora laboral (o cuando es fin de mes), y el test `FiltroHoraMayor_FinDeJornada_DesplazaAlDiaSiguiente` debe ser DETERMINISTA pasando fecha y hora explícitas.

## Scope

### In Scope
- `ObtenerHorariosDisponiblesFiltrados`: la hora recibida en `fecha` es la referencia del filtro de hora y del guard de fin de jornada (guard clause 2 ya existe pero está inactiva — ningún caller pasa hora hoy).
- Corregir la composición día-siguiente × fin-de-mes (ver Approach B).
- Test 3 (`FiltroHoraMayor_FinDeJornada_DesplazaAlDiaSiguiente`) determinista: fecha = "ahora" con horario disponible, hora = maxHora + 1h, ambas explícitas.
- Actualizar specs 50/51 (contrato).

### Out of Scope
- `sp_obtenerHorariosDisponibles` — NO se toca (sigue DATE + GETDATE). NO regenerar backup, NO sincronizar copias SQL.
- Guard clauses de `ResolverHoraReferencia` (153-165) — se mantienen; solo se corrige la composición y se activa la guard 2.
- Otros callers (todos pasan null/00:00 → comportamiento idéntico).
- Deuda documentada: delta spec 06 Req. 13 (SP evalúa contra GETDATE, no contra la referencia) sigue incumplido.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `filtro-hora-unico` (specs/50-spect-filtroHoraUnico.md): la fecha explícita CON hora pasa a mandar en la referencia del filtro y en el salto de fin de jornada; se documenta la regla de composición día-siguiente × fin-de-mes.
- `filtro-hora-unico-test` (specs/51-spect-filtroHoraUnico-test.md): test 3 pasa a ser determinista con fecha+hora explícitas; se elimina el patrón condicional if/else runtime.

## Approach

**A. Semántica de la hora recibida (decisión: con ceil, tal cual el guard 2 existente).** Cuando `fecha` trae hora ≠ 00:00, esa hora es la referencia de `FiltroHora.Mayor`. Se mantiene `ResolverHoraReferencia` tal cual: min/seg ≠ 0 → ceil a la próxima hora completa (la hora señalada ya empezó); hora exacta → tal cual. El guard de fin de jornada evalúa sobre la referencia RESUELTA (ceil si aplica). Justificación: consistente con spec 50 guard clause 2 y con "debe usar esa fecha y hora para aplicar el salto".

**B. Regla de composición día-siguiente × fin-de-mes (CRÍTICA).** Regla única:

```
1. horaRef = ResolverHoraReferencia(fecha, ahora)          // ceil si min/seg ≠ 0
2. fechaBase = fecha?.Date ?? DateTime.Today               // fecha sin normalizar
3. si horaRef > maxHora → fechaBase = fechaBase.AddDays(1)
4. fechaRef = NormalizarFechaReferencia(fechaBase)         // UNA normalización al final
```

Verificación de casos (maxHora = 22:00 salvo nota):
- 2026-01-31 23:00: fechaBase=01-31 → guard (23:00>22:00) → AddDays → 02-01 → Normalizar(02-01)=02-01. **Correcto** (hoy el código da 02-02: normaliza 01-31→02-01 en la línea 60 y luego re-normaliza 02-02 → doble salto). El usuario quiere el día siguiente (02-01).
- 2026-01-30 23:00: fechaBase=01-30 → AddDays → 01-31 → Normalizar(01-31)=02-01. **Correcto**: el salto aterriza en 01-31 (último día) y la normalización regenera el mes completo de febrero (el SP genera el calendario de @Fecha y filtra f.Fecha >= @Fecha; sin normalización @Fecha=01-31 dejaría 1 solo día).
- 2026-12-31 23:00: AddDays(1)=2027-01-01 → Normalizar → 2027-01-01. **Rollover de año OK** (AddDays y AddMonths nativos).
- 2026-02-27 23:00: AddDays → 02-28 (último día) → Normalizar → 03-01. **Correcto** (fin-de-mes aplicado DESPUÉS del salto).
- 2026-01-31 12:00 (dentro de jornada, sin salto): fechaBase=01-31 → Normalizar → 02-01. **Fin-de-mes sin salto de hora** → regenera febrero. Correcto por el criterio del usuario ("o cuando es fin de mes").

Invariante: **el salto (AddDays) se aplica SIEMPRE primero sobre la fecha cruda; la normalización de fin de mes se aplica UNA sola vez, al final.** Elimina el doble salto del código actual (líneas 60 + 78 normalizan dos veces).

**C. Edge TimeSpan(24,0,0) en CeilHoraActual.** A las 23:xx, `new TimeSpan(24,0,0)` es válido (TimeSpan admite 24h) y `24:00 > maxHora` es true → el guard dispara y `horaRef` se resetea a `minHora`; el filtro en memoria nunca ve 24:00. NO rompe. Mejora opcional (fuera de alcance si no aporta): devolver `TimeSpan(24,0,0)` explícito como constante documentada. El test no puede depender del reloj para 23:xx — por eso el test 3 pasa hora explícita.

**D. Test determinista (test 3).** GIVEN: `minHora`/`maxHora` consultados a BD (patrón ya usado en 111-115); `hora = maxHora + 1h` (si maxHora=23:00 → 24:00: usar `new TimeSpan(24,0,0)` para el cálculo de `horaRefEsperada` y `DateTime.Today.AddHours(maxHora.Hours + 1)` para `fecha` — AddHours maneja el rollover a medianoche). WHEN: `ObtenerHorariosDisponiblesFiltrados(conn, FiltroFecha.Igual, FiltroHora.Mayor, fechaConHora)` con fecha explícita `hoy + (maxHora+1h)`. THEN: todos los slots con `FechaDisponible == fechaBase + 1 día` (aplicando fin-de-mes) y `horaInicio >= minHora`. Sin seeding: el SP devuelve los slots vacíos del día siguiente (tests 1/2/4 ya dependen de slots del SP sin seedear); si el día siguiente no tuviera clases, el SP genera los empty slots del calendario igual. La aserción es DETERMINISTA: no hay if/else sobre el reloj; el guard SIEMPRE dispara porque `maxHora+1h > maxHora` por construcción.

**E. Impacto en callers.** Todos pasan null o 00:00 (InscripcionTestHelper 384/940/599/1071, InscripcionEndpointHelper 73, ClasesProgramadasHelper 317, PreReservaDeHorarioHelper 21-25 — este último NO usa el helper, llama el SP directo —, E2E 184): guard 3 (hora exacta 00:00) o guard 1 (ceil de ahora) → día-jump solo si 00:00/ceil > maxHora (nunca para 00:00; para ceil sí, como hoy). `ObtenerUnHorarioDisponible` pasa `ToDateTime(TimeOnly.MinValue)` = 00:00 → sin cambio. **Ningún caller se rompe.**

**F. Specs 50/51.** Spec 50 §3.3: la guard clause 2 pasa de "teórica" a "activa": fecha explícita con hora → la hora manda en filtro y en el salto. §3.4: documentar la composición (AddDays sobre fecha cruda, luego UNA normalización) y el criterio fin-de-mes. Spec 51: test 3 determinista (fecha+hora explícitas, sin if/else), aserción sobre día+1 con fin-de-mes.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs` | Modified | Líneas 58-81: composición del salto (AddDays sobre fecha cruda, normalización única al final); guard 2 activa |
| `GymWebApp.Tests/Integration/Features/Horarios/HorariosHelperFiltroHoraTests.cs` | Modified | Test 3 (103-139): determinista, fecha+hora explícitas, sin if/else |
| `specs/50-spect-filtroHoraUnico.md` | Modified | §3.3/§3.4: hora recibida manda; regla de composición día-siguiente × fin-de-mes |
| `specs/51-spect-filtroHoraUnico-test.md` | Modified | Test 3: determinista con fecha+hora explícitas |
| Callers (InscripcionTestHelper, InscripcionEndpointHelper, ClasesProgramadasHelper, E2E) | None | Pasan null/00:00 → sin cambio de comportamiento (regresión) |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Doble salto existente (fin-de-mes + día siguiente) cambia slots elegidos por seeds | Med | Regla B verificada contra todos los casos; correr tests 1-4 y suites de inscripciones/reagendar como regresión |
| maxHora = 23:00 → hora = 24:00: `DateTime.Today.AddHours(24)` rola la fecha | Bajo | Test 3 usa `AddHours(maxHora.Hours + 1)` y aserción sobre `fechaBase.AddDays(1)`; documentar en spec 51 |
| Guard 2 activa altera la semántica de `FiltroHora.Mayor` con fecha explícita futura | Bajo | Test 2 (fecha futura 00:00) sigue con guard 3 → sin cambio; verificar |
| Specs 50/51 quedan desincronizados si no se actualizan en este cambio | Med | Incluidos en Scope; spec phase los escribe |

## Rollback Plan

Revertir el commit del change (helper + test + specs). No hay migraciones, SP, ni backup afectados → reversión limpia sin efectos colaterales.

## Dependencies

- Specs 50/51 vigentes (contrato actual de guard clauses y tests).
- BD de tests (Testcontainers) para verificar minHora/maxHora reales del backup.

## Success Criteria

- [ ] `fecha` con hora ≠ 00:00 dispara el salto al día siguiente cuando `horaResuelta > maxHora` (guard 2 activa)
- [ ] 2026-01-31 23:00 → 02-01 (sin doble salto); 2026-12-31 → 2027-01-01; fin-de-mes sin salto regenera mes
- [ ] Test 3 determinista: pasa con fecha+hora explícitas en cualquier momento del día
- [ ] Callers existentes (null/00:00) sin cambio de comportamiento
- [ ] Specs 50/51 actualizados al nuevo contrato
