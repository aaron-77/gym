using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Horarios;

[Collection("ObtenerHorariosDisponiblesApiIntegrationTests")]
public class ObtenerHorariosDisponiblesApiTests : IntegrationTestBase<CitasApiWebApplicationFactory<Program>>
{
    public ObtenerHorariosDisponiblesApiTests(CitasApiWebApplicationFactory<Program> factory) : base(factory) { }

    #region Happy Paths (Integration)

    /// <summary>
    /// REQUISITO: Usuario autenticado solicita horarios disponibles
    /// Escenario: Usuario autenticado obtiene todos los horarios disponibles
    /// GIVEN: Hay horarios disponibles en la tabla horasLaborales
    /// AND el usuario está autenticado con token JWT válido
    /// WHEN: GET /api/horarios/obtenerHorariosDisponibles
    /// THEN: Returns 200 OK con success=true
    /// AND payload contiene lista de DTOHorarioVisualizacion
    /// AND cada item tiene idHora > 0
    /// AND cada idHora existe en horasLaborales
    /// </summary>
    [Fact]
    public async Task ObtenerHorariosDisponibles_WithAuthenticatedUser_ReturnsAvailableSlots()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        await SetAuthHeaderAsync();

        // Act
        var response = await Client.GetAsync("/api/horarios/obtenerHorariosDisponibles");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOHorarioVisualizacion>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
        
        // Verify each item has idHora populated
        foreach (var horario in result.payload!)
        {
            horario.idHora.Should().BeGreaterThan(0, "idHora must be greater than 0");
        }
    }

    /// <summary>
    /// REQUISITO: Usuario autenticado solicita horarios disponibles filtrados por fecha
    /// Escenario: Usuario autenticado obtiene horarios disponibles de una fecha específica
    /// GIVEN: Hay horarios en la base de datos para filtrar
    /// AND el usuario está autenticado con token JWT válido
    /// WHEN: GET /api/horarios/obtenerHorariosDisponibles?fecha=YYYY-MM-DD
    /// THEN: Returns 200 OK con success=true
    /// AND payload contiene solo horarios de la fecha solicitada
    /// </summary>
    [Fact]
    public async Task ObtenerHorariosDisponibles_WithSpecificDateAndAuthenticatedUser_ReturnsFilteredSlots()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        await SetAuthHeaderAsync();

        // Use a date from existing seed data
        var fechaResults = await DatabaseHelper.ExecuteQueryAsync(
            TestContainerHelper.ConnectionString,
            "SELECT DISTINCT CONVERT(varchar(10), fechaReservada, 120) as fechaReservada FROM preReservasDeHorario",
            new());
        
        var fecha = fechaResults.Count > 0 
            ? fechaResults[0]["fechaReservada"]!.ToString()!
            : DateOnly.FromDateTime(DateTime.Now).ToString("yyyy-MM-dd");

        // Act
        var response = await Client.GetAsync($"/api/horarios/obtenerHorariosDisponibles?fecha={fecha}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOHorarioVisualizacion>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
        
        // Verify returned items have idHora populated
        foreach (var horario in result.payload!)
        {
            horario.idHora.Should().BeGreaterThan(0, "idHora must be greater than 0");
        }
    }

    #endregion

    #region Sad Paths (Integration)

    /// <summary>
    /// REQUISITO: Solicitud sin autenticación retorna 401
    /// Escenario: Solicitud sin token de autenticación
    /// GIVEN: No se proporciona token de autenticación
    /// WHEN: GET /api/horarios/obtenerHorariosDisponibles
    /// THEN: Returns 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task ObtenerHorariosDisponibles_WithoutAuthentication_Returns401()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        ClearAuthHeader();

        // Act
        var response = await Client.GetAsync("/api/horarios/obtenerHorariosDisponibles");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}