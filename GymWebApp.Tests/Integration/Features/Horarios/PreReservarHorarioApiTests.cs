using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Horarios;

[Collection("PreReservarHorarioApiIntegrationTests")]
public class PreReservarHorarioApiTests : IntegrationTestBase<CitasApiWebApplicationFactory<Program>>
{
    public PreReservarHorarioApiTests(CitasApiWebApplicationFactory<Program> factory) : base(factory) { }

    #region Happy Paths (Integration)

    /// <summary>
    /// REQUISITO: Usuario autenticado crea pre-reserva de horario con datos mínimos
    /// Escenario: Usuario autenticado crea pre-reserva sin idClase ni idEntrenador
    /// GIVEN: Hay al menos un idHoraLaboral válido en horasLaborales
    /// AND el usuario está autenticado con token JWT válido
    /// WHEN: POST /api/horarios/preReservarHorario con datos válidos
    /// THEN: Returns 200 OK con success=true
    /// AND payload contiene int > 0 (id de pre-reserva creada)
    /// AND el registro existe en preReservasDeHorario
    /// </summary>
    [Fact]
    public async Task PreReservarHorario_WithValidDataAndAuthenticatedUser_CreatesPreReservation()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        await SetAuthHeaderAsync();

        // Get valid idHoraLaboral from database
        var horaResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales",
            new());
        
        var idHoraLaboral = Convert.ToInt32(horaResult["idHora"]);

        var preReserva = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "test-user-id",
            fechaTentativa = DateOnly.FromDateTime(DateTime.Now.AddDays(1)),
            idHoraLaboral = idHoraLaboral,
            idClase = null,
            idEntrenador = ""
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().BeGreaterThan(0, "Pre-reservation ID must be greater than 0");
    }

    /// <summary>
    /// REQUISITO: Usuario autenticado crea pre-reserva con idClase
    /// Escenario: Usuario autenticado crea pre-reserva especificando una clase
    /// GIVEN: Hay al menos un idHoraLaboral válido en horasLaborales
    /// AND existe al menos una Clase en la base de datos
    /// AND el usuario está autenticado con token JWT válido
    /// WHEN: POST /api/horarios/preReservarHorario con idClase válido
    /// THEN: Returns 200 OK con success=true
    /// AND payload contiene int > 0
    /// </summary>
    [Fact]
    public async Task PreReservarHorario_WithIdClaseAndAuthenticatedUser_CreatesPreReservationWithClass()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        await SetAuthHeaderAsync();

        // Get valid idHoraLaboral
        var horaResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales",
            new());
        var idHoraLaboral = Convert.ToInt32(horaResult["idHora"]);

        // Get valid idClase
        var claseResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ClaseID FROM Clases",
            new());
        var idClase = Convert.ToInt32(claseResult["ClaseID"]);

        var preReserva = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "test-user-id",
            fechaTentativa = DateOnly.FromDateTime(DateTime.Now.AddDays(1)),
            idHoraLaboral = idHoraLaboral,
            idClase = idClase,
            idEntrenador = ""
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().BeGreaterThan(0);
        
    }

    /// <summary>
    /// REQUISITO: Usuario autenticado crea pre-reserva con idEntrenador
    /// Escenario: Usuario autenticado crea pre-reserva especificando un entrenador
    /// GIVEN: Hay al menos un idHoraLaboral válido en horasLaborales
    /// AND existe al menos un entrenador (usuario con rol empleado) en AspNetUsers
    /// AND el usuario está autenticado con token JWT válido
    /// WHEN: POST /api/horarios/preReservarHorario con idEntrenador válido
    /// THEN: Returns 200 OK con success=true
    /// AND payload contiene int > 0
    /// </summary>
    [Fact]
    public async Task PreReservarHorario_WithIdEntrenadorAndAuthenticatedUser_CreatesPreReservationWithTrainer()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        await SetAuthHeaderAsync();

        // Get valid idHoraLaboral
        var horaResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales",
            new());
        var idHoraLaboral = Convert.ToInt32(horaResult["idHora"]);

        // Get valid idEntrenador (user with empleado role)
        var trainerResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 u.Id FROM AspNetUsers u 
              INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId 
              INNER JOIN AspNetRoles r ON ur.RoleId = r.Id 
              WHERE r.Name = 'empleado'",
            new());
        var idEntrenador = trainerResult["Id"]!.ToString()!;

        var preReserva = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "test-user-id",
            fechaTentativa = DateOnly.FromDateTime(DateTime.Now.AddDays(1)),
            idHoraLaboral = idHoraLaboral,
            idClase = null,
            idEntrenador = idEntrenador
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().BeGreaterThan(0);
        
        
    }

    /// <summary>
    /// REQUISITO: Usuario autenticado crea pre-reserva con todos los datos
    /// Escenario: Usuario autenticado crea pre-reserva con idClase e idEntrenador
    /// GIVEN: Hay datos válidos en horasLaborales, Clases, y AspNetUsers (empleado)
    /// AND el usuario está autenticado con token JWT válido
    /// WHEN: POST /api/horarios/preReservarHorario con todos los campos llenos
    /// THEN: Returns 200 OK con success=true
    /// AND payload contiene int > 0
    /// </summary>
    [Fact]
    public async Task PreReservarHorario_WithCompleteDataAndAuthenticatedUser_CreatesFullPreReservation()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        await SetAuthHeaderAsync();

        // Get valid idHoraLaboral
        var horaResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales",
            new());
        var idHoraLaboral = Convert.ToInt32(horaResult["idHora"]);

        // Get valid idClase
        var claseResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ClaseID FROM Clases",
            new());
        var idClase = Convert.ToInt32(claseResult["ClaseID"]);

        // Get valid idEntrenador
        var trainerResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 u.Id FROM AspNetUsers u 
              INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId 
              INNER JOIN AspNetRoles r ON ur.RoleId = r.Id 
              WHERE r.Name = 'empleado'",
            new());
        var idEntrenador = trainerResult["Id"]!.ToString()!;

        var preReserva = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "test-user-id",
            fechaTentativa = DateOnly.FromDateTime(DateTime.Now.AddDays(1)),
            idHoraLaboral = idHoraLaboral,
            idClase = idClase,
            idEntrenador = idEntrenador
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().BeGreaterThan(0);
        
        
    }

    #endregion

    #region Sad Paths (Integration)

    /// <summary>
    /// REQUISITO: Solicitud sin autenticación retorna 401
    /// Escenario: Solicitud sin token de autenticación
    /// GIVEN: No se proporciona token de autenticación
    /// WHEN: POST /api/horarios/preReservarHorario
    /// THEN: Returns 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task PreReservarHorario_WithoutAuthentication_Returns401()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        ClearAuthHeader();

        var preReserva = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "any-user-id",
            fechaTentativa = DateOnly.FromDateTime(DateTime.Now.AddDays(1)),
            idHoraLaboral = 1,
            idClase = null,
            idEntrenador = ""
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}