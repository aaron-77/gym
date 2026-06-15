using System.Net;
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

    #region Happy Paths (HP)

    /// <summary>
    /// HP01: Token de empleado + rol="cliente" → 200 OK
    /// </summary>
    [Fact]
    public async Task ObtenerUsuariosPorRol_WithEmpleadoTokenAndRolCliente_Returns200Ok()
    {
        // Arrange
        await SetAuthHeaderAsync();

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
        ClearAuthHeader();

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
        await SetAuthHeaderAsClienteAsync();

        // Act
        var response = await Client.GetAsync("/api/obtenerUsuariosPorRol?rol=cliente");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    #endregion
}
