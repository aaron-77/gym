using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("ObtenerClasesApiIntegrationTests")]
public class ObtenerClasesApiTests : IClassFixture<CitasApiWebApplicationFactory<Program>>
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;
    private string? _authToken;

    public ObtenerClasesApiTests(CitasApiWebApplicationFactory<Program> factory)
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

    #region Happy Paths (Integration)

    /// <summary>
    /// REQUISITO: Happy Path - activa=true + authenticated user
    /// Escenario: Usuario autenticado solicita clases activas
    /// GIVEN: Usuario autenticado con token válido
    /// WHEN: GET /api/Clases/obtenerClases?activa=true
    /// THEN: Returns 200 OK con lista de DTOClaseSimple
    /// AND Cada clase tiene ClaseID > 0 y NombreClase no es null
    /// </summary>
    [Fact]
    public async Task ObtenerClases_WithActivaTrueAndAuthenticatedUser_ReturnsActiveClasses()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader();

        // Act
        var response = await _client.GetAsync("/api/Clases/obtenerClases?activa=true");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOClaseSimple>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
        
        // Verify each class has required fields populated
        foreach (var clase in result.payload!)
        {
            clase.ClaseID.Should().BeGreaterThan(0, "ClaseID must be greater than 0");
            clase.NombreClase.Should().NotBeNullOrEmpty("NombreClase must not be null or empty");
        }
    }

    /// <summary>
    /// REQUISITO: Without Parameter - defaults to false
    /// Escenario: Request sin parámetro activa
    /// GIVEN: Usuario autenticado
    /// WHEN: GET /api/Clases/obtenerClases (sin parámetro)
    /// THEN: Returns 200 OK con clases inactivas (FkEstadoClase = 2)
    /// </summary>
    [Fact]
    public async Task ObtenerClases_WithoutParameter_ReturnsInactiveClasses()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader();

        // Act
        var response = await _client.GetAsync("/api/Clases/obtenerClases");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOClaseSimple>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();

        // Verify we got classes (database should have inactive classes)
        // The default behavior when activa param is missing is activa=false (FkEstadoClase = 2)
        var inactiveClasses = await DatabaseHelper.ExecuteQueryAsync(
            TestContainerHelper.ConnectionString,
            "SELECT COUNT(*) as Total FROM Clases WHERE FkEstadoClase = 2");
        
        var inactiveCount = Convert.ToInt32(inactiveClasses.First()["Total"]);
        result.payload.Count.Should().Be(inactiveCount, "Should return all inactive classes");
    }

    #endregion

    #region Authentication Tests (Integration)

    /// <summary>
    /// REQUISITO: Unauthenticated Request
    /// Escenario: Request sin token de autenticación
    /// GIVEN: Usuario NO autenticado (sin token JWT)
    /// WHEN: GET /api/Clases/obtenerClases?activa=true
    /// THEN: Returns 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task ObtenerClases_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        // NO authentication header - this is the key difference

        // Act
        var response = await _client.GetAsync("/api/Clases/obtenerClases?activa=true");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}
