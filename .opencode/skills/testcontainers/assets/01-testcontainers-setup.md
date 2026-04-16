# Testcontainers Setup Examples

## MsSqlContainer - SQL Server

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

## PostgreSqlContainer

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

## Generic IContainer - Custom Images

```csharp
using DotNet.Testcontainers.Builders;
using DotNet.Testcontainers.Containers;

// API container
var apiContainer = new ContainerBuilder()
    .WithImage("aaron77/fitnessgymapi:v17")
    .WithPortBinding(8080, true)
    .WithEnvironment("ASPNETCORE_ENVIRONMENT", "Staging")
    .WithNetwork(network)
    .WithNetworkAliases("api")
    .WithWaitStrategy(Wait.ForUnixContainer()
        .UntilHttpRequestIsSucceeded(r => r.ForPath("/health")))
    .Build();

// Frontend container
var frontendContainer = new ContainerBuilder()
    .WithImage("aaron77/fitnessgymfrontend:v17")
    .WithPortBinding(8080, true)
    .WithEnvironment("ASPNETCORE_ENVIRONMENT", "Staging")
    .WithNetwork(network)
    .WithNetworkAliases("frontend")
    .WithWaitStrategy(Wait.ForUnixContainer()
        .UntilHttpRequestIsSucceeded(r => r.ForPath("/")))
    .Build();

// Nginx container
var nginxContainer = new ContainerBuilder()
    .WithImage("nginx:alpine")
    .WithPortBinding(5080, true)
    .WithBindMount("/path/to/nginx.conf", "/etc/nginx/nginx.conf")
    .WithNetwork(network)
    .WithNetworkAliases("nginx")
    .WithWaitStrategy(Wait.ForUnixContainer()
        .UntilPortIsAvailable(80))
    .Build();
```

## Docker Network - Multi-Container Setup

```csharp
using DotNet.Testcontainers.Networks;

public static class E2eContainerHelper
{
    private static INetwork? _network;
    
    public static async Task InitializeAsync()
    {
        // Crear red Docker
        _network = new NetworkBuilder()
            .WithName($"gym-e2e-network-{Guid.NewGuid():N}")
            .Build();
        await _network.CreateAsync();

        // Contenedores en la misma red pueden comunicarse por alias
        _msSqlContainer = new MsSqlBuilder()
            .WithPassword("Password123")
            .WithNetwork(_network)
            .WithNetworkAliases("sqlserver")
            .Build();

        _apiContainer = new ContainerBuilder()
            .WithImage("api-image")
            .WithEnvironment("ConnectionStrings:DB", "Server=sqlserver,1433;...")
            .WithNetwork(_network)
            .WithNetworkAliases("api")
            .Build();
    }

    public static async Task DisposeAsync()
    {
        if (_network is not null)
            await _network.DisposeAsync();
    }
}
```

## Puntos Clave

1. **Static field**: Usar campo estático para mantener el contenedor vivo entre tests
2. **WithReuse(true)**: Evita reinicio del contenedor, ahorrando recursos CPU
3. **Connection string**: Obtener dinámicamente via `container.GetConnectionString()`
4. **Network aliases**: Usar aliases para comunicación entre contenedores
5. **Wait strategies**: Ver skill `testcontainers-wait-strategies` para configuración de espera