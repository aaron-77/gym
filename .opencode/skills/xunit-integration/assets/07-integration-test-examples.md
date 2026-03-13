## Integration Test Examples

Complete examples with IServiceScope, Arrange/Act/Assert pattern, and IClassFixture.

### Complete Test Class Example

```csharp
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System.Net;
using System.Net.Http.Json;

namespace GymWebApp.Tests.Integration;

public class UsersApiTests : IClassFixture<DatabaseFixture>, IAsyncLifetime
{
    private readonly DatabaseFixture _databaseFixture;
    private readonly ApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

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
    public async Task GetAllUsers_WhenUsersExist_ReturnsOkWithUsers()
    {
        // Arrange - Use IServiceScope to seed data
        using var scope = _factory.Services.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        
        context.Users.Add(new ApplicationUser 
        { 
            Id = Guid.NewGuid().ToString(),
            UserName = "testuser",
            Email = "test@test.com"
        });
        await context.SaveChangesAsync();

        // Act
        var response = await _client.GetAsync("/api/users");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var users = await response.Content.ReadFromJsonAsync<List<UserDto>>();
        users.Should().NotBeNull();
        users.Should().HaveCount(1);
    }

    [Fact]
    public async Task CreateUser_WithValidData_ReturnsCreated()
    {
        // Arrange
        var newUser = new CreateUserRequest
        {
            Name = "John Doe",
            Email = "john@example.com",
            Password = "Password123!"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/users", newUser);

        // Assert - HTTP
        response.StatusCode.Should().Be(HttpStatusCode.Created);

        // Assert - Database
        using var scope = _factory.Services.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        
        var createdUser = await context.Users.FirstOrDefaultAsync(u => u.Email == newUser.Email);
        createdUser.Should().NotBeNull();
        createdUser.UserName.Should().Be(newUser.Name);
    }

    [Fact]
    public async Task CreateUser_WithDuplicateEmail_ReturnsBadRequest()
    {
        // Arrange - Seed existing user
        using var scope = _factory.Services.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        
        var existingUser = new ApplicationUser 
        { 
            Id = Guid.NewGuid().ToString(),
            UserName = "existing",
            Email = "existing@test.com"
        };
        context.Users.Add(existingUser);
        await context.SaveChangesAsync();

        // Act
        var newUser = new CreateUserRequest
        {
            Name = "New User",
            Email = "existing@test.com",
            Password = "Password123!"
        };
        var response = await _client.PostAsJsonAsync("/api/users", newUser);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    public async Task DisposeAsync()
    {
        await _databaseFixture.ResetDatabaseAsync();
        _client.Dispose();
        _factory.Dispose();
    }
}
```

### DatabaseFixture Class

```csharp
using Testcontainers.MsSql;
using Microsoft.EntityFrameworkCore;
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
            TablesToIgnore = new[] { "__EFMigrationsHistory" }
        };

        await RunMigrations();
    }

    private async Task RunMigrations()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseSqlServer(ConnectionString)
            .Options;

        using var context = new ApplicationDbContext(options);
        await context.Database.MigrateAsync();
    }

    public async Task ResetDatabaseAsync()
    {
        await using var connection = new SqlConnection(ConnectionString);
        await connection.OpenAsync();
        await _checkpoint!.ResetAsync(connection);
    }

    public Task DisposeAsync() => Task.CompletedTask;
}
```

### ApiWebApplicationFactory Class

```csharp
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

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
    }
}
```

### Key Points

- Use `IClassFixture<DatabaseFixture>` for shared container lifecycle
- Use `IServiceScope` in Arrange phase to seed real data
- Call API via HttpClient in Act phase
- Assert both HTTP response and database state
- Use `IAsyncLifetime` to reset database between tests
- Use Respawn to clean tables without restarting container
