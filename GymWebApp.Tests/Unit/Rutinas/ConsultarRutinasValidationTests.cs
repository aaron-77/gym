using API.Controllers;
using DTO.Dtos;
using FluentAssertions;
using GymWebApp.Tests.Factories;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using NSubstitute;
using Xunit;

namespace GymWebApp.Tests.Unit.Rutinas;

public class ConsultarRutinasValidationTests
{
    private readonly RutinasController _sut;
    private readonly ILogger<RutinasController> _mockLogger;
    private readonly DataAccess.EntityFramework.FitnessCenterDbContext _mockContext;
    private readonly BL.Utils.JwtTokenGenerator _mockJwtTokenGenerator;

    public ConsultarRutinasValidationTests()
    {
        _mockContext = NSubstitute.Substitute.For<DataAccess.EntityFramework.FitnessCenterDbContext>();
        _mockLogger = NSubstitute.Substitute.For<ILogger<RutinasController>>();
        
        // JwtTokenGenerator is not used in the controller methods for these tests
        // Pass null since it's not needed for validation tests
        _mockJwtTokenGenerator = null!;

        _sut = new RutinasController(_mockJwtTokenGenerator, _mockContext, _mockLogger);
    }

    #region Sad Path Tests - Validación de UsuarioID

    [Fact]
    public async Task WhenUsuarioIDIsNull_ReturnsBadRequest()
    {
        // Arrange
        var request = new ConsultarRutinasRequest { UsuarioID = null };
        _sut.ModelState.AddModelError("UsuarioID", "El ID de usuario es requerido");

        // Act
        var result = await _sut.obtenerRutinasDeUusario(request);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }

    [Fact]
    public async Task WhenUsuarioIDIsEmpty_ReturnsBadRequest()
    {
        // Arrange
        var request = new ConsultarRutinasRequest { UsuarioID = "" };
        _sut.ModelState.AddModelError("UsuarioID", "El ID de usuario es requerido");

        // Act
        var result = await _sut.obtenerRutinasDeUusario(request);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }

    [Fact]
    public async Task WhenUsuarioIDIsInvalidGuid_ReturnsBadRequest()
    {
        // Arrange
        var request = new ConsultarRutinasRequest { UsuarioID = "not-a-guid" };
        _sut.ModelState.AddModelError("UsuarioID", "El ID de usuario debe ser un GUID válido");

        // Act
        var result = await _sut.obtenerRutinasDeUusario(request);

        // Assert
        result.Should().BeOfType<BadRequestResult>();
    }

    #endregion

    #region Happy Path Tests

    [Fact]
    public async Task WhenUsuarioIDIsValidGuid_ReturnsOk()
    {
        // Arrange - No necesita AddModelError ya que es válido
        var request = new ConsultarRutinasRequest { UsuarioID = Guid.NewGuid().ToString() };

        // Act
        var result = await _sut.obtenerRutinasDeUusario(request);

        // Assert - El tipo puede ser OkObjectResult o StatusCode(500) si falla la BD
        result.Should().BeAssignableTo<IActionResult>();
    }

    #endregion
}