# Proposal: fecha-referencia-datetime

## Intent

Los tests 1, 3 y 4 de `FiltroHoraMayor` dependen del reloj runtime (`DateTime.Now`/`DateTime.Today`) y usan if/else contra `maxHora` para decidir la aserción. Esto los hace no deterministas: el resultado esperado cambia según la hora del día en que se ejecutan. Se aplica el patrón de doble llamada (primera para obtener fecha de referencia segura, segunda con fecha+hora configurada) y se elimina el guard `horaRef > maxHora` del helper.

## Scope

### In Scope
- Tests 1, 3 y 4 deterministas con doble llamada: primera llamada sin filtro de hora para obtener fecha de referencia segura (día 15 del mes actual), segunda con fecha+hora configurada según el motivo del test.
- Eliminar guard `horaRef > maxHora` del helper (l.76-80) — ObtenerHorariosDisponiblesFiltrados ya resuelve saltos de hora, día, mes y año.
- Eliminar if/else sobre DateTime.Now/DateTime.Today de los tests — comparar contra fechas reales obtenidas.
- Actualizar specs 50/51 (contrato).

### Out of Scope
- `sp_obtenerHorariosDisponibles` — NO se toca.
- Test 2 (`FiltroHoraMayor_FechaExplicitaFutura_Referencia00Preservada`) — no cambia.
- Otros callers (todos pasan null/00:00 → comportamiento idéntico).
- Deuda documentada: delta spec 06 Req. 13 (SP evalúa contra GETDATE, no contra la referencia) sigue incumplido.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `filtro-hora-unico` (specs/50-spect-filtroHoraUnico.md): se elimina el guard de fin de jornada; la normalización de fecha queda en `NormalizarFechaReferencia`.
- `filtro-hora-unico-test` (specs/51-spect-filtroHoraUnico-test.md): tests 1, 3 y 4 con patrón de doble llamada y fecha fija (día 15), sin if/else runtime.

## Approach

**A. Doble llamada para obtener fecha de referencia segura (patrón común a los 3 tests).**

```
1. Primera llamada: ObtenerHorariosDisponiblesFiltrados(conn, FiltroFecha.Igual, FiltroHora.SinFiltro, fechaFija)
   → fechaFija = día 15 del mes actual. Garantiza predictibilidad (nunca cae en fin de mes).
2. De la respuesta, extraer la primera FechaDisponible real.
3. Segunda llamada: ObtenerHorariosDisponiblesFiltrados(conn, FiltroFecha.Igual, FiltroHora.Mayor, fechaConfigurada)
   → fechaConfigurada = fechaRef.ToDateTime(horaSegunMotivoDelTest).
```

**B. Tests 1, 3 y 4 (sin if/else, sin DateTime.Now).**

| Test | Hora a configurar | Aserción |
|------|-----------------|----------|
| 1. CeilAProximaHora | minHora + 30min → ceil = minHora+1h | Los slots tienen fecha == fechaRef; horaInicio >= ceil(hora); el slot de la hora iniciada se descarta |
| 3. FinDeJornada | maxHora (última hora laboral) | Los slots tienen fecha == fechaRef + 1 día; horaInicio >= minHora |
| 4. DentroDeJornada | Una hora laboral exacta dentro del rango (minHora + 1h) | Los slots tienen fecha == fechaRef; horaInicio >= horaConfigurada |

**C. Eliminar guard `horaRef > maxHora` del helper (l.76-80).** ObtenerHorariosDisponiblesFiltrados ya resuelve la normalización de hora, día, mes y año. El guard es redundante y fuerza un if/else en los tests.

**D. Regla de aserción para test 3 (salto de día).** La fecha esperada se calcula como: `fechaRef.AddDays(1)` (aplicando NormalizarFechaReferencia del helper si corresponde). Comparar contra la fecha real obtenida en la segunda llamada — no contra DateTime.Today.AddDays(1).

**E. Impacto en callers.** Todos pasan null o 00:00 → guard 3 (hora exacta 00:00) → sin cambio. Ningún caller se rompe.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs` | Modified | Eliminar guard `horaRef > maxHora` (l.76-80) |
| `GymWebApp.Tests/Integration/Features/Horarios/HorariosHelperFiltroHoraTests.cs` | Modified | Tests 1, 3, 4: doble llamada, sin if/else, sin DateTime.Now |
| `specs/50-spect-filtroHoraUnico.md` | Modified | Documentar eliminación del guard y comportamiento actual |
| `specs/51-spect-filtroHoraUnico-test.md` | Modified | Tests 1, 3, 4 con escenarios actualizados |
| Callers | None | Sin cambio de comportamiento |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Eliminar el guard cambia el comportamiento de callers que pasan hora ≠ 00:00 | Bajo | Todos los callers pasan null o 00:00 → guard 3 → sin cambio |
| Fecha 15 podría no tener slots disponibles | Bajo | El SP genera el calendario completo del mes → siempre hay slots |
| Test 3 fechaEsperada = fechaRef+1 podría no coincidir si NormalizarFechaReferencia salta | Bajo | Día 15 + 1 = día 16, nunca cae en fin de mes |

## Rollback Plan

Revertir el commit del change (helper + test + specs). No hay migraciones, SP, ni backup afectados → reversión limpia sin efectos colaterales.

## Dependencies

- Specs 50/51 vigentes (contrato actual de guard clauses y tests).
- BD de tests (Testcontainers) para verificar minHora/maxHora reales del backup.

## Success Criteria

- [ ] Tests 1, 3 y 4 deterministas: doble llamada, sin if/else sobre DateTime.Now/maxHora
- [ ] Guard `horaRef > maxHora` eliminado del helper
- [ ] Test 3 verifica salto de día contra fechaRef + 1 día (no contra DateTime.Today.AddDays(1))
- [ ] Tests 1 y 4 verifican permanencia en fechaRef obtenida (no en DateTime.Today)
- [ ] Callers existentes (null/00:00) sin cambio de comportamiento
- [ ] Specs 50/51 actualizados al nuevo contrato