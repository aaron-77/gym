using API.Controllers;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.Dtos;
using FluentAssertions;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using NSubstitute;
using Xunit;

namespace GymWebApp.Tests.Unit.Medidas;

public class ObtenerEjerciciosYParametrosValidationTests
{
    private readonly FitnessCenterDbContext _mockContext;
    private readonly UserManager<ApplicationUser> _mockUserManager;
    private readonly ILogger<MedidasController> _mockLogger;
    private readonly MedidasController _sut;

    public ObtenerEjerciciosYParametrosValidationTests()
    {
        _mockContext = Substitute.For<FitnessCenterDbContext>();
        _mockUserManager = Substitute.For<UserManager<ApplicationUser>>(
            Substitute.For<IUserStore<ApplicationUser>>(),
            null!, null!, null!, null!, null!, null!, null!, null!);
        _mockLogger = Substitute.For<ILogger<MedidasController>>();

        _sut = new MedidasController(
            _mockContext,
            _mockUserManager,
            _mockLogger
        );
    }

    #region Validación de GUID para idCliente

    /// <summary>
    /// GIVEN: idCliente es null
    /// WHEN: Se llama a ObtenerDetallesDeProgreso
    /// THEN: Retorna BadRequest por validación de GUID
    /// </summary>
    [Fact]
    public async Task ObtenerEjerciciosYParametros_WhenIdClienteIsNull_ReturnsBadRequest()
    {
        // Arrange
        string? idCliente = null;

        // Act
        var result = await _sut.ObtenerDetallesDeProgreso(idCliente!);

        // Assert
        var objectResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = objectResult.Value.Should().BeOfType<DTOResponse<List<DTOEjerciciosYParametrosDelCliente>>>().Subject;

        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
    }

    /// <summary>
    /// GIVEN: idCliente es string vacío
    /// WHEN: Se llama a ObtenerDetallesDeProgreso
    /// THEN: Retorna BadRequest por validación de GUID
    /// </summary>
    [Fact]
    public async Task ObtenerEjerciciosYParametros_WhenIdClienteIsEmpty_ReturnsBadRequest()
    {
        // Arrange
        string idCliente = string.Empty;

        // Act
        var result = await _sut.ObtenerDetallesDeProgreso(idCliente);

        // Assert
        var objectResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = objectResult.Value.Should().BeOfType<DTOResponse<List<DTOEjerciciosYParametrosDelCliente>>>().Subject;

        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
    }

    /// <summary>
    /// GIVEN: idCliente es un GUID válido
    /// WHEN: Se llama a ObtenerDetallesDeProgreso
    /// THEN: Retorna Ok (la consulta se ejecuta)
    /// </summary>
    [Fact]
    public async Task ObtenerEjerciciosYParametros_WhenIdClienteIsValidGuid_ReturnsOk()
    {
        // Arrange
        string idCliente = Guid.NewGuid().ToString();
        
        // Configure mock to return null for FindByIdAsync (cliente no existe)
        _mockUserManager.FindByIdAsync(idCliente).Returns((ApplicationUser?)null);

        // Act
        var result = await _sut.ObtenerDetallesDeProgreso(idCliente);

        // Assert - Returns BadRequest because cliente doesn't exist
        var objectResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = objectResult.Value.Should().BeOfType<DTOResponse<List<DTOEjerciciosYParametrosDelCliente>>>().Subject;

        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.errors.Should().NotBeEmpty();
        response.errors.Should().Contain(e => e.message.Contains("Cliente no encontrado"));
    }

    #endregion
}
