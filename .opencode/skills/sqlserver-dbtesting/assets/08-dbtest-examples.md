## Complete Database Test Examples

Complete test examples with AAA pattern, Testcontainers, and Respawn.

### Complete DatabaseFixture

```csharp
using Testcontainers.MsSql;
using Respawn;
using System.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace GymDbTests;

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
        // Start container
        await _msSqlContainer.StartAsync();

        // Apply schema
        await ApplySchemaAsync();

        // Initialize Respawner
        await InitializeRespawnerAsync();
    }

    private async Task ApplySchemaAsync()
    {
        // Apply EF Core migrations or execute SQL scripts
        var options = new DbContextOptionsBuilder<TestDbContext>()
            .UseSqlServer(ConnectionString)
            .Options;

        using var context = new TestDbContext(options);
        await context.Database.MigrateAsync();
    }

    private async Task InitializeRespawnerAsync()
    {
        await using var connection = new SqlConnection(ConnectionString);
        await connection.OpenAsync();

        _respawner = await Respawner.CreateAsync(connection, new RespawnerOptions
        {
            TablesToIgnore = new[] { "__EFMigrationsHistory" },
            SchemasToInclude = new[] { "dbo", "Sales" }
        });
    }

    public async Task ResetDatabaseAsync()
    {
        if (_respawner == null) return;

        await using var connection = new SqlConnection(ConnectionString);
        await connection.OpenAsync();
        await _respawner.ResetAsync(connection);
    }

    public async Task<SqlConnection> GetOpenConnectionAsync()
    {
        var connection = new SqlConnection(ConnectionString);
        await connection.OpenAsync();
        return connection;
    }

    public Task DisposeAsync() => Task.CompletedTask;
}
```

### Complete Stored Procedure Test

```csharp
public class OrderStoredProcedureTests : IClassFixture<DatabaseFixture>, IDisposable
{
    private readonly DatabaseFixture _fixture;

    public OrderStoredProcedureTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task CreateOrder_WithValidData_InsertsSuccessfully()
    {
        // Arrange - Seed data
        await SeedCustomerAsync(1, "John Doe");

        // Act - Execute stored procedure
        var parameters = new[]
        {
            new SqlParameter("@CustomerId", 1),
            new SqlParameter("@TotalAmount", 150.00m)
        };

        await using var connection = await _fixture.GetOpenConnectionAsync();
        await using var command = new SqlCommand("EXEC [dbo].[CreateOrder] @CustomerId, @TotalAmount", connection);
        command.Parameters.AddRange(parameters);
        await command.ExecuteNonQueryAsync();

        // Assert - Verify order created
        var orders = await QueryOrdersAsync(connection, 1);
        orders.Should().HaveCount(1);
        orders.First().TotalAmount.Should().Be(150.00m);
    }

    [Fact]
    public async Task CreateOrder_WithNegativeAmount_ThrowsError()
    {
        // Arrange - Seed customer
        await SeedCustomerAsync(1, "John Doe");

        // Act
        var parameters = new[]
        {
            new SqlParameter("@CustomerId", 1),
            new SqlParameter("@TotalAmount", -100.00m)
        };

        await using var connection = await _fixture.GetOpenConnectionAsync();
        await using var command = new SqlCommand("EXEC [dbo].[CreateOrder] @CustomerId, @TotalAmount", connection);
        command.Parameters.AddRange(parameters);

        // Assert
        await Assert.ThrowsAsync<SqlException>(async () => await command.ExecuteNonQueryAsync());
    }

    private async Task SeedCustomerAsync(int id, string name)
    {
        await using var connection = await _fixture.GetOpenConnectionAsync();
        var sql = "INSERT INTO Customers (Id, Name) VALUES (@Id, @Name)";
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Id", id);
        command.Parameters.AddWithValue("@Name", name);
        await command.ExecuteNonQueryAsync();
    }

    private async Task<List<Order>> QueryOrdersAsync(SqlConnection connection, int customerId)
    {
        var orders = new List<Order>();
        var sql = "SELECT Id, CustomerId, TotalAmount FROM Orders WHERE CustomerId = @CustomerId";
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@CustomerId", customerId);
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            orders.Add(new Order
            {
                Id = reader.GetInt32(0),
                CustomerId = reader.GetInt32(1),
                TotalAmount = reader.GetDecimal(2)
            });
        }
        return orders;
    }

    public void Dispose()
    {
        // Reset database after each test
        _ = _fixture.ResetDatabaseAsync().GetAwaiter().GetResult();
    }
}
```

### Complete Function Test

```csharp
public class DiscountFunctionTests : IClassFixture<DatabaseFixture>, IDisposable
{
    private readonly DatabaseFixture _fixture;

    public DiscountFunctionTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }

    [Theory]
    [InlineData(0, 0)]
    [InlineData(50, 5)]
    [InlineData(100, 10)]
    [InlineData(200, 20)]
    public async Task CalculateDiscount_VariousAmounts_ReturnsCorrectDiscount(decimal amount, decimal expectedDiscount)
    {
        // Act
        await using var connection = await _fixture.GetOpenConnectionAsync();
        var sql = "SELECT [dbo].[CalculateDiscount](@Amount)";
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Amount", amount);
        var result = await command.ExecuteScalarAsync();

        // Assert
        var discount = result == DBNull.Value ? 0 : (decimal)result;
        discount.Should().Be(expectedDiscount);
    }

    [Fact]
    public async Task GetOrdersByCustomer_ReturnsCorrectData()
    {
        // Arrange - Seed orders
        await SeedOrderAsync(1, 1, 100.00m);
        await SeedOrderAsync(2, 1, 200.00m);
        await SeedOrderAsync(3, 2, 150.00m);

        // Act - Execute TVF
        await using var connection = await _fixture.GetOpenConnectionAsync();
        var sql = "SELECT * FROM [dbo].[GetOrdersByCustomer](@CustomerId)";
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@CustomerId", 1);

        var orders = new List<Order>();
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            orders.Add(new Order
            {
                Id = reader.GetInt32(0),
                CustomerId = reader.GetInt32(1),
                TotalAmount = reader.GetDecimal(2)
            });
        }

        // Assert
        orders.Should().HaveCount(2);
        orders.Should().OnlyContain(o => o.CustomerId == 1);
    }

    private async Task SeedOrderAsync(int id, int customerId, decimal amount)
    {
        await using var connection = await _fixture.GetOpenConnectionAsync();
        var sql = "INSERT INTO Orders (Id, CustomerId, TotalAmount) VALUES (@Id, @CustomerId, @Amount)";
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Id", id);
        command.Parameters.AddWithValue("@CustomerId", customerId);
        command.Parameters.AddWithValue("@Amount", amount);
        await command.ExecuteNonQueryAsync();
    }

    public void Dispose()
    {
        _ = _fixture.ResetDatabaseAsync().GetAwaiter().GetResult();
    }
}
```

### Model Classes

```csharp
public class Order
{
    public int Id { get; set; }
    public int CustomerId { get; set; }
    public decimal TotalAmount { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class Customer
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
}

public class CustomerSummary
{
    public int CustomerId { get; set; }
    public string CustomerName { get; set; } = string.Empty;
    public int TotalOrders { get; set; }
    public decimal TotalSpent { get; set; }
}
```

### Key Points

- Use AAA pattern: Arrange (seed), Act (execute), Assert (verify)
- Seed required data in Arrange phase
- Use native T-SQL execution for SPs and functions
- Query database directly in Assert to verify side effects
- Reset database with Respawn after each test
- Use IClassFixture for shared container lifecycle
- Implement IDisposable or IAsyncLifetime for cleanup
