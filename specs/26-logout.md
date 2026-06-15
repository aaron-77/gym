# Specification for logout Endpoint

## Purpose

Define the behavior and requirements for the `POST /api/logout` endpoint in the FitnessGym API, which revokes the refresh token and logs out the user.

## Integration Requirements

### Requirement: Authenticated User

The endpoint MUST revoke the refresh token when accessed by an authenticated user.

#### Scenario: Valid token

- GIVEN the user is authenticated with a valid JWT token
- AND a valid refresh token exists in the database
- WHEN a POST request is made to `/api/logout` with valid LogoutRequest
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`

### Requirement: No Token

The endpoint MUST return unauthorized when no authentication token is provided.

#### Scenario: No authentication token

- GIVEN no authentication token is provided
- WHEN a POST request is made to `/api/logout`
- THEN the response status MUST be `401 Unauthorized`
