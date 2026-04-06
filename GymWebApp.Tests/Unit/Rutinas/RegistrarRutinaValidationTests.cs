using API.Controllers;
using DTO.Dtos;
using FluentAssertions;
using GymWebApp.Tests.Factories;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using NSubstitute;
using Xunit;

namespace GymWebApp.Tests.Unit.Rutinas;

public class RegistrarRutinaValidationTests
{
    private readonly RutinasController _sut;
    private readonly ILogger<RutinasController> _mockLogger;
    private readonly DataAccess.EntityFramework.FitnessCenterDbContext _mockContext;
    private readonly BL.Utils.JwtTokenGenerator _mockJwtTokenGenerator;

    public RegistrarRutinaValidationTests()
    {
        _mockContext = NSubstitute.Substitute.For<DataAccess.EntityFramework.FitnessCenterDbContext>();
        _mockLogger = NSubstitute.Substitute.For<ILogger<RutinasController>>();
        _mockJwtTokenGenerator = null!;

        _sut = new RutinasController(_mockJwtTokenGenerator, _mockContext, _mockLogger);
    }

    [Fact]
    public async Task WhenUsuarioIDIsNull_ReturnsBadRequest()
    {
        // Arrange
        var rutina = RutinaFactory.CrearRutinaInvalida(usuarioId: null);
        _sut.ModelState.AddModelError("UsuarioID", "Ingresa el cliente");

        // Act
        var result = await _sut.RegistrarRutina(rutina);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }

    [Fact]
    public async Task WhenEntrenadorIDIsNull_ReturnsBadRequest()
    {
        // Arrange
        var rutina = RutinaFactory.CrearRutinaInvalida(entrenadorId: null);
        _sut.ModelState.AddModelError("EntrenadorID", "Ingresa el entrenador");

        // Act
        var result = await _sut.RegistrarRutina(rutina);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }

    [Fact]
    public async Task WhenFechaCreacionIsDefault_ReturnsBadRequest()
    {
        // Arrange
        var rutina = RutinaFactory.CrearRutinaInvalida(fechaCreacion: default(DateTime));
        _sut.ModelState.AddModelError("FechaCreacion", "Ingresa la feccha");

        // Act
        var result = await _sut.RegistrarRutina(rutina);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }

    [Fact]
    public async Task WhenObservacionesIsNull_ReturnsBadRequest()
    {
        // Arrange
        var rutina = RutinaFactory.CrearRutinaInvalida(observaciones: null);
        _sut.ModelState.AddModelError("Observaciones", "Ingresa las observaciones");

        // Act
        var result = await _sut.RegistrarRutina(rutina);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }
}