using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

using API.Services;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;

namespace GymWebApp.Tests.Integration.Features.PreReservas;

/// <summary>
/// Tests de integración (S1–S2, spec 83) para InscripcionesService.LimpiarPreReservasEspecificasAsync
/// contra BD real: siembra de pre-reservas y verificación de que el wrapper las elimina (o no hace nada).
/// </summary>
[Collection("IntegrationTests")]
public class LimpiarPreReservasEspecificasServiceTests : IntegrationTestBase
{
    private readonly IInscripcionesService _sut;

    public LimpiarPreReservasEspecificasServiceTests(
        CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper)
    {
        _sut = Factory.Services.GetRequiredService<IInscripcionesService>();
    }

    [Fact]
    public async Task LimpiarPreReservasEspecificasAsync_ConPreReservasExistentes_LimpiaYRetornaTrue()
    {
        // Arrange
        // S1: seed de 2 pre-reservas con los 4 datos → el wrapper las elimina y retorna true
        var connectionString = TestContainerHelper.ConnectionString;
        var fkHoraLaboral = await PreReservaTestHelper.ObtenerIdHoraLaboralAsync(connectionString);
        var fechaReservada = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        const int idClase = 999;
        const string idEntrenador = "entrenador-spec-83";

        await PreReservaTestHelper.InsertarPreReservaAsync(connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador);
        await PreReservaTestHelper.InsertarPreReservaAsync(connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador);

        // Act
        var result = await _sut.LimpiarPreReservasEspecificasAsync(fkHoraLaboral, fechaReservada, idClase, idEntrenador);

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().BeTrue();
        result.message.Should().Be("Pre-reservas limpiadas correctamente");

        // Las pre-reservas deben haber desaparecido de BD
        var restantes = await PreReservaTestHelper.ObtenerConteoPorFiltroAsync(
            connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador);
        restantes.Should().Be(0);
    }

    [Fact]
    public async Task LimpiarPreReservasEspecificasAsync_SinPreReservas_RetornaTrueSinCambios()
    {
        // Arrange
        // S2: no hay pre-reservas con esos datos → true (nada que limpiar)
        var connectionString = TestContainerHelper.ConnectionString;
        var fkHoraLaboral = await PreReservaTestHelper.ObtenerIdHoraLaboralAsync(connectionString);
        var fechaReservada = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        const int idClase = 999;
        const string idEntrenador = "entrenador-spec-83";

        // Act
        var result = await _sut.LimpiarPreReservasEspecificasAsync(fkHoraLaboral, fechaReservada, idClase, idEntrenador);

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().BeTrue();
        result.message.Should().Be("No hay pre-reservas para limpiar");
    }
}