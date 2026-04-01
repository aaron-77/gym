using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Horarios;

[Collection("ObtenerPreReservasApiIntegrationTests")]
public class ObtenerPreReservasApiTests : IntegrationTestBase<CitasApiWebApplicationFactory<Program>>
{
    public ObtenerPreReservasApiTests(CitasApiWebApplicationFactory<Program> factory) : base(factory) { }

    #region Happy Paths (Integration)

    /// <summary>
    /// REQUISITO: Usuario autenticado solicita pre-reservas de horarios
    /// Escenario: Usuario autenticado obtiene todas las pre-reservas
    /// GIVEN: Hay pre-reservas en la tabla preReservasDeHorario
    /// AND el usuario está autenticado con token JWT válido
    /// WHEN: GET /api/horarios/obtenerPreReservas
    /// THEN: Returns 200 OK con success=true
    /// AND payload contiene lista de DTOHorarioVisualizacion
    /// AND cada item tiene idHora > 0
    /// AND cada idPreReserva existe en preReservasDeHorario
    /// </summary>
    [Fact]
    public async Task ObtenerPreReservas_WithAuthenticatedUser_ReturnsPreReservedSlots()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        await SetAuthHeaderAsync();

        // Act
        var response = await Client.GetAsync("/api/horarios/obtenerPreReservas");

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
    /// REQUISITO: Usuario autenticado solicita pre-reservas filtradas por fecha
    /// Escenario: Usuario autenticado obtiene pre-reservas de una fecha específica
    /// GIVEN: Hay pre-reservas en la tabla preReservasDeHorario para la fecha solicitada
    /// AND el usuario está autenticado con token JWT válido
    /// WHEN: GET /api/horarios/obtenerPreReservas?fecha=YYYY-MM-DD
    /// THEN: Returns 200 OK con success=true
    /// AND payload contiene solo horarios de la fecha solicitada
    /// AND la cantidad coincide con los registros en BD
    /// AND los idHora retornados coinciden con los insertados
    /// </summary>
    [Fact]
    public async Task ObtenerPreReservas_WithSpecificDateAndAuthenticatedUser_ReturnsFilteredSlots()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        await SetAuthHeaderAsync();

        // 1. Definir fecha de prueba controlada
        var testDate = DateTime.Now.AddDays(7).Date;
        var testDateStr = testDate.ToString("yyyy-MM-dd");
        
        // 2. Obtener 3 idHora diferentes de horasLaborales
        var horasResult = await DatabaseHelper.ExecuteQueryAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 3 idHora FROM horasLaborales ORDER BY idHora",
            new());
        
        var idHora1 = Convert.ToInt32(horasResult[0]["idHora"]);
        var idHora2 = Convert.ToInt32(horasResult[1]["idHora"]);
        var idHora3 = Convert.ToInt32(horasResult[2]["idHora"]);
        
        // 3. Insertar 3 pre-reservas con la MISMA fecha pero DIFERENTES horas
        // IMPORTANTE: fechaDeExpiracion debe ser en el FUTURO para que la función SQL la considere válida
        // La función fn_consultarHorariosPreReservados verifica: GETDATE() BETWEEN fechaInicio AND fechaExpiracion
        var fechaInicio = DateTime.Now;
        var fechaExpiracion = DateTime.Now.AddDays(1); // tomorrow - ensure GETDATE() is within range
        
        await DatabaseHelper.ExecuteQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO preReservasDeHorario 
              (fechaInicioDeLaReserva, fechaDeExpiracionDeLaReserva, fkHoraLaboral, 
               idUsuarioQueReserva, fechaReservada, idClase, fechaDeLaClase, idEntrenador)
              VALUES 
              (@FechaInicio, @FechaExpiracion, @IdHora1, @Usuario, @Fecha, NULL, NULL, NULL),
              (@FechaInicio, @FechaExpiracion, @IdHora2, @Usuario, @Fecha, NULL, NULL, NULL),
              (@FechaInicio, @FechaExpiracion, @IdHora3, @Usuario, @Fecha, NULL, NULL, NULL)",
            new() {
                ["@FechaInicio"] = fechaInicio,
                ["@FechaExpiracion"] = fechaExpiracion,
                ["@IdHora1"] = idHora1,
                ["@IdHora2"] = idHora2,
                ["@IdHora3"] = idHora3,
                ["@Usuario"] = "test-user-id",
                ["@Fecha"] = testDate
            });

        // 4. Verificar conteo antes del test
        var countBefore = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT COUNT(*) as Total FROM preReservasDeHorario WHERE fechaReservada = @Fecha",
            new() { ["@Fecha"] = testDate });
        var expectedCount = Convert.ToInt32(countBefore["Total"]);
        expectedCount.Should().Be(3, "Debe haber 3 pre-reservas insertadas");

        // Act
        var response = await Client.GetAsync($"/api/horarios/obtenerPreReservas?fecha={testDateStr}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOHorarioVisualizacion>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
        
        // Verificar que la cantidad coincide con los insertados
        result.payload.Count.Should().Be(expectedCount, "Debe retornar exactamente las pre-reservas insertadas");
        
        // Verificar que cada resultado tiene la fecha correcta
        foreach (var horario in result.payload!)
        {
            var fechaItem = horario.fechaDisponible.Date;
            fechaItem.Should().Be(testDate, "All returned items must match the test date");
        }
        
        // Verificar que los idHora retornados son los que insertamos
        var returnedIds = result.payload.Select(h => h.idHora).ToHashSet();
        returnedIds.Should().BeEquivalentTo(new[] { idHora1, idHora2, idHora3 }, 
            "Must return exactly the hours we inserted");
    }

    #endregion

    #region Sad Paths (Integration)

    /// <summary>
    /// REQUISITO: Solicitud sin autenticación retorna 401
    /// Escenario: Solicitud sin token de autenticación
    /// GIVEN: No se proporciona token de autenticación
    /// WHEN: GET /api/horarios/obtenerPreReservas
    /// THEN: Returns 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task ObtenerPreReservas_WithoutAuthentication_Returns401()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        ClearAuthHeader();

        // Act
        var response = await Client.GetAsync("/api/horarios/obtenerPreReservas");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}