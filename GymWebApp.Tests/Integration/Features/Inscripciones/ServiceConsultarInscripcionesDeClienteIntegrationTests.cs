using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Xunit;
using API.Services;
using API.Services.Validaciones;
using DataAccess.EntityFramework;
using DTO.Dtos;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;

namespace GymWebApp.Tests.Integration.Features.Inscripciones;

/// <summary>
/// Tests de integración para ServiceConsultarInscripcionesDeCliente (spec 32).
/// Validan la interacción real con la BD: función SQL, UserManager, DI real.
/// Los tests de guard clauses (null, empty, whitespace) se cubren en Unit tests.
///
/// Para garantizar datos actuales, los tests que necesitan inscripciones ejecutan:
///   1. sp_cron_generarClasesProgramadas — genera clases programadas para hoy
///   2. sp_generarRegistroDePrueba_inscricionesDeClases — inscribe a un cliente
/// </summary>
[Collection("IntegrationTests")]
public class ServiceConsultarInscripcionesDeClienteIntegrationTests : IntegrationTestBase
{
    public ServiceConsultarInscripcionesDeClienteIntegrationTests(
        CitasApiWebApplicationFactory<Program> factory,
        TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    /// <summary>
    /// Crea el servicio con dependencias reales resueltas desde DI.
    /// </summary>
    private ServiceConsultarInscripcionesDeCliente CreateService()
    {
        var context = Factory.Services.GetRequiredService<FitnessCenterDbContext>();
        var logger = Factory.Services.GetRequiredService<ILogger<ServiceConsultarInscripcionesDeCliente>>();
        var validador = Factory.Services.GetRequiredService<IValidadorUsuarioExistente>();

        return new ServiceConsultarInscripcionesDeCliente(context, logger, validador);
    }

    /// <summary>
    /// Genera datos frescos de clases programadas e inscripciones.
    /// Ejecuta sp_cron_generarClasesProgramadas (clases para HOY) y luego selecciona
    /// una clase que SÍ va a ser visible por fn_obtenerInscripcionesDelCliente
    /// (mismo filtro: fecha futura o fecha hoy con hora no vencida).
    /// </summary>
    /// <returns>ID del cliente que fue inscrito.</returns>
    private async Task<string> SeedFreshInscripcionAsync()
    {
        // 1. Generar clases programadas para hoy
        await DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            "EXEC dbo.sp_cron_generarClasesProgramadas");

        // 2. Tomar un cliente sin inscripciones previas (evita duplicados)
        var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 Id FROM AspNetUsers
              WHERE Id NOT IN (SELECT fkCliente FROM inscripcionesDeClases)
              ORDER BY NEWID()");
        var clienteId = clienteRow?["Id"]?.ToString();
        clienteId.Should().NotBeNull("Debe existir al menos un usuario en seed data");

        // 3. Seleccionar una clase que pase el MISMO filtro que fn_obtenerInscripcionesDelCliente
        //    (fecha futura, o fecha hoy con hora todavía no vencida)
        var claseRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 cp.idProgramacionClase
              FROM clasesProgramadas cp
              INNER JOIN horariosDeClasesProgramadas hcp
                  ON cp.idProgramacionClase = hcp.fkClaseProgramada
              INNER JOIN horasLaborales hl
                  ON hcp.fkHorarioLaboral = hl.idHora
              WHERE cp.fechaDeLaClase > CAST(GETDATE() AS DATE)
                 OR (cp.fechaDeLaClase = CAST(GETDATE() AS DATE)
                     AND hl.horaInicio > CAST(GETDATE() AS TIME))
              ORDER BY NEWID()");

        var idClaseProgramada = claseRow?["idProgramacionClase"] != null
            ? Convert.ToInt32(claseRow["idProgramacionClase"])
            : 0;

        idClaseProgramada.Should().BeGreaterThan(0,
            "sp_cron_generarClasesProgramadas debió generar al menos una clase con horario futuro");

        // 4. Inscribir al cliente via SP (valida cupo, duplicados, etc.)
        await DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            "EXEC dbo.sp_generarRegistroDePrueba_inscricionesDeClases @idCliente = @Cliente, @idClaseProgramada = @Clase",
            new Dictionary<string, object?>
            {
                ["@Cliente"] = clienteId!,
                ["@Clase"] = idClaseProgramada
            });

