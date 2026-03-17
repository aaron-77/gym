using API.Controllers;
using API.Hubs;
using API.Services;
using BL;
using DataAccess.EntityFramework;
using DTO.Dtos;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using NSubstitute;
using System.Net.Http;
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
        // Arrange - Setup NSubstitute mocks (following project standard)
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

    #region ObtenerClases Tests

    /// <summary>
    /// Test 1: Verify endpoint has [Authorize] attribute.
    /// </summary>
    [Fact]
    public void ObtenerClases_HasAuthorizeAttribute()
    {
        // Arrange - Get the method info
        var methodInfo = typeof(ClasesController).GetMethod("ObtenerClases");

        // Assert - Verify [Authorize] attribute is present
        methodInfo.Should().NotBeNull();
        var authorizeAttribute = methodInfo!.GetCustomAttributes(true)
            .OfType<Microsoft.AspNetCore.Authorization.AuthorizeAttribute>()
            .FirstOrDefault();

        authorizeAttribute.Should().NotBeNull();
    }

    /// <summary>
    /// Test 2: Verify 500 response when database error occurs.
    /// </summary>
    [Fact]
    public async Task ObtenerClases_WhenDatabaseError_Returns500()
    {
        // Arrange - Mockear _mockContext para que falle al acceder a Clases
        var mockDbSet = Substitute.For<DbSet<Clase>, IQueryable<Clase>>();
        _mockContext.Clases.Returns(mockDbSet);

        // Simular error en la consulta
        var queryable = Substitute.For<IQueryable<Clase>>();
        queryable.When(x => x.GetEnumerator()).Throws(new Exception("Error de base de datos"));
        queryable.Expression.Returns(Enumerable.Empty<Clase>().AsQueryable().Expression);
        queryable.ElementType.Returns(typeof(Clase));

        // Act
        var result = await _sut.ObtenerClases(true);

        // Assert - Verify 500 Internal Server Error response
        var objectResult = result.Result as ObjectResult;
        objectResult.Should().NotBeNull();
        objectResult!.StatusCode.Should().Be(500);

        var response = objectResult.Value as DTOResponse<List<DTOClaseSimple>>;
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
        response.httpCode.Should().Be(500);
        response.message.Should().Contain("Error");
    }

    #endregion
}
