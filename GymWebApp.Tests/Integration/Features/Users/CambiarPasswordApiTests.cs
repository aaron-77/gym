using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("IntegrationTests")]
public class CambiarPasswordApiTests : IntegrationTestBase
{
    private readonly string _connectionString;

    public CambiarPasswordApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper)
    {
        _connectionString = testContainerHelper.ConnectionString;
    }

    #region Happy Paths (HP)

    /// <summary>
    /// HP01: Email válido + passwords válidos → 200 OK
    /// </summary>
    [Fact]
    public async Task CambiarPassword_WithValidEmailAndPasswords_Returns200Ok()
    {
        // Arrange
        var email = TestUsersOptions.EmpleadoEmail;
        var changePasswordRequest = new UserPassEdit
        {
            Email = email,
            NewPassword = "NewPassword123!",
            ConfirmPassword = "NewPassword123!"
        };

        var originalHash = await DatabaseHelper.ExecuteScalarAsync<string>(
            _connectionString,
            "SELECT PasswordHash FROM AspNetUsers WHERE Email = @Email",
            new Dictionary<string, object?> { { "@Email", email } });

        try
        {
            // Act
            var response = await Client.PostAsJsonAsync("/api/cambiarPassword", changePasswordRequest);

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
            
            var result = await response.Content.ReadFromJsonAsync<DTOResponse<string>>();
            result.Should().NotBeNull();
            result!.success.Should().BeTrue();
            result.httpCode.Should().Be(200);
        }
        finally
        {
            if (originalHash != null)
            {
                await DatabaseHelper.ExecuteNonQueryAsync(
                    _connectionString,
                    "UPDATE AspNetUsers SET PasswordHash = @Hash WHERE Email = @Email",
                    new Dictionary<string, object?>
                    {
                        { "@Hash", originalHash },
                        { "@Email", email }
                    });
            }
        }
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
        var changePasswordRequest = new UserPassEdit
        {
            Email = $"nonexistent.{Guid.NewGuid():N}@test.com",
            NewPassword = "NewPassword123!",
            ConfirmPassword = "NewPassword123!"
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/cambiarPassword", changePasswordRequest);

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
        var changePasswordRequest = new UserPassEdit
        {
            Email = "not-an-email",  // Invalid email format
            NewPassword = "short",   // Too short
            ConfirmPassword = "different"  // Doesn't match
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/cambiarPassword", changePasswordRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<string>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
    }

    #endregion
}
