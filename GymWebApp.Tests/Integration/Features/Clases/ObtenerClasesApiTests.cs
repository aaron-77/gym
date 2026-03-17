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

        // Verify classes are actually active (FkEstadoClase = 1) in database
        foreach (var clase in result.payload)
        {
            var claseDb = await DatabaseHelper.ExecuteQuerySingleAsync(
                TestContainerHelper.ConnectionString,
                "SELECT FkEstadoClase FROM Clases WHERE ClaseID = @Id",
                new() { ["@Id"] = clase.ClaseID });
            
            claseDb.Should().NotBeNull();
            var estado = Convert.ToInt32(claseDb["FkEstadoClase"]);
            estado.Should().Be(1, "La clase debe estar activa (FkEstadoClase = 1)");
        }
    }

    #endregion
}
