using FluentAssertions;
using Microsoft.Extensions.Logging;
using NSubstitute;
using Xunit;

using API.Services;
using API.Services.Validaciones;
using BL.Validaciones;
using DataAccess.EntityFramework;
using DataAccess.Infraestructure;
using DTO.Dtos;

namespace GymWebApp.Tests.Unit.Inscripciones;

/// <summary>
/// Tests unitarios para InscripcionesService.ReagendarInscripcionAsync (spec 40).
/// Validan únicamente las guard clauses que no requieren BD.
/// </summary>
public class ServiceReagendarInscripcionGuardClauseTests
{
    private readonly FitnessCenterDbContext _mockContext;
    private readonly ILogger<InscripcionesService> _mockLogger;
    private readonly IValidadorFechaCancelacionInscripcion _mockValidadorFecha;
    private readonly IValidadorUsuarioExistente _mockValidador;
    private readonly IDataAccessExecutor _mockDbExecutor;

    public ServiceReagendarInscripcionGuardClauseTests()
    {
        _mockContext = Substitute.For<FitnessCenterDbContext>();
        _mockLogger = Substitute.For<ILogger<InscripcionesService>>();
        _mockValidadorFecha = Substitute.For<IValidadorFechaCancelacionInscripcion>();
        _mockValidador = Substitute.For<IValidadorUsuarioExistente>();
        _mockDbExecutor = Substitute.For<IDataAccessExecutor>();
    }

    [Fact]
    public async Task ReagendarInscripcionAsync_IdInscripcionInvalido_ReturnsBadRequest()
    {
        // Arrange
        var sut = new InscripcionesService(
            _mockContext, _mockLogger, _mockValidadorFecha, _mockValidador, _mockDbExecutor);

        // Act — idInscripcion <= 0
        var result = await sut.ReagendarInscripcionAsync(0, 1, "cliente-id");

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("mayor a 0"));
    }

    [Fact]
    public async Task ReagendarInscripcionAsync_IdClaseProgramadaInvalido_ReturnsBadRequest()
    {
        // Arrange
        var sut = new InscripcionesService(
            _mockContext, _mockLogger, _mockValidadorFecha, _mockValidador, _mockDbExecutor);

        // Act — idClaseProgramada <= 0
        var result = await sut.ReagendarInscripcionAsync(1, 0, "cliente-id");

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("mayor a 0"));
    }

    [Fact]
    public async Task ReagendarInscripcionAsync_IdClienteVacio_ReturnsBadRequest()
    {
        // Arrange
        var sut = new InscripcionesService(
            _mockContext, _mockLogger, _mockValidadorFecha, _mockValidador, _mockDbExecutor);

        // Act — idCliente vacío
        var result = await sut.ReagendarInscripcionAsync(1, 1, "");

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("vacío"));
    }
}
