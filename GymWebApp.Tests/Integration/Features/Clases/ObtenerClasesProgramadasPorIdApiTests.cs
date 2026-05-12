using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("IntegrationTests")]
public class ObtenerClasesProgramadasPorIdApiTests : IntegrationTestBase
{
    public ObtenerClasesProgramadasPorIdApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    #region Happy Path - Con autenticación válida retorna clases programadas

    /// <summary>
    /// Escenario: Cliente autenticado con rol empleado solicita clases programadas por ID
    /// GIVEN: Existe al menos una clase programada en la base de datos
    /// WHEN: Se hace GET a /api/Clases/obtenerClasesProgramadasPorId?idClase=1 con token válido
    /// THEN: El estado de respuesta debe ser 200 OK
    /// AND success debe ser true
    /// AND payload debe contener una lista con al menos un elemento
    /// </summary>
    [Fact]
    public async Task ObtenerClasesProgramadasPorId_ConAuthValida_ReturnsClasesProgramadas()
    {
        // Arrange
        await SetAuthHeaderAsync();

        // Obtener un ID de clase existente
        var idClase = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ClaseId FROM Clases");

        idClase.Should().BeGreaterThan(0, "Debe existir al menos una clase en la base de datos");

        // Act
        var response = await Client.GetAsync($"/api/Clases/obtenerClasesProgramadasPorId?idClase={idClase}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOClaseProgramadaView>>>();
        
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
        result.payload.Should().NotBeEmpty("Debe retornar al menos una clase programada");
        
        result.payload.First().idClaseProgramada.Should().BeGreaterThan(0, 
            "El ID de clase programada debe ser mayor a 0");
    }

    #endregion

    #region Sad Path 1 - Sin autenticación retorna Unauthorized

    /// <summary>
    /// Escenario: Usuario anónimo intenta acceder al endpoint sin token
    /// GIVEN: El usuario no está autenticado
    /// WHEN: Se hace GET a /api/Clases/obtenerClasesProgramadasPorId?idClase=1 sin token
    /// THEN: El estado de respuesta debe ser 401 Unauthorized
    /// </summary>
    [Fact]
public async Task ObtenerClasesProgramadasPorId_SinAuth_ReturnsUnauthorized()
    {
        // Arrange
        await SetAuthHeaderAsync();

        // Act
        var response = await Client.GetAsync("/api/Clases/obtenerClasesProgramadasPorId?idClase=99999");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOClaseProgramadaView>>>();
        
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
        result.payload.Should().BeEmpty("No debe haber clases programadas para un ID inexistente");
    }

    #endregion
}