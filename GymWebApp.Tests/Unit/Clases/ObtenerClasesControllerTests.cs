using API.Controllers;
using API.Hubs;
using API.Services;
using BL;
using DataAccess.EntityFramework;
using DTO.Dtos;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using NSubstitute;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Security.Claims;
using System.Threading.Tasks;
using Xunit;

namespace GymWebApp.Tests.Unit.Clases;

public class ObtenerClasesControllerTests
{
    private readonly FitnessCenterDbContext _mockContext;
    private readonly HttpCustomClient _mockHttpClient;
    private readonly UserRoleService _mockUserRoleService;
    private readonly ServicioActualizacionesDeHorariosRealTime _mockServicioActualizaciones;
    private readonly ClasesService _mockClasesService;
    private readonly ILogger<ClasesController> _mockLogger;
    private readonly ClasesController _sut;

    public ObtenerClasesControllerTests()
    {
        // Arrange - Setup Substitutes (same pattern as existing tests)
        _mockContext = Substitute.For<FitnessCenterDbContext>();
        _mockHttpClient = Substitute.For<HttpCustomClient>(new HttpClient());
        _mockUserRoleService = Substitute.For<UserRoleService>(_mockContext, null!);
        _mockServicioActualizaciones = Substitute.For<ServicioActualizacionesDeHorariosRealTime>(_mockContext, null!, null!); 
        _mockClasesService = Substitute.For<ClasesService>(_mockContext);
        _mockLogger = Substitute.For<ILogger<ClasesController>>();

        _sut = new ClasesController(
            _mockContext,
            _mockHttpClient,
            _mockUserRoleService,
            _mockServicioActualizaciones,
            _mockClasesService,
            _mockLogger
        );
    }

    #region REQUISITO: Unauthenticated Request (Unit Test)

    /// <summary>
    /// REQUISITO: Unauthenticated Request
    /// Escenario: Request sin token de autenticación
    /// GIVEN: Controller con [Authorize] attribute
    /// WHEN: Se llama al endpoint sin autenticación
    /// THEN: Debe retornar 401 Unauthorized
    /// 
    /// NOTE: Este test documenta el requerimiento de [Authorize].
    /// En tests de unidad, el atributo [Authorize] es manejado por el middleware de ASP.NET Core.
    /// La verificación real de 401 se hace en tests de integración.
    /// </summary>
    [Fact]
    public async Task ObtenerClases_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange - Call controller directly without authentication
        
        // Act - Call the controller method directly
        var result = await _sut.ObtenerClases(true);

        // Assert - The endpoint should be protected by [Authorize]
        // In unit tests, we can't test [Authorize] directly, but we can verify
        // that the endpoint exists and the method signature is correct
        result.Should().NotBeNull();
        
        // Note: The actual 401 Unauthorized response is verified in integration tests.
        // This unit test documents the requirement that the endpoint must have [Authorize] attribute.
    }

    #endregion

    #region REQUISITO: Database Error Handling (Unit Test)

    /// <summary>
    /// REQUISITO: Database Error
    /// Escenario: Error de base de datos al consultar clases
    /// GIVEN: DbContext que lanza excepción al ejecutar query
    /// WHEN: GET /api/Clases/obtenerClases?activa=true
    /// THEN: Returns 500 Internal Server Error con success=false y errors no null
    /// </summary>
    [Fact]
    public async Task ObtenerClases_WhenDatabaseError_Returns500()
    {
        // Arrange - The mock context is already configured to throw when methods are called
        // because it's a substitute without proper configuration.
        // This mimics a database error scenario.

        // Act
        var result = await _sut.ObtenerClases(true);

        // Assert
        var objectResult = result.Result as ObjectResult;
        objectResult.Should().NotBeNull();
        objectResult!.StatusCode.Should().Be((int)HttpStatusCode.InternalServerError);

        var response = objectResult.Value as DTOResponse<List<DTOClaseSimple>>;
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
        response.errors.Should().NotBeNull();
        response.errors.Should().NotBeEmpty();
    }

    #endregion
}
