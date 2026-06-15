---
name: testcontainers
description: >
  Testcontainers for .NET: gestión de contenedores Docker para tests de integración.
  Trigger: When using Testcontainers to run databases, message brokers, or other services in Docker for testing.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## When to Use

- Running real database instances (SQL Server, PostgreSQL, MySQL) in Docker for integration tests
- Setting up message brokers (RabbitMQ, Kafka) for testing
- Configuring E2E test infrastructure with multiple containers
- Managing container lifecycle with IAsyncLifetime

## Critical Patterns

### MsSqlContainer Setup

```csharp
using Testcontainers.MsSql;

public class DatabaseFixture : IAsyncLifetime
{
    private static readonly MsSqlContainer _msSqlContainer = new MsSqlBuilder()
        .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
        .WithPassword("YourStrong@Passw0rd")
        .WithReuse(true)
        .Build();

    public string ConnectionString => _msSqlContainer.GetConnectionString();

    public async Task InitializeAsync()
    {
        await _msSqlContainer.StartAsync();
    }

    public async Task DisposeAsync()
    {
        await _msSqlContainer.DisposeAsync();
    }
}
```

**Nota**: MsSqlBuilder incluye un wait strategy por defecto que ejecuta `sqlcmd -Q "SELECT 1"` para verificar que SQL Server está listo. No es necesario agregar wait strategy manualmente.

### PostgreSqlContainer Setup

```csharp
using Testcontainers.PostgreSql;

public class DatabaseFixture : IAsyncLifetime
{
    private static readonly PostgreSqlContainer _postgreSqlContainer = new PostgreSqlBuilder()
        .WithImage("postgres:15")
        .WithDatabase("testdb")
        .WithUsername("testuser")
        .WithPassword("testpass")
        .WithReuse(true)
        .Build();

    public string ConnectionString => _postgreSqlContainer.GetConnectionString();

    public async Task InitializeAsync()
    {
        await _postgreSqlContainer.StartAsync();
    }

    public async Task DisposeAsync()
    {
        await _postgreSqlContainer.DisposeAsync();
    }
}
```

### Generic IContainer for Custom Images

```csharp
using DotNet.Testcontainers.Builders;
using DotNet.Testcontainers.Containers;

var container = new ContainerBuilder()
    .WithImage("my-image:latest")
    .WithPortBinding(8080, true)
    .WithEnvironment("ENV_VAR", "value")
    .WithWaitStrategy(Wait.ForUnixContainer().UntilPortIsAvailable(8080))
    .Build();

await container.StartAsync();
var mappedPort = container.GetMappedPublicPort(8080);
await container.DisposeAsync();
```

### Docker Network for Multi-Container Setup

```csharp
using DotNet.Testcontainers.Networks;

var network = new NetworkBuilder()
    .WithName($"test-network-{Guid.NewGuid():N}")
    .Build();

await network.CreateAsync();

var container1 = new ContainerBuilder()
    .WithImage("image1:latest")
    .WithNetwork(network)
    .WithNetworkAliases("service1")
    .Build();

var container2 = new ContainerBuilder()
    .WithImage("image2:latest")
    .WithNetwork(network)
    .WithNetworkAliases("service2")
    .Build();

await container1.StartAsync();
await container2.StartAsync();

// container1 puede reachear a container2 usando "service2" como hostname

await network.DisposeAsync();
```

## Recursos

- **Setup examples**: Ver [assets/01-testcontainers-setup.md](assets/01-testcontainers-setup.md)
- **Wait strategies**: Ver [assets/02-wait-strategies.md](assets/02-wait-strategies.md) (referencia a skill dedicada)
- **Documentation**: https://dotnet.testcontainers.org/