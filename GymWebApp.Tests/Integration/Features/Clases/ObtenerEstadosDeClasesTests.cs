using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("IntegrationTests")]
public class ObtenerEstadosDeClasesTests : IntegrationTestBase
{
    public ObtenerEstadosDeClasesTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper)
    {
    }

    #region Sad Path (Integration)

    /// <summary>
    /// REQUISITO: Sad Path - Sin autenticación
    /// Escenario: Usuario no autenticado intenta acceder al endpoint
    /// GIVEN: Cliente HTTP sin token de autenticación
    /// WHEN: GET /api/Clases/obtenerEstadosDeClasesProgramdas
    /// THEN: Returns 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task ObtenerEstadosDeClasesProgramadas_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange
        ClearAuthHeader();

        // Act
        var response = await Client.GetAsync("/api/Clases/obtenerEstadosDeClasesProgramdas");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion

    #region Happy Paths (Integration)

    /// <summary>
    /// REQUISITE: Happy Path - Usuario autenticado con rol "empleado"
    /// Escenario: Usuario empleado autenticado obtiene los estados de clases programadas
    /// GIVEN: Usuario autenticado con token válido y rol "empleado"
    /// WHEN: GET /api/Clases/obtenerEstadosDeClasesProgramdas
    /// THEN: Returns 200 OK con Success=true, payload con lista no vacía de DTOEstadoClaseProgramada
    /// AND El mensaje debe indicar que se obtuvo correctamente
    /// </summary>
    [Fact]
    public async Task ObtenerEstadosDeClasesProgramadas_WithAuthenticatedEmpleado_ReturnsOkWithEstadosList()
    {
        // Arrange
        await SetAuthHeaderAsync();

        // Act
        var response = await Client.GetAsync("/api/Clases/obtenerEstadosDeClasesProgramdas");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOEstadoClaseProgramada>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Contain("Estados de clases programadas obtenidos correctamente");
        result.payload.Should().NotBeNull();
        result.payload.Should().NotBeEmpty("La lista de estados no debe estar vacía");
        
        // Verify each estado has required fields populated
        foreach (var estado in result.payload!)
        {
            estado.IdEstadoClaseProgramada.Should().BeGreaterThan(0, "IdEstadoClaseProgramada must be greater than 0");
            estado.NombresEstado.Should().NotBeNullOrEmpty("NombresEstado must not be null or empty");
        }
    }

    #endregion
}
