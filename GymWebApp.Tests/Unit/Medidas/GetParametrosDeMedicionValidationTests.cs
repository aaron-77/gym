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

public class GetParametrosDeMedicionValidationTests
{
    private readonly FitnessCenterDbContext _mockContext;
    private readonly UserManager<ApplicationUser> _mockUserManager;
    private readonly ILogger<MedidasController> _mockLogger;
    private readonly MedidasController _sut;

    public GetParametrosDeMedicionValidationTests()
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

    #region Validación de GUID para idUsuario

    /// <summary>
    /// GIVEN: idUsuario es null
    /// WHEN: Se llama a getParametrosDeMedicion
    /// THEN: Retorna BadRequest con error de validación de GUID
    /// </summary>
    [Fact]
    public async Task GetParametrosDeMedicion_WhenIdUsuarioIsNull_ReturnsBadRequest()
    {
        // Arrange
        string? idUsuario = null;

        // Act
        var result = await _sut.getParametrosDeMedicion(idUsuario!);

        // Assert
        var objectResult = result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = objectResult.Value.Should().BeOfType<DTOResponse<List<DTOParametroDeMedicion>>>().Subject;

        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.errors.Should().NotBeEmpty();
        response.errors.Should().Contain(e => e.propiedad == "idUsuario");
    }

    /// <summary>
    /// GIVEN: idUsuario es string vacío
    /// WHEN: Se llama a getParametrosDeMedicion
    /// THEN: Retorna BadRequest con error de validación de GUID
    /// </summary>
    [Fact]
    public async Task GetParametrosDeMedicion_WhenIdUsuarioIsEmpty_ReturnsBadRequest()
    {
        // Arrange
        string idUsuario = string.Empty;

        // Act
        var result = await _sut.getParametrosDeMedicion(idUsuario);

        // Assert
        var objectResult = result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = objectResult.Value.Should().BeOfType<DTOResponse<List<DTOParametroDeMedicion>>>().Subject;

        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.errors.Should().NotBeEmpty();
        response.errors.Should().Contain(e => e.propiedad == "idUsuario");
    }

    /// <summary>
    /// GIVEN: idUsuario es un GUID inválido
    /// WHEN: Se llama a getParametrosDeMedicion
    /// THEN: Retorna BadRequest con error de validación de GUID
    /// </summary>
    [Fact]
    public async Task GetParametrosDeMedicion_WhenIdUsuarioIsInvalidGuid_ReturnsBadRequest()
    {
        // Arrange
        string idUsuario = "not-a-valid-guid";

        // Act
        var result = await _sut.getParametrosDeMedicion(idUsuario);

        // Assert
        var objectResult = result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = objectResult.Value.Should().BeOfType<DTOResponse<List<DTOParametroDeMedicion>>>().Subject;

        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.errors.Should().NotBeEmpty();
        response.errors.Should().Contain(e => e.propiedad == "idUsuario");
    }

    /// <summary>
    /// GIVEN: idUsuario es un GUID válido
    /// WHEN: Se llama a getParametrosDeMedicion
    /// THEN: Retorna Ok (la consulta se ejecuta)
    /// </summary>
    [Fact]
    public async Task GetParametrosDeMedicion_WhenIdUsuarioIsValidGuid_ReturnsOk()
    {
        // Arrange
        string idUsuario = Guid.NewGuid().ToString();

        // Act
        var result = await _sut.getParametrosDeMedicion(idUsuario);

        // Assert
        result.Should().BeOfType<OkObjectResult>();
    }

    #endregion
}
