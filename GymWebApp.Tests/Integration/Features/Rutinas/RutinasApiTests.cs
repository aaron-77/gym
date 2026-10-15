using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
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
        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);
        var entrenadorId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.EmpleadoEmail);

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
        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);

        // First create a routine
        var entrenadorId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.EmpleadoEmail);
        var rutinaRequest = RutinaFactory.CrearRutinaValida(
            usuarioId: clienteId,
            entrenadorId: entrenadorId);

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
        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);

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
        var clienteId = await UserHelper.GetUserIdByEmailAsync(
            TestContainerHelper.ConnectionString,
            TestUsersOptions.ClienteRebecaEmail);

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
}
