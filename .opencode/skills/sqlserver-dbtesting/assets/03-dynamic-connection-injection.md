## Dynamic Connection Injection

Dynamically retrieve and inject connection string from container.

### SqlConnection Helper

```csharp
using System.Data.SqlClient;

public class DatabaseFixture : IAsyncLifetime
{
    private static readonly MsSqlContainer _msSqlContainer = new MsSqlBuilder()
        .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
        .WithPassword("YourStrong@Passw0rd!")
        .WithReuse(true)
        .Build();

    public string ConnectionString => _msSqlContainer.GetConnectionString();

    public async Task<SqlConnection> GetOpenConnectionAsync()
    {
        var connection = new SqlConnection(ConnectionString);
        await connection.OpenAsync();
        return connection;
    }

    public SqlConnection GetOpenConnection()
    {
        var connection = new SqlConnection(ConnectionString);
        connection.Open();
        return connection;
    }
}
```

### Creating Connections in Tests

```csharp
public class StoredProcedureTests : IClassFixture<DatabaseFixture>
{
    private readonly DatabaseFixture _fixture;

    public StoredProcedureTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task CreateOrder_InsertsSuccessfully()
    {
        // Get dynamic connection from container
        await using var connection = await _fixture.GetOpenConnectionAsync();

        // Use connection for T-SQL execution
    }
}
```

### DbContext with Dynamic Connection

```csharp
using Microsoft.EntityFrameworkCore;

public class TestDbContext : DbContext
{
    private readonly string _connectionString;

    public TestDbContext(string connectionString)
    {
        _connectionString = connectionString;
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer(_connectionString);
    }

    public DbSet<Order> Orders => Set<Order>();
    public DbSet<Customer> Customers => Set<Customer>();
}

// Usage in tests
[Fact]
public async Task GetOrders_ReturnsCorrectData()
{
    // Arrange
    var context = new TestDbContext(_fixture.ConnectionString);

    // Act & Assert
}
```

### Key Points

- Get connection string from `_msSqlContainer.GetConnectionString()`
- Never hardcode connection strings
- Create new connection for each test or use connection pooling
- Always use `using` or `await using` for proper disposal
- Pass connection string to DbContext for EF Core operations
