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

public class ObtenerDetallesDeProgresoValidationTests
{
    private readonly FitnessCenterDbContext _mockContext;
    private readonly UserManager<ApplicationUser> _mockUserManager;
    private readonly ILogger<MedidasController> _mockLogger;
    private readonly MedidasController _sut;

    public ObtenerDetallesDeProgresoValidationTests()
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

    #region Validación de idCliente

    /// <summary>
    /// GIVEN: idCliente es null
    /// WHEN: Se llama a ObtenerDetallesDeProgresoApi
    /// THEN: Retorna BadRequest con error de validación de GUID
    /// </summary>
    [Fact]
    public async Task ObtenerDetallesDeProgresoApi_WhenIdClienteIsNull_ReturnsBadRequest()
    {
        // Arrange
        string? idCliente = null;

        // Act
        var result = await _sut.ObtenerDetallesDeProgresoApi(
            idCliente: idCliente!,
            idParametro: 1,
            idEjercicio: null,
            espaciadoTemporal: null,
            tipoDeBusqueda: null);

        // Assert
        var objectResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = objectResult.Value.Should().BeOfType<DTOResponse<MedidasConMetas>>().Subject;

        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.errors.Should().NotBeEmpty();
        response.errors.Should().Contain(e => e.propiedad == "idCliente");
    }

    /// <summary>
    /// GIVEN: idCliente es un GUID inválido
    /// WHEN: Se llama a ObtenerDetallesDeProgresoApi
    /// THEN: Retorna BadRequest con error de validación de GUID
    /// </summary>
    [Fact]
    public async Task ObtenerDetallesDeProgresoApi_WhenIdClienteIsInvalidGuid_ReturnsBadRequest()
    {
        // Arrange
        string idCliente = "not-a-valid-guid";

        // Act
        var result = await _sut.ObtenerDetallesDeProgresoApi(
            idCliente: idCliente,
            idParametro: 1,
            idEjercicio: null,
            espaciadoTemporal: null,
            tipoDeBusqueda: null);

        // Assert
        var objectResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = objectResult.Value.Should().BeOfType<DTOResponse<MedidasConMetas>>().Subject;

        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.errors.Should().NotBeEmpty();
        response.errors.Should().Contain(e => e.propiedad == "idCliente");
    }

    #endregion

    #region Validación de idParametro

    /// <summary>
    /// GIVEN: idParametro es negativo
    /// WHEN: Se llama a ObtenerDetallesDeProgresoApi
    /// THEN: Retorna BadRequest con error de validación
    /// </summary>
    [Fact]
    public async Task ObtenerDetallesDeProgresoApi_WhenIdParametroIsNegative_ReturnsBadRequest()
    {
        // Arrange
        string idCliente = Guid.NewGuid().ToString();

        // Act
        var result = await _sut.ObtenerDetallesDeProgresoApi(
            idCliente: idCliente,
            idParametro: -1,
            idEjercicio: null,
            espaciadoTemporal: null,
            tipoDeBusqueda: null);

        // Assert
        var objectResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = objectResult.Value.Should().BeOfType<DTOResponse<MedidasConMetas>>().Subject;

        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.errors.Should().NotBeEmpty();
        response.errors.Should().Contain(e => e.propiedad == "idParametro");
    }

    #endregion

    #region Validación de espaciadoTemporal

    /// <summary>
    /// GIVEN: espaciadoTemporal tiene valor inválido
    /// WHEN: Se llama a ObtenerDetallesDeProgresoApi
    /// THEN: Retorna BadRequest con error de validación
    /// </summary>
    [Fact]
    public async Task ObtenerDetallesDeProgresoApi_WhenEspaciadoTemporalIsInvalid_ReturnsBadRequest()
    {
        // Arrange
        string idCliente = Guid.NewGuid().ToString();

        // Act
        var result = await _sut.ObtenerDetallesDeProgresoApi(
            idCliente: idCliente,
            idParametro: 1,
            idEjercicio: null,
            espaciadoTemporal: "invalid-value",
            tipoDeBusqueda: null);

        // Assert
        var objectResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = objectResult.Value.Should().BeOfType<DTOResponse<MedidasConMetas>>().Subject;

        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.errors.Should().NotBeEmpty();
        response.errors.Should().Contain(e => e.propiedad == "espaciadoTemporal");
    }

    #endregion

    #region Validación de tipoDeBusqueda

    /// <summary>
    /// GIVEN: tipoDeBusqueda tiene valor inválido
    /// WHEN: Se llama a ObtenerDetallesDeProgresoApi
    /// THEN: Retorna BadRequest con error de validación
    /// </summary>
    [Fact]
    public async Task ObtenerDetallesDeProgresoApi_WhenTipoDeBusquedaIsInvalid_ReturnsBadRequest()
    {
        // Arrange
        string idCliente = Guid.NewGuid().ToString();

        // Act
        var result = await _sut.ObtenerDetallesDeProgresoApi(
            idCliente: idCliente,
            idParametro: 1,
            idEjercicio: null,
            espaciadoTemporal: null,
            tipoDeBusqueda: "INVALIDO");

        // Assert
        var objectResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = objectResult.Value.Should().BeOfType<DTOResponse<MedidasConMetas>>().Subject;

        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.errors.Should().NotBeEmpty();
        response.errors.Should().Contain(e => e.propiedad == "tipoDeBusqueda");
    }

    #endregion

    #region Happy Path

    /// <summary>
    /// GIVEN: Todos los parámetros son válidos
    /// WHEN: Se llama a ObtenerDetallesDeProgresoApi
    /// THEN: Retorna Ok
    /// </summary>
    [Fact]
    public async Task ObtenerDetallesDeProgresoApi_WhenAllValid_ReturnsOk()
    {
        // Arrange
        string idCliente = Guid.NewGuid().ToString();

        // Act
        var result = await _sut.ObtenerDetallesDeProgresoApi(
            idCliente: idCliente,
            idParametro: 1,
            idEjercicio: null,
            espaciadoTemporal: "individual",
            tipoDeBusqueda: "MES");

        // Assert
        result.Result.Should().BeOfType<ObjectResult>();
    }

    #endregion
}
