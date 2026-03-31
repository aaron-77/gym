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

[Collection("ReagendarInscripcionAClaseApiIntegrationTests")]
public class ReagendarInscripcionAClaseApiTests : IClassFixture<ClasesApiWebApplicationFactory<Program>>
{
    private readonly ClasesApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public ReagendarInscripcionAClaseApiTests(ClasesApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        TestContainerHelper.InitializeAsync().GetAwaiter().GetResult();
        TestContainerHelper.ResetDatabaseAsync().GetAwaiter().GetResult();
    }

    #region Happy Path Tests

    [Fact]
    public async Task ReagendarInscripcionAClase_WithValidData_ReturnsOk()
    {
        // Arrange
        var token = await _factory.AuthenticateAsync(_client);
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing users from seed data
        var (clienteId, _) = await GetExistingUserIdsAsync();

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

        // Get existing Clase from seed data
        var clase = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 claseId FROM Clases WHERE fkEstadoClase = 1");

        var fkClase = Convert.ToInt32(clase?["claseId"] ?? 1);

        // Get existing HoraLaboral
        var horaLaboral = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales");

        var fkHoraLaboral = Convert.ToInt32(horaLaboral?["idHora"] ?? 1);

        // Get existing Entrenador (empleado)
        var entrenador = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'uno@gmail.com'");

        var fkEntrenador = entrenador?["Id"]?.ToString() ?? throw new Exception("Entrenador not found");

        // Create first clase programada (old class) - Using SCOPE_IDENTITY() to get the ID
        var fechaClaseAnterior = DateOnly.FromDateTime(DateTime.Now.AddDays(7));
        var idClaseProgramadaAnterior = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador) 
              VALUES (@FkClase, @CupoMaximo, @FkEstadoClaseProgramada, @FechaDeLaClase, @FkEntrenador);
              SELECT SCOPE_IDENTITY();",
            new()
            {
                ["@FkClase"] = fkClase,
                ["@CupoMaximo"] = 20,
                ["@FkEstadoClaseProgramada"] = fkEstadoClaseProgramada,
                ["@FechaDeLaClase"] = fechaClaseAnterior,
                ["@FkEntrenador"] = fkEntrenador
            });

        var inscripcion = InscripcionClaseFactory.Crear(
            fkProgramacionClase: idClaseProgramadaAnterior,
            fkCliente: clienteId,
            fkEstadoInscripcion: fkEstadoInscripcionActiva);

        var idInscripcionCancelada = await InscripcionClaseHelper.InsertarInscripcionAsync(
            TestContainerHelper.ConnectionString,
            inscripcion);

        // Create second clase programada (new class) - Using SCOPE_IDENTITY() to get the ID
        var fechaClaseNueva = DateOnly.FromDateTime(DateTime.Now.AddDays(14));
        var idClaseProgramadaNueva = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador) 
              VALUES (@FkClase, @CupoMaximo, @FkEstadoClaseProgramada, @FechaDeLaClase, @FkEntrenador);
              SELECT SCOPE_IDENTITY();",
            new()
            {
                ["@FkClase"] = fkClase,
                ["@CupoMaximo"] = 20,
                ["@FkEstadoClaseProgramada"] = fkEstadoClaseProgramada,
                ["@FechaDeLaClase"] = fechaClaseNueva,
                ["@FkEntrenador"] = fkEntrenador
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
        var response = await _client.PostAsJsonAsync("/api/Clases/reagendacionDeInscripcionAClase", requestDto);

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
        await TestContainerHelper.ResetDatabaseAsync();
        _client.DefaultRequestHeaders.Authorization = null;

        var requestDto = ReagendacionInscripcionFactory.Crear();

        // Act
        var response = await _client.PostAsJsonAsync("/api/Clases/reagendacionDeInscripcionAClase", requestDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
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
