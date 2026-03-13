## Testcontainers Setup

Use Testcontainers to run a real database instance in Docker instead of using in-memory or real databases.

### MsSqlContainer Setup

```csharp
using Testcontainers.MsSql;

public class DatabaseFixture : IAsyncLifetime
{
    private static readonly MsSqlContainer _msSqlContainer = new MsSqlBuilder()
        .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
        .WithPassword("YourStrong@Passw0rd")
        .WithReuse(true)  // Reuse container to save CPU resources
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
        .WithReuse(true)  // Reuse container to save CPU resources
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

### Key Points

- Use static field to keep container alive across tests
- `.WithReuse(true)` prevents container restart, saving CPU on i5 processors
- Connection string is obtained dynamically via `container.GetConnectionString()`
