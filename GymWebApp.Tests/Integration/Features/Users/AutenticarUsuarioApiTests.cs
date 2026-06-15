using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("IntegrationTests")]
public class AutenticarUsuarioApiTests : IntegrationTestBase
{
    public AutenticarUsuarioApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper) { }

    #region Happy Paths (HP)

    /// <summary>
    /// HP01: Credenciales válidas → 200 OK + DTOLoggedUser
    /// </summary>
    [Fact]
    public async Task Autenticar_WithValidCredentials_Returns200OkAndDTOLoggedUser()
    {
        // Arrange
        var loginRequest = new UserCredentials
        {
            correo = "uno@gmail.com",
            contrasena = "Password123*"
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/autenticar", loginRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<DTOLoggedUser>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload!.Id.Should().NotBeEmpty();
        result.payload.NombreCompleto.Should().NotBeEmpty();
        result.payload.Correo.Should().Be("uno@gmail.com");
        result.payload.AccessToken.Should().NotBeEmpty();
    }

    #endregion

    #region Sad Paths (SP)

    /// <summary>
    /// SP01: Credenciales inválidas → 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task Autenticar_WithInvalidCredentials_Returns401Unauthorized()
    {
        // Arrange
        var loginRequest = new UserCredentials
        {
            correo = "uno@gmail.com",
            contrasena = "WrongPassword123"
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/autenticar", loginRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<DTOLoggedUser>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
    }

    #endregion
}
