using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("IntegrationTests")]
public class LogoutApiTests : IntegrationTestBase
{
    public LogoutApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    #region Happy Paths (HP)

    /// <summary>
    /// HP01: Token válido → 200 OK
    /// </summary>
    [Fact]
    public async Task Logout_WithValidToken_Returns200Ok()
    {
        // First authenticate to get the refresh token
        await SetAuthHeaderAsync();
        var loginResponse = await Client.PostAsJsonAsync("/api/autenticar", new UserCredentials
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
        var response = await Client.PostAsJsonAsync("/api/logout", logoutRequest);

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
        ClearAuthHeader();

        var logoutRequest = new LogoutRequest
        {
            RefreshToken = "some-token"
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/logout", logoutRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}
