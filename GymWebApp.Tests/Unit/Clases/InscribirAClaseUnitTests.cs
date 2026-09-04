using API.Controllers;
using API.Hubs;
using API.Services;
using BL;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.Dtos;
using FluentAssertions;
using GymWebApp.Tests.Integration.Factories;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.Extensions.Logging;
using NSubstitute;
using System.Data;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace GymWebApp.Tests.Unit.Clases;

public class InscribirAClaseUnitTests
{
    private readonly FitnessCenterDbContext _mockContext;
    private readonly IHttpCustomClient _mockHttpClient;
    private readonly UserRoleService _mockUserRoleService;
    private readonly ServicioActualizacionesDeHorariosRealTime _mockServicioActualizaciones;
    private readonly IClasesService _mockClasesService;
    private readonly IInscripcionesService _mockServicioInscripciones;
    private readonly ILogger<ClasesController> _mockLogger;
    private readonly UserManager<ApplicationUser> _mockUserManager;
    private readonly ClasesController _sut;

    public InscribirAClaseUnitTests()
    {
        // Arrange - Setup Substitutes (mocks)
        _mockContext = Substitute.For<FitnessCenterDbContext>();
        _mockHttpClient = Substitute.For<IHttpCustomClient>();
        _mockUserRoleService = Substitute.For<UserRoleService>(_mockContext, null!);
        _mockServicioActualizaciones = Substitute.For<ServicioActualizacionesDeHorariosRealTime>(_mockContext, null!, null!);
        _mockClasesService = Substitute.For<IClasesService>();
        _mockServicioInscripciones = Substitute.For<IInscripcionesService>();
        _mockLogger = Substitute.For<ILogger<ClasesController>>();
        _mockUserManager = Substitute.For<UserManager<ApplicationUser>>(
            Substitute.For<IUserStore<ApplicationUser>>(),
            null!, null!, null!, null!, null!, null!, null!, null!);

        _sut = new ClasesController(
            _mockContext,
            _mockHttpClient,
            _mockUserRoleService,
            _mockServicioActualizaciones,
            _mockClasesService,
            _mockServicioInscripciones,
            _mockUserManager,
            _mockLogger
        );
    }

    #region Sad Path Tests - Validación de parámetros

    [Fact]
    public async Task InscribirAClase_WithIdProgramacionClaseZero_ReturnsBadRequest()
    {
        // Arrange
        var requestDto = new DTOInscripcionAClase
        {
            IdProgramacionClase = 0,
            IdCliente = "test-client-id"
        };

        // Add model state error to simulate [Required] validation failure
        _sut.ModelState.AddModelError("IdProgramacionClase", "The IdProgramacionClase field is required.");

        // Act
        var result = await _sut.InscribirAClase(requestDto);

        // Assert
        var badRequestResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = badRequestResult.Value as DTOResponse<int>;
        
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.message.Should().Contain("Datos inválidos");
    }

    [Fact]
    public async Task InscribirAClase_WithIdProgramacionClaseNegative_ReturnsBadRequest()
    {
        // Arrange
        var requestDto = new DTOInscripcionAClase
        {
            IdProgramacionClase = -1,
            IdCliente = "test-client-id"
        };

        // Add model state error to simulate [Required] validation failure
        _sut.ModelState.AddModelError("IdProgramacionClase", "The IdProgramacionClase field is required.");

        // Act
        var result = await _sut.InscribirAClase(requestDto);

        // Assert
        var badRequestResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = badRequestResult.Value as DTOResponse<int>;
        
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.message.Should().Contain("Datos inválidos");
    }

    [Fact]
    public async Task InscribirAClase_WithEmptyIdCliente_ReturnsBadRequest()
    {
        // Arrange
        var requestDto = new DTOInscripcionAClase
        {
            IdProgramacionClase = 1,
            IdCliente = ""
        };

        // Add model state error to simulate [Required] validation failure
        _sut.ModelState.AddModelError("IdCliente", "The IdCliente field is required.");

        // Act
        var result = await _sut.InscribirAClase(requestDto);

        // Assert
        var badRequestResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = badRequestResult.Value as DTOResponse<int>;
        
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.message.Should().Contain("Datos inválidos");
    }

    [Fact]
    public async Task InscribirAClase_WithNullIdCliente_ReturnsBadRequest()
    {
        // Arrange
        var requestDto = new DTOInscripcionAClase
        {
            IdProgramacionClase = 1,
            IdCliente = null!
        };

        // Add model state error to simulate [Required] validation failure
        _sut.ModelState.AddModelError("IdCliente", "The IdCliente field is required.");

        // Act
        var result = await _sut.InscribirAClase(requestDto);

        // Assert
        var badRequestResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = badRequestResult.Value as DTOResponse<int>;
        
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.message.Should().Contain("Datos inválidos");
    }

    #endregion

    #region Sad Path Tests - Errores de base de datos

    [Fact]
    public async Task InscribirAClase_WhenDatabaseFails_ReturnsInternalServerError()
    {
        // Arrange
        var requestDto = new DTOInscripcionAClase
        {
            IdProgramacionClase = 1,
            IdCliente = "valid-client-id"
        };

        // Configure the real-time service to throw an exception
        // This simulates a database failure (since the controller's catch block catches all exceptions)
        _mockServicioActualizaciones
            .When(x => x.enviarCuposActualizadosDeClaseProgramada(1))
            .Do(x => throw new Exception("Database error"));

        // Act
        var result = await _sut.InscribirAClase(requestDto);

        // Assert
        var statusCodeResult = result.Result.Should().BeOfType<ObjectResult>().Subject;
        statusCodeResult.StatusCode.Should().Be(500);

        var response = statusCodeResult.Value as DTOResponse<int>;
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
        response.message.Should().Contain("Error al registrar la inscripción");
    }

    #endregion
}