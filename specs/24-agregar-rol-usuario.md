# Specification for AgregarRolUsuario Endpoint

## Purpose

Define the behavior and requirements for the `POST /api/AgregarRolUsuario` endpoint in the FitnessGym API, which assigns a role to an existing user. This endpoint is restricted to employees only.

## Integration Requirements

### Requirement: Authenticated Employee

The endpoint MUST assign a role to a user when accessed by an authenticated employee.

#### Scenario: Valid employee token

- GIVEN the user is authenticated with a valid JWT token with "empleado" role
- AND a valid user exists in the database
- WHEN a POST request is made to `/api/AgregarRolUsuario` with valid DTOAgregarRol
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`

### Requirement: No Token

The endpoint MUST return unauthorized when no token is provided.

#### Scenario: No authentication token

- GIVEN no authentication token is provided
- WHEN a POST request is made to `/api/AgregarRolUsuario`
- THEN the response status MUST be `401 Unauthorized`

### Requirement: Client Token

The endpoint MUST return forbidden when accessed by a client (not employee).

#### Scenario: Client token

- GIVEN the user is authenticated with a valid JWT token with "cliente" role (not employee)
- WHEN a POST request is made to `/api/AgregarRolUsuario` with authentication headers
- THEN the response status MUST be `403 Forbidden`
