## WebApplicationFactory Integration

Synchronize WebApplicationFactory with Testcontainers and inject dynamic connection string.

### Custom WebApplicationFactory

```csharp
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;

public class ApiWebApplicationFactory<TProgram> : WebApplicationFactory<TProgram> where TProgram : class
{
    private readonly string _connectionString;

    public ApiWebApplicationFactory(string connectionString)
    {
        _connectionString = connectionString;
    }

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseSetting("ConnectionStrings:DefaultConnection", _connectionString);

        builder.ConfigureServices(services =>
        {
            var descriptor = services.SingleOrDefault(
                d => d.ServiceType == typeof(DbContextOptions<ApplicationDbContext>));

            if (descriptor != null)
            {
                services.Remove(descriptor);
            }

            services.AddDbContext<ApplicationDbContext>(options =>
                options.UseSqlServer(_connectionString));
        });

        builder.UseEnvironment("Testing");
    }
}
```

### Waiting for Container State

```csharp
public class ApiWebApplicationFactory<TProgram> : WebApplicationFactory<TProgram> where TProgram : class
{
    private readonly string _connectionString;

    public ApiWebApplicationFactory(string connectionString)
    {
        _connectionString = connectionString;
    }

    protected override async Task ConfigureWebHost(IWebHostBuilder builder)
    {
        // Wait for container to be ready before configuring
        await WaitForDatabaseReady();

        builder.UseSetting("ConnectionStrings:DefaultConnection", _connectionString);

        builder.ConfigureServices(services =>
        {
            // Replace DbContext with test database
            var descriptor = services.SingleOrDefault(
                d => d.ServiceType == typeof(DbContextOptions<ApplicationDbContext>));

            if (descriptor != null)
            {
                services.Remove(descriptor);
            }

            services.AddDbContext<ApplicationDbContext>(options =>
                options.UseSqlServer(_connectionString));
        });
    }

    private async Task WaitForDatabaseReady()
    {
        var maxRetries = 30;
        for (int i = 0; i < maxRetries; i++)
        {
            try
            {
                using var connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();
                return;
            }
            catch
            {
                await Task.Delay(1000);
            }
        }
        throw new Exception("Database not ready");
    }
}
```

### Using with Test Class

```csharp
public class UsersApiTests : IClassFixture<DatabaseFixture>
{
    private readonly DatabaseFixture _databaseFixture;
    private readonly HttpClient _client;

    public UsersApiTests(DatabaseFixture databaseFixture)
    {
        _databaseFixture = databaseFixture;

        var factory = new ApiWebApplicationFactory<Program>(
            _databaseFixture.ConnectionString);
        
        _client = factory.CreateClient();
    }
}
```

### Key Points

- Use `.UseSetting()` to inject dynamic connection string
- Wait for container to be in "Running" state before configuring
- Replace DbContext services to use test database
- Pass connection string from DatabaseFixture to factory
