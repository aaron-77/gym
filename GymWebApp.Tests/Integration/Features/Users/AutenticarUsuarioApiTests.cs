using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("AutenticarUsuarioApiIntegrationTests")]
public class AutenticarUsuarioApiTests : IClassFixture<CitasApiWebApplicationFactory<Program>>
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public AutenticarUsuarioApiTests(CitasApiWebApplicationFactory<Program> factory)
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
    /// HP01: Credenciales válidas → 200 OK + DTOLoggedUser
    /// </summary>
    [Fact]
    public async Task Autenticar_WithValidCredentials_Returns200OkAndDTOLoggedUser()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        
        var loginRequest = new UserCredentials
        {
            correo = "uno@gmail.com",
            contrasena = "Password123*"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/autenticar", loginRequest);

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
        await TestContainerHelper.ResetDatabaseAsync();
        
        var loginRequest = new UserCredentials
        {
            correo = "uno@gmail.com",
            contrasena = "WrongPassword123"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/autenticar", loginRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<DTOLoggedUser>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
    }

    #endregion
}
