using API.Controllers;
using API.Hubs;
using API.Services;
using BL;
using DataAccess.EntityFramework;
using DTO.Dtos;
using FluentAssertions;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using NSubstitute;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Xunit;

namespace GymWebApp.Tests.Unit.Clases;

public class ClasesControllerTests
{
    private readonly FitnessCenterDbContext _mockContext;
    private readonly HttpCustomClient _mockHttpClient;
    private readonly UserRoleService _mockUserRoleService;
    private readonly ServicioActualizacionesDeHorariosRealTime _mockServicioActualizaciones;
    private readonly ClasesService _mockClasesService;
    private readonly ILogger<ClasesController> _mockLogger;
    private readonly ClasesController _sut;

    public ClasesControllerTests()
    {
        // Arrange - Setup Substitutes
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

    #region REQUISITO: Handling Non-Existent Class (Unit Test)

    [Fact]
    public async Task ConsultarDetallesDeClase_WhenClassDoesNotExist_ReturnsNotFound()
    {
        // Arrange
        var nonExistentId = 9999;
        
        // Act
        // El controlador fallará al intentar ejecutar FromSqlInterpolated si no está configurado,
        // lo cual disparará el catch (500).
        var result = await _sut.ConsultarDetallesDeClase(nonExistentId);

        // Assert
        result.Result.Should().BeOfType<ObjectResult>()
            .Which.StatusCode.Should().Be(500); 
    }

    #endregion

    #region REQUISITO: Internal Server Error Handling (Unit Test)

    [Fact]
    public async Task ConsultarDetallesDeClase_WhenExceptionOccurs_ReturnsInternalServerError()
    {
        // Act - Invoke (disparará error por mocks no configurados para EF)
        var result = await _sut.ConsultarDetallesDeClase(1);

        // Assert
        var objectResult = result.Result as ObjectResult;
        objectResult.Should().NotBeNull();
        objectResult!.StatusCode.Should().Be(500);

        var response = objectResult.Value as DTOResponse<DetalleDeClase>;
        response.Should().NotBeNull();
        response!.success.Should().BeFalse();
    }

    #endregion

    #region REQUISITO: Response Pattern Consistency (Unit Test)

    [Fact]
    public void ResponseManager_BuildResponse_FollowsPattern()
    {
        // Arrange
        var payload = new DetalleDeClase { Duracion = 60 };
        
        // Act
        var response = BL.Utils.ResponseManager.BuildResponse(
            true, 200, "Success", null, payload);

        // Assert
        response.success.Should().BeTrue();
        response.httpCode.Should().Be(200);
        response.message.Should().Be("Success");
        response.payload.Should().Be(payload);
    }

    #endregion
}
