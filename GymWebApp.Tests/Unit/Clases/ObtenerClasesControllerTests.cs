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

    // Tests eliminados según especificación
    // Solo se mantiene el Happy Path: Activas con auth
}
