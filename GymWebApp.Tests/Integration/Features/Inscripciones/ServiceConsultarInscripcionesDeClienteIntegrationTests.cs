using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Xunit;
using API.Services;
using API.Services.Validaciones;
using BL.Validaciones;
using DataAccess.EntityFramework;
using DataAccess.Infraestructure;
using DTO.Dtos;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;

namespace GymWebApp.Tests.Integration.Features.Inscripciones;

/// <summary>
/// Tests de integración para InscripcionesService (spec 32).
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
    private InscripcionesService CreateService()
    {
        var context = Factory.Services.GetRequiredService<FitnessCenterDbContext>();
        var logger = Factory.Services.GetRequiredService<ILogger<InscripcionesService>>();
        var validadorFecha = Factory.Services.GetRequiredService<IValidadorFechaCancelacionInscripcion>();
        var validadorUsuario = Factory.Services.GetRequiredService<IValidadorUsuarioExistente>();
        var dbExecutor = Factory.Services.GetRequiredService<IDataAccessExecutor>();

        return new InscripcionesService(context, logger, validadorFecha, validadorUsuario, dbExecutor);
    }

    #region Happy Path

    [Fact]
    public async Task ConsultarInscripcionesAsync_ClienteConInscripcionesFuturas_ReturnsOkWithList()
    {
        // Arrange — generar datos frescos via SPs
        var clienteId = await InscripcionTestHelper.SeedFreshInscripcionAsync(TestContainerHelper.ConnectionString);
        var service = CreateService();

        // Act
        var result = await service.ConsultarInscripcionesDeClienteAsync(clienteId);

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

        var clienteId = await InscripcionTestHelper.GetClienteSinInscripcionesVigentesAsync(TestContainerHelper.ConnectionString);
        clienteId.Should().NotBeNull("Debe existir al menos un usuario sin inscripciones vigentes (futuras) en seed data");

        // Act
        var result = await service.ConsultarInscripcionesDeClienteAsync(clienteId!);

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload.Should().BeEmpty();
    }

    #endregion

    #region Edge Cases — Validación de parámetros

    [Fact]
    public async Task ConsultarInscripcionesAsync_GuidVacio_ReturnsBadRequest()
    {
        // Arrange
        var service = CreateService();

        // Act
        var result = await service.ConsultarInscripcionesDeClienteAsync(string.Empty);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("ID de usuario"));
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_NullId_ReturnsBadRequest()
    {
        // Arrange
        var service = CreateService();

        // Act
        var result = await service.ConsultarInscripcionesDeClienteAsync(null!);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("ID de usuario"));
    }

    #endregion

    #region Edge Cases — Casos con BD

    [Fact]
    public async Task ConsultarInscripcionesAsync_GuidInexistente_ReturnsNotFound()
    {
        // Arrange
        var service = CreateService();
        var guidInexistente = Guid.NewGuid().ToString();

        // Act
        var result = await service.ConsultarInscripcionesDeClienteAsync(guidInexistente);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(404);
        result.errors.Should().Contain(e => e.message.Contains("no existe"));
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_ClienteConSoloInscripcionesCanceladas_ReturnsOkWithEmptyList()
    {
        // Arrange — generar inscripción vigente via SP y luego cancelarla
        var clienteId = await InscripcionTestHelper.SeedFreshInscripcionAsync(TestContainerHelper.ConnectionString);
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
        var result = await service.ConsultarInscripcionesDeClienteAsync(clienteId);

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
        var result = await service.ConsultarInscripcionesDeClienteAsync("abc123");

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("GUID"));
    }

    #endregion
}