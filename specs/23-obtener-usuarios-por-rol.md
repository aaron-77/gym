# Specification for obtenerUsuariosPorRol Endpoint

## Purpose

Define the behavior and requirements for the `GET /api/obtenerUsuariosPorRol` endpoint in the FitnessGym API, which retrieves users filtered by role. This endpoint is restricted to employees only.

## Integration Requirements

### Requirement: Authenticated Employee - Query by Cliente

The endpoint MUST return users with "cliente" role when accessed by an authenticated employee.

#### Scenario: Valid employee token querying clientes

- GIVEN the user is authenticated with a valid JWT token with "empleado" role
- WHEN a GET request is made to `/api/obtenerUsuariosPorRol?rol=cliente` with authentication headers
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a list of `QueryUser` objects with role "cliente"

### Requirement: Authenticated Employee - Query by Entrenador

The endpoint MUST return users with "entrenador" role when accessed by an authenticated employee.

#### Scenario: Valid employee token querying entrenadores

- GIVEN the user is authenticated with a valid JWT token with "empleado" role
- WHEN a GET request is made to `/api/obtenerUsuariosPorRol?rol=entrenador` with authentication headers
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a list of `QueryUser` objects with role "entrenador"

### Requirement: No Token

The endpoint MUST return unauthorized when no token is provided.

#### Scenario: No authentication token

- GIVEN no authentication token is provided
- WHEN a GET request is made to `/api/obtenerUsuariosPorRol`
- THEN the response status MUST be `401 Unauthorized`

### Requirement: Client Token

The endpoint MUST return forbidden when accessed by a client (not employee).

#### Scenario: Client token

- GIVEN the user is authenticated with a valid JWT token with "cliente" role (not employee)
- WHEN a GET request is made to `/api/obtenerUsuariosPorRol` with authentication headers
- THEN the response status MUST be `403 Forbidden`
