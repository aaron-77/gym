using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("IntegrationTests")]
public class DetallesDeClaseApiTests : IntegrationTestBase
{
    public DetallesDeClaseApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

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
        // Obtener la clase con nombre "HIIT"
        int? idClaseNulleable = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ClaseId FROM Clases WHERE NombreClase = 'HIIT'");
        Assert.NotNull(idClaseNulleable);
        idClaseNulleable.Should().NotBeNull("La clase 'HIIT' debe existir en la base de datos");
        int idClase = idClaseNulleable.Value;

        // Act
        var response = await Client.GetAsync($"/api/Clases/detallesDeClase?idClase={idClase}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<DetalleDeClase>>();
        
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
        
        // Verificar todos los campos requeridos de DetalleDeClase
        var payload = result.payload;
        
        // Campos escalares obligatorios
        payload.Duracion.Should().BeGreaterThan(0, "La duración debe ser mayor a 0");
        payload.NivelDeIntensidad.Should().NotBeNullOrEmpty("El nivel de intensidad es requerido");
        payload.NivelDeDificultad.Should().NotBeNullOrEmpty("El nivel de dificultad es requerido");
        payload.DescripcionDeLaClase.Should().NotBeNullOrEmpty("La descripción de la clase es requerida");
        
        // Campos de tipo objeto (no null, pueden estar vacíos)
        payload.imagenesDeClase.Should().NotBeNull("Las imágenes de clase son requeridas");
        payload.BeneficiosDeLaClase.Should().NotBeNull("Los beneficios de la clase son requeridos");
        payload.EstructuraDeLaClase.Should().NotBeNull("La estructura de la clase es requerida");
        payload.EjerciciosDeClase.Should().NotBeNull("Los ejercicios de clase son requeridos");
        payload.EquipamientoRecomendado.Should().NotBeNull("El equipamiento recomendado es requerido");
        payload.HorariosProgramados.Should().NotBeNull("Los horarios programados son requeridos");
        
        // Campo opcional (puede ser null)
        // payload.Consejos puede ser null, no se verifica
    }

    #endregion
}
