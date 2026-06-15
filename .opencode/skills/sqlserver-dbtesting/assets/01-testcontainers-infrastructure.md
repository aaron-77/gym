## Infrastructure Orchestration (Testcontainers)

Use `MsSqlBuilder` to spin up a real SQL Server instance in Docker.

### Basic MsSqlContainer Setup

```csharp
using Testcontainers.MsSql;
using Xunit;

public class DatabaseFixture : IAsyncLifetime
{
    private static readonly MsSqlContainer _msSqlContainer = new MsSqlBuilder()
        .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
        .WithPassword("YourStrong@Passw0rd!")
        .WithReuse(true)  // Keep container alive between runs (optimizes CPU)
        .Build();

    public string ConnectionString => _msSqlContainer.GetConnectionString();

    public async Task InitializeAsync()
    {
        // Start the container
        await _msSqlContainer.StartAsync();

        // Wait until container is ready
        await WaitForContainerReady();
    }

    private async Task WaitForContainerReady()
    {
        var maxRetries = 30;
        var delay = TimeSpan.FromSeconds(1);

        for (int i = 0; i < maxRetries; i++)
        {
            if (_msSqlContainer.State == TestcontainersStates.Running)
            {
                return;
            }
            await Task.Delay(delay);
        }

        throw new Exception("SQL Server container failed to start");
    }

    public Task DisposeAsync()
    {
        // Don't dispose if using .WithReuse(true)
        return Task.CompletedTask;
    }
}
```

### Using with IClassFixture

```csharp
public class StoredProcedureTests : IClassFixture<DatabaseFixture>
{
    private readonly DatabaseFixture _databaseFixture;

    public StoredProcedureTests(DatabaseFixture databaseFixture)
    {
        _databaseFixture = databaseFixture;
    }
}
```

### Key Points

- Use `MsSqlBuilder` for SQL Server containers
- Use `.WithReuse(true)` to optimize CPU on limited processors
- Manage lifecycle with `IAsyncLifetime`
- Get connection string via `container.GetConnectionString()`
- Wait for container state to be "Running" before use
