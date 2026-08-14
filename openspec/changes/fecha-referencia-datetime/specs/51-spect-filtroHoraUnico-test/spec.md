# Delta for 51-spect-filtroHoraUnico-test

## Purpose

Los tests 1, 3 y 4 dejan de depender del reloj runtime y de condiciones if/else sobre maxHora. Se aplica el patrón de doble llamada: primera para obtener una fecha de referencia segura (día 15 del mes actual), segunda con fecha+hora configurada según el motivo del test. Se elimina el guard `horaRef > maxHora` del helper.

## MODIFIED Requirements

### Requirement: Test 1 determinista — Ceil a próxima hora

| # | Prueba | Tipo | Descripción | Resultado |
|---|--------|------|-------------|-----------|
| 1 | FiltroHoraMayor con minutos → ceil a próxima hora (determinista) | Happy Path | Primera llamada con fecha fija (día 15) sin filtro de hora para obtener fecha de referencia segura; segunda con fecha de esa referencia + hora laboral con minutos | todos los slots de la fecha de referencia con horaInicio >= hora ceil; el slot de la hora iniciada se descarta |

#### Scenario: Ceil con minutos descartando el slot actual

- GIVEN una fecha de referencia segura obtenida de la primera llamada (día 15 del mes actual)
- AND horaConfigurada = hora laboral con minutos (ej: minHora + 30min) → ceil = minHora + 1h
- WHEN se invoca `ObtenerHorariosDisponiblesFiltrados` con fechaConfigurada y FiltroHora.Mayor
- THEN todos los slots devueltos tienen FechaDisponible == fechaRef
- AND todos los slots tienen horaInicio >= hora ceil
- AND ningún slot tiene horaInicio == horaConfigurada (el slot iniciado se descarta por el ceil)

### Requirement: Test 3 determinista — Desplaza al día siguiente

| # | Prueba | Tipo | Descripción | Resultado |
|---|--------|------|-------------|-----------|
| 3 | FiltroHoraMayor fin de jornada → desplaza al día siguiente (determinista) | Edge Case | Primera llamada con fecha fija (día 15) para fecha de referencia; segunda con maxHora como hora | todos los slots del día siguiente a la fecha de referencia con horaInicio >= minHora |

#### Scenario: Salto de fin de jornada garantizado

- GIVEN una fecha de referencia segura obtenida de la primera llamada (día 15 del mes actual)
- AND horaConfigurada = maxHora (última hora laboral)
- WHEN se invoca `ObtenerHorariosDisponiblesFiltrados` con fechaConfigurada y FiltroHora.Mayor
- THEN todos los slots devueltos tienen FechaDisponible == fechaRef + 1 día
- AND todos los slots tienen horaInicio >= minHora
- AND no existe rama condicional sobre la hora actual

### Requirement: Test 4 determinista — Permanece en día actual

| # | Prueba | Tipo | Descripción | Resultado |
|---|--------|------|-------------|-----------|
| 4 | FiltroHoraMayor dentro de jornada → permanece en día actual (determinista) | Happy Path | Primera llamada con fecha fija (día 15) para fecha de referencia; segunda con hora laboral exacta dentro del rango | todos los slots de la fecha de referencia con horaInicio >= horaConfigurada |

#### Scenario: Dentro de jornada sin salto

- GIVEN una fecha de referencia segura obtenida de la primera llamada (día 15 del mes actual)
- AND horaConfigurada = hora laboral exacta dentro del rango (ej: minHora + 1h)
- WHEN se invoca `ObtenerHorariosDisponiblesFiltrados` con fechaConfigurada y FiltroHora.Mayor
- THEN todos los slots devueltos tienen FechaDisponible == fechaRef
- AND todos los slots tienen horaInicio >= horaConfigurada
- AND no existe rama condicional sobre la hora actual

## Notas

- Test 2 (`FiltroHoraMayor_FechaExplicitaFutura_Referencia00Preservada`) no cambia.
- El guard `horaRef > maxHora` se elimina del helper — ObtenerHorariosDisponiblesFiltrados ya resuelve la normalización.
- La fecha esperada del test 3 se calcula como `fechaRef.AddDays(1)` (con NormalizarFechaReferencia si corresponde), no contra DateTime.Today.AddDays(1).
- La fecha fija (día 15) garantiza predictibilidad: nunca cae en fin de mes, evitando diferencia de 2 días.