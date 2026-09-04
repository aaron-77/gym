using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

using DataAccess.Repositories;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;

namespace GymWebApp.Tests.Integration.Features.PreReservas;

/// <summary>
/// Tests de integración (R5–R6, spec 83) para InscripcionRepository.EliminarPreReservasEspecificasAsync.
/// Verifica que el método recibe una colección de IdPreReserva y elimina SOLO esas filas:
/// devuelve el conteo de filas eliminadas y las demás pre-reservas permanecen intactas.
/// </summary>
[Collection("IntegrationTests")]
public class InscripcionRepositoryEliminarPreReservasTests : IntegrationTestBase
{
    private readonly IInscripcionRepository _sut;

    public InscripcionRepositoryEliminarPreReservasTests(
        CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper)
    {
        _sut = Factory.Services.GetRequiredService<IInscripcionRepository>();
    }

    [Fact]
    public async Task EliminarPreReservasEspecificasAsync_ConTodosLosIdsPasados_EliminaTodasYLanzaConteoCorrecto()
    {
        // Arrange
        // R5: seed de 2 pre-reservas; se pasan ambos IdPreReserva → ambas deben desaparecer
        var connectionString = TestContainerHelper.ConnectionString;
        var fkHoraLaboral = await PreReservaTestHelper.ObtenerIdHoraLaboralAsync(connectionString);
        var fechaReservada = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        const int idClase = 999;
        const string idEntrenador = "entrenador-spec-83";

        var id1 = await PreReservaTestHelper.InsertarPreReservaAsync(connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador);
        var id2 = await PreReservaTestHelper.InsertarPreReservaAsync(connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador);

        // Act
        var eliminadas = await _sut.EliminarPreReservasEspecificasAsync(new List<int> { id1, id2 });

        // Assert
        eliminadas.Should().Be(2, "Deben eliminarse exactamente las 2 pre-reservas pasadas por parámetro");
        (await PreReservaTestHelper.ObtenerConteoPorIdAsync(connectionString, id1)).Should().Be(0);
        (await PreReservaTestHelper.ObtenerConteoPorIdAsync(connectionString, id2)).Should().Be(0);
    }

    [Fact]
    public async Task EliminarPreReservasEspecificasAsync_SoloEliminaLosIdsPasados_DejaIntactasLasDemas()
    {
        // Arrange
        // R6: seed de 3 pre-reservas; se pasan solo 2 IdPreReserva → la tercera permanece en BD
        var connectionString = TestContainerHelper.ConnectionString;
        var fkHoraLaboral = await PreReservaTestHelper.ObtenerIdHoraLaboralAsync(connectionString);
        var fechaReservada = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        const int idClase = 999;
        const string idEntrenador = "entrenador-spec-83";

        var id1 = await PreReservaTestHelper.InsertarPreReservaAsync(connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador);
        var id2 = await PreReservaTestHelper.InsertarPreReservaAsync(connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador);
        var id3 = await PreReservaTestHelper.InsertarPreReservaAsync(connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador);

        // Act — solo se pasan id1 e id2
        var eliminadas = await _sut.EliminarPreReservasEspecificasAsync(new List<int> { id1, id2 });

        // Assert
        eliminadas.Should().Be(2, "Deben eliminarse solo las 2 pre-reservas pasadas por parámetro");
        (await PreReservaTestHelper.ObtenerConteoPorIdAsync(connectionString, id1)).Should().Be(0);
        (await PreReservaTestHelper.ObtenerConteoPorIdAsync(connectionString, id2)).Should().Be(0);
        (await PreReservaTestHelper.ObtenerConteoPorIdAsync(connectionString, id3)).Should().Be(1, "La pre-reserva cuyo id no se pasó debe permanecer en BD");
    }
}