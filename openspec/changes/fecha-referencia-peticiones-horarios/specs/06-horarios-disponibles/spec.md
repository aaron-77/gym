# Delta for 06-horarios-disponibles

## Purpose

The frontend scheduler (`agendarioDeHorarios.js`) MUST send the browser's reference date as the `fecha` query param (`yyyy-MM-dd`, via `toLocaleDateString('sv-SE')`) in EVERY GET request to `obtenerHorariosDisponibles` and `obtenerPreReservas`. The expired-hour filter (Requirement 13) MUST be evaluated against that received reference date, not against the server clock.

## ADDED Requirements

### Requirement: The scheduler always sends the reference date in horario requests

The frontend scheduler MUST include the query param `fecha` with the browser's current date formatted as `yyyy-MM-dd` in every request it makes to `obtenerHorariosDisponibles` and `obtenerPreReservas`, including requests made without an explicit date argument.

#### Scenario: Initialization without an explicit date

- GIVEN a page using `agendarioDeHorarios.js` is loaded
- WHEN `obtenerHorariosNuevos` is invoked without a date argument
- THEN the request to `obtenerHorariosDisponibles` MUST include `fecha` equal to today in `yyyy-MM-dd` format
- AND the request to `obtenerPreReservas` MUST include the same `fecha` value

#### Scenario: Month or year navigation

- GIVEN the user navigates the calendar to another month or year
- WHEN the change handler triggers a new horario fetch
- THEN both horario requests MUST include `fecha` with the navigated date in `yyyy-MM-dd` format

#### Scenario: Reload after SignalR reconnection

- GIVEN the SignalR connection reconnects
- WHEN the scheduler reloads horarios
- THEN both horario requests MUST include `fecha` with today's date in `yyyy-MM-dd` format

## MODIFIED Requirements

### Requirement 13: Horarios Disponibles Filtra Horas Vencidas del Día Actual

The endpoint MUST NOT return horarios whose `horaInicio` has already passed when the reference date (received via the `fecha` query param) is today. Only horarios with `horaInicio` later than the current time SHALL be returned for the current date. The "is it today?" decision MUST be based on the received `fecha` reference, not on the server's own clock. This filter does NOT apply to future dates.
(Previously: the endpoint relied on the server's current date when the request had no date parameter; the hour filter applied against GETDATE())

#### Scenario: Hoy a las 15:30, no se devuelven horarios anteriores

- GIVEN there are available horarios at 06:00, 07:00, ..., 16:00, 17:00 for today
- AND the current time is 15:30
- AND the reference date sent by the browser is today
- WHEN a GET request is made to `/api/horarios/obtenerHorariosDisponibles?fecha=<today>`
- THEN the response status MUST be `200 OK`
- AND the `payload` MUST NOT include horarios with `horaInicio` before 15:30

#### Scenario: Hoy a las 15:30, sí se devuelven horarios desde las 16:00 en adelante

- GIVEN there are available horarios at 06:00, 07:00, ..., 15:30, 16:00, 17:00 for today
- AND the current time is 15:30
- AND the reference date sent by the browser is today
- WHEN a GET request is made to `/api/horarios/obtenerHorariosDisponibles?fecha=<today>`
- THEN the response status MUST be `200 OK`
- AND the `payload` MUST include horarios con `horaInicio` a las 16:00 y 17:00
- AND the `payload` MUST NOT include horarios con `horaInicio` a las 15:30 o anteriores

#### Scenario: Fecha futura, se devuelven todos los horarios sin filtro de hora

- GIVEN the requested date is tomorrow (a future date)
- AND there are available horarios at 06:00, 07:00, ..., 17:00 for tomorrow
- AND the current time is 15:30
- WHEN a GET request is made to `/api/horarios/obtenerHorariosDisponibles?fecha=<tomorrow>`
- THEN the response status MUST be `200 OK`
- AND the `payload` MUST include ALL horarios for tomorrow, including those with `horaInicio` before 15:30
