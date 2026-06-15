# Specification for refresh Token Endpoint

## Purpose

Define the behavior and requirements for the `POST /api/refresh` endpoint in the FitnessGym API, which refreshes JWT tokens using a refresh token.

## Integration Requirements

### Requirement: Valid Refresh Token

The endpoint MUST return new tokens when a valid refresh token is provided.

#### Scenario: Valid refresh token

- GIVEN the user is authenticated with a valid JWT token
- AND a valid refresh token exists in the database
- WHEN a POST request is made to `/api/refresh` with valid RefreshTokenRequest
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a `DTOLoggedUser` with new AccessToken and RefreshToken

### Requirement: No Token

The endpoint MUST return unauthorized when no authentication token is provided.

#### Scenario: No authentication token

- GIVEN no authentication token is provided
- WHEN a POST request is made to `/api/refresh`
- THEN the response status MUST be `401 Unauthorized`

### Requirement: Invalid or Expired Refresh Token

The endpoint MUST return unauthorized when refresh token is invalid or expired.

#### Scenario: Invalid refresh token

- GIVEN a refresh token that is invalid or expired
- WHEN a POST request is made to `/api/refresh` with invalid refresh token
- THEN the response status MUST be `401 Unauthorized`
