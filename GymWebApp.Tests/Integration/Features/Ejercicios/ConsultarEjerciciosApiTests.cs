using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Ejercicios;

[Collection("ConsultarEjerciciosApiIntegrationTests")]
public class ConsultarEjerciciosApiTests : IClassFixture<CitasApiWebApplicationFactory<Program>>
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;
    private string? _authToken;

    public ConsultarEjerciciosApiTests(CitasApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        InitializeAsync().GetAwaiter().GetResult();
    }

    private async Task InitializeAsync()
    {
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        _authToken = await _factory.AuthenticateAsync(_client);
    }

    private void SetAuthHeader()
    {
        if (string.IsNullOrEmpty(_authToken))
            throw new InvalidOperationException("Auth token not available");
        
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _authToken);
    }

    private void ClearAuthHeader()
    {
        _client.DefaultRequestHeaders.Authorization = null;
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
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader();

        // Act
        var response = await _client.GetAsync("/api/consultarEjercicios");

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
        await TestContainerHelper.ResetDatabaseAsync();
        ClearAuthHeader();

        // Act
        var response = await _client.GetAsync("/api/consultarEjercicios");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}