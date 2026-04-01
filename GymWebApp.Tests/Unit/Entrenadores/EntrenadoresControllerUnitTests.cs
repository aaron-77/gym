using API.Controllers;
using DataAccess.EntityFramework;
using DTO.Dtos;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using NSubstitute;
using Microsoft.EntityFrameworkCore;

namespace GymWebApp.Tests.Unit.Entrenadores;

public class EntrenadoresControllerUnitTests
{
    private readonly FitnessCenterDbContext _mockDb;
    private readonly ILogger<EntrenadoresController> _mockLogger;
    private readonly EntrenadoresController _controller;

    public EntrenadoresControllerUnitTests()
    {
        _mockLogger = Substitute.For<ILogger<EntrenadoresController>>();
        _mockDb = Substitute.For<FitnessCenterDbContext>();
        
        _controller = new EntrenadoresController(_mockDb, _mockLogger);
    }

    #region Sad Path 1: Fecha vacía o nula

    [Fact]
    public async Task ObtenerEntrenadoresDisponibles_WithEmptyDate_ReturnsBadRequest()
    {
        var result = await _controller.ObtenerEntrenadoresDisponibles("");
        
        var response = (DTOResponse<List<QueryUser>>)((BadRequestObjectResult)result).Value;
        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.message.Should().Be("La fecha tiene un formato incorrecto");
    }

    [Fact]
    public async Task ObtenerEntrenadoresDisponibles_WithNullDate_ReturnsBadRequest()
    {
        var result = await _controller.ObtenerEntrenadoresDisponibles(null!);
        
        var response = (DTOResponse<List<QueryUser>>)((BadRequestObjectResult)result).Value;
        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.message.Should().Be("La fecha tiene un formato incorrecto");
    }

    [Fact]
    public async Task ObtenerEntrenadoresDisponibles_WithWhitespaceDate_ReturnsBadRequest()
    {
        var result = await _controller.ObtenerEntrenadoresDisponibles("   ");
        
        var response = (DTOResponse<List<QueryUser>>)((BadRequestObjectResult)result).Value;
        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.message.Should().Be("La fecha tiene un formato incorrecto");
    }

    [Fact]
    public async Task ObtenerEntrenadoresDisponibles_WithInvalidFormat_ReturnsBadRequest()
    {
        var result = await _controller.ObtenerEntrenadoresDisponibles("not-a-date");
        
        var response = (DTOResponse<List<QueryUser>>)((BadRequestObjectResult)result).Value;
        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.message.Should().Be("La fecha tiene un formato incorrecto");
    }

    #endregion

    #region Sad Path 2: Fecha anterior a la actual

    [Fact]
    public async Task ObtenerEntrenadoresDisponibles_WithPastDate_ReturnsBadRequest()
    {
        var pastDate = DateTime.Now.AddDays(-10).ToString("yyyy-MM-dd");
        var result = await _controller.ObtenerEntrenadoresDisponibles(pastDate);
        
        var response = (DTOResponse<List<QueryUser>>)((BadRequestObjectResult)result).Value;
        response.success.Should().BeFalse();
        response.httpCode.Should().Be(400);
        response.message.Should().Be("La fecha no puede ser anterior a la fecha actual");
    }

    #endregion
}