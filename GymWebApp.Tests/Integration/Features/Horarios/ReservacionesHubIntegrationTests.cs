using System.Text.Json;
using DTO.Dtos;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using FluentAssertions;
using Microsoft.AspNetCore.SignalR.Client;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Horarios;

[Collection("ReservacionesHubIntegrationTests")]
public class ReservacionesHubIntegrationTests : SignalRIntegrationTestBase
{
    public ReservacionesHubIntegrationTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) : base(factory, testContainerHelper)
    {
    }

    protected override string GetHubName() => "reservacionesHub";

    [Fact]
    public async Task EnviarPreReservasActualizadas_InvokeAsync_ReceivesSignalREvent()
    {
        //ARRANGE                
        var fkData = await PreReservaDeHorarioHelper.obtenerRegistrosNecesarios(
            TestContainerHelper.ConnectionString);

        // Usar los datos del helper para la pre-reserva
        var fechaInicioDeLaReserva = DateTime.Today; // Incluye fecha y hora del helper
        var fechaDeExpiracionDeLaReserva = DateTime.Today.AddDays(1); // Derivada del helper, asegura validez

        var rowsAffected = await GymWebApp.Tests.SharedHelpers.DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO preReservasDeHorario 
              (fechaInicioDeLaReserva, fechaDeExpiracionDeLaReserva, fkHoraLaboral, 
               idUsuarioQueReserva, fechaReservada, idClase, fechaDeLaClase, idEntrenador)
              VALUES (@FechaInicio, @FechaExpiracion, @IdHora, @Usuario, @Fecha, NULL, NULL, NULL)",
            new Dictionary<string, object?>
            {
                ["@FechaInicio"] = fechaInicioDeLaReserva,
                ["@FechaExpiracion"] = fechaDeExpiracionDeLaReserva,
                ["@IdHora"] = fkData.HoraLaboralId,
                ["@Usuario"] = fkData.UserId,
                ["@Fecha"] = fkData.FechaReservada.Date // Solo la fecha, la columna es date
            });

        rowsAffected.Should().BeGreaterThan(0, "La inserción de pre-reserva debe afectar al menos 1 fila");

        
        var tcs = new TaskCompletionSource<bool>();
        //ACT
        _hubConnection!.On<DTOResponse<List<DTOHorarioVisualizacion>>>(
            "actualizarPreReservasDeHorario",
            (respuesta) =>
            {
                tcs.TrySetResult(respuesta.success);
            });

        await _hubConnection.InvokeAsync("enviarPreReservasActualizadas", fkData.UserId);
        bool result = await tcs.Task.WaitAsync(TimeSpan.FromSeconds(5));
        //ASSERT
        Assert.True(result);
    }

    [Fact]
    public async Task EnviarHorariosDisponiblesActualizados_WithAvailableSchedules_SendsCorrectEvent()
    {
        //ARRANGE
        

        var tcs = new TaskCompletionSource<DTOResponse<List<DTOHorarioVisualizacion>>>();

        _hubConnection!.On<DTOResponse<List<DTOHorarioVisualizacion>>>(
            "actualizarHorariosDisponibles",
            (respuesta) => tcs.TrySetResult(respuesta));

        //ACT
        await _hubConnection.InvokeAsync("enviarHorariosDisponiblesActualizados", "testUserId");
        var respuesta = await tcs.Task.WaitAsync(TimeSpan.FromSeconds(5));

        //ASSERT
        respuesta.success.Should().BeTrue();
        respuesta.httpCode.Should().Be(200);
        respuesta.payload.Should().NotBeNull();
        respuesta.payload.Should().NotBeEmpty();
        respuesta.message.Should().Contain("éxito");
    }

    [Fact]
    public async Task EnviarHorariosDisponiblesActualizados_SendsValidAvailableSchedules()
    {
        //ARRANGE
        // No es necesario hacer seed de datos. El estado base de la BD (horasLaborales disponibles)
        // es suficiente para que el servicio devuelva horarios disponibles.
        var tcs = new TaskCompletionSource<DTOResponse<List<DTOHorarioVisualizacion>>>();

        _hubConnection!.On<DTOResponse<List<DTOHorarioVisualizacion>>>(
            "actualizarHorariosDisponibles",
            (respuesta) => tcs.TrySetResult(respuesta));

        //ACT
        await _hubConnection.InvokeAsync("enviarHorariosDisponiblesActualizados", "testUserId");
        var respuesta = await tcs.Task.WaitAsync(TimeSpan.FromSeconds(5));

        //ASSERT
        respuesta.success.Should().BeTrue();
        respuesta.payload.Should().NotBeNull();
        respuesta.payload.Should().NotBeEmpty();
    }
}