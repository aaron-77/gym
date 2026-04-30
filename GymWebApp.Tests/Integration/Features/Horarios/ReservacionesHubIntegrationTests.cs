using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using DTO.Dtos;
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

    [Fact]
    public async Task RegistrarPreReserva_ApiNotificaViaSignalR_RecibeEventoSignalR()
    {
        await TestContainerHelper.ResetDatabaseAsync();
        await SetAuthHeaderAsync();

        var tcs = new TaskCompletionSource<bool>();

        _hubConnection!.On<string>(
            "actualizarPreReservasDeHorario",
            (arg) =>
            {
                using var doc = JsonDocument.Parse(arg);
                var root = doc.RootElement;
                var success = root.TryGetProperty("success", out var successProp) && successProp.GetBoolean();
                tcs.TrySetResult(success);
            });

        var fkData = await PreReservaDeHorarioHelper.obtenerRegistrosNecesarios(
            TestContainerHelper.ConnectionString);

        var dto = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = fkData.UserId,
            idEntrenador = fkData.TrainerId,
            idClase = fkData.ClaseId,
            idHoraLaboral = fkData.HoraLaboralId,
            fechaTentativa = DateOnly.FromDateTime(fkData.FechaReservada)
        };

        var response = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", dto);

        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var completedTask = await Task.WhenAny(tcs.Task, Task.Delay(TimeSpan.FromSeconds(10)));

        completedTask.Should().NotBe(Task.Delay(TimeSpan.FromSeconds(10)));

        var signalRReceived = await tcs.Task;
        signalRReceived.Should().BeTrue();
    }
}