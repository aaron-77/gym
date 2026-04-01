# Specification for Horarios - Pre-Reservas Endpoints

## Purpose

Define the behavior and requirements for the pre-reservation horario endpoints in the FitnessGym API.

## Integration Requirements (Happy Path)

### Requirement 1: Authenticated User Requests Pre-Reserved Horarios

The endpoint MUST return a list of pre-reserved horarios when the user is authenticated with "empleado" role.

#### Scenario: Authenticated employee requests all pre-reserved horarios

- GIVEN there are pre-reserved horarios in the database (preReservasDeHorario table)
- AND the user is authenticated with a valid JWT token with "empleado" role
- WHEN a GET request is made to `/api/horarios/obtenerPreReservas` with authentication headers
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a list of `DTOHorarioVisualizacion` objects
- AND each object MUST have `idHora > 0`, `fechaDisponible` populated, and `horaInicio`/`horaFin` valid
- AND each returned horario MUST exist in the `preReservasDeHorario` table (verified via direct DB query)

### Requirement 2: Authenticated User Requests Pre-Reserved Horarios for Specific Date

The endpoint MUST return pre-reserved horarios filtered by the provided date parameter.

#### Scenario: Authenticated employee requests pre-reserved horarios for a specific date

- GIVEN there are pre-reserved horarios in the database for various dates
- AND the user is authenticated with a valid JWT token with "empleado" role
- WHEN a GET request is made to `/api/horarios/obtenerPreReservas?fecha=YYYY-MM-DD` with authentication headers
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain only `DTOHorarioVisualizacion` objects matching the requested date
- AND the count of returned items MUST match the count of records in `preReservasDeHorario` for that date (verified via direct DB query)

## Sad Path Requirements

### Requirement 3: Unauthenticated Request Returns 401

The endpoint MUST reject requests without valid authentication.

#### Scenario: Request without authentication token

- GIVEN no authentication token is provided
- WHEN a GET request is made to `/api/horarios/obtenerPreReservas`
- THEN the response status MUST be `401 Unauthorized`