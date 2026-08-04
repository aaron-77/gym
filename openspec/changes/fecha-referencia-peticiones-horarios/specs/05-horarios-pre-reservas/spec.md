# Delta for 05-horarios-pre-reservas

## Purpose

The frontend scheduler (`agendarioDeHorarios.js`) MUST send the browser's reference date as the `fecha` query param (`yyyy-MM-dd`, via `toLocaleDateString('sv-SE')`) in EVERY GET request to `obtenerPreReservas`, just as it does for `obtenerHorariosDisponibles`. The endpoint already accepts an optional `fecha` param, so requests without it MUST keep working (backward compatibility).

## ADDED Requirements

### Requirement: The scheduler always sends the reference date to obtenerPreReservas

The frontend scheduler MUST include the query param `fecha` with the browser's current date formatted as `yyyy-MM-dd` in every request it makes to `obtenerPreReservas`, including requests made without an explicit date argument.

#### Scenario: Initialization without an explicit date

- GIVEN a page using `agendarioDeHorarios.js` is loaded
- WHEN `obtenerHorariosNuevos` is invoked without a date argument
- THEN the request to `obtenerPreReservas` MUST include `fecha` equal to today in `yyyy-MM-dd` format

#### Scenario: Month or year navigation

- GIVEN the user navigates the calendar to another month or year
- WHEN the change handler triggers a new horario fetch
- THEN the request to `obtenerPreReservas` MUST include `fecha` with the navigated date in `yyyy-MM-dd` format

#### Scenario: Reload after SignalR reconnection

- GIVEN the SignalR connection reconnects
- WHEN the scheduler reloads horarios
- THEN the request to `obtenerPreReservas` MUST include `fecha` with today's date in `yyyy-MM-dd` format

### Requirement: Backward compatibility when fecha is omitted

The endpoint MUST keep returning pre-reserved horarios when the `fecha` query param is absent. The param is optional and its absence MUST NOT break existing callers or change the response contract.

#### Scenario: GET without fecha returns all pre-reservas

- GIVEN there are pre-reserved horarios in the database (preReservasDeHorario table)
- AND the user is authenticated with a valid JWT token with "empleado" role
- WHEN a GET request is made to `/api/horarios/obtenerPreReservas` without `fecha`
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a list of `DTOHorarioVisualizacion` objects
