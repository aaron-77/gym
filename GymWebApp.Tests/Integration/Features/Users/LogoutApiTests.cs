using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("LogoutApiIntegrationTests")]
public class LogoutApiTests : IClassFixture<CitasApiWebApplicationFactory<Program>>
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public LogoutApiTests(CitasApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
    }

    private void SetAuthHeader(string? token)
    {
        _client.DefaultRequestHeaders.Authorization = token != null 
            ? new AuthenticationHeaderValue("Bearer", token) 
            : null;
    }

    #region Happy Paths (HP)

    /// <summary>
    /// HP01: Token válido → 200 OK
    /// </summary>
    [Fact]
    public async Task Logout_WithValidToken_Returns200Ok()
    {
        // Arrange
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        
        // First authenticate to get the refresh token
        var loginResponse = await _client.PostAsJsonAsync("/api/autenticar", new UserCredentials
        {
            correo = "uno@gmail.com",
            contrasena = "Password123*"
        });
        
        var loginResult = await loginResponse.Content.ReadFromJsonAsync<DTOResponse<DTOLoggedUser>>();
        
        // Assert - verify we got a valid response with refresh token
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        loginResult.Should().NotBeNull();
        loginResult!.success.Should().BeTrue();
        loginResult.payload.Should().NotBeNull();
        var refreshToken = loginResult.payload!.RefreshToken;
        refreshToken.Should().NotBeEmpty("Refresh token should be provided on login");
        
        // Get access token for auth header
        var authToken = loginResult.payload.AccessToken;
        SetAuthHeader(authToken);

        var logoutRequest = new LogoutRequest
        {
            RefreshToken = refreshToken
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/logout", logoutRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<object>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
    }

    #endregion

    #region Sad Paths (SP)

    /// <summary>
    /// SP01: Sin token → 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task Logout_WithoutToken_Returns401Unauthorized()
    {
        // Arrange
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader(null);

        var logoutRequest = new LogoutRequest
        {
            RefreshToken = "some-token"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/logout", logoutRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}