        return clienteId!;
    }

    #region Happy Path

    [Fact]
    public async Task ConsultarInscripcionesAsync_ClienteConInscripcionesFuturas_ReturnsOkWithList()
    {
        // Arrange — generar datos frescos via SPs
        var clienteId = await SeedFreshInscripcionAsync();
        var service = CreateService();

        // Act
        var result = await service.ConsultarInscripcionesAsync(clienteId);

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload.Should().NotBeEmpty("El cliente fue inscrito via SP a una clase de hoy");
        result.payload.Should().AllSatisfy(i =>
        {
            i.IdInscripcion.Should().BeGreaterThan(0);
            i.NombreClase.Should().NotBeNullOrEmpty();
            i.FechaDeLaClase.Should().BeOnOrAfter(DateTime.Today);
        });
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_ClienteSinInscripciones_ReturnsOkWithEmptyList()
    {
        // Arrange — BD recién reseteada, buscar usuario sin inscripciones
        var service = CreateService();

        var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 Id FROM AspNetUsers
              WHERE Id NOT IN (SELECT fkCliente FROM inscripcionesDeClases)");

        var clienteId = clienteRow?["Id"]?.ToString();
        clienteId.Should().NotBeNull("Debe existir al menos un usuario sin inscripciones en seed data");

        // Act
        var result = await service.ConsultarInscripcionesAsync(clienteId!);

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload.Should().BeEmpty();
    }

    #endregion

    #region Edge Cases

    [Fact]
    public async Task ConsultarInscripcionesAsync_GuidInexistente_ReturnsNotFound()
    {
        // Arrange
        var service = CreateService();
        var guidInexistente = Guid.NewGuid().ToString();

        // Act
        var result = await service.ConsultarInscripcionesAsync(guidInexistente);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(404);
        result.errors.Should().Contain(e => e.message.Contains("no existe"));
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_ClienteConSoloInscripcionesCanceladas_ReturnsOkWithEmptyList()
    {
        // Arrange — generar inscripción vigente via SP y luego cancelarla
        var clienteId = await SeedFreshInscripcionAsync();
        var service = CreateService();

        // Obtener la inscripción recién creada y cambiarla a cancelada
        var inscripcionRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 idInscripcion FROM inscripcionesDeClases 
              WHERE fkCliente = @Cliente AND fkEstadoInscripcion = 1",
            new Dictionary<string, object?> { ["@Cliente"] = clienteId });

        var idInscripcion = inscripcionRow?["idInscripcion"] != null
            ? Convert.ToInt32(inscripcionRow["idInscripcion"])
            : 0;

        idInscripcion.Should().BeGreaterThan(0, "SeedFreshInscripcionAsync debió crear una inscripción vigente");

        // Cambiar estado a cancelada (idEstadoInscripcion = 4)
        await DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            "UPDATE inscripcionesDeClases SET fkEstadoInscripcion = 4 WHERE idInscripcion = @Id",
            new Dictionary<string, object?> { ["@Id"] = idInscripcion });

        // Act
        var result = await service.ConsultarInscripcionesAsync(clienteId);

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload.Should().BeEmpty("La función SQL solo retorna inscripciones con estado 'vigente'");
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_GuidInvalido_ReturnsBadRequest()
    {
        // Arrange
        var service = CreateService();

        // Act
        var result = await service.ConsultarInscripcionesAsync("abc123");

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("GUID"));
    }

    #endregion
}
