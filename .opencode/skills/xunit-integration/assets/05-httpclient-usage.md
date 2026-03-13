## HttpClient Usage

Create and use HttpClient from WebApplicationFactory for API integration tests.

### Basic HttpClient Creation

```csharp
public class UsersApiTests : IClassFixture<DatabaseFixture>
{
    private readonly HttpClient _client;

    public UsersApiTests(DatabaseFixture databaseFixture)
    {
        var factory = new ApiWebApplicationFactory<Program>(
            databaseFixture.ConnectionString);
        
        _client = factory.CreateClient();
    }
}
```

### GET Request

```csharp
[Fact]
public async Task GetAllUsers_ReturnsOkWithUsers()
{
    // Act
    var response = await _client.GetAsync("/api/users");

    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.OK);
    
    var content = await response.Content.ReadAsStringAsync();
    var users = JsonSerializer.Deserialize<List<UserDto>>(content, 
        new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
    
    users.Should().NotBeNull();
}
```

### POST Request

```csharp
[Fact]
public async Task CreateUser_WithValidData_ReturnsCreated()
{
    // Arrange
    var newUser = new CreateUserRequest
    {
        Name = "John Doe",
        Email = "john@example.com"
    };

    // Act
    var response = await _client.PostAsJsonAsync("/api/users", newUser);

    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.Created);
    
    var createdUser = await response.Content.ReadFromJsonAsync<UserDto>();
    createdUser.Should().NotBeNull();
    createdUser.Name.Should().Be("John Doe");
}
```

### PUT Request

```csharp
[Fact]
public async Task UpdateUser_WithValidData_ReturnsOk()
{
    // Arrange
    var existingUserId = 1;
    var updateData = new UpdateUserRequest
    {
        Name = "Updated Name"
    };

    // Act
    var response = await _client.PutAsJsonAsync(
        $"/api/users/{existingUserId}", 
        updateData);

    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.OK);
}
```

### DELETE Request

```csharp
[Fact]
public async Task DeleteUser_ReturnsNoContent()
{
    // Arrange
    var userId = 1;

    // Act
    var response = await _client.DeleteAsync($"/api/users/{userId}");

    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.NoContent);
}
```

### Handling Authentication

```csharp
[Fact]
public async Task GetProtectedEndpoint_WithoutAuth_ReturnsUnauthorized()
{
    // Act
    var response = await _client.GetAsync("/api/admin/users");

    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
}

[Fact]
public async Task GetProtectedEndpoint_WithValidToken_ReturnsOk()
{
    // Arrange
    var token = await GetAuthTokenAsync();
    _client.DefaultRequestHeaders.Authorization = 
        new AuthenticationHeaderValue("Bearer", token);

    // Act
    var response = await _client.GetAsync("/api/admin/users");

    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.OK);
}
```

### Key Points

- Use `CreateClient()` to get configured HttpClient
- Use extension methods: `PostAsJsonAsync`, `GetAsync`, `PutAsJsonAsync`, `DeleteAsync`
- Configure `JsonSerializerOptions` for case-insensitive deserialization
- Set authentication headers for protected endpoints
