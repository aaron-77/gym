using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("ClasesApiIntegrationTests")]
public class DetallesDeClaseApiTests : IClassFixture<ClasesApiWebApplicationFactory<Program>>
{
    private readonly ClasesApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public DetallesDeClaseApiTests(ClasesApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        InitializeAsync().GetAwaiter().GetResult();
    }

    private async Task InitializeAsync()
    {
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
    }

    #region REQUISITO: Successful Class Retrieval (Integration - Happy Path)

    /// <summary>
    /// REQUISITO: Successful Class Retrieval
    /// Escenario: Anonymous user requests class details with success
    /// GIVEN: a class with ID 1 exists in the database
    /// WHEN: a GET request is made to /api/Clases/detallesDeClase?idClase=1
    /// THEN: the response status MUST be 200 OK
    /// AND the success field MUST be true
    /// AND the payload MUST contain the details for the class
    /// </summary>
    [Fact]
    public async Task ConsultarDetallesDeClase_WithExistingId_ReturnsOkAndFullDetails()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        
        // Obtener una clase existente que tenga niveles de intensidad y dificultad (para evitar INNER JOIN nulls)
        var existingClass = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 c.ClaseId 
              FROM Clases c
              INNER JOIN nivelesDeIntensidadDeClase ni ON c.FkIntensidad = ni.IdNivelDeIntensidad
              INNER JOIN nivelesDeDificultadDeClase nd ON c.FkDificultad = nd.IdNivelDeDificultadDeClase");
        
        var idClase = existingClass?["ClaseId"];
        idClase.Should().NotBeNull("Se requiere al menos una clase en la base de datos");

        // Act
        var response = await _client.GetAsync($"/api/Clases/detallesDeClase?idClase={idClase}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<DetalleDeClase>>();
        
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
        result.payload.Duracion.Should().BeGreaterThan(0);
    }

    #endregion
}
