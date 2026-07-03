using FluentAssertions;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using NSubstitute;
using Xunit;
using API.Services;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.Dtos;

namespace GymWebApp.Tests.Unit.Inscripciones;

public class ServiceConsultarInscripcionesDeClienteTests
{
    private readonly FitnessCenterDbContext _mockContext;
    private readonly UserManager<ApplicationUser> _mockUserManager;
    private readonly ILogger<ServiceConsultarInscripcionesDeCliente> _mockLogger;
    private readonly ServiceConsultarInscripcionesDeCliente _sut;

    public ServiceConsultarInscripcionesDeClienteTests()
    {
        _mockContext = Substitute.For<FitnessCenterDbContext>();
        _mockLogger = Substitute.For<ILogger<ServiceConsultarInscripcionesDeCliente>>();

        var mockUserStore = Substitute.For<IUserStore<ApplicationUser>>();
        _mockUserManager = Substitute.For<UserManager<ApplicationUser>>(
            mockUserStore,
            null!, null!, null!, null!, null!, null!, null!, null!);

        _sut = new ServiceConsultarInscripcionesDeCliente(
            _mockContext, _mockUserManager, _mockLogger);
    }

    #region Validation Tests - Guard Clauses

    [Fact]
    public async Task ConsultarInscripcionesAsync_NullId_ReturnsBadRequest()
    {
        // Act
        var result = await _sut.ConsultarInscripcionesAsync(null!);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("ID de usuario"));
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_EmptyId_ReturnsBadRequest()
    {
        // Act
        var result = await _sut.ConsultarInscripcionesAsync(string.Empty);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("ID de usuario"));
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_WhitespaceId_ReturnsBadRequest()
    {
        // Act
        var result = await _sut.ConsultarInscripcionesAsync("   ");

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("ID de usuario"));
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_InvalidGuidFormat_ReturnsBadRequest()
    {
        // Act
        var result = await _sut.ConsultarInscripcionesAsync("abc123");

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("GUID"));
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_UserNotFound_ReturnsNotFound()
    {
        // Arrange
        var validGuid = Guid.NewGuid().ToString();
        _mockUserManager.FindByIdAsync(validGuid).Returns((ApplicationUser?)null);

        // Act
        var result = await _sut.ConsultarInscripcionesAsync(validGuid);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(404);
        result.errors.Should().Contain(e => e.message.Contains("no existe"));
    }

    #endregion

    #region Happy Path Tests

    [Fact]
    public async Task ConsultarInscripcionesAsync_ValidRequest_ReturnsOkWithList()
    {
        // Arrange
        var validGuid = Guid.NewGuid().ToString();

        var expectedInscripciones = new List<DTOInscripcionDelCliente>
        {
            new()
            {
                IdInscripcion = 1,
                FechaDeInscripcion = DateTime.Now.AddDays(-5),
                IdClaseProgramada = 10,
                NombreClase = "Spinning",
                FechaDeLaClase = DateTime.Now.AddDays(10),
                HoraInicio = new TimeSpan(8, 0, 0),
                HoraFin = new TimeSpan(9, 0, 0),
                NombreEntrenador = "Juan Pérez"
            },
            new()
            {
                IdInscripcion = 2,
                FechaDeInscripcion = DateTime.Now.AddDays(-3),
                IdClaseProgramada = 15,
                NombreClase = "Yoga",
                FechaDeLaClase = DateTime.Now.AddDays(12),
                HoraInicio = new TimeSpan(10, 0, 0),
                HoraFin = new TimeSpan(11, 0, 0),
                NombreEntrenador = "María García"
            }
        };

        _mockUserManager.FindByIdAsync(validGuid).Returns(new ApplicationUser { Id = validGuid });

        var service = new ServiceConsultarInscripcionesDeClienteTestable(
            _mockContext, _mockUserManager, _mockLogger)
        {
            OnExecuteQueryAsync = _ => Task.FromResult(expectedInscripciones)
        };

        // Act
        var result = await service.ConsultarInscripcionesAsync(validGuid);

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload.Should().HaveCount(2);
        result.payload.Should().Contain(i => i.NombreClase == "Spinning");
        result.payload.Should().Contain(i => i.NombreClase == "Yoga");
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_ValidRequestNoInscriptions_ReturnsOkWithEmptyList()
    {
        // Arrange
        var validGuid = Guid.NewGuid().ToString();

        _mockUserManager.FindByIdAsync(validGuid).Returns(new ApplicationUser { Id = validGuid });

        var service = new ServiceConsultarInscripcionesDeClienteTestable(
            _mockContext, _mockUserManager, _mockLogger)
        {
            OnExecuteQueryAsync = _ => Task.FromResult(new List<DTOInscripcionDelCliente>())
        };

        // Act
        var result = await service.ConsultarInscripcionesAsync(validGuid);

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload.Should().BeEmpty();
    }

    [Fact]
    public async Task ConsultarInscripcionesAsync_DatabaseError_ReturnsServerError()
    {
        // Arrange
        var validGuid = Guid.NewGuid().ToString();

        _mockUserManager.FindByIdAsync(validGuid).Returns(new ApplicationUser { Id = validGuid });

        var service = new ServiceConsultarInscripcionesDeClienteTestable(
            _mockContext, _mockUserManager, _mockLogger)
        {
            OnExecuteQueryAsync = _ => throw new InvalidOperationException("Error de BD simulado")
        };

        // Act
        var result = await service.ConsultarInscripcionesAsync(validGuid);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(500);
    }

    #endregion
}

internal class ServiceConsultarInscripcionesDeClienteTestable : ServiceConsultarInscripcionesDeCliente
{
    public Func<string, Task<List<DTOInscripcionDelCliente>>>? OnExecuteQueryAsync { get; set; }

    public ServiceConsultarInscripcionesDeClienteTestable(
        FitnessCenterDbContext context,
        UserManager<ApplicationUser> userManager,
        ILogger<ServiceConsultarInscripcionesDeCliente> logger)
        : base(context, userManager, logger)
    {
    }

    protected override Task<List<DTOInscripcionDelCliente>> ExecuteQueryAsync(string idUsuario)
    {
        return OnExecuteQueryAsync?.Invoke(idUsuario)
               ?? Task.FromResult(new List<DTOInscripcionDelCliente>());
    }
}
