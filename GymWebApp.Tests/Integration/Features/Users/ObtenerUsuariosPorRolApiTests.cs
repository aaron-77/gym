using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("IntegrationTests")]
public class ObtenerUsuariosPorRolApiTests : IntegrationTestBase
{
    public ObtenerUsuariosPorRolApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper) { }

    private void SetAuthHeader(string? token)
    {
        Client.DefaultRequestHeaders.Authorization = token != null 
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
        var authToken = await Factory.AuthenticateAsync(Client);
        SetAuthHeader(authToken);

        // Act
        var response = await Client.GetAsync("/api/obtenerUsuariosPorRol?rol=cliente");

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
        SetAuthHeader(null);

        // Act
        var response = await Client.GetAsync("/api/obtenerUsuariosPorRol?rol=cliente");

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
        var clienteToken = await Factory.AuthenticateAsClienteAsync(Client);
        SetAuthHeader(clienteToken);

        // Act
        var response = await Client.GetAsync("/api/obtenerUsuariosPorRol?rol=cliente");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    #endregion
}
