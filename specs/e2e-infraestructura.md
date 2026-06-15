# Specification for E2E Test Infrastructure

## Purpose

Define the infrastructure configuration for end-to-end (E2E) tests using Playwright with Testcontainers in the FitnessGym project. This spec establishes the test environment setup required to run comprehensive E2E tests against the full application stack (API, Frontend, Database, Nginx reverse proxy).

## Integration Requirements

### Requirement: Testcontainers Packages

The project MUST include Testcontainers packages for E2E testing.

#### Scenario: Package references

- GIVEN GymWebApp.Tests.csproj
- WHEN E2E infrastructure is configured
- THEN the following packages MUST be referenced:
  - `Testcontainers` v4.1.0 (generic container management for Nginx, API, Frontend)
  - `Testcontainers.MsSql` v4.1.0 (SQL Server container)
  - `Microsoft.Playwright` v1.58.0 (browser automation)
  - `Microsoft.Playwright.Xunit` v1.58.0 (xUnit integration)

### Requirement: E2eContainerHelper Class

The project MUST provide a helper class to manage test containers.

#### Scenario: Container helper initialization

- GIVEN E2eContainerHelper.InitializeAsync() is called
- WHEN the test environment starts
- THEN the following containers MUST be started in order:
  1. **Docker Network** — created for inter-container communication
  2. **SQL Server** (mcr.microsoft.com/mssql/server:2022-latest) on port 1433 (internal)
  3. **API** (aaron77/fitnessgymapi:v17) on port 5274 (internal and host-mapped)
  4. **Frontend** (aaron77/fitnessgymfrontend:v17) on port 5062 (internal and host-mapped)
  5. **Nginx** (nginx:alpine) on port 80 (internal) mapped to 5080 (host)

#### Scenario: Nginx reverse proxy configuration

- GIVEN the Nginx container is started
- THEN a custom nginx.conf file MUST be mounted via `.WithBindMount()`
- AND the config MUST route:
  - `/api/*` requests to `http://api:5274`
  - All other requests to `http://frontend:5062`
- AND the config MUST be loaded from a known path in the test project (e.g., `E2E/Common/nginx.conf`)

#### Scenario: Container wait strategies

- GIVEN each container is built
- THEN a wait strategy MUST be configured before start:
  - API: `Wait.ForUnixContainer().UntilPortIsAvailable(5274)`
  - Frontend: `Wait.ForUnixContainer().UntilPortIsAvailable(5062)`
  - Nginx: `Wait.ForUnixContainer().UntilPortIsAvailable(80)`
  - SQL Server: built-in MsSqlBuilder wait strategy

#### Scenario: Container cleanup

- GIVEN E2eContainerHelper.DisposeAsync() is called
- WHEN the test environment stops
- THEN all running containers MUST be stopped and removed in parallel (Task.WhenAll)
- AND the Docker network MUST be removed
- AND the disposal order MUST be: Nginx → Frontend → API → SQL Server → Network

#### Scenario: Thread-safe initialization

- GIVEN multiple test classes initialize containers concurrently
- THEN a `SemaphoreSlim` MUST guard initialization to prevent duplicate containers
- AND double-checked locking pattern MUST be used (check flag, acquire lock, check flag again)

### Requirement: Playwright Base Class

The project MUST provide a base class for Playwright tests.

#### Scenario: Base test class setup

- GIVEN a test class inherits from PlaywrightTestBase
- WHEN the test class is constructed
- THEN E2eContainerHelper.InitializeAsync() MUST be called (sync-over-async via `.GetAwaiter().GetResult()` in static constructor guard)
- AND `_isInitialized` static flag MUST prevent redundant initialization
- WHEN `InitializeAsync()` is called by xUnit
- THEN a headless Chromium browser MUST be launched
- AND a new browser context and page MUST be created
- WHEN `DisposeAsync()` is called by xUnit
- THEN page → context → browser MUST be closed in order
- AND the Playwright instance MUST be disposed

#### Scenario: Page access

- GIVEN a test class inherits from PlaywrightTestBase
- THEN the `Page` property MUST be available for test execution

### Requirement: Base URLs

