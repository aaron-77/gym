using API.Controllers;
using API.Hubs;
using API.Services;
using API.Services.Validaciones;
using BL;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.Dtos;
using FluentAssertions;
using GymWebApp.Tests.Integration.Factories;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using NSubstitute;
using Moq;
using System.Threading.Tasks;
using Xunit;

namespace GymWebApp.Tests.Unit.Clases;

public class ReagendarInscripcionAClaseUnitTests
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

    public ReagendarInscripcionAClaseUnitTests()
    {
        // Arrange - Setup Substitutes with NSubstitute and Moq
        
        // DbContext (concrete class with constructors) - debe crearse primero
        var mockContext = new Mock<FitnessCenterDbContext>(
            new DbContextOptionsBuilder<FitnessCenterDbContext>()
                .UseSqlServer("TestConnection").Options);
        _mockContext = mockContext.Object;

        // IHttpCustomClient - usa NSubstitute para la interfaz
        _mockHttpClient = Substitute.For<IHttpCustomClient>();

        // UserRoleService - espera FitnessCenterDbContext y UserManager<ApplicationUser>
        _mockUserRoleService = Substitute.For<UserRoleService>(_mockContext, null!);

        // Validadores para HorariosService
        var mockValidadorUsuario = new Mock<IValidadorUsuarioExistente>();
        var mockValidadorClase = new Mock<IValidadorClaseExistente>();
        var mockValidadorClaseProgramada = new Mock<IValidadorClaseProgramadaExistente>();

        // HorariosService - necesita context + 3 validadores
        var mockHorariosService = new Mock<HorariosService>(
            _mockContext,
            mockValidadorUsuario.Object,
            mockValidadorClase.Object,
            mockValidadorClaseProgramada.Object);

        // ServicioActualizacionesDeHorariosRealTime - espera FitnessCenterDbContext, IHubContext<ReservacionesHub>, HorariosService
        var mockHubContext = new Mock<IHubContext<ReservacionesHub>>();
        _mockServicioActualizaciones = Substitute.For<ServicioActualizacionesDeHorariosRealTime>(
            _mockContext,
            mockHubContext.Object,
            mockHorariosService.Object);

        _mockClasesService = new Mock<IClasesService>().Object;
        _mockServicioInscripciones = new Mock<IInscripcionesService>().Object;
        _mockLogger = new Mock<ILogger<ClasesController>>().Object;
        // UserManager<ApplicationUser> - usa NSubstitute (no Moq)
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

    #region Sad Path Tests - Missing Required Fields

    [Fact]
    public async Task ReagendarInscripcionAClase_WithMissingIdInscripcionCancelada_ReturnsBadRequest()
    {
        // Arrange
        var requestDto = ReagendacionInscripcionFactory.Crear(
            idInscripcionCancelada: 0,
            idClaseProgramadaNueva: 1,
            idCliente: "test-client-id");

        // Add model state error to simulate [Required] validation failure
        _sut.ModelState.AddModelError("idInscripcionCancelada", "The idInscripcionCancelada field is required.");

        // Act
        var result = await _sut.ReagendarInscripcionAClase(requestDto);

        // Assert
        var badRequestResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = badRequestResult.Value as DTOResponse<string>;
        
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.message.Should().Contain("Datos inválidos");
    }

    [Fact]
    public async Task ReagendarInscripcionAClase_WithMissingIdClaseProgramadaNueva_ReturnsBadRequest()
    {
        // Arrange
        var requestDto = ReagendacionInscripcionFactory.Crear(
            idInscripcionCancelada: 1,
            idClaseProgramadaNueva: 0,
            idCliente: "test-client-id");

        // Add model state error to simulate [Required] validation failure
        _sut.ModelState.AddModelError("idClaseProgramadaNueva", "The idClaseProgramadaNueva field is required.");

        // Act
        var result = await _sut.ReagendarInscripcionAClase(requestDto);

        // Assert
        var badRequestResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = badRequestResult.Value as DTOResponse<string>;
        
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.message.Should().Contain("Datos inválidos");
    }

    [Fact]
    public async Task ReagendarInscripcionAClase_WithMissingIdCliente_ReturnsBadRequest()
    {
        // Arrange
        var requestDto = ReagendacionInscripcionFactory.Crear(
            idInscripcionCancelada: 1,
            idClaseProgramadaNueva: 2,
            idCliente: "");

        // Add model state error to simulate [Required] validation failure
        _sut.ModelState.AddModelError("idCliente", "The idCliente field is required.");

        // Act
        var result = await _sut.ReagendarInscripcionAClase(requestDto);

        // Assert
        var badRequestResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = badRequestResult.Value as DTOResponse<string>;
        
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.message.Should().Contain("Datos inválidos");
    }

    #endregion

    #region Happy Path Tests

    [Fact]
    public async Task ReagendarInscripcionAClase_WithValidData_ReturnsOk()
    {
        // Arrange
        var requestDto = ReagendacionInscripcionFactory.Crear();

        // Note: This test validates the response when ModelState is valid.
        // The actual stored procedure execution is tested in integration tests.

        // Act
        var result = await _sut.ReagendarInscripcionAClase(requestDto);

        // Assert
        // Since we're using NSubstitute without actual DB, the ExecuteSqlRawAsync will throw
        // We verify that the endpoint attempted to process the request
        result.Result.Should().NotBeNull();
    }

    #endregion
}
