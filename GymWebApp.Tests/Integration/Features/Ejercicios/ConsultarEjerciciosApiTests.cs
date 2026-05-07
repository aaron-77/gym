using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Ejercicios;

[Collection("IntegrationTests")]
public class ConsultarEjerciciosApiTests : IntegrationTestBase
{
    public ConsultarEjerciciosApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper) { }

    public override async Task InitializeAsync()
    {
        await base.InitializeAsync();
        await SetAuthHeaderAsync();
    }

    #region Happy Paths (Integration)

    /// <summary>
    /// REQUISITO: Happy Path - usuario autenticado obtiene ejercicios
    /// Escenario: Usuario autenticado solicita lista de ejercicios
    /// GIVEN: Usuario autenticado con token válido
    /// WHEN: GET /api/consultarEjercicios
    /// THEN: Returns 200 OK con lista de Ejercicio
    /// AND Cada ejercicio tiene EjercicioID > 0 y NombreEjercicio no es null/empty
    /// AND Los ejercicios existen en la base de datos
    /// </summary>
    [Fact]
    public async Task ConsultarEjercicios_WithAuthenticatedUser_ReturnsExercisesFromDatabase()
    {
        // Act
        var response = await Client.GetAsync("/api/consultarEjercicios");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<Ejercicio>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
        
        // Verify each exercise has required fields populated
        foreach (var ejercicio in result.payload!)
        {
            ejercicio.EjercicioID.Should().BeGreaterThan(0, "EjercicioID must be greater than 0");
            ejercicio.NombreEjercicio.Should().NotBeNullOrEmpty("NombreEjercicio must not be null or empty");
        }

    }

    #endregion

    #region Sad Paths (Integration)

    /// <summary>
    /// REQUISITO: Sad Path - solicitud sin autenticación
    /// Escenario: Usuario no autenticado intenta acceder al endpoint
    /// GIVEN: Sin token de autenticación
    /// WHEN: GET /api/consultarEjercicios
    /// THEN: Returns 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task ConsultarEjercicios_WithoutAuthentication_Returns401Unauthorized()
    {
        // Arrange
        ClearAuthHeader();

        // Act
        var response = await Client.GetAsync("/api/consultarEjercicios");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}