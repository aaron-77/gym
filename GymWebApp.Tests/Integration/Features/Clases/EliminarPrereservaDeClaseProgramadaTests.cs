using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("EliminarPrereservaDeClaseProgramadaTests")]
public class EliminarPrereservaDeClaseProgramadaTests : IClassFixture<ClasesApiWebApplicationFactory<Program>>
{
    private readonly ClasesApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public EliminarPrereservaDeClaseProgramadaTests(ClasesApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        TestContainerHelper.InitializeAsync().GetAwaiter().GetResult();
        TestContainerHelper.ResetDatabaseAsync().GetAwaiter().GetResult();
    }

    #region Happy Path Tests

    [Fact]
    public async Task EliminarPrereservaDeClaseProgramada_WithValidData_ReturnsOkAndDeletesRecord()
    {
        // Arrange: Authenticate as empleado
        var token = await _factory.AuthenticateAsync(_client);
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get a valid fkHoraLaboral
        var horaLaboral = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales");
        var fkHoraLaboral = Convert.ToInt32(horaLaboral?["idHora"] ?? 1);

        // Insert a pre-reserva into the database
        var fechaReservada = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        var fechaInicio = DateTime.Now.AddDays(7).AddHours(8);
        var fechaExpiracion = DateTime.Now.AddDays(7).AddHours(22);

        await DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO preReservasDeHorario (fkHoraLaboral, fechaReservada, fechaInicioDeLaReserva, fechaDeExpiracionDeLaReserva)
              VALUES (@fkHoraLaboral, @fechaReservada, @fechaInicio, @fechaExpiracion)",
            new() {
                ["@fkHoraLaboral"] = fkHoraLaboral,
                ["@fechaReservada"] = fechaReservada,
                ["@fechaInicio"] = fechaInicio,
                ["@fechaExpiracion"] = fechaExpiracion
            });

        // Get the inserted ID
        var createdRecord = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idPreReserva FROM preReservasDeHorario ORDER BY idPreReserva DESC");
        var idPreReserva = Convert.ToInt32(createdRecord["idPreReserva"]);

        // Act
        var response = await _client.PostAsJsonAsync("/api/Clases/eliminarPrereservaDeClaseProgramada", idPreReserva);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.message.Should().Contain("Pre-reserva eliminada correctamente");
        result.payload.Should().BeGreaterThan(0);

        // Verify in DB that the record was deleted
        var recordCount = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT COUNT(*) as Total FROM preReservasDeHorario WHERE idPreReserva = @id",
            new() { ["@id"] = idPreReserva });
        var count = Convert.ToInt32(recordCount["Total"]);
        count.Should().Be(0);
    }

    #endregion

    #region Sad Path Tests

    [Fact]
    public async Task EliminarPrereservaDeClaseProgramada_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange: No auth header
        _client.DefaultRequestHeaders.Authorization = null;

        // Act
        var response = await _client.PostAsJsonAsync("/api/Clases/eliminarPrereservaDeClaseProgramada", 1);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}