---
name: xunit-integration
description: >
  API integration testing patterns for .NET 8 with Testcontainers, WebApplicationFactory, and Respawn.
  Trigger: When writing integration tests for .NET APIs - testcontainers, database fixtures, HTTP client.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## When to Use

- Writing integration tests for .NET 8+ Web APIs
- Using Testcontainers for real database instances in Docker
- Configuring WebApplicationFactory with dynamic connection strings
- Testing API endpoints with HttpClient
- Managing test isolation with Respawn
- Handling JWT authentication in integration tests

## Critical Patterns

### Testcontainers Setup

Use real database containers instead of in-memory databases. Configure for reuse to save CPU resources.

See [assets/01-testcontainers-testsetup.md](assets/01-testcontainers-testsetup.md) for examples.

### Database Fixture (IAsyncLifetime)

Manage container lifecycle with `IAsyncLifetime` interface. Run migrations automatically.

See [assets/02-database-fixture.md](assets/02-database-fixture.md) for examples.

### WebApplicationFactory Integration

Synchronize factory with container and inject dynamic connection string.

See [assets/03-webapplication-factory.md](assets/03-webapplication-factory.md) for examples.

### Respawn Integration

Clean database tables between tests without restarting container.

See [assets/04-respawn-integration.md](assets/04-respawn-integration.md) for examples.

### HttpClient Usage

Make HTTP requests to tested API endpoints.

See [assets/05-httpclient-usage.md](assets/05-httpclient-usage.md) for examples.

### Authentication Integration

Handle JWT tokens and role-based testing.

See [assets/06-authentication-integration.md](assets/06-authentication-integration.md) for examples.

### Integration Test Examples

Complete examples with IServiceScope, Arrange/Act/Assert, and IClassFixture.

See [assets/07-integration-test-examples.md](assets/07-integration-test-examples.md) for complete examples.

## Commands

```bash
# Run all tests
dotnet test

# Run with verbose output
dotnet test --verbosity normal

# Run single test
dotnet test --filter "FullyQualifiedName~Namespace.ClassName.MethodName"

# Run tests with coverage
dotnet test --collect:"XPlat Code Coverage"

# Run tests in release mode
dotnet test -c Release
```
