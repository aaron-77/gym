# Specification for RegistrarUsuario Endpoint

## Purpose

Define the behavior and requirements for the `POST /api/RegistrarUsuario` endpoint in the FitnessGym API, which registers new users.

## Integration Requirements

### Requirement: Valid Data

The endpoint MUST register a new user with valid data.

#### Scenario: Valid registration data

- GIVEN a user does NOT exist in the database with the provided email
- WHEN a POST request is made to `/api/RegistrarUsuario` with valid NewUser data
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a `DTOCreatedUser` object

### Requirement: Duplicate Email

The endpoint MUST return bad request when email already exists.

#### Scenario: Duplicate email

- GIVEN a user already exists in the database with the provided email
- WHEN a POST request is made to `/api/RegistrarUsuario` with duplicate email
- THEN the response status MUST be `400 Bad Request` or `500 Internal Server Error`

### Requirement: Invalid Data

The endpoint MUST return bad request when data is invalid.

#### Scenario: Invalid or missing required fields

- GIVEN a request with invalid or missing required fields
- WHEN a POST request is made to `/api/RegistrarUsuario`
- THEN the response status MUST be `400 Bad Request`
