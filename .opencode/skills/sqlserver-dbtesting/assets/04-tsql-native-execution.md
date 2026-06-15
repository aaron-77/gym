## Native T-SQL Execution

Execute T-SQL commands for Stored Procedures and Functions.

### Using SqlCommand

```csharp
using System.Data.SqlClient;

public class TSqlExecutor
{
    private readonly string _connectionString;

    public TSqlExecutor(string connectionString)
    {
        _connectionString = connectionString;
    }

    public async Task<int> ExecuteNonQueryAsync(string sql, params SqlParameter[] parameters)
    {
        await using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        await using var command = new SqlCommand(sql, connection);
        if (parameters != null)
        {
            command.Parameters.AddRange(parameters);
        }

        return await command.ExecuteNonQueryAsync();
    }

    public async Task<object?> ExecuteScalarAsync(string sql, params SqlParameter[] parameters)
    {
        await using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        await using var command = new SqlCommand(sql, connection);
        if (parameters != null)
        {
            command.Parameters.AddRange(parameters);
        }

        return await command.ExecuteScalarAsync();
    }

    public async Task<SqlDataReader> ExecuteReaderAsync(string sql, params SqlParameter[] parameters)
    {
        var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var command = new SqlCommand(sql, connection);
        if (parameters != null)
        {
            command.Parameters.AddRange(parameters);
        }

        return await command.ExecuteReaderAsync(CommandBehavior.CloseConnection);
    }
}
```

### Executing Stored Procedures

```csharp
// EXEC [Schema].[ProcedureName] @Param1
string sql = "EXEC [dbo].[CreateOrder] @CustomerId, @TotalAmount";

var parameters = new[]
{
    new SqlParameter("@CustomerId", 1),
    new SqlParameter("@TotalAmount", 150.00m)
};

await executor.ExecuteNonQueryAsync(sql, parameters);
```

### Executing Scalar Functions

```csharp
// SELECT [dbo].[FunctionName](@Param1)
string sql = "SELECT [dbo].[CalculateDiscount](@Amount)";

var parameters = new[]
{
    new SqlParameter("@Amount", 100.00m)
};

var result = await executor.ExecuteScalarAsync(sql, parameters);
decimal discount = (decimal)result!;
```

### Executing Table-Valued Functions (TVF)

```csharp
// SELECT * FROM [Schema].[FunctionName](@Param1)
string sql = "SELECT * FROM [dbo].[GetOrdersByCustomer](@CustomerId)";

var parameters = new[]
{
    new SqlParameter("@CustomerId", 1)
};

await using var reader = await executor.ExecuteReaderAsync(sql, parameters);
var orders = new List<Order>();
while (await reader.ReadAsync())
{
    orders.Add(new Order
    {
        Id = reader.GetInt32(0),
        CustomerId = reader.GetInt32(1),
        TotalAmount = reader.GetDecimal(2)
    });
}
```

### Key Points

- Use `EXEC` for Stored Procedures
- Use `SELECT` for Functions (scalar and TVF)
- Always use `SqlParameter` for input values
- This ensures proper data type matching between C# and SQL Server
- Use `ExecuteNonQueryAsync` for INSERT/UPDATE/DELETE
- Use `ExecuteScalarAsync` for single value results
- Use `ExecuteReaderAsync` for multiple rows/columns
