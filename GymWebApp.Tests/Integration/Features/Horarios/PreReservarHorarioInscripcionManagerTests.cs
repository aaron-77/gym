using System;
using System.Collections.Generic;
using System.Text.Json;
using System.Threading.Tasks;
using BL;
using DTO.Dtos;
using FluentAssertions;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Horarios;

[Collection("IntegrationTests")]
public class PreReservarHorarioInscripcionManagerTests : IntegrationTestBase
{
    public PreReservarHorarioInscripcionManagerTests(
        CitasApiWebApplicationFactory<Program> factory,
        TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    #region Happy Path

    [Fact]
    public async Task ConTodosLosDatosCorrectos_Devuelve200()
    {
        // Arrange
        await SetAuthHeaderAsync();
        var manager = new HorariosManager(new HttpCustomClient(Client));

        var slot = await SlotDisponibleParaClaseProgramadaHelper
            .obtenerSlotDisponibleParaClaseProgramadaAsync(
                TestContainerHelper.ConnectionString,
                DateOnly.FromDateTime(DateTime.Now.AddDays(7)));

        if (slot == null)
            throw new InvalidOperationException("No se encontró slot disponible para la prueba");

        var claseResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ClaseID FROM Clases",
            new());
        var idClase = Convert.ToInt32(claseResult["ClaseID"]);

        var claseProgResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idProgramacionClase FROM clasesProgramadas",
            new());
        var idClaseProgramada = Convert.ToInt32(claseProgResult["idProgramacionClase"]);

        var dto = new DTOPreReservaDeHorarioInscripcion
        {
            idUsuarioQueReserva = slot.ClienteId,
            fechaTentativa = DateOnly.FromDateTime(DateTime.Now.AddDays(10)),
            idHoraLaboral = slot.IdHoraLaboral,
            idClase = idClase,
            idEntrenador = slot.EntrenadorId,
            idClaseProgramada = idClaseProgramada
        };

