## Database Fixture (IAsyncLifetime)

Use `IAsyncLifetime` to manage container lifecycle and database migrations.

### DatabaseFixture Class

```csharp
using Microsoft.EntityFrameworkCore;
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
        // Wait for container to be in Running state
        await _msSqlContainer.StartAsync();

        // Wait until container is ready
        await WaitForContainerReady();

        // Run EF Core migrations
        await RunMigrations();
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

        throw new Exception("Container failed to start");
    }

    private async Task RunMigrations()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseSqlServer(ConnectionString)
            .Options;

        using var context = new ApplicationDbContext(options);
        await context.Database.MigrateAsync();
    }

    public async Task DisposeAsync()
    {
        // Container will be reused, so don't dispose if using .WithReuse(true)
        // await _msSqlContainer.DisposeAsync();
    }
}
```

### Using with IClassFixture

```csharp
public class UsersApiTests : IClassFixture<DatabaseFixture>
{
    private readonly DatabaseFixture _databaseFixture;

    public UsersApiTests(DatabaseFixture databaseFixture)
    {
        _databaseFixture = databaseFixture;
    }
}
```

### Key Points

- `InitializeAsync()` starts container and runs migrations
- Wait for container state to be "Running" before configuring DbContext
- Use `context.Database.Migrate()` to apply EF Core migrations
- Don't dispose container when using `.WithReuse(true)`
