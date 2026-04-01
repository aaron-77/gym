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

[Collection("InscribirAClaseApiIntegrationTests")]
public class InscribirAClaseApiTests : IClassFixture<ClasesApiWebApplicationFactory<Program>>
{
    private readonly ClasesApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public InscribirAClaseApiTests(ClasesApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        TestContainerHelper.InitializeAsync().GetAwaiter().GetResult();
        TestContainerHelper.ResetDatabaseAsync().GetAwaiter().GetResult();
    }

    #region Happy Path Tests

    [Fact]
    public async Task InscribirAClase_WithValidData_RegistersInscription_ReturnsOk()
    {
        // Arrange
        var token = await _factory.AuthenticateAsync(_client);
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing client from seed data (rebeca@gmail.com)
        var (clienteId, _) = await GetExistingUserIdsAsync();

        // Get existing EstadoClaseProgramada (activa = 1 typically)
        var estadoClaseProgramada = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idEstadoClaseProgramada FROM estadosClasesProgramadas");

        var fkEstadoClaseProgramada = Convert.ToInt32(estadoClaseProgramada?["idEstadoClaseProgramada"] ?? 1);

        // Get existing Clase from seed data
        var clase = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 claseId FROM Clases WHERE fkEstadoClase = 1");

        var fkClase = Convert.ToInt32(clase?["claseId"] ?? 1);

        // Get existing Entrenador (empleado)
        var entrenador = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'uno@gmail.com'");

        var fkEntrenador = entrenador?["Id"]?.ToString() ?? throw new Exception("Entrenador not found");

        // Create clase programada with cupoMaximo > 0
        var fechaClase = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        var idClaseProgramada = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador) 
              VALUES (@FkClase, @cupoMaximo, @FkEstadoClaseProgramada, @FechaDeLaClase, @FkEntrenador);
              SELECT SCOPE_IDENTITY();",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = fkClase,
                ["@cupoMaximo"] = 20,
                ["@FkEstadoClaseProgramada"] = fkEstadoClaseProgramada,
                ["@FechaDeLaClase"] = fechaClase,
                ["@FkEntrenador"] = fkEntrenador
            });

        idClaseProgramada.Should().BeGreaterThan(0, "La clase programada debe tener un ID válido");

        // Get count of inscriptions before
        var countBefore = await InscripcionClaseHelper.ObtenerConteoInscripcionesAsync(
            TestContainerHelper.ConnectionString);

        var requestDto = new DTOInscripcionAClase
        {
            IdProgramacionClase = idClaseProgramada,
            IdCliente = clienteId
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/Clases/inscribirAClase", requestDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        
        // Note: The stored procedure doesn't return the inserted ID, so we check success=true
        // The payload value is from ExecuteSqlInterpolatedAsync which returns rows affected (usually >= 0)
        // We verify the DB was actually updated in the next assertion

        // Verify DB: Check inscription was created
        var countAfter = await InscripcionClaseHelper.ObtenerConteoInscripcionesAsync(
            TestContainerHelper.ConnectionString);

        countAfter.Should().BeGreaterThan(countBefore, "Debe existir un nuevo registro de inscripción");
    }

    #endregion

    #region Sad Path Tests

    [Fact]
    public async Task InscribirAClase_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        _client.DefaultRequestHeaders.Authorization = null;

        var requestDto = new DTOInscripcionAClase
        {
            IdProgramacionClase = 1,
            IdCliente = "test-client-id"
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/Clases/inscribirAClase", requestDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task InscribirAClase_WithNoAvailableSpots_ReturnsBadRequest()
    {
        // Arrange
        var token = await _factory.AuthenticateAsync(_client);
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing client from seed data (rebeca@gmail.com)
        var (clienteId, _) = await GetExistingUserIdsAsync();

        // Get existing EstadoClaseProgramada (activa = 1 typically)
        var estadoClaseProgramada = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idEstadoClaseProgramada FROM estadosClasesProgramadas");

        var fkEstadoClaseProgramada = Convert.ToInt32(estadoClaseProgramada?["idEstadoClaseProgramada"] ?? 1);

        // Get existing Clase from seed data
        var clase = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 claseId FROM Clases WHERE fkEstadoClase = 1");

        var fkClase = Convert.ToInt32(clase?["claseId"] ?? 1);

        // Get existing Entrenador (empleado)
        var entrenador = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'uno@gmail.com'");

        var fkEntrenador = entrenador?["Id"]?.ToString() ?? throw new Exception("Entrenador not found");

        // Create clase programada with cupoMaximo = 0
        var fechaClase = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        var idClaseProgramada = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador) 
              VALUES (@FkClase, @cupoMaximo, @FkEstadoClaseProgramada, @FechaDeLaClase, @FkEntrenador);
              SELECT SCOPE_IDENTITY();",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = fkClase,
                ["@cupoMaximo"] = 0,
                ["@FkEstadoClaseProgramada"] = fkEstadoClaseProgramada,
                ["@FechaDeLaClase"] = fechaClase,
                ["@FkEntrenador"] = fkEntrenador
            });

        var requestDto = new DTOInscripcionAClase
        {
            IdProgramacionClase = idClaseProgramada,
            IdCliente = clienteId
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/Clases/inscribirAClase", requestDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.message.Should().Contain("No hay cupo disponible");
    }

    [Fact]
    public async Task InscribirAClase_WithNonExistentClassProgram_ReturnsError()
    {
        // Arrange
        var token = await _factory.AuthenticateAsync(_client);
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing client from seed data (rebeca@gmail.com)
        var (clienteId, _) = await GetExistingUserIdsAsync();

        var requestDto = new DTOInscripcionAClase
        {
            IdProgramacionClase = 99999,
            IdCliente = clienteId
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/Clases/inscribirAClase", requestDto);

        // Assert
        // The stored procedure might return 0 (no inscription) or 500 depending on implementation
        // Based on the controller, if the SP fails or returns 0, we should get an error
        response.StatusCode.Should().BeOneOf(HttpStatusCode.InternalServerError, HttpStatusCode.BadRequest);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
    }

    [Fact]
    public async Task InscribirAClase_WithNonExistentClient_ReturnsError()
    {
        // Arrange
        var token = await _factory.AuthenticateAsync(_client);
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get EstadoClaseProgramada for creating a valid class
        var estadoClaseProgramada = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idEstadoClaseProgramada FROM estadosClasesProgramadas");

        var fkEstadoClaseProgramada = Convert.ToInt32(estadoClaseProgramada?["idEstadoClaseProgramada"] ?? 1);

        // Get existing Clase from seed data
        var clase = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 claseId FROM Clases WHERE fkEstadoClase = 1");

        var fkClase = Convert.ToInt32(clase?["claseId"] ?? 1);

        // Get existing Entrenador (empleado)
        var entrenador = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'uno@gmail.com'");

        var fkEntrenador = entrenador?["Id"]?.ToString() ?? throw new Exception("Entrenador not found");

        // Create clase programada
        var fechaClase = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        var idClaseProgramada = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador) 
              VALUES (@FkClase, @cupoMaximo, @FkEstadoClaseProgramada, @FechaDeLaClase, @FkEntrenador);
              SELECT SCOPE_IDENTITY();",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = fkClase,
                ["@cupoMaximo"] = 20,
                ["@FkEstadoClaseProgramada"] = fkEstadoClaseProgramada,
                ["@FechaDeLaClase"] = fechaClase,
                ["@FkEntrenador"] = fkEntrenador
            });

        // Use non-existent client ID (GUID format)
        var nonExistentClientId = Guid.NewGuid().ToString();

        var requestDto = new DTOInscripcionAClase
        {
            IdProgramacionClase = idClaseProgramada,
            IdCliente = nonExistentClientId
        };

        // Act
        var response = await _client.PostAsJsonAsync("/api/Clases/inscribirAClase", requestDto);

        // Assert
        // The stored procedure should fail because client doesn't exist
        response.StatusCode.Should().BeOneOf(HttpStatusCode.InternalServerError, HttpStatusCode.BadRequest);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
    }

    #endregion

    #region Helper Methods

    private async Task<(string clienteId, string empleadoId)> GetExistingUserIdsAsync()
    {
        // Get cliente user (rebeca@gmail.com from seed data)
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'rebeca@gmail.com'");

        // Get empleado user (uno@gmail.com from seed data - has empleado role)
        var empleado = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'uno@gmail.com'");

        if (cliente == null || empleado == null)
            throw new Exception("Error: No se encontraron los usuarios de prueba en el backup.");

        return (cliente["Id"]!.ToString()!, empleado["Id"]!.ToString()!);
    }

    #endregion
}