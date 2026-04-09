using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Factories;
using GymWebApp.Tests.Integration.Helpers;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("AgregarRolUsuarioApiIntegrationTests")]
public class AgregarRolUsuarioApiTests : IClassFixture<CitasApiWebApplicationFactory<Program>>
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public AgregarRolUsuarioApiTests(CitasApiWebApplicationFactory<Program> factory)
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
    /// HP01: Token de empleado válido → 200 OK
    /// </summary>
    [Fact]
    public async Task AgregarRolUsuario_WithValidEmpleadoToken_Returns200Ok()
    {
        // Arrange
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        var authToken = await _factory.AuthenticateAsync(_client);
        SetAuthHeader(authToken);

        // Get a user with 'empleado' role (they typically don't have 'cliente' role)
        var existingUserId = await UserHelper.GetUserIdByRoleAsync(TestContainerHelper.ConnectionString, "empleado");
        
        // Add 'cliente' role (which they shouldn't have)
        var addRoleRequest = new DTOAgregarRol
        {
            UserId = existingUserId,
            Role = "cliente"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/AgregarRolUsuario", addRoleRequest);

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
    /// SP01: Sin token → 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task AgregarRolUsuario_WithoutToken_Returns401Unauthorized()
    {
        // Arrange
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader(null);

        // NO need DB query - any string works for this test
        var addRoleRequest = AgregarRolFactory.Crear("any-user-id", "cliente");

        // Act
        var response = await _client.PostAsJsonAsync("/api/AgregarRolUsuario", addRoleRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    /// <summary>
    /// SP02: Token de cliente → 403 Forbidden
    /// </summary>
    [Fact]
    public async Task AgregarRolUsuario_WithClienteToken_Returns403Forbidden()
    {
        // Arrange
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        
        var existingUserId = await UserHelper.GetAnyUserIdAsync(TestContainerHelper.ConnectionString);
        
        var clienteToken = await _factory.AuthenticateAsClienteAsync(_client);
        SetAuthHeader(clienteToken);

        var addRoleRequest = AgregarRolFactory.Crear(existingUserId, "cliente");

        // Act
        var response = await _client.PostAsJsonAsync("/api/AgregarRolUsuario", addRoleRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    #endregion
}
