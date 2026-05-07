using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Factories;
using GymWebApp.Tests.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Rutinas;

[Collection("IntegrationTests")]
public class RutinasApiTests : IntegrationTestBase
{
    public RutinasApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    #region Happy Path Tests

    [Fact]
    public async Task RegistrarRutina_WithValidData_ReturnsOk()
    {
        // Arrange
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing users from seed data
        var (clienteId, entrenadorId) = await GetExistingUserIdsAsync();

        // Create request DTO
        var requestDto = RutinaFactory.CrearRutinaValida(
            usuarioId: clienteId,
            entrenadorId: entrenadorId);

        // Act
        var response = await Client.PostAsJsonAsync("/api/registrarRutina", requestDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<HttpResponseRutina>();
        result.Should().NotBeNull();
        result!.ok.Should().BeTrue();
        result.message.Should().Contain("Registro exitoso");
        result.data.Should().NotBeNull();
    }

    [Fact]
    public async Task AsignarEjercicio_WithValidData_ReturnsOk()
    {
        // Arrange
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing user IDs
        var (clienteId, _) = await GetExistingUserIdsAsync();

        // First create a routine
        var (_, trainerId) = await GetExistingUserIdsAsync();
        var rutinaRequest = RutinaFactory.CrearRutinaValida(
            usuarioId: clienteId,
            entrenadorId: trainerId);

        var rutinaResponse = await Client.PostAsJsonAsync("/api/registrarRutina", rutinaRequest);
        rutinaResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var rutinaResult = await rutinaResponse.Content.ReadFromJsonAsync<HttpResponseRutina>();
        var rutinaId = rutinaResult?.data?.RutinaId ?? 1;

        // Get existing exercise from seed data
        var ejercicio = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ejercicioId FROM ejercicios");

        var ejercicioId = Convert.ToInt32(ejercicio?["ejercicioId"] ?? 1);

        // Create assignment DTO
        var asignacionDto = RutinaFactory.CrearAsignacionValida(
            usuarioId: clienteId,
            rutinaId: rutinaId,
            ejercicioId: ejercicioId);

        // Act
        var response = await Client.PostAsJsonAsync("/api/asignarEjercicio", asignacionDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<AsignacionDeEjercicio>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.message.Should().Contain("Registro exitoso");
    }

    [Fact]
    public async Task ConsultarRutinas_WithEmpleadoAuth_ReturnsOk()
    {
        // Arrange
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing user ID
        var (clienteId, _) = await GetExistingUserIdsAsync();

        // Act
        var response = await Client.GetAsync($"/api/consultarRutinas?UsuarioID={clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<Rutina>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
    }

    [Fact]
    public async Task ConsultarRutinas_WithClienteAuth_ReturnsForbidden()
    {
        // Arrange
        var token = await Factory.AuthenticateAsClienteAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente ID
        var (clienteId, _) = await GetExistingUserIdsAsync();

        // Act
        var response = await Client.GetAsync($"/api/consultarRutinas?UsuarioID={clienteId}");

        // Assert - The controller only allows "empleado" role, so cliente gets 403
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    #endregion

    #region Sad Path Tests

    [Fact]
    public async Task RegistrarRutina_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange
        Client.DefaultRequestHeaders.Authorization = null;

        var requestDto = RutinaFactory.CrearRutinaValida();

        // Act
        var response = await Client.PostAsJsonAsync("/api/registrarRutina", requestDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task AsignarEjercicio_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange
        Client.DefaultRequestHeaders.Authorization = null;

        var asignacionDto = RutinaFactory.CrearAsignacionValida();

        // Act
        var response = await Client.PostAsJsonAsync("/api/asignarEjercicio", asignacionDto);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task ConsultarRutinas_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange
        Client.DefaultRequestHeaders.Authorization = null;

        // Act
        var response = await Client.GetAsync("/api/consultarRutinas?UsuarioID=test");

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