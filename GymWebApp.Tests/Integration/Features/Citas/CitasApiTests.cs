using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using DTO.Dtos;
using FluentAssertions;
using CitaRequest = DTO.Dtos.Cita;

namespace GymWebApp.Tests.Integration;

[Collection("IntegrationTests")]
public class CitasApiTests : IntegrationTestBase
{
    public CitasApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper) { }

    public override async Task InitializeAsync()
    {
        await base.InitializeAsync();
        await SetAuthHeaderAsync();
    }

    #region Happy Paths (Integration)

    [Fact]
    public async Task RegistrarCita_WithValidData_ReturnsOk()
    {
        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);
        var entrenadorId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.EmpleadoEmail);

        var cita = new CitaRequest
        {
            fechaInicioCita = DateTime.Now.AddDays(1).Date.AddHours(10),
            fechaFinCita = DateTime.Now.AddDays(1).Date.AddHours(11),
            fkCliente = clienteId,
            fkEntrenador = entrenadorId,
            tipoCita = "entrenamiento personal",
            estado = "Agendada"
        };

        var response = await Client.PostAsJsonAsync("/api/RegistrarCita", cita);

        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<CitaRequest>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Be("Registro exitoso");

        var count = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            "SELECT COUNT(*) FROM Citas WHERE UserId = @UserId AND EntrenadorId = @EntrenadorId",
            new() { 
                ["@UserId"] = clienteId,
                ["@EntrenadorId"] = entrenadorId
            });
        
        count.Should().Be(1);
    }

    [Fact]
    public async Task ModificarCita_WithValidData_ReturnsOk()
    {
        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);
        var entrenadorId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.EmpleadoEmail);
        
        var fechaInicioNueva = DateTime.Now.AddDays(1).Date.AddHours(10);
        var fechaFinNueva = DateTime.Now.AddDays(1).Date.AddHours(11);
        
        var citaNueva = new CitaRequest
        {
            fechaInicioCita = fechaInicioNueva,
            fechaFinCita = fechaFinNueva,
            fkCliente = clienteId,
            fkEntrenador = entrenadorId,
            tipoCita = "Entrenamiento Personal",
            estado = "Agendada"
        };

        var crearResponse = await Client.PostAsJsonAsync("/api/RegistrarCita", citaNueva);
        crearResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var citaCreada = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 CitaID FROM Citas 
              WHERE UserId = @UserId AND EntrenadorId = @EntrenadorId 
              ORDER BY CitaID DESC",
            new() { 
                ["@UserId"] = clienteId, 
                ["@EntrenadorId"] = entrenadorId 
            });
        
        var citaId = Convert.ToInt32(citaCreada!["CitaID"]);

        var nuevaFechaInicio = DateTime.Now.AddDays(2).Date.AddHours(14);
        var nuevaFechaFin = DateTime.Now.AddDays(2).Date.AddHours(15);
        var nuevoEstado = "Completada";

        var citaEdit = new CitaEdit
        {
            Id = citaId,
            fechaInicioCita = nuevaFechaInicio,
            fechaFinCita = nuevaFechaFin,
            fkEntrenador = entrenadorId,
            estado = nuevoEstado
        };

        var response = await Client.PutAsJsonAsync("/api/RegistrarCita", citaEdit);

        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<CitaEdit>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Be("Modificacion exitosa");

        var citaActualizada = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT * FROM Citas WHERE CitaID = @CitaID",
            new() { ["@CitaID"] = citaId });

        ((DateTime)citaActualizada!["FechaHora"]).Should().Be(nuevaFechaInicio);
        ((DateTime)citaActualizada["FechaHoraFin"]).Should().Be(nuevaFechaFin);
        citaActualizada["EntrenadorId"]!.ToString().Should().Be(entrenadorId);
        citaActualizada["Estado"]!.ToString().Should().Be(nuevoEstado);
    }

    [Fact]
    public async Task RegistrarDuracion_WithValidData_ReturnsOk()
    {
        var duracion = new DuracionCitasMedicion
        {
            duracion = 60,
            frecuenciaNotificaciones = 30
        };

        var response = await Client.PostAsJsonAsync("/api/registrarDuracion", duracion);

        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<DuracionCitasMedicion>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Be("Registro exitoso");

        var count = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            "SELECT COUNT(*) FROM DuracionCitas WHERE Duracion = @Duracion AND FrecuenciaNotificaciones = @Frec",
            new() { 
                ["@Duracion"] = 60,
                ["@Frec"] = 30
            });
        
        count.Should().Be(1);
    }

    [Fact]
    public async Task RegistrarDuracion_UpdateExisting_ReturnsOk()
    {
        // Paso 1: Obtener la duración existente de la BD
        var existing = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 DuracionId, Duracion, FrecuenciaNotificaciones FROM DuracionCitas");

        var duracionId = Convert.ToInt32(existing!["DuracionId"]);
        var duracionOriginal = Convert.ToInt32(existing["Duracion"]);
        var frecuenciaOriginal = Convert.ToInt32(existing["FrecuenciaNotificaciones"]);

        // Paso 2: Calcular nuevo valor basado en la duración existente
        var nuevaDuracion = duracionOriginal * 2;
        var nuevaFrecuencia = frecuenciaOriginal * 5;

        var duracionUpdate = new DuracionCitasMedicion
        {
            Id = duracionId,
            duracion = nuevaDuracion,
            frecuenciaNotificaciones = nuevaFrecuencia
        };

        // Paso 3: Ejecutar actualización
        var updateResponse = await Client.PostAsJsonAsync("/api/registrarDuracion", duracionUpdate);

        updateResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await updateResponse.Content.ReadFromJsonAsync<DTOResponse<DuracionCitasMedicion>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();

        // Paso 4: Verificar que los datos se hayan modificado correctamente
        var updated = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT * FROM DuracionCitas WHERE DuracionId = @Id",
            new() { ["@Id"] = duracionId });

        ((int)updated!["Duracion"]).Should().Be(nuevaDuracion);
        ((int)updated["FrecuenciaNotificaciones"]).Should().Be(nuevaFrecuencia);
    }

    [Fact]
    public async Task GetDuracionCita_WithAuthenticatedUser_ReturnsOk()
    {
        var response = await Client.GetAsync("/api/getDuracionCita");

        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Be("consulta exitosa");
        result.payload.Should().BeGreaterThan(0);

        var duracionDb = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Duracion FROM duracionCitas");
        
        result.payload.Should().Be(duracionDb);
    }

    [Fact]
    public async Task GetCitasAgendadas_WithAuth_ReturnsOk()
    {
        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);

        var response = await Client.GetAsync($"/api/getCitasAgendadas?idUsuario={clienteId}");

        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<Cita>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Be("consulta exitosa");
    }

    #endregion
}
