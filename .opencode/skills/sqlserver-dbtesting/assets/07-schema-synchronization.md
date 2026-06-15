## Schema Synchronization

Automatically apply database schema (tables, stored procedures, functions) to container.

### EF Core Migrations

```csharp
using Microsoft.EntityFrameworkCore;

public class DatabaseFixture : IAsyncLifetime
{
    private static readonly MsSqlContainer _msSqlContainer = new MsSqlBuilder()
        .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
        .WithPassword("YourStrong@Passw0rd!")
        .WithReuse(true)
        .Build();

    public string ConnectionString => _msSqlContainer.GetConnectionString();

    public async Task InitializeAsync()
    {
        await _msSqlContainer.StartAsync();
        await ApplyMigrationsAsync();
    }

    private async Task ApplyMigrationsAsync()
    {
        var options = new DbContextOptionsBuilder<TestDbContext>()
            .UseSqlServer(ConnectionString)
            .Options;

        using var context = new TestDbContext(options);
        await context.Database.MigrateAsync();
    }

    public Task DisposeAsync() => Task.CompletedTask;
}
```

### SQL Script Execution

```csharp
public class DatabaseFixture : IAsyncLifetime
{
    private static readonly MsSqlContainer _msSqlContainer = new MsSqlBuilder()
        .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
        .WithPassword("YourStrong@Passw0rd!")
        .WithReuse(true)
        .Build();

    public string ConnectionString => _msSqlContainer.GetConnectionString();

    public async Task InitializeAsync()
    {
        await _msSqlContainer.StartAsync();
        await ExecuteSqlScriptsAsync();
    }

    private async Task ExecuteSqlScriptsAsync()
    {
        var scriptsPath = Path.Combine(Directory.GetCurrentDirectory(), "..", "..", "..", "bd");

        await using var connection = new SqlConnection(ConnectionString);
        await connection.OpenAsync();

        // Execute all SQL files in order
        var sqlFiles = Directory.GetFiles(scriptsPath, "*.sql")
            .OrderBy(f => f);

        foreach (var file in sqlFiles)
        {
            var sql = await File.ReadAllTextAsync(file);
            await using var command = new SqlCommand(sql, connection);
            await command.ExecuteNonQueryAsync();
        }
    }

    public Task DisposeAsync() => Task.CompletedTask;
}
```

### Verify Schema Exists

```csharp
public class SchemaValidator
{
    private readonly string _connectionString;

    public SchemaValidator(string connectionString)
    {
        _connectionString = connectionString;
    }

    public async Task<bool> TableExistsAsync(string tableName)
    {
        await using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var sql = @"
            SELECT COUNT(*) 
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_NAME = @TableName";

        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@TableName", tableName);
        var result = await command.ExecuteScalarAsync();

        return (int)result! > 0;
    }

    public async Task<bool> StoredProcedureExistsAsync(string procedureName)
    {
        await using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var sql = @"
            SELECT COUNT(*) 
            FROM INFORMATION_SCHEMA.ROUTINES 
            WHERE ROUTINE_NAME = @Name AND ROUTINE_TYPE = 'PROCEDURE'";

        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Name", procedureName);
        var result = await command.ExecuteScalarAsync();

        return (int)result! > 0;
    }

    public async Task<bool> FunctionExistsAsync(string functionName)
    {
        await using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var sql = @"
            SELECT COUNT(*) 
            FROM INFORMATION_SCHEMA.ROUTINES 
            WHERE ROUTINE_NAME = @Name AND ROUTINE_TYPE = 'FUNCTION'";

        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Name", functionName);
        var result = await command.ExecuteScalarAsync();

        return (int)result! > 0;
    }
}
```

### Verify in Tests

```csharp
[Fact]
public async Task DatabaseSchema_IsReady()
{
    // Arrange
    var validator = new SchemaValidator(_fixture.ConnectionString);

    // Assert - Verify tables exist
    (await validator.TableExistsAsync("Customers")).Should().BeTrue();
    (await validator.TableExistsAsync("Orders")).Should().BeTrue();

    // Assert - Verify stored procedures exist
    (await validator.StoredProcedureExistsAsync("CreateOrder")).Should().BeTrue();

    // Assert - Verify functions exist
    (await validator.FunctionExistsAsync("CalculateDiscount")).Should().BeTrue();
    (await validator.FunctionExistsAsync("GetOrdersByCustomer")).Should().BeTrue();
}
```

### Key Points

- Apply migrations or SQL scripts after container starts
- Use EF Core `Database.MigrateAsync()` for migrations
- Execute SQL scripts for stored procedures and functions
- Verify schema exists before running tests
- Use `INFORMATION_SCHEMA` to validate objects
- Run schema sync once at initialization
