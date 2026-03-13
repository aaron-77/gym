# Specification for Clases - Obtener Clases Endpoint

## Purpose

Define the behavior and requirements for the `GET /api/Clases/obtenerClases` endpoint in the FitnessGym API, which returns a catalog of classes (not scheduled classes).

## Integration Requirements (Happy Path)

### Requirement: Authenticated User Requests Active Classes

The endpoint MUST return a list of active classes when the user is authenticated and the `activa` parameter is `true`.

#### Scenario: Authenticated user requests active classes catalog

- GIVEN there are active classes in the database (FkEstadoClase = 1)
- AND the user is authenticated with a valid JWT token
- WHEN a GET request is made to `/api/Clases/obtenerClases?activa=true` with authentication headers
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a list of `DTOClaseSimple` objects
- AND each object MUST have `ClaseID` and `NombreClase` populated

---

## Unit Testing Requirements (Sad Paths)

### Requirement: Unauthenticated Request Returns Error

When a request is made without authentication, the system MUST return an unauthorized error.

#### Scenario: Request without authentication

- GIVEN the user is not authenticated (no JWT token)
- WHEN a GET request is made to `/api/Clases/obtenerClases?activa=true`
- THEN the response status MUST be `401 Unauthorized` (or 403 depending on config)

### Requirement: Inactive Classes Returned When activa=false

When the `activa` parameter is `false` or not provided, the endpoint MUST return inactive classes.

#### Scenario: Request with activa=false returns inactive classes

- GIVEN there are inactive classes in the database (FkEstadoClase = 2)
- AND the user is authenticated
- WHEN a GET request is made to `/api/Clases/obtenerClases?activa=false`
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a list of inactive classes

#### Scenario: Request without activa parameter defaults to false

- GIVEN there are inactive classes in the database
- AND the user is authenticated
- WHEN a GET request is made to `/api/Clases/obtenerClases` (no query parameter)
- THEN the response MUST return inactive classes (same as `activa=false`)

### Requirement: Error Handling

The endpoint MUST handle exceptions and return a proper error response.

#### Scenario: Database error returns 500

- GIVEN the database connection fails or an error occurs
- WHEN a GET request is made to `/api/Clases/obtenerClases`
- THEN the response status MUST be `500 Internal Server Error`
- AND the `success` field MUST be `false`
- AND the `errors` list MUST contain error details