        try
        {
            // Act
            var result = await manager.PreReservarHorarioInscripcion(dto);

            // Assert
            result.success.Should().BeTrue();
            result.httpCode.Should().Be(200);
            result.payload.Should().NotBeNull();
            ((JsonElement)result.payload!).GetInt32().Should().BeGreaterThan(0);
        }
        finally
        {
            await PreReservarHorarioApiTestHelper.LimpiarPreReservasDeHorarioAsync(
                TestContainerHelper.ConnectionString, dto);
        }
    }

    #endregion

    #region Sad Paths

    [Fact]
    public async Task SinIdUsuarioQueReserva_Devuelve400()
    {
        // Arrange
        await SetAuthHeaderAsync();
        var manager = new HorariosManager(new HttpCustomClient(Client));

        var slot = await SlotDisponibleParaClaseProgramadaHelper
            .obtenerSlotDisponibleParaClaseProgramadaAsync(
                TestContainerHelper.ConnectionString,
                DateOnly.FromDateTime(DateTime.Now.AddDays(7)));

        if (slot == null)
            throw new InvalidOperationException("No se encontró slot disponible para la prueba");

        var claseResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ClaseID FROM Clases",
            new());
        var idClase = Convert.ToInt32(claseResult["ClaseID"]);

        var claseProgResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idProgramacionClase FROM clasesProgramadas",
            new());
        var idClaseProgramada = Convert.ToInt32(claseProgResult["idProgramacionClase"]);

        var dto = new DTOPreReservaDeHorarioInscripcion
        {
            idUsuarioQueReserva = null,
            fechaTentativa = DateOnly.FromDateTime(DateTime.Now.AddDays(10)),
            idHoraLaboral = slot.IdHoraLaboral,
            idClase = idClase,
            idEntrenador = slot.EntrenadorId,
            idClaseProgramada = idClaseProgramada
        };

        // Act
        var result = await manager.PreReservarHorarioInscripcion(dto);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.payload.Should().BeNull();
        result.errors.Should().Contain(e => e.propiedad == "idUsuarioQueReserva");
    }

    [Fact]
    public async Task ConIdEntrenadorVacio_Devuelve400()
    {
        // Arrange
        await SetAuthHeaderAsync();
        var manager = new HorariosManager(new HttpCustomClient(Client));

        var slot = await SlotDisponibleParaClaseProgramadaHelper
            .obtenerSlotDisponibleParaClaseProgramadaAsync(
                TestContainerHelper.ConnectionString,
                DateOnly.FromDateTime(DateTime.Now.AddDays(7)));

        if (slot == null)
            throw new InvalidOperationException("No se encontró slot disponible para la prueba");

        var claseResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ClaseID FROM Clases",
            new());
        var idClase = Convert.ToInt32(claseResult["ClaseID"]);

        var claseProgResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idProgramacionClase FROM clasesProgramadas",
            new());
        var idClaseProgramada = Convert.ToInt32(claseProgResult["idProgramacionClase"]);

        var dto = new DTOPreReservaDeHorarioInscripcion
        {
            idUsuarioQueReserva = slot.ClienteId,
            fechaTentativa = DateOnly.FromDateTime(DateTime.Now.AddDays(10)),
            idHoraLaboral = slot.IdHoraLaboral,
            idClase = idClase,
            idEntrenador = "",
            idClaseProgramada = idClaseProgramada
        };

        // Act
        var result = await manager.PreReservarHorarioInscripcion(dto);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.payload.Should().BeNull();
        result.errors.Should().Contain(e => e.propiedad == "idEntrenador");
    }

    [Fact]
    public async Task ConIdClaseCero_Devuelve400()
    {
        // Arrange
        await SetAuthHeaderAsync();
        var manager = new HorariosManager(new HttpCustomClient(Client));

        var slot = await SlotDisponibleParaClaseProgramadaHelper
            .obtenerSlotDisponibleParaClaseProgramadaAsync(
                TestContainerHelper.ConnectionString,
                DateOnly.FromDateTime(DateTime.Now.AddDays(7)));

        if (slot == null)
            throw new InvalidOperationException("No se encontró slot disponible para la prueba");

        var claseProgResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idProgramacionClase FROM clasesProgramadas",
            new());
        var idClaseProgramada = Convert.ToInt32(claseProgResult["idProgramacionClase"]);

        var dto = new DTOPreReservaDeHorarioInscripcion
        {
            idUsuarioQueReserva = slot.ClienteId,
            fechaTentativa = DateOnly.FromDateTime(DateTime.Now.AddDays(10)),
            idHoraLaboral = slot.IdHoraLaboral,
            idClase = 0,
            idEntrenador = slot.EntrenadorId,
            idClaseProgramada = idClaseProgramada
        };

        // Act
        var result = await manager.PreReservarHorarioInscripcion(dto);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.payload.Should().BeNull();
        result.errors.Should().Contain(e => e.propiedad == "idClase");
    }

    [Fact]
    public async Task SinIdClaseProgramada_Devuelve400()
    {
        // Arrange
        await SetAuthHeaderAsync();
        var manager = new HorariosManager(new HttpCustomClient(Client));

        var slot = await SlotDisponibleParaClaseProgramadaHelper
            .obtenerSlotDisponibleParaClaseProgramadaAsync(
                TestContainerHelper.ConnectionString,
                DateOnly.FromDateTime(DateTime.Now.AddDays(7)));

        if (slot == null)
            throw new InvalidOperationException("No se encontró slot disponible para la prueba");

        var claseResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ClaseID FROM Clases",
            new());
        var idClase = Convert.ToInt32(claseResult["ClaseID"]);

        var dto = new DTOPreReservaDeHorarioInscripcion
        {
            idUsuarioQueReserva = slot.ClienteId,
            fechaTentativa = DateOnly.FromDateTime(DateTime.Now.AddDays(10)),
            idHoraLaboral = slot.IdHoraLaboral,
            idClase = idClase,
            idEntrenador = slot.EntrenadorId,
            idClaseProgramada = 0
        };

        // Act
        var result = await manager.PreReservarHorarioInscripcion(dto);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.payload.Should().BeNull();
        result.errors.Should().Contain(e => e.propiedad == "idClaseProgramada");
    }

    [Fact]
    public async Task ConFechaInvalida_Devuelve400()
    {
        // Arrange
        await SetAuthHeaderAsync();
        var manager = new HorariosManager(new HttpCustomClient(Client));

        var slot = await SlotDisponibleParaClaseProgramadaHelper
            .obtenerSlotDisponibleParaClaseProgramadaAsync(
                TestContainerHelper.ConnectionString,
                DateOnly.FromDateTime(DateTime.Now.AddDays(7)));

        if (slot == null)
            throw new InvalidOperationException("No se encontró slot disponible para la prueba");

        var claseResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ClaseID FROM Clases",
            new());
        var idClase = Convert.ToInt32(claseResult["ClaseID"]);

        var claseProgResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idProgramacionClase FROM clasesProgramadas",
            new());
        var idClaseProgramada = Convert.ToInt32(claseProgResult["idProgramacionClase"]);

        // Divergencia con spec 69: default(DateOnly) = 0001-01-01 falla
        // FechaMinimaValida(1890) (año 1 < 1890), no [Required].
        var dto = new DTOPreReservaDeHorarioInscripcion
        {
            idUsuarioQueReserva = slot.ClienteId,
            fechaTentativa = default(DateOnly),
            idHoraLaboral = slot.IdHoraLaboral,
            idClase = idClase,
            idEntrenador = slot.EntrenadorId,
            idClaseProgramada = idClaseProgramada
        };

        // Act
        var result = await manager.PreReservarHorarioInscripcion(dto);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.payload.Should().BeNull();
        result.errors.Should().Contain(e => e.propiedad == "fechaTentativa");
    }

    #endregion
}
