# Specification for autenticar Endpoint

## Purpose

Define the behavior and requirements for the `POST /api/autenticar` endpoint in the FitnessGym API, which authenticates users and returns JWT tokens.

## Integration Requirements

### Requirement: Valid Credentials

The endpoint MUST authenticate user with valid credentials.

#### Scenario: Valid credentials

- GIVEN a user exists in the database with correct credentials
- WHEN a POST request is made to `/api/autenticar` with valid UserCredentials
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a `DTOLoggedUser` object with AccessToken

### Requirement: Invalid Credentials

The endpoint MUST return unauthorized for invalid credentials.

#### Scenario: Invalid credentials

- GIVEN a user does NOT exist or password is incorrect
- WHEN a POST request is made to `/api/autenticar` with invalid UserCredentials
- THEN the response status MUST be `401 Unauthorized`
