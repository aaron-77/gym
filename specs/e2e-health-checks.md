# Specification for Health Check Endpoints

## Purpose

Define the health check endpoints configuration for the FitnessGym API and Frontend applications. This spec establishes the health check mechanism used for container orchestration (wait strategies in E2E tests) and load balancer probes.

## Integration Requirements

### Requirement: Health Check Endpoint in API

The API MUST expose a health check endpoint for container orchestration and monitoring.

#### Scenario: API health check returns healthy status

- GIVEN the API container is running
- WHEN a GET request is made to `/health`
- THEN the response status MUST be `200 OK`
- AND the response body MUST be JSON with a `status` field
- AND the value MUST be `"Healthy"` when all checks pass

#### Scenario: API health check with rate limiting

- GIVEN a client sends more than 100 requests per minute to `/health`
- THEN HTTP 429 Too Many Requests MUST be returned
- AND the rate limit policy MUST be named `"HealthPolicy"`

### Requirement: Health Check Endpoint in Frontend

The Frontend MUST expose a health check endpoint for container orchestration and monitoring.

#### Scenario: Frontend health check returns healthy status

- GIVEN the Frontend container is running
- WHEN a GET request is made to `/health`
- THEN the response status MUST be `200 OK`
- AND the response body MUST be JSON with a `status` field
- AND the value MUST be `"Healthy"` when all checks pass

#### Scenario: Frontend health check with rate limiting

- GIVEN a client sends more than 100 requests per minute to `/health`
- THEN HTTP 429 Too Many Requests MUST be returned
- AND the rate limit policy MUST be named `"HealthPolicy"`

### Requirement: Health Check Configuration in E2E Tests

The E2E test infrastructure MUST verify containers are healthy before running tests.

#### Scenario: API container wait strategy

- GIVEN the E2eContainerHelper is initializing the API container
- THEN the container wait strategy MUST use HTTP health check on `/health`
- AND it MUST wait until the endpoint returns 200 OK

#### Scenario: Frontend container wait strategy

- GIVEN the E2eContainerHelper is initializing the Frontend container
- THEN the container wait strategy MUST use HTTP health check on `/health`
- AND it MUST wait until the endpoint returns 200 OK

### Requirement: Rate Limiting Policy

Both API and Frontend MUST implement rate limiting to prevent abuse of health endpoints.

#### Scenario: Rate limiter configuration

- GIVEN the application starts
- THEN a rate limiter policy named `"HealthPolicy"` MUST be registered
- AND it MUST allow 100 requests per minute per IP
- AND the window size MUST be 1 minute
- AND the queue limit MUST be 0 (reject excess requests)

## Technical Implementation

### Endpoint Configuration

| Application | Endpoint | Port (Internal) | Rate Limit |
|-------------|----------|-----------------|------------|
| API | `/health` | 5274 | 100 req/min |
| Frontend | `/health` | 5062 | 100 req/min |

### Routing via Nginx

| Path Nginx | Destino | Puerto |
|------------|---------|--------|
| `/health` | Frontend | 5062 |
| `/api/*` | API | 5274 |
| `/*` | Frontend | 5062 |

### Access Points

| URL | Via | Destino | Status |
|----|-----|--------|--------|
| `localhost:5274/health` | Directo API | API | ✅ 200 |
| `localhost:5062/health` | Directo Frontend | Frontend | ✅ 200 |
| `localhost:5080/health` | Nginx → Frontend | Frontend | ✅ 200 |
| `localhost:5080/api/health` | Nginx → API | API | ✅ 200 |

### Response Format

```json
{"status":"Healthy"}
```

### Response Format (Degraded)

```json
{"status":"Unhealthy"}
```

### Package Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| AspNetCore.HealthChecks.Uris | 8.0+ | HTTP health check validation |

## Acceptance Criteria

1. ✅ GET `/health` returns 200 OK with `{"status":"Healthy"}` when API/Frontend is running
2. ✅ Rate limiting allows 100 requests per minute to health endpoints
3. ✅ E2E tests wait for `/health` to return 200 before proceeding
4. ✅ Response uses `System.Text.Json.JsonSerializer` for JSON serialization