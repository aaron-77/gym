using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;

using DTO.Dtos;
using FluentAssertions;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.PreReservas;

/// <summary>
/// Tests de integración (C1–C2, spec 83) del flujo ClasesController.InscribirAClase + limpieza de
/// pre-reservas (spec 82): tras una inscripción exitosa el controller invoca
/// LimpiarPreReservasEspecificasAsync con los datos de la clase programada y las pre-reservas
/// coincidentes desaparecen de BD.
/// </summary>
[Collection("IntegrationTests")]
public class ClasesControllerInscribirAClaseLimpiezaTests : IntegrationTestBase
{
    public ClasesControllerInscribirAClaseLimpiezaTests(
        CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    [Fact]
    public async Task InscribirAClase_ConPreReservaCoincidenteExistente_LimpiaLaPreReservaYRetorna200()
    {
        // Arrange
        // C1: seed de pre-reserva que coincide con los datos de la clase programada (fkHoraLaboral,
        // fechaReservada = fechaDeLaClase, idClase e idEntrenador) → tras el POST la pre-reserva
        // debe desaparecer de BD.
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);

        // Estado de clase programada (activa = 1 típicamente)
        var estadoClaseProgramada = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idEstadoClaseProgramada FROM estadosClasesProgramadas");
        var fkEstadoClaseProgramada = Convert.ToInt32(estadoClaseProgramada?["idEstadoClaseProgramada"] ?? 1);

        // Slot disponible de forma segura (fecha futura +7 días)
        var fechaClase = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        var slot = await SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync(
            TestContainerHelper.ConnectionString, fechaClase);

        if (slot == null)
            throw new InvalidOperationException("No se encontró slot disponible para la clase");

        // Clase programada con datos del slot (fkClase, fechaDeLaClase, fkEntrenador)
        var idClaseProgramada = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador) 
              VALUES (@FkClase, @cupoMaximo, @FkEstadoClaseProgramada, @FechaDeLaClase, @FkEntrenador);
              SELECT SCOPE_IDENTITY();",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = slot.ClaseId,
                ["@cupoMaximo"] = slot.Cupo,
                ["@FkEstadoClaseProgramada"] = fkEstadoClaseProgramada,
                ["@FechaDeLaClase"] = slot.FechaDisponible,
                ["@FkEntrenador"] = slot.EntrenadorId
            });

        // Horario de la clase programada (fkHorarioLaboral = slot.IdHoraLaboral)
        await DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral)
              VALUES (@FkClaseProgramada, @FkHorarioLaboral)",
            new Dictionary<string, object?>
            {
                ["@FkClaseProgramada"] = idClaseProgramada,
                ["@FkHorarioLaboral"] = slot.IdHoraLaboral
            });

        idClaseProgramada.Should().BeGreaterThan(0, "La clase programada debe tener un ID válido");

        // Seed de la pre-reserva que el controller debe limpiar:
        // fkHoraLaboral = slot.IdHoraLaboral, fechaReservada = slot.FechaDisponible,
        // idClase = slot.ClaseId, idEntrenador = slot.EntrenadorId
        await PreReservaTestHelper.InsertarPreReservaAsync(
            TestContainerHelper.ConnectionString,
            slot.IdHoraLaboral,
            slot.FechaDisponible.ToDateTime(TimeOnly.MinValue),
            slot.ClaseId,
            slot.EntrenadorId,
            clienteId);

        var requestDto = new DTOInscripcionAClase
        {
            IdProgramacionClase = idClaseProgramada,
            IdCliente = clienteId
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/inscribirAClase", requestDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();

        // La pre-reserva coincidente debe haber desaparecido tras la inscripción exitosa
        var preReservasRestantes = await PreReservaTestHelper.ObtenerConteoPorFiltroAsync(
            TestContainerHelper.ConnectionString,
            slot.IdHoraLaboral,
            slot.FechaDisponible.ToDateTime(TimeOnly.MinValue),
            slot.ClaseId,
            slot.EntrenadorId);

        preReservasRestantes.Should().Be(0, "La inscripción exitosa debe limpiar la pre-reserva coincidente");
    }

    [Fact]
    public async Task InscribirAClase_SinPreReservaPrevia_Retorna200YFlujoSinCambios()
    {
        // Arrange
        // C2: no hay pre-reserva con los datos de la clase programada → inscripción normal (compatibilidad)
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);

        var estadoClaseProgramada = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idEstadoClaseProgramada FROM estadosClasesProgramadas");
        var fkEstadoClaseProgramada = Convert.ToInt32(estadoClaseProgramada?["idEstadoClaseProgramada"] ?? 1);

        var fechaClase = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        var slot = await SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync(
            TestContainerHelper.ConnectionString, fechaClase);

        if (slot == null)
            throw new InvalidOperationException("No se encontró slot disponible para la clase");

        var idClaseProgramada = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador) 
              VALUES (@FkClase, @cupoMaximo, @FkEstadoClaseProgramada, @FechaDeLaClase, @FkEntrenador);
              SELECT SCOPE_IDENTITY();",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = slot.ClaseId,
                ["@cupoMaximo"] = slot.Cupo,
                ["@FkEstadoClaseProgramada"] = fkEstadoClaseProgramada,
                ["@FechaDeLaClase"] = slot.FechaDisponible,
                ["@FkEntrenador"] = slot.EntrenadorId
            });

        await DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral)
              VALUES (@FkClaseProgramada, @FkHorarioLaboral)",
            new Dictionary<string, object?>
            {
                ["@FkClaseProgramada"] = idClaseProgramada,
                ["@FkHorarioLaboral"] = slot.IdHoraLaboral
            });

        idClaseProgramada.Should().BeGreaterThan(0, "La clase programada debe tener un ID válido");

        // Conteo de inscripciones antes (para verificar que se crea la inscripción)
        var countBefore = await InscripcionClaseHelper.ObtenerConteoInscripcionesAsync(
            TestContainerHelper.ConnectionString);

        var requestDto = new DTOInscripcionAClase
        {
            IdProgramacionClase = idClaseProgramada,
            IdCliente = clienteId
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/inscribirAClase", requestDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();

        // Flujo sin cambios: la inscripción se crea normalmente
        var countAfter = await InscripcionClaseHelper.ObtenerConteoInscripcionesAsync(
            TestContainerHelper.ConnectionString);
        countAfter.Should().BeGreaterThan(countBefore, "Debe existir un nuevo registro de inscripción");

        // Sin pre-reserva previa, no queda ninguna pre-reserva tras el flujo
        var preReservasRestantes = await PreReservaTestHelper.ObtenerConteoPorFiltroAsync(
            TestContainerHelper.ConnectionString,
            slot.IdHoraLaboral,
            slot.FechaDisponible.ToDateTime(TimeOnly.MinValue),
            slot.ClaseId,
            slot.EntrenadorId);
        preReservasRestantes.Should().Be(0);
    }
}
