# Delta for 51-spect-filtroHoraUnico-test

## Purpose

El test 3 `FiltroHoraMayor_FinDeJornada_DesplazaAlDiaSiguiente` deja de depender del reloj runtime: pasa fecha y hora explícitas (hoy con una hora posterior a la última hora laboral) para que el salto de fin de jornada se dispare SIEMPRE por construcción, sin if/else sobre la hora actual. Las pruebas 1, 2 y 4 no cambian.

## MODIFIED Requirements

### Requirement: Test 3 determinista con fecha y hora explícitas

La fila 3 de la tabla de pruebas del spec 51 SHALL quedar así (el resto de la tabla no cambia):

| # | Prueba | Tipo | Descripción | Resultado |
|---|--------|------|-------------|-----------|
| 3 | FiltroHoraMayor fin de jornada → desplaza al día siguiente (determinista) | Edge Case | Consultar minHora y maxHora a la BD; fecha explícita = hoy con hora = maxHora + 1 hora; sin seeding (el SP genera los slots vacíos del calendario) | todos los slots del día siguiente (aplicando fin de mes) con horaInicio >= minHora; sin ramas condicionales sobre el reloj |

(Previously: la consulta se ejecutaba sin fecha explícita y el resultado esperado se decidía por if/else comparando la hora actual contra la última hora laboral)

#### Scenario: Salto de fin de jornada garantizado por construcción

- GIVEN minHora y maxHora consultados a la BD (patrón de las demás pruebas del archivo)
- AND la hora de referencia = maxHora más una hora (siempre mayor que maxHora)
- AND la fecha explícita = la fecha de hoy con esa hora de referencia
- AND no hay seeding: el SP genera los slots vacíos del calendario de la fecha consultada
- WHEN se invoca `ObtenerHorariosDisponiblesFiltrados` con filtro de fecha Igual, filtro de hora Mayor y esa fecha explícita
- THEN todos los slots devueltos pertenecen al día siguiente al de la fecha base
- AND todos los slots tienen horaInicio >= minHora
- AND no existe rama condicional sobre la hora actual: el salto dispara por construcción

#### Scenario: Última hora laboral a las 23:00 (borde de medianoche)

- GIVEN maxHora = 23:00 y la hora de referencia = maxHora más una hora (24:00)
- AND la fecha explícita se construye avanzando horas desde hoy, de modo que cruzar la medianoche rola al día siguiente con hora 00:00
- WHEN se invoca el filtro con esa fecha explícita
- THEN la consulta opera sobre el día siguiente y la aserción permanece sobre ese día
- AND la fecha esperada del día siguiente se calcula aplicando la misma regla de fin de mes del helper (si cae en el último día del mes, se espera el primer día del mes posterior)

#### Scenario: Regresión de las pruebas 1, 2 y 4

- GIVEN las pruebas 1 y 4 (sin fecha explícita, guard 1: ceil de la hora actual) y la prueba 2 (fecha futura con hora 00:00, guard 3: hora exacta preservada)
- WHEN se ejecutan tras este cambio
- THEN sus descripciones, resultados esperados y aserciones permanecen tal cual
- AND ninguna de ellas depende de la fecha explícita con hora del test 3

## Notas

- Siguen fuera de alcance los tests derivados: ceil de fecha explícita con minutos/segundos (guard 2 del spec 50), horaRef igual a maxHora en el borde exacto. El borde 23:00 queda documentado dentro del test 3; el fin de mes se cubre en la aserción de la fecha esperada del test 3.
- La fecha con hora de referencia del test 3 es de hora exacta (minutos y segundos en cero): no ejercita el ceil de la guard 2, solo el salto de jornada.