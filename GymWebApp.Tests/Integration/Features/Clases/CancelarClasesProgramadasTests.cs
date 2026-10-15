using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Factories;
using GymWebApp.Tests.Integration.Helpers;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("IntegrationTests")]
public class CancelarClasesProgramadasTests : IntegrationTestBase
{
    public CancelarClasesProgramadasTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    #region Happy Path Tests

    [Fact]
    public async Task CancelarClasesProgramadas_WithValidData_ReturnsOkAndCreatesReagendacion()
    {
        
        // Arrange: Create reservation directly in DB (endpoint has known issues)
        
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing users (clienteId only - entrenador comes from slot)
        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);

        // Obtener slot disponible de forma segura (fecha futura +7 días)
        var fechaClase = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        var slot = await SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync(
            TestContainerHelper.ConnectionString, fechaClase);

        if (slot == null)
            throw new InvalidOperationException("No se encontró slot disponible para la clase");

        // Get existing fkEstadoClaseProgramada
        var estadoClase = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idEstadoClaseProgramada FROM estadosClasesProgramadas");
        var fkEstadoClaseProgramada = Convert.ToInt32(estadoClase?["idEstadoClaseProgramada"] ?? 1);

        // Get existing fkEstadoHorarioClase
        var estadoHorarioClase = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idEstadoHorarioClase FROM estadosHorarioClaseProgramada");
        var fkEstadoHorarioClase = Convert.ToInt32(estadoHorarioClase?["idEstadoHorarioClase"] ?? 1);

