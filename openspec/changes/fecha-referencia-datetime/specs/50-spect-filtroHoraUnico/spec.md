# Delta for 50-spect-filtroHoraUnico

## Purpose

`HorariosHelper.ObtenerHorariosDisponiblesFiltrados` deja de descartar la hora de la fecha explícita: cuando `fecha` llega con hora distinta de 00:00, esa hora MANDA como referencia del filtro `FiltroHora.Mayor` y como disparador del salto de fin de jornada. Se define la regla de composición día-siguiente × fin-de-mes con una única normalización al final. El stored procedure NO se toca; los callers que pasan null o 00:00 conservan la selección de guard clause actual.

## MODIFIED Requirements

### Requirement: Guard clause 2 activa — la fecha explícita con hora manda

La referencia horaria de `FiltroHora.Mayor` se resuelve con las tres guard clauses del spec 50 §3.3; la guard clause 2 pasa de teórica a ACTIVA:

| # | Fecha de referencia | Acción sobre la referencia horaria |
|---|---------------------|------------------------------------|
| 1 | Sin fecha explícita (null) | Ceil a la próxima hora completa desde la hora actual (sin cambios) |
| 2 | Explícita con hora ≠ 00:00 | La hora recibida es la referencia del filtro y del salto de fin de jornada; con minutos/segundos ≠ 0 se aplica ceil a la próxima hora completa y el salto evalúa sobre esa referencia resuelta |
| 3 | Explícita con hora exacta 00:00 | Se toma tal cual (sin cambios) |

(Previously: la guard 2 era teórica porque ningún caller pasaba hora ≠ 00:00; la fecha se truncaba a su parte de fecha y la hora recibida se descartaba)

#### Scenario: La hora recibida manda en el filtro

- GIVEN fecha explícita = hoy a las 16:00, dentro de la jornada
- WHEN se invoca el filtro con esa fecha y `FiltroHora.Mayor`
- THEN la consulta permanece en el día recibido
- AND solo devuelve slots con horaInicio >= 16:00

#### Scenario: La hora recibida dispara el salto de fin de jornada

- GIVEN última hora laboral 22:00 y fecha explícita = hoy a las 23:00
- WHEN se invoca el filtro con esa fecha
- THEN la consulta se desplaza al día siguiente y devuelve slots con horaInicio >= la primera hora laboral

#### Scenario: Con minutos y segundos se conserva el ceil

- GIVEN fecha explícita = hoy a las 16:35
- WHEN se invoca el filtro
- THEN la referencia es 17:00 (ceil por guard 2) y el salto evalúa sobre esa referencia resuelta

## ADDED Requirements

### Requirement: Regla de composición día-siguiente × fin-de-mes

La resolución de la fecha de referencia SHALL seguir exactamente este orden:

1. Se toma la fecha recibida a secas (solo su parte de fecha; si no se recibió, la fecha de hoy), sin redondear ni normalizar.
2. Si la referencia horaria resuelta supera la última hora laboral, se avanza esa fecha UN día calendario.
3. Recién al final se aplica la normalización de fin de mes (requisito siguiente).

Todo el resto del flujo (llamada al SP y filtros de fecha y hora) usa la fecha resultante del paso 3. El orden es obligatorio porque normalizar y avanzar un día NO conmutan: normalizar primero y avanzar después reintroduce el doble salto — una fecha que ya cayó en el último día del mes se movería al mes siguiente y luego el avance la desplazaría otro mes más.

#### Scenario: Fecha con hora superior a la última hora laboral

- GIVEN última hora laboral 22:00 y fecha = el 20 de enero de 2026 a las 23:00
- WHEN se avanza un día sobre la fecha cruda y se normaliza al final
- THEN la referencia final es el 21 de enero, sin salto extra

#### Scenario: El salto aterriza en el último día del mes

- GIVEN última hora laboral 22:00 y fecha = el 30 de enero de 2026 a las 23:00
- WHEN se avanza un día sobre la fecha cruda
- THEN la fecha cruda pasa al 31 de enero y la normalización final la mueve al 1 de febrero
- AND el SP regenera el calendario completo de febrero

#### Scenario: Fin de mes sin doble salto

- GIVEN fecha = el 31 de enero de 2026 a las 23:00
- WHEN se avanza un día sobre la fecha cruda y se normaliza al final
- THEN la referencia final es el 1 de febrero, NUNCA el 2 de febrero

#### Scenario: Rollover de año

- GIVEN fecha = el 31 de diciembre de 2026 a las 23:00
- WHEN se avanza un día y se normaliza al final
- THEN la referencia final es el 1 de enero de 2027

### Requirement: Criterio de fin de mes

Si la fecha de referencia (desplazada o no) cae en el último día del mes, la normalización SHALL moverla al primer día del mes siguiente para que el SP regenere el calendario completo de ese mes. La normalización SHALL aplicarse UNA sola vez y siempre al final de la composición.

#### Scenario: Fin de mes sin salto de hora

- GIVEN última hora laboral 22:00 y fecha = el 31 de enero de 2026 a las 12:00 (dentro de la jornada)
- WHEN se resuelve la composición (sin avance de día)
- THEN la normalización final mueve la referencia al 1 de febrero
- AND el SP regenera el mes completo de febrero

### Requirement: Callers sin hora conservan el comportamiento

Todo caller que pase null o una fecha con hora 00:00 SHALL conservar la misma selección de guard clause: guard 1 (ceil de la hora actual) para null y guard 3 (hora exacta 00:00) para 00:00. El salto de jornada solo puede dispararse si la referencia resultante supera la última hora laboral, como hoy; la hora 00:00 nunca lo dispara.

#### Scenario: Regresión de callers sin hora

- GIVEN un caller pasa null (guard 1) o una fecha con hora 00:00 (guard 3)
- WHEN se invoca el filtro
- THEN la referencia horaria se resuelve igual que hoy y el resultado general no cambia
- AND la única diferencia posible es la corrección del doble salto en la noche del último día del mes, que pasa de saltar dos meses a saltar uno (comportamiento correcto buscado)