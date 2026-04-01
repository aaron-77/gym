# Specification for Horarios - Available Horarios and Pre-Reservation Endpoints

## Purpose

Define the behavior and requirements for the available horarios and pre-reservation creation endpoints in the FitnessGym API.

## Integration Requirements (Happy Path)

### Requirement 1: Authenticated User Requests Available Horarios

The endpoint MUST return a list of available (non-reserved) horarios when the user is authenticated with "empleado" role.

#### Scenario: Authenticated employee requests all available horarios

- GIVEN there are available horarios in the `horasLaborales` table (not pre-reserved)
- AND the user is authenticated with a valid JWT token with "empleado" role
- WHEN a GET request is made to `/api/horarios/obtenerHorariosDisponibles` with authentication headers
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a list of `DTOHorarioVisualizacion` objects
- AND each object MUST have `idHora > 0`, `fechaDisponible` populated, and `horaInicio`/`horaFin` valid
- AND each returned `idHora` MUST exist in the `horasLaborales` table (verified via direct DB query)

### Requirement 2: Authenticated User Requests Available Horarios for Specific Date

The endpoint MUST return available horarios filtered by the provided date parameter.

#### Scenario: Authenticated employee requests available horarios for a specific date

- GIVEN there are available horarios in the database
- AND the user is authenticated with a valid JWT token with "empleado" role
- WHEN a GET request is made to `/api/horarios/obtenerHorariosDisponibles?fecha=YYYY-MM-DD` with authentication headers
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain only `DTOHorarioVisualizacion` objects matching the requested date

### Requirement 3: Authenticated User Creates a Pre-Reservation

The endpoint MUST create a new pre-reservation when valid data is provided by an authenticated employee.

#### Scenario: Authenticated employee creates a valid pre-reservation

- GIVEN there is at least one valid `idHoraLaboral` in the `horasLaborales` table (obtained via direct DB query: `SELECT TOP 1 idHora FROM horasLaborales`)
- AND the user is authenticated with a valid JWT token with "empleado" role
- WHEN a POST request is made to `/api/horarios/preReservarHorario` with:
  - Authentication headers
  - Body containing a valid `DTOPreReservaDeHorario` with:
    - `fechaTentativa`: a future DateOnly value
    - `idHoraLaboral`: a valid ID obtained from the `horasLaborales` table
    - `idUsuarioQueReserva`: the authenticated user's ID
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain an integer greater than 0 (the created pre-reservation ID)
- AND a new record MUST exist in the `preReservasDeHorario` table with the returned ID (verified via direct DB query)

## Sad Path Requirements

### Requirement 4: Unauthenticated Request to Available Horarios Returns 401

The endpoint MUST reject requests without valid authentication.

#### Scenario: Request without authentication token

- GIVEN no authentication token is provided
- WHEN a GET request is made to `/api/horarios/obtenerHorariosDisponibles`
- THEN the response status MUST be `401 Unauthorized`

### Requirement 5: Unauthenticated Request to Pre-Reservation Returns 401

The endpoint MUST reject requests without valid authentication.

#### Scenario: Request without authentication token

- GIVEN no authentication token is provided
- WHEN a POST request is made to `/api/horarios/preReservarHorario`
- THEN the response status MUST be `401 Unauthorized`