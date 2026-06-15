## Stored Procedures Testing

Test SQL Server Stored Procedures with AAA pattern.

### Basic Stored Procedure Test

```csharp
public class OrderStoredProcedureTests : IClassFixture<DatabaseFixture>
{
    private readonly DatabaseFixture _fixture;

    public OrderStoredProcedureTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task CreateOrder_InsertsOrderSuccessfully()
    {
        // Arrange - Seed required data
        await SeedCustomerAsync(1, "John Doe");

        var parameters = new[]
        {
            new SqlParameter("@CustomerId", 1),
            new SqlParameter("@TotalAmount", 150.00m)
        };

        // Act - Execute stored procedure
        await using var connection = await _fixture.GetOpenConnectionAsync();
        await using var command = new SqlCommand("EXEC [dbo].[CreateOrder] @CustomerId, @TotalAmount", connection);
        command.Parameters.AddRange(parameters);
        await command.ExecuteNonQueryAsync();

        // Assert - Verify order was created
        var orders = await QueryOrdersByCustomerAsync(1);
        orders.Should().HaveCount(1);
        orders.First().TotalAmount.Should().Be(150.00m);
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

    private async Task<List<Order>> QueryOrdersByCustomerAsync(int customerId)
    {
        var orders = new List<Order>();
        await using var connection = await _fixture.GetOpenConnectionAsync();
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
}
```

### Testing Triggers and Constraints

```csharp
[Fact]
public async Task CreateOrder_UpdatesCustomerTotalSpent()
{
    // Arrange
    await SeedCustomerAsync(1, "John Doe");
    await SeedCustomerTotalAsync(1, 0);

    // Act
    var parameters = new[]
    {
        new SqlParameter("@CustomerId", 1),
        new SqlParameter("@TotalAmount", 100.00m)
    };

    await using var connection = await _fixture.GetOpenConnectionAsync();
    await using var command = new SqlCommand("EXEC [dbo].[CreateOrder] @CustomerId, @TotalAmount", connection);
    command.Parameters.AddRange(parameters);
    await command.ExecuteNonQueryAsync();

    // Assert - Verify trigger updated customer total
    var totalSpent = await QueryCustomerTotalAsync(1);
    totalSpent.Should().Be(100.00m);
}
```

### Testing Multi-Table Updates

```csharp
[Fact]
public async Task ProcessOrder_UpdatesInventoryAndCreatesOrder()
{
    // Arrange - Seed inventory
    await SeedProductAsync(1, "Laptop", 10);

    // Act
    var parameters = new[]
    {
        new SqlParameter("@CustomerId", 1),
        new SqlParameter("@ProductId", 1),
        new SqlParameter("@Quantity", 2)
    };

    await using var connection = await _fixture.GetOpenConnectionAsync();
    await using var command = new SqlCommand("EXEC [dbo].[ProcessOrder] @CustomerId, @ProductId, @Quantity", connection);
    command.Parameters.AddRange(parameters);
    await command.ExecuteNonQueryAsync();

    // Assert - Verify order created
    var orderCount = await QueryOrderCountAsync();
    orderCount.Should().Be(1);

    // Assert - Verify inventory updated
    var remainingStock = await QueryProductStockAsync(1);
    remainingStock.Should().Be(8);
}
```

### Testing Error Handling

```csharp
[Fact]
public async Task CreateOrder_WithInvalidCustomer_ThrowsError()
{
    // Arrange - No customer seeded

    // Act
    var parameters = new[]
    {
        new SqlParameter("@CustomerId", 999),
        new SqlParameter("@TotalAmount", 100.00m)
    };

    await using var connection = await _fixture.GetOpenConnectionAsync();
    await using var command = new SqlCommand("EXEC [dbo].[CreateOrder] @CustomerId, @TotalAmount", connection);
    command.Parameters.AddRange(parameters);

    // Assert - Should throw due to foreign key constraint
    await Assert.ThrowsAsync<SqlException>(async () => await command.ExecuteNonQueryAsync());
}
```

### Key Points

- Seed required data in Arrange phase
- Execute stored procedure with `EXEC [Schema].[Name]`
- Use direct queries in Assert to verify side effects
- Test triggers, constraints, and multi-table updates
- Test error handling with invalid data
