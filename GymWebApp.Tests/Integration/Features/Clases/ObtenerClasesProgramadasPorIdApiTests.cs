using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
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

        var dto = await GymWebApp.Tests.SharedHelpers.ClasesProgramadasHelper.GenerarClaseProgramadaAsync(
            TestContainerHelper.ConnectionString);
        await GymWebApp.Tests.SharedHelpers.ClasesProgramadasHelper.RegistrarClaseProgramadaML(
            TestContainerHelper.ConnectionString, dto);

        // Obtener un ID de clase que tenga clases programadas (futuras o existentes)
        var idClaseNullable = await DatabaseHelper.ExecuteScalarAsync<int?>(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 cp.fkClase
              FROM clasesProgramadas cp
              WHERE cp.fechaDeLaClase >= CAST(GETDATE() AS DATE)
              ORDER BY NEWID()");

        var idClase = idClaseNullable ?? 0;

        if (idClase == 0)
        {
            // Fallback: cualquier clase del catálogo
            idClaseNullable = await DatabaseHelper.ExecuteScalarAsync<int?>(
                TestContainerHelper.ConnectionString,
                "SELECT TOP 1 ClaseId FROM Clases");
            idClase = idClaseNullable ?? 0;
        }

        idClase.Should().BeGreaterThan(0, "Debe existir al menos una clase con clases programadas futuras");

        // Act
        var response = await Client.GetAsync($"/api/Clases/obtenerClasesProgramadasPorId?idClase={idClase}");

        // Assert
        
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOClaseProgramadaView>>>();
        
        result.Should().NotBeNull();

        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
        result.payload.Should().NotBeEmpty("Debe retornar al menos una clase programada");
        
        result.payload.First().idClaseProgramada.Should().BeGreaterThan(0, 
            "El ID de clase programada debe ser mayor a 0");
    }

    #endregion

    #region Sad Path 1 - ID de clase inexistente retorna lista vacía

    /// <summary>
    /// Escenario: Usuario autenticado consulta clases programadas con un ID de clase inexistente
    /// GIVEN: El usuario está autenticado con token JWT válido
    /// AND el ID de clase no existe en la base de datos
    /// WHEN: Se hace GET a /api/Clases/obtenerClasesProgramadasPorId?idClase=99999
    /// THEN: El estado de respuesta debe ser 200 OK
    /// AND success debe ser true
    /// AND payload debe ser una lista vacía
    /// </summary>
    [Fact]
    public async Task ObtenerClasesProgramadasPorId_ConIdInexistente_RetornaListaVacia()
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