The project MUST expose base URLs for test execution.

#### Scenario: Accessing base URLs

- GIVEN the test containers are running
- THEN `FrontendBaseUrl` MUST be `"http://localhost:5080"` (through Nginx proxy)
- AND `ApiBaseUrl` MUST be `"http://localhost:5274"` (direct API access)
- AND `ConnectionString` MUST be available for database seeding operations

### Requirement: Database Seeding for E2E

The E2E test environment MUST have seed data available.

#### Scenario: Seed data source

- GIVEN the API Docker image (aaron77/fitnessgymapi:v17) is built
- THEN the image MUST include database migration and seed data execution on startup
- AND the seed data MUST include:
  - Test user `uno@gmail.com` with password `Password123*` (employee role)
  - Test user `aaronhl1313@gmail.com` with password `Password123*` (client role)
  - Reference data: roles, exercise types, class types, intensity levels, difficulty levels
  - At least one sample class and one scheduled class for display testing

#### Scenario: Alternative seeding via API

- IF the Docker image does NOT auto-seed on startup
- THEN E2E tests MUST seed data via API calls before executing scenarios
- AND seeding MUST be done in a class-level setup (not per-test) for performance

## Directory Structure

The E2E test infrastructure MUST follow this directory structure:

```
GymWebApp.Tests/
└── E2E/
    ├── Common/
    │   ├── E2eContainerHelper.cs      # Container management
    │   ├── PlaywrightTestBase.cs      # Base class for tests
    │   └── nginx.conf                 # Nginx reverse proxy config
    └── Features/
        └── {FeatureName}E2ETests.cs   # Test files per feature
```

## Port Configuration

| Service    | Docker Image                                      | Internal Port | External (Host) | Description        |
|------------|---------------------------------------------------|---------------|-----------------|--------------------|
| Nginx      | nginx:alpine                                      | 80            | 5080            | Reverse proxy      |
| API        | aaron77/fitnessgymapi:v17                         | 5274          | 5274            | ASP.NET Core API   |
| Frontend   | aaron77/fitnessgymfrontend:v17                    | 5062          | 5062            | Blazor Server      |
| SQL Server | mcr.microsoft.com/mssql/server:2022-latest        | 1433          | —               | Database           |

## Nginx Configuration

The Nginx container MUST use the following reverse proxy configuration:

```nginx
events { worker_connections 1024; }

http {
    upstream api {
        server api:5274;
    }

    upstream frontend {
        server frontend:5062;
    }

    server {
        listen 80;

        location /api/ {
            proxy_pass http://api;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        location / {
            proxy_pass http://frontend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
        }
    }
}
```

Key points:
- The `proxy_http_version 1.1` and WebSocket upgrade headers are REQUIRED for Blazor Server SignalR connections.
- The `/api/` route MUST strip or forward the prefix correctly based on API routing expectations.

## Test Execution Flow

1. **Class-level (static)**: Initialize `E2eContainerHelper` — starts all containers once per test run
2. **Per-test**: `PlaywrightTestBase.InitializeAsync()` — creates fresh browser/page per test
3. **Test execution**: Run Playwright assertions
4. **Per-test dispose**: `PlaywrightTestBase.DisposeAsync()` — closes browser/page
5. **Run-level dispose**: `E2eContainerHelper.DisposeAsync()` — stops all containers

## Test Isolation Strategy

### Between Feature Classes
- All E2E tests share the same database instance (single container set per test run)
- Tests MUST NOT depend on execution order between classes
- Tests that modify or delete data MUST be designed to not break other tests
- If test isolation is critical, use `ICollectionFixture` with per-collection containers

### Within Feature Classes
- Tests within a class share the same database state
- Tests MUST be designed to be independent of sibling test side effects
- Do NOT rely on one test creating data that another test consumes

## Limitations

- Docker daemon MUST be running on the host machine
- Docker images MUST be pre-built and available (or built locally before E2E runs)
- Parallel test execution requires careful consideration of shared database state
- Port 5080, 5274, and 5062 MUST be available on the host machine
- Total container startup time is approximately 60-120 seconds (SQL Server initialization dominates)
