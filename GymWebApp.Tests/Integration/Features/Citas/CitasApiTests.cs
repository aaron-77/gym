using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using CitaRequest = DTO.Dtos.Cita;

namespace GymWebApp.Tests.Integration;

[Collection("CitaApiIntegrationTests")]
public class CitasApiTests : IClassFixture<CitasApiWebApplicationFactory<Program>>
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;
    private string? _authToken;

    public CitasApiTests(CitasApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        InitializeAsync().GetAwaiter().GetResult();
    }

    private async Task InitializeAsync()
    {
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        _authToken = await _factory.AuthenticateAsync(_client);
    }

    private void SetAuthHeader()
    {
        if (string.IsNullOrEmpty(_authToken))
            throw new InvalidOperationException("Auth token not available");
        
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _authToken);
    }

    #region Happy Paths (Integration)

    [Fact]
    public async Task RegistrarCita_WithValidData_ReturnsOk()
    {
        await TestContainerHelper.ResetDatabaseAsync();
        
        SetAuthHeader();
        
        var (clienteId, entrenadorId) = await GetExistingUserIdsAsync();

        var cita = new CitaRequest
        {
            fechaInicioCita = DateTime.Now.AddDays(1).Date.AddHours(10),
            fechaFinCita = DateTime.Now.AddDays(1).Date.AddHours(11),
            fkCliente = clienteId,
            fkEntrenador = entrenadorId,
            tipoCita = "entrenamiento personal",
            estado = "Agendada"
        };

        var response = await _client.PostAsJsonAsync("/api/RegistrarCita", cita);

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
        await TestContainerHelper.ResetDatabaseAsync();
        
        SetAuthHeader();

        var (clienteId, trainerId) = await GetExistingUserIdsAsync();
        
        var fechaInicioNueva = DateTime.Now.AddDays(1).Date.AddHours(10);
        var fechaFinNueva = DateTime.Now.AddDays(1).Date.AddHours(11);
        
        var citaNueva = new CitaRequest
        {
            fechaInicioCita = fechaInicioNueva,
            fechaFinCita = fechaFinNueva,
            fkCliente = clienteId,
            fkEntrenador = trainerId,
            tipoCita = "Entrenamiento Personal",
            estado = "Agendada"
        };

        var crearResponse = await _client.PostAsJsonAsync("/api/RegistrarCita", citaNueva);
        crearResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var citaCreada = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 CitaID FROM Citas 
              WHERE UserId = @UserId AND EntrenadorId = @EntrenadorId 
              ORDER BY CitaID DESC",
            new() { 
                ["@UserId"] = clienteId, 
                ["@EntrenadorId"] = trainerId 
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
            fkEntrenador = trainerId,
            estado = nuevoEstado
        };

        var response = await _client.PutAsJsonAsync("/api/RegistrarCita", citaEdit);

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
        citaActualizada["EntrenadorId"]!.ToString().Should().Be(trainerId);
        citaActualizada["Estado"]!.ToString().Should().Be(nuevoEstado);
    }

    [Fact]
    public async Task RegistrarDuracion_WithValidData_ReturnsOk()
    {
        await TestContainerHelper.ResetDatabaseAsync();
        
        SetAuthHeader();

        var duracion = new DuracionCitasMedicion
        {
            duracion = 60,
            frecuenciaNotificaciones = 30
        };

        var response = await _client.PostAsJsonAsync("/api/registrarDuracion", duracion);

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
        await TestContainerHelper.ResetDatabaseAsync();
        
        SetAuthHeader();

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
        var updateResponse = await _client.PostAsJsonAsync("/api/registrarDuracion", duracionUpdate);

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
        await TestContainerHelper.ResetDatabaseAsync();
        
        SetAuthHeader();

        var response = await _client.GetAsync("/api/getDuracionCita");

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
        await TestContainerHelper.ResetDatabaseAsync();
        
        SetAuthHeader();
        
        var (clienteId, _) = await GetExistingUserIdsAsync();

        var response = await _client.GetAsync($"/api/getCitasAgendadas?idUsuario={clienteId}");

        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<Cita>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Be("consulta exitosa");
    }

    #endregion

    #region Helper Methods

    private async Task<(string clienteId, string entrenadorId)> GetExistingUserIdsAsync()
    {
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'rebeca@gmail.com'");

        var entrenador = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'uno@gmail.com'");

        if (cliente == null || entrenador == null)
            throw new Exception("Error: No se encontraron los usuarios de prueba en el backup.");

        return (cliente["Id"]!.ToString()!, entrenador["Id"]!.ToString()!);
    }

    #endregion
}
