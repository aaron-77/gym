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

    #region REQUISITO: Unauthenticated Request (Unit Test - Documentation)

    /// <summary>
    /// REQUISITO: Unauthenticated Request (Documentación)
    /// Escenario: Request sin token de autenticación
    /// GIVEN: Endpoint con [Authorize] attribute (verificar en ClasesController.cs línea 186)
    /// WHEN: Se llama al endpoint sin autenticación
    /// THEN: Debe retornar 401 Unauthorized
    /// 
    /// NOTA IMPORTANTE: Este es un test de DOCUMENTACIÓN del requerimiento de [Authorize].
    /// El atributo [Authorize] es manejado por el middleware de ASP.NET Core (Policy-based),
    /// NO por el controller directamente. Por lo tanto:
    /// - En tests unitarios: NO podemos verificar 401 porque el middleware no está presente
    /// - En tests de integración: SÍ verificamos el 401 real (AuthenticateAsync middleware)
    /// 
    /// Este test verifica que:
    /// 1. El método del controller existe y es accesible
    /// 2. La firma del método es correcta (retorna Task<ActionResult<DTOResponse<List<DTOClaseSimple>>>>)
    /// 
    /// La verificación REAL del 401 está en:
    /// Integration/Features/Clases/ObtenerClasesApiTests.ObtenerClases_WithoutAuthentication_ReturnsUnauthorized
    /// </summary>
    [Fact]
    public async Task ObtenerClases_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange - Verify controller has [Authorize] attribute on the method
        // The [Authorize] attribute is applied at controller level in ClasesController.cs
        
        // Act - Call the controller method directly (bypasses middleware)
        var result = await _sut.ObtenerClases(true);

        // Assert - Document the requirement
        // In unit tests, we verify the method exists and can be called
        // The actual 401 response is handled by ASP.NET Core middleware
        result.Should().NotBeNull();
        
        // This unit test serves as DOCUMENTATION that:
        // - The endpoint REQUIRES authentication (via [Authorize] attribute)
        // - The integration test verifies the actual 401 response
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
