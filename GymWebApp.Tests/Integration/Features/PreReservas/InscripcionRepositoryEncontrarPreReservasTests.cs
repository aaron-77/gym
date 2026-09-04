using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

using DataAccess.Repositories;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;

namespace GymWebApp.Tests.Integration.Features.PreReservas;

/// <summary>
/// Tests de integración (R1–R4, spec 83) para InscripcionRepository.EncontrarPreReservasAsync.
/// Requieren BD real (TestContainers + Respawn): se siembran pre-reservas con datos controlados
/// vía PreReservaTestHelper y se verifica el filtro por (fkHoraLaboral, fechaReservada, idClase, idEntrenador).
/// </summary>
[Collection("IntegrationTests")]
public class InscripcionRepositoryEncontrarPreReservasTests : IntegrationTestBase
{
    private readonly IInscripcionRepository _sut;

    public InscripcionRepositoryEncontrarPreReservasTests(
        CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper)
    {
        _sut = Factory.Services.GetRequiredService<IInscripcionRepository>();
    }

    [Fact]
    public async Task EncontrarPreReservasAsync_CoincidenciaEnLos4Datos_DevuelveLaPreReserva()
    {
        // Arrange
        // R1: seed de una pre-reserva con los 4 datos exactos → debe devolverse
        var connectionString = TestContainerHelper.ConnectionString;
        var fkHoraLaboral = await PreReservaTestHelper.ObtenerIdHoraLaboralAsync(connectionString);
        var fechaReservada = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        const int idClase = 999;
        const string idEntrenador = "entrenador-spec-83";

        var idPreReserva = await PreReservaTestHelper.InsertarPreReservaAsync(
            connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador);

        // Act
        var resultado = await _sut.EncontrarPreReservasAsync(fkHoraLaboral, fechaReservada, idClase, idEntrenador);

        // Assert
        resultado.Should().ContainSingle();
        var encontrada = resultado[0];
        encontrada.IdPreReserva.Should().Be(idPreReserva);
        encontrada.FkHoraLaboral.Should().Be(fkHoraLaboral);
        encontrada.FechaReservada.Should().Be(fechaReservada);
        encontrada.IdClase.Should().Be(idClase);
        encontrada.IdEntrenador.Should().Be(idEntrenador);
    }

    [Fact]
    public async Task EncontrarPreReservasAsync_MultiplesCoincidencias_DevuelveTodas()
    {
        // Arrange
        // R2: varias pre-reservas con los mismos 4 datos → todas deben devolverse.
        // fechaDeLaClase = NULL permite sembrar duplicados sin violar el índice único filtrado
        // UX_preReservasDeHorario_Unique (solo aplica con idClase, fechaDeLaClase e idEntrenador NOT NULL).
        var connectionString = TestContainerHelper.ConnectionString;
        var fkHoraLaboral = await PreReservaTestHelper.ObtenerIdHoraLaboralAsync(connectionString);
        var fechaReservada = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        const int idClase = 999;
        const string idEntrenador = "entrenador-spec-83";

        var id1 = await PreReservaTestHelper.InsertarPreReservaAsync(connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador);
        var id2 = await PreReservaTestHelper.InsertarPreReservaAsync(connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador);
        var id3 = await PreReservaTestHelper.InsertarPreReservaAsync(connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador);

        // Act
        var resultado = await _sut.EncontrarPreReservasAsync(fkHoraLaboral, fechaReservada, idClase, idEntrenador);

        // Assert
        resultado.Should().HaveCount(3);
        resultado.Select(p => p.IdPreReserva).Should().BeEquivalentTo(new[] { id1, id2, id3 });
    }

    [Fact]
    public async Task EncontrarPreReservasAsync_FiltroConOtroEntrenador_DevuelveListaVacia()
    {
        // Arrange
        // R3: seed con un entrenador y consulta con otro → sin coincidencias
        var connectionString = TestContainerHelper.ConnectionString;
        var fkHoraLaboral = await PreReservaTestHelper.ObtenerIdHoraLaboralAsync(connectionString);
        var fechaReservada = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        const int idClase = 999;

        await PreReservaTestHelper.InsertarPreReservaAsync(
            connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, "entrenador-a");

        // Act
        var resultado = await _sut.EncontrarPreReservasAsync(fkHoraLaboral, fechaReservada, idClase, "entrenador-b");

        // Assert
        resultado.Should().BeEmpty();
    }

    [Fact]
    public async Task EncontrarPreReservasAsync_PreReservaConIdEntrenadorNull_NoSeIncluyeEnElResultado()
    {
        // Arrange
        // R4: una pre-reserva con IdEntrenador null no debe devolverse al filtrar por un entrenador
        // (el WHERE idEntrenador = @p excluye naturalmente las filas con NULL)
        var connectionString = TestContainerHelper.ConnectionString;
        var fkHoraLaboral = await PreReservaTestHelper.ObtenerIdHoraLaboralAsync(connectionString);
        var fechaReservada = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        const int idClase = 999;

        await PreReservaTestHelper.InsertarPreReservaAsync(
            connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, idEntrenador: null);

        var idValida = await PreReservaTestHelper.InsertarPreReservaAsync(
            connectionString, fkHoraLaboral, fechaReservada.ToDateTime(TimeOnly.MinValue), idClase, "entrenador-spec-83");

        // Act
        var resultado = await _sut.EncontrarPreReservasAsync(fkHoraLaboral, fechaReservada, idClase, "entrenador-spec-83");

        // Assert
        resultado.Should().ContainSingle();
        resultado[0].IdPreReserva.Should().Be(idValida);
        resultado[0].IdEntrenador.Should().NotBeNull();
    }
}