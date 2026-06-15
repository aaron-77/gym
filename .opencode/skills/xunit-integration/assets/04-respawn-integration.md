## Respawn Integration

Use Respawn to clean database tables between tests without restarting the container.

### Respawn Setup

```csharp
using Respawn;

public class DatabaseFixture : IAsyncLifetime
{
    private static readonly MsSqlContainer _msSqlContainer = new MsSqlBuilder()
        .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
        .WithPassword("YourStrong@Passw0rd")
        .WithReuse(true)
        .Build();

    private Checkpoint? _checkpoint;

    public string ConnectionString => _msSqlContainer.GetConnectionString();

    public async Task InitializeAsync()
    {
        await _msSqlContainer.StartAsync();
        
        _checkpoint = new Checkpoint
        {
            TablesToIgnore = new[]
            {
                "__EFMigrationsHistory",
                "__Databases"
            }
        };
    }

    public async Task ResetDatabaseAsync()
    {
        await using var connection = new SqlConnection(ConnectionString);
        await connection.OpenAsync();
        await _checkpoint.ResetAsync(connection);
    }

    public async Task DisposeAsync()
    {
        // Don't dispose when using reuse
    }
}
```

### Using Respawn in Tests

```csharp
public class UsersApiTests : IClassFixture<DatabaseFixture>, IAsyncLifetime
{
    private readonly DatabaseFixture _databaseFixture;
    private readonly HttpClient _client;
    private readonly ApiWebApplicationFactory<Program> _factory;

    public UsersApiTests(DatabaseFixture databaseFixture)
    {
        _databaseFixture = databaseFixture;
        _factory = new ApiWebApplicationFactory<Program>(
            _databaseFixture.ConnectionString);
        _client = _factory.CreateClient();
    }

    public async Task InitializeAsync()
    {
        await _databaseFixture.ResetDatabaseAsync();
    }

    [Fact]
    public async Task CreateUser_WithValidData_ReturnsCreated()
    {
        // Arrange
        var userData = new { Name = "John", Email = "john@test.com" };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users", userData);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Created);
    }

    // This runs after each test to clean the database
    public async Task DisposeAsync()
    {
        await _databaseFixture.ResetDatabaseAsync();
    }
}
```

### Alternative: ITestOutputHelper Integration

```csharp
public class UsersApiTests : IClassFixture<DatabaseFixture>, IDisposable
{
    private readonly DatabaseFixture _databaseFixture;

    public UsersApiTests(DatabaseFixture databaseFixture)
    {
        _databaseFixture = databaseFixture;
    }

    public void Dispose()
    {
        // Clean up after each test
        _ = _databaseFixture.ResetDatabaseAsync().GetAwaiter().GetResult();
    }
}
```

### Key Points

- Use Respawn to reset tables without restarting container
- Call `ResetDatabaseAsync()` after each test
- Use `ITestOutputHelper` or `IDisposable` to trigger cleanup
- Configure `TablesToIgnore` for migration history tables
