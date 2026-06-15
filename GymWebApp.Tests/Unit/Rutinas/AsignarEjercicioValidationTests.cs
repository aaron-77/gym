using API.Controllers;
using DTO.Dtos;
using FluentAssertions;
using GymWebApp.Tests.Factories;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using NSubstitute;
using Xunit;

namespace GymWebApp.Tests.Unit.Rutinas;

public class AsignarEjercicioValidationTests
{
    private readonly RutinasController _sut;
    private readonly ILogger<RutinasController> _mockLogger;
    private readonly DataAccess.EntityFramework.FitnessCenterDbContext _mockContext;
    private readonly BL.Utils.JwtTokenGenerator _mockJwtTokenGenerator;

    public AsignarEjercicioValidationTests()
    {
        _mockContext = NSubstitute.Substitute.For<DataAccess.EntityFramework.FitnessCenterDbContext>();
        _mockLogger = NSubstitute.Substitute.For<ILogger<RutinasController>>();
        
        // JwtTokenGenerator is not used in the controller methods for these tests
        _mockJwtTokenGenerator = null!;

        _sut = new RutinasController(_mockJwtTokenGenerator, _mockContext, _mockLogger);
    }

    [Fact]
    public async Task WhenUsuarioIDIsNull_ReturnsBadRequest()
    {
        // Arrange
        var asignacion = RutinaFactory.CrearAsignacionInvalida(usuarioId: null);
        _sut.ModelState.AddModelError("UsuarioID", "Tienes que seleccionar un cliente");

        // Act
        var result = await _sut.asignarEjercicioARutina(asignacion);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }

    [Fact]
    public async Task WhenRutinaIdIsZero_ReturnsBadRequest()
    {
        // Arrange
        var asignacion = RutinaFactory.CrearAsignacionInvalida(rutinaId: 0);
        _sut.ModelState.AddModelError("RutinaId", "Selecciona una rutina");

        // Act
        var result = await _sut.asignarEjercicioARutina(asignacion);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }

    [Fact]
    public async Task WhenRutinaIdIsNegative_ReturnsBadRequest()
    {
        // Arrange
        var asignacion = RutinaFactory.CrearAsignacionInvalida(rutinaId: -1);
        _sut.ModelState.AddModelError("RutinaId", "Selecciona una rutina");

        // Act
        var result = await _sut.asignarEjercicioARutina(asignacion);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }

    [Fact]
    public async Task WhenEjercicioIDIsZero_ReturnsBadRequest()
    {
        // Arrange
        var asignacion = RutinaFactory.CrearAsignacionInvalida(ejercicioId: 0);
        _sut.ModelState.AddModelError("EjercicioID", "Selecciona un ejercicio");

        // Act
        var result = await _sut.asignarEjercicioARutina(asignacion);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }

    [Fact]
    public async Task WhenSetsIsZero_ReturnsBadRequest()
    {
        // Arrange
        var asignacion = RutinaFactory.CrearAsignacionInvalida(sets: 0);
        _sut.ModelState.AddModelError("Sets", "Ingresa los sets");

        // Act
        var result = await _sut.asignarEjercicioARutina(asignacion);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }

    [Fact]
    public async Task WhenSetsIsNegative_ReturnsBadRequest()
    {
        // Arrange
        var asignacion = RutinaFactory.CrearAsignacionInvalida(sets: -1);
        _sut.ModelState.AddModelError("Sets", "Ingresa los sets");

        // Act
        var result = await _sut.asignarEjercicioARutina(asignacion);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }

    [Fact]
    public async Task WhenRepeticionesIsNegative_ReturnsBadRequest()
    {
        // Arrange
        var asignacion = RutinaFactory.CrearAsignacionInvalida(repeticiones: -1);
        _sut.ModelState.AddModelError("Repeticiones", "Ingresa las repeticiones");

        // Act
        var result = await _sut.asignarEjercicioARutina(asignacion);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }
}