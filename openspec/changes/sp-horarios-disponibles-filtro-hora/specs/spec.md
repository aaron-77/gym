# Delta for 06-horarios-disponibles

## Purpose

Documentar el filtro de horas vencidas en `sp_obtenerHorariosDisponibles` para el día actual, y los escenarios de regresión que deben mantenerse. Actualmente el SP filtra fechas pasadas pero no horas vencidas del día de hoy.

## ADDED Requirements

### Requirement 1: SP filtra horas vencidas del día actual

The SP MUST exclude horarios whose `horaInicio` has already passed when evaluating today's date. Only horarios with `horaInicio` greater than the current time SHALL be returned for the current date.

#### Scenario: Hoy a las 15:30, NO se devuelven slots anteriores a las 15:30

- GIVEN the current time is 15:30
- AND there are available horarios at 06:00, 07:00, ..., 15:00, 16:00, 17:00 for today
- WHEN the SP executes without a `@Fecha` parameter (defaults to today)
- THEN the result set MUST NOT include horarios with `horaInicio` before 15:30

#### Scenario: Hoy a las 15:30, SÍ se devuelven slots desde las 16:00 en adelante

- GIVEN the current time is 15:30
- AND there are available horarios at 15:00, 15:30, 16:00, 17:00 for today
- WHEN the SP executes without a `@Fecha` parameter
- THEN the result set MUST include horarios with `horaInicio` at 16:00 and 17:00
- AND the result set MUST NOT include horarios with `horaInicio` at 15:00 or 15:30

### Requirement 2: SP NO filtra horas para fechas futuras

The SP MUST return ALL available horarios for future dates regardless of the current time. The hour filter SHALL only apply to the current date.

#### Scenario: Fecha futura, se devuelven todos los slots del día

- GIVEN the requested date is tomorrow (a future date)
- AND the current time is 15:30
- AND there are available horarios at 06:00, 07:00, ..., 17:00 for tomorrow
- WHEN the SP executes with `@Fecha = tomorrow`
- THEN the result set MUST include all horarios including those with `horaInicio` before 15:30

## Unchanged Behavior (Explicitly Preserved)

### Requirement 3: SP con fecha del mes anterior retorna vacío

The SP MUST return an empty result set when the requested date is in the past (previous month or earlier). This is existing behavior that MUST be preserved.

#### Scenario: Fecha del mes anterior devuelve conjunto vacío

- GIVEN the requested date is in the previous month
- WHEN the SP executes with `@Fecha = past-date`
- THEN the result set MUST be empty
