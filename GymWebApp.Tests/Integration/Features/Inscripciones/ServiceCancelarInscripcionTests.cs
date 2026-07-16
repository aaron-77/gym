using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

using API.Services;
using DTO.Dtos;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;

namespace GymWebApp.Tests.Integration.Features.Inscripciones;

/// <summary>
/// Tests de integración para InscripcionesService.CancelarInscripcionAsync (spec 38).
/// Validan la interacción real con la BD: SP de cancelación, validaciones de fecha/hora,
/// guard clauses y edge cases de datos.
/// </summary>
[Collection("IntegrationTests")]
public class ServiceCancelarInscripcionTests : IntegrationTestBase
{
    private readonly IInscripcionesService _service;

    public ServiceCancelarInscripcionTests(
        CitasApiWebApplicationFactory<Program> factory,
        TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper)
    {
        _service = Factory.Services.GetRequiredService<IInscripcionesService>();
    }

    #region Happy Path

    [Fact]
  
    
    public async Task CancelarInscripcionAsync_InscripcionValidaFutura_ReturnsOk()
    {
        // Arrange — generar inscripción con fecha posterior a la última clase existente
        var (_, idInscripcion) = await InscripcionTestHelper.SeedSingleInscripcionConFechaPosteriorAsync(
            TestContainerHelper.ConnectionString);
        // Act
        var result = await _service.CancelarInscripcionAsync(idInscripcion);

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().BeTrue();
    }

    #endregion

    #region Edge Cases — Guard Clauses

    [Fact]
    public async Task CancelarInscripcionAsync_IdCero_ReturnsBadRequest()
    {
        // Act
        var result = await _service.CancelarInscripcionAsync(0);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("mayor a 0"));
    }

    [Fact]
    public async Task CancelarInscripcionAsync_IdNegativo_ReturnsBadRequest()
    {
        // Act
        var result = await _service.CancelarInscripcionAsync(-1);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("mayor a 0"));
    }

    #endregion

    #region Edge Cases — Casos con BD

    [Fact]
    public async Task CancelarInscripcionAsync_InscripcionInexistente_ReturnsNotFound()
    {
        // Act — ID alto que seguro no existe en BD
        var result = await _service.CancelarInscripcionAsync(999999);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(404);
        result.errors.Should().Contain(e => e.message.Contains("no existe"));
    }

    [Fact]
    public async Task CancelarInscripcionAsync_InscripcionConFechaPasada_ReturnsBadRequest()
    {
        // Arrange — buscar inscripción existente con fecha pasada
        var existingRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 i.idInscripcion
              FROM inscripcionesDeClases i
              INNER JOIN clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase
              WHERE cp.fechaDeLaClase < CAST(GETDATE() AS DATE)
                AND i.fkEstadoInscripcion = (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase)
              ORDER BY NEWID()");

        int idInscripcion;

        if (existingRow != null)
        {
            idInscripcion = Convert.ToInt32(existingRow["idInscripcion"]);
        }
        else
        {
            // No hay clases pasadas → crear una con hora pasada
            (_, idInscripcion) = await InscripcionTestHelper.SeedSingleInscripcionConHoraPasadaAsync(
                TestContainerHelper.ConnectionString);
        }

        // Act
        var result = await _service.CancelarInscripcionAsync(idInscripcion);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("finalizó"));
    }

    [Fact]
    public async Task CancelarInscripcionAsync_InscripcionDeHoyConHoraPasada_ReturnsBadRequest()
    {
        //Arrange
        // 1. Buscar una inscripción existente con fecha hoy y hora pasada
        var existingRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 i.idInscripcion
              FROM inscripcionesDeClases i
              INNER JOIN clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase
              INNER JOIN horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
              INNER JOIN horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
              WHERE cp.fechaDeLaClase = CAST(GETDATE() AS DATE)
                AND i.fkEstadoInscripcion = 1
                AND hl.horaInicio < CAST(GETDATE() AS TIME)
              ORDER BY NEWID()");

        int idInscripcion;

        if (existingRow != null)
        {
            idInscripcion = Convert.ToInt32(existingRow["idInscripcion"]);
        }
        else
        {
            // 2. No existe inscripción con hora pasada → crear una directamente
            //    con fecha hoy y hora laboral anterior a la actual
            (_, idInscripcion) = await InscripcionTestHelper.SeedSingleInscripcionConHoraPasadaAsync(
                TestContainerHelper.ConnectionString);
        }

        // Act
        var result = await _service.CancelarInscripcionAsync(idInscripcion);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("comenzó"));
    }

    #endregion
}
