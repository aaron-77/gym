using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Factories;
using GymWebApp.Tests.Integration.Helpers;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("IntegrationTests")]
public class ReagendarInscripcionAClaseApiTests : IntegrationTestBase
{
    public ReagendarInscripcionAClaseApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    #region Happy Path Tests

    [Fact]
    public async Task ReagendarInscripcionAClase_WithValidData_ReturnsOk()
    {
        // Arrange
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing users from seed data
        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);

        // Get existing EstadoInscripcion (inscrita = 1 typically)
        var estadoInscripcionActiva = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idEstadoInscripcion FROM estadosInscripciones");

        var fkEstadoInscripcionActiva = Convert.ToInt32(estadoInscripcionActiva?["idEstadoInscripcion"] ?? 1);

        // Get existing EstadoClaseProgramada (activa = 1 typically)
        var estadoClaseProgramada = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idEstadoClaseProgramada FROM estadosClasesProgramadas");

        var fkEstadoClaseProgramada = Convert.ToInt32(estadoClaseProgramada?["idEstadoClaseProgramada"] ?? 1);

        // Obtener slot disponible para la clase ANTERIOR (fecha futura +7 días)
        var fechaClaseAnterior = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        var slotAnterior = await SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync(
            TestContainerHelper.ConnectionString, fechaClaseAnterior);

        if (slotAnterior == null)
            throw new InvalidOperationException("No se encontró slot disponible para la clase anterior");

        // Insertar clase programada ANTERIOR con datos seguros
        var idClaseProgramadaAnterior = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador) 
              VALUES (@FkClase, @CupoMaximo, @FkEstadoClaseProgramada, @FechaDeLaClase, @FkEntrenador);
              SELECT SCOPE_IDENTITY();",
            new()
            {
                ["@FkClase"] = slotAnterior.ClaseId,
                ["@CupoMaximo"] = slotAnterior.Cupo,
                ["@FkEstadoClaseProgramada"] = fkEstadoClaseProgramada,
                ["@FechaDeLaClase"] = slotAnterior.FechaDisponible,
                ["@FkEntrenador"] = slotAnterior.EntrenadorId
            });

        // Insertar horario para la clase anterior
        await DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral)
              VALUES (@FkClaseProgramada, @FkHorarioLaboral)",
            new Dictionary<string, object?>
            {
                ["@FkClaseProgramada"] = idClaseProgramadaAnterior,
                ["@FkHorarioLaboral"] = slotAnterior.IdHoraLaboral
            });

        var inscripcion = InscripcionClaseFactory.Crear(
            fkProgramacionClase: idClaseProgramadaAnterior,
            fkCliente: clienteId,
            fkEstadoInscripcion: fkEstadoInscripcionActiva);

        var idInscripcionCancelada = await InscripcionClaseHelper.InsertarInscripcionAsync(
            TestContainerHelper.ConnectionString,
            inscripcion);

        // Obtener slot disponible para la clase NUEVA (fecha futura +14 días)
        var fechaClaseNueva = DateOnly.FromDateTime(DateTime.Now.AddDays(14));
        var slotNuevo = await SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync(
            TestContainerHelper.ConnectionString, fechaClaseNueva, slotAnterior.ClaseId);

        if (slotNuevo == null)
            throw new InvalidOperationException("No se encontró slot disponible para la clase nueva");

        // Insertar clase programada NUEVA con datos seguros
        var idClaseProgramadaNueva = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador) 
              VALUES (@FkClase, @CupoMaximo, @FkEstadoClaseProgramada, @FechaDeLaClase, @FkEntrenador);
              SELECT SCOPE_IDENTITY();",
            new()
            {
                ["@FkClase"] = slotNuevo.ClaseId,
                ["@CupoMaximo"] = slotNuevo.Cupo,
                ["@FkEstadoClaseProgramada"] = fkEstadoClaseProgramada,
                ["@FechaDeLaClase"] = slotNuevo.FechaDisponible,
                ["@FkEntrenador"] = slotNuevo.EntrenadorId
            });

        // Insertar horario para la clase nueva
        await DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral)
              VALUES (@FkClaseProgramada, @FkHorarioLaboral)",
            new Dictionary<string, object?>
            {
                ["@FkClaseProgramada"] = idClaseProgramadaNueva,
                ["@FkHorarioLaboral"] = slotNuevo.IdHoraLaboral
            });

        // Verify both classes use the same fkClase
        idClaseProgramadaAnterior.Should().BeGreaterThan(0, "La clase programada anterior debe tener un ID válido");
        idClaseProgramadaNueva.Should().BeGreaterThan(0, "La clase programada nueva debe tener un ID válido");
        idClaseProgramadaNueva.Should().NotBe(idClaseProgramadaAnterior, "Las clases programadas deben ser diferentes");

        // Get count of inscriptions before
        var countBefore = await InscripcionClaseHelper.ObtenerConteoInscripcionesAsync(
            TestContainerHelper.ConnectionString);

        var requestDto = ReagendacionInscripcionFactory.Crear(
            idInscripcionCancelada: idInscripcionCancelada,
            idClaseProgramadaNueva: idClaseProgramadaNueva,
            idCliente: clienteId);

        
        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/reagendacionDeInscripcionAClase", requestDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<string>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Contain("exitosamente");

        // Verify original inscription has different state
        var estadoInscripcion = await InscripcionClaseHelper.ObtenerEstadoInscripcionAsync(
            TestContainerHelper.ConnectionString,
            idInscripcionCancelada);

        estadoInscripcion.Should().NotBe(fkEstadoInscripcionActiva, "La inscripción cancelada debe tener un estado diferente al activo");

        // Verify new inscription exists and has the same clienteId
        var countAfter = await InscripcionClaseHelper.ObtenerConteoInscripcionesAsync(
            TestContainerHelper.ConnectionString);

        countAfter.Should().BeGreaterThan(countBefore, "Debe existir un nuevo registro de inscripción");

        // Find the new inscription (should have same clienteId and new fkProgramacionClase)
        var nuevaInscripcionClienteId = await InscripcionClaseHelper.ObtenerClienteIdAsync(
            TestContainerHelper.ConnectionString,
            idInscripcionCancelada + 1);

        nuevaInscripcionClienteId.Should().Be(clienteId, "La nueva inscripción debe tener el mismo clienteId");

        // Verify the original class program state is unchanged (still active)
        var claseProgramadaOriginal = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT fkEstadoClaseProgramada FROM clasesProgramadas WHERE idProgramacionClase = @Id",
            new Dictionary<string, object?> { ["@Id"] = idClaseProgramadaAnterior });

        var estadoClaseOriginal = Convert.ToInt32(claseProgramadaOriginal?["fkEstadoClaseProgramada"]);
        estadoClaseOriginal.Should().Be(fkEstadoClaseProgramada, "El estado de la clase programada original debe permanecer sin cambios");
    }

    #endregion

    #region Sad Path Tests

    [Fact]
    public async Task ReagendarInscripcionAClase_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange
        Client.DefaultRequestHeaders.Authorization = null;

        var requestDto = ReagendacionInscripcionFactory.Crear();

        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/reagendacionDeInscripcionAClase", requestDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}
