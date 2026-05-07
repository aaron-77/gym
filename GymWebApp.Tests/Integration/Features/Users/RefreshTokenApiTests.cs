using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("IntegrationTests")]
public class RefreshTokenApiTests : IntegrationTestBase
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public RefreshTokenApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper)
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
    /// HP01: Refresh token válido → 200 OK
    /// </summary>
    [Fact]
    public async Task RefreshToken_WithValidRefreshToken_Returns200Ok()
    {
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
        
        // Store original tokens before refresh
        var originalAccessToken = loginResult.payload!.AccessToken;
        var originalRefreshToken = loginResult.payload!.RefreshToken;
        
        var refreshToken = loginResult.payload.RefreshToken;
        refreshToken.Should().NotBeEmpty("Refresh token should be provided on login");

        var refreshRequest = new RefreshTokenRequest
        {
            RefreshToken = refreshToken
        };

        // Act
        SetAuthHeader(originalAccessToken);
        var response = await _client.PostAsJsonAsync("/api/refresh", refreshRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<DTOLoggedUser>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload!.AccessToken.Should().NotBeEmpty();
        result.payload.AccessToken.Should().NotBe(originalAccessToken, 
            "New access token should be different from original");
        result.payload.RefreshToken.Should().NotBe(originalRefreshToken,
            "New refresh token should be different from original");
    }

    #endregion

    #region Sad Paths (SP)

    /// <summary>
    /// SP01: Sin token → 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task RefreshToken_WithoutToken_Returns401Unauthorized()
    {
        // Arrange
        SetAuthHeader(null);

        var refreshRequest = new RefreshTokenRequest
        {
            RefreshToken = "some-invalid-token"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/refresh", refreshRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}
