# Specification for E2E Test Infrastructure

## Purpose

Define the infrastructure configuration for end-to-end (E2E) tests using Playwright with Testcontainers in the FitnessGym project. This spec establishes the test environment setup required to run comprehensive E2E tests against the full application stack (API, Frontend, Database).

## Integration Requirements

### Requirement: Testcontainers Package

The project MUST include Testcontainers packages for E2E testing.

#### Scenario: Testcontainers.MsSql already installed

- GIVEN Testcontainers.MsSql v4.1.0 is already referenced in GymWebApp.Tests.csproj
- WHEN the E2E infrastructure is configured
- THEN add Testcontainers v4.1.0 to enable generic container management for Nginx and other services

### Requirement: E2eContainerHelper Class

The project MUST provide a helper class to manage test containers.

#### Scenario: Container helper initialization

- GIVEN E2eContainerHelper.InitializeAsync() is called
- WHEN the test environment starts
- THEN the following containers MUST be started:
  - SQL Server (Testcontainers.MsSql) on port 1433 (internal)
  - API on port 5274 (internal)
  - Frontend on port 5062 (internal)
  - Nginx reverse proxy on port 5080 (external mapped)
- AND a Docker network MUST be created for inter-container communication

#### Scenario: Container cleanup

- GIVEN E2eContainerHelper.DisposeAsync() is called
- WHEN the test environment stops
- THEN all running containers MUST be stopped and removed
- AND the Docker network MUST be removed

### Requirement: Playwright Base Class

The project MUST provide a base class for Playwright tests.

#### Scenario: Base test class setup

- GIVEN a test class inherits from PlaywrightTestBase
- WHEN the test class is initialized
- THEN E2eContainerHelper MUST be initialized in the class constructor
- AND the page MUST be available for test execution

### Requirement: Base URLs

The project MUST expose base URLs for test execution.

#### Scenario: Accessing base URLs

- GIVEN the test containers are running
- THEN FrontendBaseUrl MUST be `"http://localhost:5080"`
- AND ApiBaseUrl MUST be `"http://localhost:5274"`

## Directory Structure

The E2E test infrastructure MUST follow this directory structure:

```
GymWebApp.Tests/
└── E2E/
    └── Common/
        ├── E2eContainerHelper.cs      # Container management
        └── PlaywrightTestBase.cs  # Base class for tests
    └── Features/
        └── (test files per feature)
```

## Scenarios

### Scenario: Login Flow Test

- GIVEN a registered user exists in the database
- WHEN navigating to `/signIn`
- AND filling the login form with valid credentials
- AND submitting the form
- THEN the user SHOULD be redirected to the homepage
- AND the user session SHOULD be active

### Scenario: Homepage Load

- GIVEN the application is running
- WHEN navigating to the homepage `/`
- THEN the page SHOULD load successfully
- AND the scheduled classes SHOULD be displayed
- AND the navigation menu SHOULD be visible

### Scenario: Navigation Between Pages

- GIVEN the user is on the homepage
- WHEN clicking on a navigation link (e.g., "Clases", "Horarios")
- THEN the corresponding page SHOULD load
- AND the URL SHOULD reflect the navigation

### Scenario: API Health Check

- GIVEN the API container is running
- WHEN making a GET request to the health endpoint
- THEN the response SHOULD indicate the API is healthy

## Technical Implementation Notes

### Port Configuration

| Service  | Internal Port | External (Host) | Description            |
|----------|--------------|-----------------|----------------------|
| Nginx    | 80           | 5080            | Reverse proxy         |
| API      | 5274         | 5274            | ASP.NET Core API    |
| Frontend  | 5062         | 5062            | Blazor Server      |
| SQL Server| 1433         | -               | Database         |

### Nginx Configuration

The Nginx container MUST be configured as a reverse proxy to route:
- `/api/*` requests to the API container
- All other requests to the Frontend container

### Test Execution Order

1. Class-level: Initialize E2eContainerHelper
2. Test: Execute Playwright tests
3. Class-level: Dispose E2eContainerHelper

## Limitations

- Tests MUST run with Docker daemon running
- Each test class gets a fresh container environment
- Parallel execution requires careful port management or container-per-test isolation