using FluentAssertions;
using Microsoft.Extensions.Logging;
using NSubstitute;
using Xunit;
using API.Services;
using API.Services.Validaciones;
using BL.Validaciones;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DataAccess.Infraestructure;
using DTO.Dtos;

namespace GymWebApp.Tests.Unit.Inscripciones;

public class ServiceConsultarInscripcionesDeClienteTests
{
    private readonly FitnessCenterDbContext _mockContext;
    private readonly IValidadorUsuarioExistente _mockValidador;
    private readonly ILogger<InscripcionesService> _mockLogger;
    private readonly IValidadorFechaCancelacionInscripcion _mockValidadorFecha;
    private readonly IDataAccessExecutor _mockDbExecutor;

    public ServiceConsultarInscripcionesDeClienteTests()
    {
        _mockContext = Substitute.For<FitnessCenterDbContext>();
        _mockLogger = Substitute.For<ILogger<InscripcionesService>>();
        _mockValidador = Substitute.For<IValidadorUsuarioExistente>();
        _mockValidadorFecha = Substitute.For<IValidadorFechaCancelacionInscripcion>();
        _mockDbExecutor = Substitute.For<IDataAccessExecutor>();
    }

    #region Validation Tests - Guard Clauses

    [Fact]
    public async Task ConsultarInscripcionesAsync_NullId_ReturnsBadRequest()
    {
        // Arrange
        var sut = new InscripcionesService(
            _mockContext, _mockLogger, _mockValidadorFecha, _mockValidador, _mockDbExecutor);

        // Act
        var result = await sut.ConsultarInscripcionesDeClienteAsync(null!);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("ID de usuario"));
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_EmptyId_ReturnsBadRequest()
    {
        // Arrange
        var sut = new InscripcionesService(
            _mockContext, _mockLogger, _mockValidadorFecha, _mockValidador, _mockDbExecutor);

        // Act
        var result = await sut.ConsultarInscripcionesDeClienteAsync(string.Empty);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("ID de usuario"));
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_WhitespaceId_ReturnsBadRequest()
    {
        // Arrange
        var sut = new InscripcionesService(
            _mockContext, _mockLogger, _mockValidadorFecha, _mockValidador, _mockDbExecutor);

        // Act
        var result = await sut.ConsultarInscripcionesDeClienteAsync("   ");

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("ID de usuario"));
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_InvalidGuidFormat_ReturnsBadRequest()
    {
        // Arrange
        var sut = new InscripcionesService(
            _mockContext, _mockLogger, _mockValidadorFecha, _mockValidador, _mockDbExecutor);

        // Act
        var result = await sut.ConsultarInscripcionesDeClienteAsync("abc123");

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("GUID"));
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_UserNotFound_ReturnsNotFound()
    {
        // Arrange
        var validGuid = Guid.NewGuid().ToString();
        _mockValidador.ValidarAsync(validGuid).Returns((false, (ApplicationUser?)null));
        var sut = new InscripcionesService(
            _mockContext, _mockLogger, _mockValidadorFecha, _mockValidador, _mockDbExecutor);

        // Act
        var result = await sut.ConsultarInscripcionesDeClienteAsync(validGuid);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(404);
        result.errors.Should().Contain(e => e.message.Contains("no existe"));
    }

    #endregion

    #region Happy Path Tests

    [Fact]
    public async Task ConsultarInscripcionesAsync_ValidRequest_ReturnsOkWithList()
    {
        // Arrange
        var validGuid = Guid.NewGuid().ToString();

        var expectedInscripciones = new List<DTOInscripcionDelCliente>
        {
            new()
            {
                IdInscripcion = 1,
                FechaDeInscripcion = DateTime.Now.AddDays(-5),
                IdClaseProgramada = 10,
                NombreClase = "Spinning",
                FechaDeLaClase = DateTime.Now.AddDays(10),
                HoraInicio = new TimeSpan(8, 0, 0),
                HoraFin = new TimeSpan(9, 0, 0),
                NombreEntrenador = "Juan Pérez"
            },
            new()
            {
                IdInscripcion = 2,
                FechaDeInscripcion = DateTime.Now.AddDays(-3),
                IdClaseProgramada = 15,
                NombreClase = "Yoga",
                FechaDeLaClase = DateTime.Now.AddDays(12),
                HoraInicio = new TimeSpan(10, 0, 0),
                HoraFin = new TimeSpan(11, 0, 0),
                NombreEntrenador = "María García"
            }
        };

        _mockValidador.ValidarAsync(validGuid).Returns((true, new ApplicationUser { Id = validGuid }));
        _mockDbExecutor.QueryAsync<DTOInscripcionDelCliente>(Arg.Any<FormattableString>())
            .Returns(Task.FromResult(expectedInscripciones));

        var sut = new InscripcionesService(
            _mockContext, _mockLogger, _mockValidadorFecha, _mockValidador, _mockDbExecutor);

        // Act
        var result = await sut.ConsultarInscripcionesDeClienteAsync(validGuid);

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload.Should().HaveCount(2);
        result.payload.Should().Contain(i => i.NombreClase == "Spinning");
        result.payload.Should().Contain(i => i.NombreClase == "Yoga");
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_ValidRequestNoInscriptions_ReturnsOkWithEmptyList()
    {
        // Arrange
        var validGuid = Guid.NewGuid().ToString();

        _mockValidador.ValidarAsync(validGuid).Returns((true, new ApplicationUser { Id = validGuid }));
        _mockDbExecutor.QueryAsync<DTOInscripcionDelCliente>(Arg.Any<FormattableString>())
            .Returns(Task.FromResult(new List<DTOInscripcionDelCliente>()));

        var sut = new InscripcionesService(
            _mockContext, _mockLogger, _mockValidadorFecha, _mockValidador, _mockDbExecutor);

        // Act
        var result = await sut.ConsultarInscripcionesDeClienteAsync(validGuid);

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload.Should().BeEmpty();
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_DatabaseError_ReturnsServerError()
    {
        // Arrange
        var validGuid = Guid.NewGuid().ToString();

        _mockValidador.ValidarAsync(validGuid).Returns((true, new ApplicationUser { Id = validGuid }));
        _mockDbExecutor
            .QueryAsync<DTOInscripcionDelCliente>(Arg.Any<FormattableString>())
            .Returns(Task.FromException<List<DTOInscripcionDelCliente>>(
                new InvalidOperationException("Error de BD simulado")));

        var sut = new InscripcionesService(
            _mockContext, _mockLogger, _mockValidadorFecha, _mockValidador, _mockDbExecutor);

        // Act
        var result = await sut.ConsultarInscripcionesDeClienteAsync(validGuid);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(500);
    }

    #endregion
}