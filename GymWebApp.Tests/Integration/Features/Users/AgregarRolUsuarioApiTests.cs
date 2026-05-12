using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Factories;
using GymWebApp.Tests.Integration.Helpers;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("IntegrationTests")]
public class AgregarRolUsuarioApiTests : IntegrationTestBase
{
    public AgregarRolUsuarioApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper) { }

    #region Happy Paths (HP)

    /// <summary>
    /// HP01: Token de empleado válido → 200 OK
    /// </summary>
    [Fact]
    public async Task AgregarRolUsuario_WithValidEmpleadoToken_Returns200Ok()
    {
        await SetAuthHeaderAsync();
        var existingUserId = await UserHelper.GetUserIdByRoleAsync(TestContainerHelper.ConnectionString, "empleado");
        
        // Add 'cliente' role (which they shouldn't have)
        var addRoleRequest = new DTOAgregarRol
        {
            UserId = existingUserId,
            Role = "cliente"
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/AgregarRolUsuario", addRoleRequest);

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
        ClearAuthHeader();

        // NO need DB query - any string works for this test
        var addRoleRequest = AgregarRolFactory.Crear("any-user-id", "cliente");

        // Act
        var response = await Client.PostAsJsonAsync("/api/AgregarRolUsuario", addRoleRequest);

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
        var existingUserId = await UserHelper.GetUserIdByRoleAsync(TestContainerHelper.ConnectionString, "cliente");
        
        await SetAuthHeaderAsClienteAsync();

        var addRoleRequest = AgregarRolFactory.Crear(existingUserId, "empleado");

        // Act
        var response = await Client.PostAsJsonAsync("/api/AgregarRolUsuario", addRoleRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    #endregion
}
