# Specification for obtenerUsuarios Endpoint

## Purpose

Define the behavior and requirements for the `GET /api/obtenerUsuarios` endpoint in the FitnessGym API, which retrieves all users. This endpoint is restricted to employees only.

## Integration Requirements

### Requirement: Authenticated Employee

The endpoint MUST return all users when accessed by an authenticated employee.

#### Scenario: Valid employee token

- GIVEN the user is authenticated with a valid JWT token with "empleado" role
- WHEN a GET request is made to `/api/obtenerUsuarios` with authentication headers
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a list of `ExistingUser` objects

### Requirement: No Token

The endpoint MUST return unauthorized when no token is provided.

#### Scenario: No authentication token

- GIVEN no authentication token is provided
- WHEN a GET request is made to `/api/obtenerUsuarios`
- THEN the response status MUST be `401 Unauthorized`

### Requirement: Client Token

The endpoint MUST return forbidden when accessed by a client (not employee).

#### Scenario: Client token

- GIVEN the user is authenticated with a valid JWT token with "cliente" role (not employee)
- WHEN a GET request is made to `/api/obtenerUsuarios` with authentication headers
- THEN the response status MUST be `403 Forbidden`
