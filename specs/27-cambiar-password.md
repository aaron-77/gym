# Specification for cambiarPassword Endpoint

## Purpose

Define the behavior and requirements for the `POST /api/cambiarPassword` endpoint in the FitnessGym API, which allows users to change their password.

## Integration Requirements

### Requirement: Valid Email and Passwords

The endpoint MUST change the password when valid email and passwords are provided.

#### Scenario: Valid password change request

- GIVEN a user exists in the database with the provided email
- AND the current password is correct
- WHEN a POST request is made to `/api/cambiarPassword` with valid UserPassEdit
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`

### Requirement: Non-existent Email

The endpoint MUST return bad request when email does not exist.

#### Scenario: Email not in system

- GIVEN no user exists in the database with the provided email
- WHEN a POST request is made to `/api/cambiarPassword` with non-existent email
- THEN the response status MUST be `400 Bad Request`

### Requirement: Invalid Request

The endpoint MUST return bad request when request data is invalid.

#### Scenario: Invalid or missing fields

- GIVEN a request with invalid or missing required fields
- WHEN a POST request is made to `/api/cambiarPassword`
- THEN the response status MUST be `400 Bad Request`
