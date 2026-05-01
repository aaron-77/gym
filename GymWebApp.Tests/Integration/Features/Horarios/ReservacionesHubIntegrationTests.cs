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
    public ReservacionesHubIntegrationTests(CitasApiWebApplicationFactory<Program> factory) : base(factory)
    {
    }

    protected override string GetHubName() => "reservacionesHub";

    [Fact]
    public async Task EnviarPreReservasActualizadas_InvokeAsync_ReceivesSignalREvent()
    {
        
        var tcs = new TaskCompletionSource<bool>();

        _hubConnection!.On<DTOResponse<List<DTOHorarioVisualizacion>>>(
            "actualizarPreReservasDeHorario",
            (respuesta) =>
            {
                tcs.TrySetResult(respuesta.success);
            });
        
        var fkData = await PreReservaDeHorarioHelper.obtenerRegistrosNecesarios(
            TestContainerHelper.ConnectionString);

        // Insertar pre-reserva con fecha de hoy para que el test funcione
        var fechaInicio = DateTime.Now;
        var fechaExpiracion = DateTime.Now.AddDays(1); // mañana - válida según función SQL

        await GymWebApp.Tests.SharedHelpers.DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO preReservasDeHorario 
              (fechaInicioDeLaReserva, fechaDeExpiracionDeLaReserva, fkHoraLaboral, 
               idUsuarioQueReserva, fechaReservada, idClase, fechaDeLaClase, idEntrenador)
              VALUES (@FechaInicio, @FechaExpiracion, @IdHora, @Usuario, @Fecha, NULL, NULL, NULL)",
            new Dictionary<string, object?>
            {
                ["@FechaInicio"] = fechaInicio,
                ["@FechaExpiracion"] = fechaExpiracion,
                ["@IdHora"] = fkData.HoraLaboralId,
                ["@Usuario"] = fkData.UserId,
                ["@Fecha"] = DateTime.Now.Date
            });

        await _hubConnection.InvokeAsync("enviarPreReservasActualizadas", fkData.UserId);
        bool result = await tcs.Task.WaitAsync(TimeSpan.FromSeconds(5));
        Assert.True(result);
    }
}