        // Insert clase programada with datos seguros
        // Schema: idProgramacionClase, fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaCreacion, 
        //         fechaModificacion, fkEntrenador, fechaDeLaClase
        await DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, fkEntrenador, CupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase)
              VALUES (@fkClase, @fkEntrenador, @cupoMaximo, @fkEstadoClaseProgramada, @fechaDeLaClase)",
            new() {
                ["@fkClase"] = slot.ClaseId,
                ["@fkEntrenador"] = Guid.Parse(slot.EntrenadorId),
                ["@cupoMaximo"] = slot.Cupo,
                ["@fkEstadoClaseProgramada"] = fkEstadoClaseProgramada,
                ["@fechaDeLaClase"] = slot.FechaDisponible
            });

        // Get the created record ID
        var createdRecord = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idProgramacionClase FROM clasesProgramadas ORDER BY idProgramacionClase DESC");
        var idProgramacionClase = Convert.ToInt32(createdRecord["idProgramacionClase"]);

        // Insert into horariosDeClasesProgramadas with datos seguros
        // Schema: idHorarioDeClaseProgramada, fkClaseProgramada, fkHorarioLaboral, fkEstadoHorarioClase
        await DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral, fkEstadoHorarioClase)
              VALUES (@fkClaseProgramada, @fkHorarioLaboral, @fkEstadoHorarioClase)",
            new() {
                ["@fkClaseProgramada"] = idProgramacionClase,
                ["@fkHorarioLaboral"] = slot.IdHoraLaboral,
                ["@fkEstadoHorarioClase"] = fkEstadoHorarioClase
            });

        // Obtener slot para la clase reagendada (fecha futura +14 días)
        var fechaClaseReagendada = DateOnly.FromDateTime(DateTime.Now.AddDays(14));
        var slotReagendado = await SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync(
            TestContainerHelper.ConnectionString, fechaClaseReagendada, slot.ClaseId);

        if (slotReagendado == null)
            throw new InvalidOperationException("No se encontró slot disponible para la clase reagendada");

        // Create cancel request
        var requestList = new List<DTOClaseCancelada>
        {
            DTOClaseCanceladaFactory.Crear(
                idProgramacionClase: idProgramacionClase,
                fkClase: slot.ClaseId,
                fkEntrenador: slot.EntrenadorId,
                cupoMaximo: slot.Cupo,
                fkEstadoClaseProgramada: fkEstadoClaseProgramada,
                fechaDeLaClase: slot.FechaDisponible,
                idUsuarioQueReserva: clienteId,
                fkHoraLaboral: slot.IdHoraLaboral,
                idPreservaDeHorario: 0,
                claseReagendada: new DTODatosClaseProgramada
                {
                    fkClase = slotReagendado.ClaseId,
                    fkEntrenador = slotReagendado.EntrenadorId,
                    cupoMaximo = slotReagendado.Cupo,
                    fkEstadoClaseProgramada = fkEstadoClaseProgramada,
                    fechaDeLaClase = slotReagendado.FechaDisponible,
                    idUsuarioQueReserva = clienteId,
                    fkHoraLaboral = slotReagendado.IdHoraLaboral
                }
            )
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/cancelarClasesProgramadas", requestList);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<string>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Contain("cancelada exitosamente");
    }

    #endregion

    #region Sad Path Tests

    [Fact]
    public async Task CancelarClasesProgramadas_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange: Empty auth header
        Client.DefaultRequestHeaders.Authorization = null;

        var requestList = new List<DTOClaseCancelada>
        {
            DTOClaseCanceladaFactory.Crear(
                idProgramacionClase: 1,
                fkClase: 1,
                fkEntrenador: "00000000-0000-0000-0000-000000000001",
                cupoMaximo: 20,
                fkEstadoClaseProgramada: 1,
                fechaDeLaClase: DateOnly.FromDateTime(DateTime.Now.AddDays(7)),
                idUsuarioQueReserva: "00000000-0000-0000-0000-000000000001",
                fkHoraLaboral: 1,
                idPreservaDeHorario: 0,
                claseReagendada: null
            )
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/cancelarClasesProgramadas", requestList);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task CancelarClasesProgramadas_WithInvalidReagendacion_ReturnsOkWithErrorMessage()
    {
        // Arrange: Create reservation first using API
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);
        var entrenadorId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.EmpleadoEmail);

        var claseActiva = ClaseFactory.CrearClaseActiva();
        var savedClase = await DatabaseHelper.NonQueryAsyncTyped(
            TestContainerHelper.ConnectionString,
            "Clases",
            claseActiva);

        var estadoClase = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idEstadoClaseProgramada FROM estadosClasesProgramadas");
        var fkEstadoClaseProgramada = Convert.ToInt32(estadoClase?["idEstadoClaseProgramada"] ?? 1);

        var horaLaboral = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales");
        var fkHoraLaboral = Convert.ToInt32(horaLaboral?["idHora"] ?? 1);

        // Register first
        var requestDto = new DTODatosClaseProgramada
        {
            fkClase = savedClase.ClaseId,
            fkEntrenador = Guid.Parse(entrenadorId).ToString(),
            cupoMaximo = 20,
            fkEstadoClaseProgramada = fkEstadoClaseProgramada,
            fechaDeLaClase = DateOnly.FromDateTime(DateTime.Now.AddDays(7)),
            idUsuarioQueReserva = clienteId,
            fkHoraLaboral = fkHoraLaboral
        };

        var registerResponse = await Client.PostAsJsonAsync("/api/Clases/registrarClaseProgramada", requestDto);
        var registerResult = await registerResponse.Content.ReadFromJsonAsync<DTOResponse<int?>>();
        var idProgramacionClase = registerResult!.payload!.Value;

        // Create cancel request with invalid reschedule (non-existent class)
        var requestList = new List<DTOClaseCancelada>
        {
            DTOClaseCanceladaFactory.Crear(
                idProgramacionClase: idProgramacionClase,
                fkClase: savedClase.ClaseId,
                fkEntrenador: Guid.Parse(entrenadorId).ToString(),
                cupoMaximo: 20,
                fkEstadoClaseProgramada: fkEstadoClaseProgramada,
                fechaDeLaClase: DateOnly.FromDateTime(DateTime.Now.AddDays(7)),
                idUsuarioQueReserva: clienteId,
                fkHoraLaboral: fkHoraLaboral,
                idPreservaDeHorario: 0,
                claseReagendada: new DTODatosClaseProgramada
                {
                    fkClase = 99999, // Non-existent class
                    fkEntrenador = Guid.Parse(entrenadorId).ToString(),
                    cupoMaximo = 20,
                    fkEstadoClaseProgramada = fkEstadoClaseProgramada,
                    fechaDeLaClase = DateOnly.FromDateTime(DateTime.Now.AddDays(14)),
                    idUsuarioQueReserva = clienteId,
                    fkHoraLaboral = fkHoraLaboral
                }
            )
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/cancelarClasesProgramadas", requestList);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<string>>();
        result.Should().NotBeNull();
        // Either the cancel fails or the reschedule fails
        result!.message.Should().Match(m => m.Contains("Error al reagendar") || m.Contains("No se pudo cancelar"));
    }

    [Fact]
    public async Task CancelarClasesProgramadas_WithoutReagendacion_ReturnsOkWithMessage()
    {
        // Arrange: Create reservation first using API

        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);
        var entrenadorId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.EmpleadoEmail);

        var claseActiva = ClaseFactory.CrearClaseActiva();
        var savedClase = await DatabaseHelper.NonQueryAsyncTyped(
            TestContainerHelper.ConnectionString,
            "Clases",
            claseActiva);

        var estadoClase = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idEstadoClaseProgramada FROM estadosClasesProgramadas");
        var fkEstadoClaseProgramada = Convert.ToInt32(estadoClase?["idEstadoClaseProgramada"] ?? 1);

        var horaLaboral = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales");
        var fkHoraLaboral = Convert.ToInt32(horaLaboral?["idHora"] ?? 1);

        // Register first
        var requestDto = new DTODatosClaseProgramada
        {
            fkClase = savedClase.ClaseId,
            fkEntrenador = Guid.Parse(entrenadorId).ToString(),
            cupoMaximo = 20,
            fkEstadoClaseProgramada = fkEstadoClaseProgramada,
            fechaDeLaClase = DateOnly.FromDateTime(DateTime.Now.AddDays(7)),
            idUsuarioQueReserva = clienteId,
            fkHoraLaboral = fkHoraLaboral
        };

        var registerResponse = await Client.PostAsJsonAsync("/api/Clases/registrarClaseProgramada", requestDto);
        var registerResult = await registerResponse.Content.ReadFromJsonAsync<DTOResponse<int?>>();
        var idProgramacionClase = registerResult!.payload!.Value;

        // Create cancel request WITHOUT reschedule
        var requestList = new List<DTOClaseCancelada>
        {
            DTOClaseCanceladaFactory.Crear(
                idProgramacionClase: idProgramacionClase,
                fkClase: savedClase.ClaseId,
                fkEntrenador: Guid.Parse(entrenadorId).ToString(),
                cupoMaximo: 20,
                fkEstadoClaseProgramada: fkEstadoClaseProgramada,
                fechaDeLaClase: DateOnly.FromDateTime(DateTime.Now.AddDays(7)),
                idUsuarioQueReserva: clienteId,
                fkHoraLaboral: fkHoraLaboral,
                idPreservaDeHorario: 0,
                claseReagendada: null
            )
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/cancelarClasesProgramadas", requestList);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<string>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Contain("Sin petición de reagendación");
    }

    #endregion
}
