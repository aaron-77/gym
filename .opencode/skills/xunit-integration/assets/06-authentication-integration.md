## Authentication Integration

Handle JWT authentication in integration tests.

### Test User Creation

```csharp
public class TestAuthHelper
{
    public static async Task<string> CreateTestUserAndGetToken(
        IServiceProvider serviceProvider,
        string email = "testuser@test.com",
        string password = "TestPassword123!")
    {
        var userManager = serviceProvider.GetRequiredService<UserManager<ApplicationUser>>();
        
        var user = new ApplicationUser
        {
            Email = email,
            UserName = email
        };

        var result = await userManager.CreateAsync(user, password);
        
        if (!result.Succeeded)
        {
            var existingUser = await userManager.FindByEmailAsync(email);
            if (existingUser != null)
            {
                return await GenerateJwtToken(serviceProvider, existingUser);
            }
            throw new Exception("Failed to create test user");
        }

        return await GenerateJwtToken(serviceProvider, user);
    }

    private static async Task<string> GenerateJwtToken(
        IServiceProvider serviceProvider,
        ApplicationUser user)
    {
        var jwtService = serviceProvider.GetRequiredService<IJwtService>();
        return await jwtService.GenerateTokenAsync(user);
    }
}
```

### Using with HttpClient

```csharp
public class UsersApiTests : IClassFixture<DatabaseFixture>
{
    private readonly HttpClient _client;
    private readonly IServiceProvider _serviceProvider;

    public UsersApiTests(DatabaseFixture databaseFixture)
    {
        var factory = new ApiWebApplicationFactory<Program>(
            databaseFixture.ConnectionString);
        
        _serviceProvider = factory.Services;
        _client = factory.CreateClient();
    }

    private async Task<string> GetAuthTokenAsync()
    {
        return await TestAuthHelper.CreateTestUserAndGetToken(_serviceProvider);
    }

    [Fact]
    public async Task GetUsers_AsAdmin_ReturnsOk()
    {
        // Arrange
        var token = await GetAuthTokenAsync();
        _client.DefaultRequestHeaders.Authorization = 
            new AuthenticationHeaderValue("Bearer", token);

        // Act
        var response = await _client.GetAsync("/api/users");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
    }
}
```

### Cookie Authentication

```csharp
[Fact]
public async Task Login_WithValidCredentials_ReturnsCookie()
{
    // Arrange
    var loginData = new 
    {
        Email = "testuser@test.com",
        Password = "TestPassword123!"
    };

    // Act
    var response = await _client.PostAsJsonAsync("/api/auth/login", loginData);

    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.OK);
    
    var setCookieHeader = response.Headers.GetValues("Set-Cookie").FirstOrDefault();
    setCookieHeader.Should().NotBeNull();
    
    _client.DefaultRequestHeaders.Add("Cookie", setCookieHeader);
}
```

### Role-Based Testing

```csharp
[Fact]
public async Task GetAllUsers_AsAdmin_ReturnsOk()
{
    // Arrange
    var adminUser = await CreateTestUserWithRole(_serviceProvider, "admin");
    var token = await GenerateJwtToken(_serviceProvider, adminUser);
    _client.DefaultRequestHeaders.Authorization = 
        new AuthenticationHeaderValue("Bearer", token);

    // Act
    var response = await _client.GetAsync("/api/admin/users");

    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.OK);
}

[Fact]
public async Task GetAllUsers_AsUser_ReturnsForbidden()
{
    // Arrange
    var regularUser = await CreateTestUserWithRole(_serviceProvider, "user");
    var token = await GenerateJwtToken(_serviceProvider, regularUser);
    _client.DefaultRequestHeaders.Authorization = 
        new AuthenticationHeaderValue("Bearer", token);

    // Act
    var response = await _client.GetAsync("/api/admin/users");

    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
}
```

### Key Points

- Create test users with known credentials
- Generate JWT tokens for authenticated requests
- Set `Authorization` header with Bearer token
- Use cookie-based auth when testing login endpoints
- Test role-based authorization separately
