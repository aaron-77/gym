using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("CambiarPasswordApiIntegrationTests")]
public class CambiarPasswordApiTests : IClassFixture<CitasApiWebApplicationFactory<Program>>
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public CambiarPasswordApiTests(CitasApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        InitializeAsync().GetAwaiter().GetResult();
    }

    private async Task InitializeAsync()
    {
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
    }

    #region Happy Paths (HP)

    /// <summary>
    /// HP01: Email válido + passwords válidos → 200 OK
    /// </summary>
    [Fact]
    public async Task CambiarPassword_WithValidEmailAndPasswords_Returns200Ok()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        
        var changePasswordRequest = new UserPassEdit
        {
            Email = "uno@gmail.com",
            NewPassword = "NewPassword123!",
            ConfirmPassword = "NewPassword123!"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/cambiarPassword", changePasswordRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<string>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
    }

    #endregion

    #region Sad Paths (SP)

    /// <summary>
    /// SP01: Email inexistente → 400 Bad Request
    /// </summary>
    [Fact]
    public async Task CambiarPassword_WithNonExistentEmail_Returns400BadRequest()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        
        var changePasswordRequest = new UserPassEdit
        {
            Email = $"nonexistent.{Guid.NewGuid():N}@test.com",
            NewPassword = "NewPassword123!",
            ConfirmPassword = "NewPassword123!"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/cambiarPassword", changePasswordRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<string>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
    }

    /// <summary>
    /// SP02: Request inválido → 400 Bad Request
    /// </summary>
    [Fact]
    public async Task CambiarPassword_WithInvalidRequest_Returns400BadRequest()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        
        var changePasswordRequest = new UserPassEdit
        {
            Email = "not-an-email",  // Invalid email format
            NewPassword = "short",   // Too short
            ConfirmPassword = "different"  // Doesn't match
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/cambiarPassword", changePasswordRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<string>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
    }

    #endregion
}
