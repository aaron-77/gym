using API.Controllers;
using API.Hubs;
using API.Services;
using BL;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.Dtos;
using FluentAssertions;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using NSubstitute;
using System.Collections.Generic;
using System.Threading.Tasks;
using Xunit;

namespace GymWebApp.Tests.Unit.Clases;

public class ObtenerClasesControllerTests
{
    private readonly FitnessCenterDbContext _mockContext;
    private readonly HttpCustomClient _mockHttpClient;
    private readonly UserRoleService _mockUserRoleService;
    private readonly ServicioActualizacionesDeHorariosRealTime _mockServicioActualizaciones;
    private readonly IClasesService _mockClasesService;
    private readonly ILogger<ClasesController> _mockLogger;
    private readonly UserManager<ApplicationUser> _mockUserManager;
    private readonly ClasesController _sut;

    public ObtenerClasesControllerTests()
    {
        // Arrange - Setup Substitutes (same pattern as existing tests)
        _mockContext = Substitute.For<FitnessCenterDbContext>();
        _mockHttpClient = Substitute.For<HttpCustomClient>(new HttpClient());
        _mockUserRoleService = Substitute.For<UserRoleService>(_mockContext, null!);
        _mockServicioActualizaciones = Substitute.For<ServicioActualizacionesDeHorariosRealTime>(_mockContext, null!, null!); 
        _mockClasesService = Substitute.For<IClasesService>();
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
            _mockUserManager,
            _mockLogger
        );
    }

    #region Sad Path 2 - ID inválido retorna BadRequest

    /// <summary>
    /// Escenario: Se intenta obtener clases programadas con ID inválido
    /// GIVEN: El ModelState tiene error en el campo idClase
    /// WHEN: Se llama al método obtenerClasesProgramadasPorId con id=0
    /// THEN: Debe retornar BadRequest con success=false
    /// </summary>
    [Fact]
    public async Task ObtenerClasesProgramadasPorId_ConIdCero_ReturnsBadRequest()
    {
        // Arrange
        _sut.ModelState.AddModelError("idClase", "The idClase field must be greater than 0.");
        
        // Act
        var result = await _sut.obtenerClasesProgramadasPorId(0);
        
        // Assert
        var badRequestResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = badRequestResult.Value as DTOResponse<List<DTOClaseProgramadaView>>;
        
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
    }

    /// <summary>
    /// Escenario: Se intenta obtener clases programadas con ID negativo
    /// GIVEN: El ModelState tiene error en el campo idClase
    /// WHEN: Se llama al método obtenerClasesProgramadasPorId con id=-5
    /// THEN: Debe retornar BadRequest con success=false
    /// </summary>
    [Fact]
    public async Task ObtenerClasesProgramadasPorId_ConIdNegativo_ReturnsBadRequest()
    {
        // Arrange
        _sut.ModelState.AddModelError("idClase", "The idClase field must be greater than 0.");
        
        // Act
        var result = await _sut.obtenerClasesProgramadasPorId(-5);
        
        // Assert
        var badRequestResult = result.Result.Should().BeOfType<BadRequestObjectResult>().Subject;
        var response = badRequestResult.Value as DTOResponse<List<DTOClaseProgramadaView>>;
        
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
    }

    #endregion

    // Tests eliminados según especificación
    // Solo se mantiene el Happy Path: Activas con auth
}
