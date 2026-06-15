## Database State Management (Respawn)

Use Respawn to clean database tables between tests without restarting the container.

### Respawn Setup

```csharp
using Testcontainers.MsSql;
using Respawn;
using System.Data.SqlClient;

public class DatabaseFixture : IAsyncLifetime
{
    private static readonly MsSqlContainer _msSqlContainer = new MsSqlBuilder()
        .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
        .WithPassword("YourStrong@Passw0rd!")
        .WithReuse(true)
        .Build();

    private Respawner? _respawner;

    public string ConnectionString => _msSqlContainer.GetConnectionString();

    public async Task InitializeAsync()
    {
        await _msSqlContainer.StartAsync();

        // Initialize Respawner after container is running
        await InitializeRespawner();
    }

    private async Task InitializeRespawner()
    {
        await using var connection = new SqlConnection(ConnectionString);
        await connection.OpenAsync();

        _respawner = await Respawner.CreateAsync(connection, new RespawnerOptions
        {
            TablesToIgnore = new[]
            {
                "__EFMigrationsHistory",
                "__Databases"
            },
            SchemasToInclude = new[] { "dbo", "Sales", "Inventory" }
        });
    }

    public async Task ResetDatabaseAsync()
    {
        if (_respawner == null)
        {
            throw new InvalidOperationException("Respawner not initialized");
        }

        await using var connection = new SqlConnection(ConnectionString);
        await connection.OpenAsync();
        await _respawner.ResetAsync(connection);
    }

    public Task DisposeAsync() => Task.CompletedTask;
}
```

### Reset Before Each Test

```csharp
public class StoredProcedureTests : IClassFixture<DatabaseFixture>, IAsyncLifetime
{
    private readonly DatabaseFixture _databaseFixture;

    public StoredProcedureTests(DatabaseFixture databaseFixture)
    {
        _databaseFixture = databaseFixture;
    }

    public async Task InitializeAsync()
    {
        // Reset database before first test
        await _databaseFixture.ResetDatabaseAsync();
    }

    [Fact]
    public async Task CreateOrder_InsertsOrderSuccessfully()
    {
        // Arrange & Act & Assert
    }

    [Fact]
    public async Task GetCustomerOrders_ReturnsCorrectData()
    {
        // This test runs after previous test, so DB is clean
    }

    public async Task DisposeAsync()
    {
        // Reset after all tests in class
        await _databaseFixture.ResetDatabaseAsync();
    }
}
```

### Alternative: Reset Per Test

```csharp
public class StoredProcedureTests : IClassFixture<DatabaseFixture>, IDisposable
{
    private readonly DatabaseFixture _databaseFixture;

    public StoredProcedureTests(DatabaseFixture databaseFixture)
    {
        _databaseFixture = databaseFixture;
    }

    [Fact]
    public async Task Test1()
    {
        // Test runs with clean database
    }

    public void Dispose()
    {
        // Clean up after each test
        _ = _databaseFixture.ResetDatabaseAsync().GetAwaiter().GetResult();
    }
}
```

### Key Points

- Initialize Respawner once after container starts
- Configure `TablesToIgnore` for system tables
- Use `SchemasToInclude` to target specific schemas
- Call `ResetAsync()` before each test
- This clears data without restarting the container
