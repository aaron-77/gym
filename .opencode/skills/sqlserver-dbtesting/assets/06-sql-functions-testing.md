## SQL Functions Testing

Test SQL Server Scalar and Table-Valued Functions.

### Testing Scalar Functions

```csharp
public class DiscountFunctionTests : IClassFixture<DatabaseFixture>
{
    private readonly DatabaseFixture _fixture;

    public DiscountFunctionTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task CalculateDiscount_WithStandardAmount_ReturnsTenPercent()
    {
        // Arrange
        var amount = 100.00m;

        // Act
        await using var connection = await _fixture.GetOpenConnectionAsync();
        var sql = "SELECT [dbo].[CalculateDiscount](@Amount)";
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Amount", amount);
        var result = await command.ExecuteScalarAsync();

        // Assert
        var discount = (decimal)result!;
        discount.Should().Be(10.00m);
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
}
```

### Testing Table-Valued Functions (TVF)

```csharp
[Fact]
public async Task GetOrdersByCustomer_ReturnsCorrectOrders()
{
    // Arrange - Seed test data
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
        orders.Add(MapToOrder(reader));
    }

    // Assert
    orders.Should().HaveCount(2);
    orders.Should().OnlyContain(o => o.CustomerId == 1);
}

[Fact]
public async Task GetOrdersByCustomer_WithNoOrders_ReturnsEmpty()
{
    // Act
    await using var connection = await _fixture.GetOpenConnectionAsync();
    var sql = "SELECT * FROM [dbo].[GetOrdersByCustomer](@CustomerId)";
    await using var command = new SqlCommand(sql, connection);
    command.Parameters.AddWithValue("@CustomerId", 999);

    var orders = new List<Order>();
    await using var reader = await command.ExecuteReaderAsync();
    while (await reader.ReadAsync())
    {
        orders.Add(MapToOrder(reader));
    }

    // Assert
    orders.Should().BeEmpty();
}
```

### Testing Multi-Statement Table-Valued Functions

```csharp
[Fact]
public async Task GetCustomerOrderSummary_ReturnsAggregatedData()
{
    // Arrange
    await SeedCustomerAsync(1, "John Doe");
    await SeedOrderAsync(1, 1, 100.00m);
    await SeedOrderAsync(2, 1, 200.00m);

    // Act
    await using var connection = await _fixture.GetOpenConnectionAsync();
    var sql = "SELECT * FROM [dbo].[GetCustomerOrderSummary]()";
    await using var command = new SqlCommand(sql, connection);

    var summaries = new List<CustomerSummary>();
    await using var reader = await command.ExecuteReaderAsync();
    while (await reader.ReadAsync())
    {
        summaries.Add(new CustomerSummary
        {
            CustomerId = reader.GetInt32(0),
            CustomerName = reader.GetString(1),
            TotalOrders = reader.GetInt32(2),
            TotalSpent = reader.GetDecimal(3)
        });
    }

    // Assert
    var johnSummary = summaries.First(s => s.CustomerId == 1);
    johnSummary.TotalOrders.Should().Be(2);
    johnSummary.TotalSpent.Should().Be(300.00m);
}
```

### Testing Functions with Date Parameters

```csharp
[Fact]
public async Task GetOrdersByDateRange_ReturnsCorrectOrders()
    {
        // Arrange
        var startDate = new DateTime(2024, 1, 1);
        var endDate = new DateTime(2024, 1, 31);
        await SeedOrderWithDateAsync(1, 1, 100.00m, new DateTime(2024, 1, 15));
        await SeedOrderWithDateAsync(2, 1, 200.00m, new DateTime(2024, 2, 15));

        // Act
        await using var connection = await _fixture.GetOpenConnectionAsync();
        var sql = "SELECT * FROM [dbo].[GetOrdersByDateRange](@StartDate, @EndDate)";
        await using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@StartDate", startDate);
        command.Parameters.AddWithValue("@EndDate", endDate);

        var orders = new List<Order>();
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            orders.Add(MapToOrder(reader));
        }

        // Assert
        orders.Should().HaveCount(1);
    }

    private Order MapToOrder(SqlDataReader reader)
    {
        return new Order
        {
            Id = reader.GetInt32(0),
            CustomerId = reader.GetInt32(1),
            TotalAmount = reader.GetDecimal(2)
        };
    }
}
```

### Key Points

- Use `SELECT [Schema].[FunctionName](@Param)` for scalar functions
- Use `SELECT * FROM [Schema].[FunctionName](@Param)` for TVFs
- Always use `SqlParameter` for inputs
- Map results to business objects for assertions
- Use FluentAssertions to verify return values
- Test with various input values including edge cases
