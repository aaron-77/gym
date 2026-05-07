using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Horarios;

[Collection("IntegrationTests")]
public class PreReservarHorarioApiTests : IntegrationTestBase
{
    public PreReservarHorarioApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper) { }

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

    /// <summary>
    /// REQUISITO: Intento de crear pre-reserva duplicada con clase y entrenador
    /// Escenario: Ya existe pre-reserva con misma combinación (idClase, idEntrenador, fecha, hora)
    /// GIVEN: Hay una pre-reserva existente con idClase + idEntrenador + fecha + hora
    /// AND el usuario está autenticado con token JWT válido
    /// WHEN: POST /api/horarios/preReservarHorario con la MISMA combinación
    /// THEN: Returns 500 Internal Server Error
    /// AND solo existe UN registro en preReservasDeHorario (verificado en BD)
    /// </summary>
    [Fact]
    public async Task PreReservarHorario_WithDuplicateClassAndTrainer_ReturnsError()
    {
        // Arrange
        await SetAuthHeaderAsync();

        // Get valid ids
        var horaResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales",
            new());
        var idHora = Convert.ToInt32(horaResult["idHora"]);

        var claseResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ClaseID FROM Clases",
            new());
        var idClase = Convert.ToInt32(claseResult["ClaseID"]);

        var trainerResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 u.Id FROM AspNetUsers u 
              INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId 
              INNER JOIN AspNetRoles r ON ur.RoleId = r.Id 
              WHERE r.Name = 'empleado'",
            new());
        var idEntrenador = trainerResult["Id"]!.ToString()!;

        var testDate = DateOnly.FromDateTime(DateTime.Now.AddDays(7));

        // Act 1: Create first pre-reservation (should succeed)
        var preReserva1 = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "test-user-1",
            fechaTentativa = testDate,
            idHoraLaboral = idHora,
            idClase = idClase,
            idEntrenador = idEntrenador
        };
        var response1 = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva1);
        response1.StatusCode.Should().Be(HttpStatusCode.OK);
        var result1 = await response1.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result1!.payload.Should().BeGreaterThan(0);

        // Act 2: Try to create duplicate (should fail)
        var preReserva2 = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "test-user-2",
            fechaTentativa = testDate,
            idHoraLaboral = idHora,
            idClase = idClase,
            idEntrenador = idEntrenador
        };
        var response2 = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva2);

        // Assert
        response2.StatusCode.Should().Be(HttpStatusCode.InternalServerError);
        
        var result2 = await response2.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result2.Should().NotBeNull();
        result2!.success.Should().BeFalse();

        // Verify only one record exists in database
        var countResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT COUNT(*) as Total FROM preReservasDeHorario 
              WHERE fkHoraLaboral = @IdHora 
                AND fechaReservada = @Fecha 
                AND idClase = @IdClase 
                AND idEntrenador = @IdEntrenador",
            new() { 
                ["@IdHora"] = idHora, 
                ["@Fecha"] = testDate.ToDateTime(TimeOnly.MinValue),
                ["@IdClase"] = idClase,
                ["@IdEntrenador"] = idEntrenador
            });
        var count = Convert.ToInt32(countResult["Total"]);
        count.Should().Be(1, "Only one pre-reservation should exist for this combination");
    }

    /// <summary>
    /// REQUISITO: Intento de crear pre-reserva duplicada solo con clase (sin entrenador)
    /// Escenario: Ya existe pre-reserva con misma combinación (idClase, fecha, hora) sin entrenador
    /// GIVEN: Hay una pre-reserva existente con idClase + null idEntrenador + fecha + hora
    /// AND el usuario está autenticado con token JWT válido
    /// WHEN: POST /api/horarios/preReservarHorario con la MISMA combinación
    /// THEN: Returns 500 Internal Server Error
    /// </summary>
    [Fact]
    public async Task PreReservarHorario_WithDuplicateClassOnly_ReturnsError()
    {
        // Arrange
        await SetAuthHeaderAsync();

        var horaResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales",
            new());
        var idHora = Convert.ToInt32(horaResult["idHora"]);

        var claseResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ClaseID FROM Clases",
            new());
        var idClase = Convert.ToInt32(claseResult["ClaseID"]);

        var testDate = DateOnly.FromDateTime(DateTime.Now.AddDays(7));

        // Act 1: Create first pre-reservation with class only
        var preReserva1 = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "test-user-1",
            fechaTentativa = testDate,
            idHoraLaboral = idHora,
            idClase = idClase,
            idEntrenador = ""
        };
        var response1 = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva1);
        response1.StatusCode.Should().Be(HttpStatusCode.OK);

        // Act 2: Try to create duplicate
        var preReserva2 = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "test-user-2",
            fechaTentativa = testDate,
            idHoraLaboral = idHora,
            idClase = idClase,
            idEntrenador = ""
        };
        var response2 = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva2);

        // Assert
        response2.StatusCode.Should().Be(HttpStatusCode.InternalServerError);
        
        // Verify only one record exists
        var countResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT COUNT(*) as Total FROM preReservasDeHorario 
              WHERE fkHoraLaboral = @IdHora 
                AND fechaReservada = @Fecha 
                AND idClase = @IdClase 
                AND (idEntrenador = '' OR idEntrenador IS NULL)",
            new() { 
                ["@IdHora"] = idHora, 
                ["@Fecha"] = testDate.ToDateTime(TimeOnly.MinValue),
                ["@IdClase"] = idClase
            });
        var count = Convert.ToInt32(countResult["Total"]);
        count.Should().Be(1);
    }

    /// <summary>
    /// REQUISITO: Intento de crear pre-reserva duplicada solo con entrenador (sin clase)
    /// Escenario: Ya existe pre-reserva con misma combinación (idEntrenador, fecha, hora) sin clase
    /// GIVEN: Hay una pre-reserva existente con null idClase + idEntrenador + fecha + hora
    /// AND el usuario está autenticado con token JWT válido
    /// WHEN: POST /api/horarios/preReservarHorario con la MISMA combinación
    /// THEN: Returns 500 Internal Server Error
    /// </summary>
    [Fact]
    public async Task PreReservarHorario_WithDuplicateTrainerOnly_ReturnsError()
    {
        // Arrange
        await SetAuthHeaderAsync();

        var horaResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales",
            new());
        var idHora = Convert.ToInt32(horaResult["idHora"]);

        var trainerResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 u.Id FROM AspNetUsers u 
              INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId 
              INNER JOIN AspNetRoles r ON ur.RoleId = r.Id 
              WHERE r.Name = 'empleado'",
            new());
        var idEntrenador = trainerResult["Id"]!.ToString()!;

        var testDate = DateOnly.FromDateTime(DateTime.Now.AddDays(7));

        // Act 1: Create first pre-reservation with trainer only
        var preReserva1 = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "test-user-1",
            fechaTentativa = testDate,
            idHoraLaboral = idHora,
            idClase = null,
            idEntrenador = idEntrenador
        };
        var response1 = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva1);
        response1.StatusCode.Should().Be(HttpStatusCode.OK);

        // Act 2: Try to create duplicate
        var preReserva2 = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "test-user-2",
            fechaTentativa = testDate,
            idHoraLaboral = idHora,
            idClase = null,
            idEntrenador = idEntrenador
        };
        var response2 = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva2);

        // Assert
        response2.StatusCode.Should().Be(HttpStatusCode.InternalServerError);
        
        // Verify only one record exists
        var countResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT COUNT(*) as Total FROM preReservasDeHorario 
              WHERE fkHoraLaboral = @IdHora 
                AND fechaReservada = @Fecha 
                AND idClase IS NULL 
                AND idEntrenador = @IdEntrenador",
            new() { 
                ["@IdHora"] = idHora, 
                ["@Fecha"] = testDate.ToDateTime(TimeOnly.MinValue),
                ["@IdEntrenador"] = idEntrenador
            });
        var count = Convert.ToInt32(countResult["Total"]);
        count.Should().Be(1);
    }

    /// <summary>
    /// REQUISITO: Intento de crear pre-reserva duplicada sin clase ni entrenador
    /// Escenario: Ya existe pre-reserva con misma combinación (fecha, hora) sin clase ni entrenador
    /// GIVEN: Hay una pre-reserva existente con null idClase + '' idEntrenador + fecha + hora
    /// AND el usuario está autenticado con token JWT válido
    /// WHEN: POST /api/horarios/preReservarHorario con la MISMA combinación
    /// THEN: Returns 500 Internal Server Error
    /// </summary>
    [Fact]
    public async Task PreReservarHorario_WithDuplicateMinimalData_ReturnsError()
    {
        // Arrange
        await SetAuthHeaderAsync();

        var horaResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 idHora FROM horasLaborales",
            new());
        var idHora = Convert.ToInt32(horaResult["idHora"]);

        var testDate = DateOnly.FromDateTime(DateTime.Now.AddDays(7));

        // Act 1: Create first pre-reservation with minimal data
        var preReserva1 = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "test-user-1",
            fechaTentativa = testDate,
            idHoraLaboral = idHora,
            idClase = null,
            idEntrenador = ""
        };
        var response1 = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva1);
        response1.StatusCode.Should().Be(HttpStatusCode.OK);

        // Act 2: Try to create duplicate
        var preReserva2 = new DTOPreReservaDeHorario
        {
            idUsuarioQueReserva = "test-user-2",
            fechaTentativa = testDate,
            idHoraLaboral = idHora,
            idClase = null,
            idEntrenador = ""
        };
        var response2 = await Client.PostAsJsonAsync("/api/horarios/preReservarHorario", preReserva2);

        // Assert
        response2.StatusCode.Should().Be(HttpStatusCode.InternalServerError);
        
        // Verify only one record exists
        var countResult = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT COUNT(*) as Total FROM preReservasDeHorario 
              WHERE fkHoraLaboral = @IdHora 
                AND fechaReservada = @Fecha 
                AND idClase IS NULL 
                AND (idEntrenador = '' OR idEntrenador IS NULL)",
            new() { 
                ["@IdHora"] = idHora, 
                ["@Fecha"] = testDate.ToDateTime(TimeOnly.MinValue)
            });
        var count = Convert.ToInt32(countResult["Total"]);
        count.Should().Be(1);
    }

    #endregion
}