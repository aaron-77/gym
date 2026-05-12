using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("IntegrationTests")]
public class ObtenerUsuariosApiTests : IntegrationTestBase
{
    public ObtenerUsuariosApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    public override async Task InitializeAsync()
    {
        await base.InitializeAsync();
        await SetAuthHeaderAsync();
    }

    #region Happy Paths (HP)

    /// <summary>
    /// HP01: Token de empleado válido → 200 OK + lista ExistingUser
    /// </summary>
    [Fact]
    public async Task ObtenerUsuarios_WithValidEmpleadoToken_Returns200OkAndUserList()
    {
        // Arrange - set auth
        await SetAuthHeaderAsync();

        // Act
        var response = await Client.GetAsync("/api/obtenerUsuarios");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<ExistingUser>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload.Should().NotBeEmpty();
        
        // Verify each user has required fields
        foreach (var user in result.payload!)
        {
            user.Id.Should().NotBeEmpty();
            user.NombreCompleto.Should().NotBeEmpty();
        }
    }

    #endregion

    #region Sad Paths (SP)

    /// <summary>
    /// SP01: Sin token → 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task ObtenerUsuarios_WithoutToken_Returns401Unauthorized()
    {
        // Arrange
        ClearAuthHeader();

        // Act
        var response = await Client.GetAsync("/api/obtenerUsuarios");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    /// <summary>
    /// SP02: Token de cliente → 403 Forbidden
    /// </summary>
    [Fact]
    public async Task ObtenerUsuarios_WithClienteToken_Returns403Forbidden()
    {
        ClearAuthHeader();
        // Arrange
        await SetAuthHeaderAsClienteAsync();

        // Act
        var response = await Client.GetAsync("/api/obtenerUsuarios");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    #endregion
}
