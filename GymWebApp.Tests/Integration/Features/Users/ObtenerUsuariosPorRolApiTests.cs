using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("ObtenerUsuariosPorRolApiIntegrationTests")]
public class ObtenerUsuariosPorRolApiTests : IClassFixture<CitasApiWebApplicationFactory<Program>>
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public ObtenerUsuariosPorRolApiTests(CitasApiWebApplicationFactory<Program> factory)
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
    /// HP01: Token de empleado + rol="cliente" → 200 OK
    /// </summary>
    [Fact]
    public async Task ObtenerUsuariosPorRol_WithEmpleadoTokenAndRolCliente_Returns200Ok()
    {
        // Arrange
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        var authToken = await _factory.AuthenticateAsync(_client);
        SetAuthHeader(authToken);

        // Act
        var response = await _client.GetAsync("/api/obtenerUsuariosPorRol?rol=cliente");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<QueryUser>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
    }

    #endregion

    #region Sad Paths (SP)

    /// <summary>
    /// SP01: Sin token → 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task ObtenerUsuariosPorRol_WithoutToken_Returns401Unauthorized()
    {
        // Arrange
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader(null);

        // Act
        var response = await _client.GetAsync("/api/obtenerUsuariosPorRol?rol=cliente");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    /// <summary>
    /// SP02: Token de cliente → 403 Forbidden
    /// </summary>
    [Fact]
    public async Task ObtenerUsuariosPorRol_WithClienteToken_Returns403Forbidden()
    {
        // Arrange
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        var clienteToken = await _factory.AuthenticateAsClienteAsync(_client);
        SetAuthHeader(clienteToken);

        // Act
        var response = await _client.GetAsync("/api/obtenerUsuariosPorRol?rol=cliente");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    #endregion
}
