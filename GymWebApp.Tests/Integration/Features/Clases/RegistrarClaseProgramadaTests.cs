using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Factories;
using GymWebApp.Tests.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("IntegrationTests")]
public class RegistrarClaseProgramadaTests : IntegrationTestBase
{
    public RegistrarClaseProgramadaTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    #region Happy Path Tests

    [Fact]
    public async Task RegistrarRClaseProgramada_WithValidData_ReturnsOk()
    {
        // Arrange
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing users from seed data
        var (clienteId, entrenadorId) = await GetExistingUserIdsAsync();

        // Create a clase activa using factory and insert to database
        var claseActiva = ClaseFactory.CrearClaseActiva();
        var savedClase = await DatabaseHelper.NonQueryAsyncTyped(
            TestContainerHelper.ConnectionString,
            "Clases",
            claseActiva);

        // Get existing fkEstadoClaseProgramada from seed data
        var estadoClase = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idEstadoClaseProgramada FROM estadosClasesProgramadas");

        var fkEstadoClaseProgramada = Convert.ToInt32(estadoClase?["idEstadoClaseProgramada"] ?? 1);

        // Get existing fkHoraLaboral from seed data
        var horaLaboral = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales");

        var fkHoraLaboral = Convert.ToInt32(horaLaboral?["idHora"] ?? 1);

        // Create request DTO
        var requestDto = new DTODatosClaseProgramada
        {
            fkClase = savedClase.ClaseId,
            fkEntrenador = entrenadorId,
            cupoMaximo = 20,
            fkEstadoClaseProgramada = fkEstadoClaseProgramada,
            fechaDeLaClase = DateOnly.FromDateTime(DateTime.Now.AddDays(7)),
            idUsuarioQueReserva = clienteId,
            fkHoraLaboral = fkHoraLaboral
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/registrarClaseProgramada", requestDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int?>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Contain("Clase programada registrada correctamente");
        result.payload.Should().BeGreaterThan(0);

        // Verificar que el registro existe en la BD con el ID retornado
        var registroEncontrado = await DatabaseHelper.ExecuteQueryAsync(
            TestContainerHelper.ConnectionString,
            "SELECT IdProgramacionClase, fkClase, fkEntrenador FROM ClasesProgramadas WHERE IdProgramacionClase = @Id",
            new() { ["@Id"] = result.payload });

        registroEncontrado.Count().Should().BeGreaterThan(0, 
            $"El registro con ID {result.payload} debería existir en la BD");
    }

    #endregion

    #region Sad Path Tests

    [Fact]
    public async Task RegistrarClaseProgramada_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange
        Client.DefaultRequestHeaders.Authorization = null;

        var requestDto = new DTODatosClaseProgramada
        {
            fkClase = 1,
            fkEntrenador = Guid.NewGuid().ToString(),
            cupoMaximo = 20,
            fkEstadoClaseProgramada = 1,
            fechaDeLaClase = DateOnly.FromDateTime(DateTime.Now.AddDays(7)),
            idUsuarioQueReserva = Guid.NewGuid().ToString(),
            fkHoraLaboral = 1
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/registrarClaseProgramada", requestDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion

    #region Helper Methods

    private async Task<(string clienteId, string entrenadorId)> GetExistingUserIdsAsync()
    {
        // Get cliente user (rebeca@gmail.com from seed data)
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'rebeca@gmail.com'");

        // Get empleado user (uno@gmail.com from seed data - has empleado role)
        var entrenador = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'uno@gmail.com'");

        if (cliente == null || entrenador == null)
            throw new Exception("Error: No se encontraron los usuarios de prueba en el backup.");

        return (cliente["Id"]!.ToString()!, entrenador["Id"]!.ToString()!);
    }

    #endregion
}
