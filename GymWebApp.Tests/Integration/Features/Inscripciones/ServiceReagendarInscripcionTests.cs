using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

using API.Services;
using DTO.Dtos;
using BL.Utils.Enums;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;

namespace GymWebApp.Tests.Integration.Features.Inscripciones;

/// <summary>
/// Tests de integración para InscripcionesService.ReagendarInscripcionAsync (spec 40).
/// Validan la interacción real con la BD: SP de reagendación, validaciones de fecha/hora,
/// guard clauses y edge cases de datos.
/// </summary>
[Collection("IntegrationTests")]
public class ServiceReagendarInscripcionTests : IntegrationTestBase
{
    private readonly IInscripcionesService _service;

    public ServiceReagendarInscripcionTests(
        CitasApiWebApplicationFactory<Program> factory,
        TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper)
    {
        _service = Factory.Services.GetRequiredService<IInscripcionesService>();
    }

    #region Happy Path

    [Fact]
    public async Task ReagendarInscripcionAsync_InscripcionValidaFutura_ReturnsOk()
    {
        // Arrange — generar inscripción con fecha posterior a la última clase existente
        var seedResult = await InscripcionTestHelper.SeedSingleInscripcionConFechaPosteriorAsync(
            TestContainerHelper.ConnectionString);

        if (seedResult == null)
        {
            var fallbackDate = await InscripcionTestHelper.SeedFallbackAsync(
                TestContainerHelper.ConnectionString, DateTime.Today.Year);

            if (fallbackDate == null)
                throw new InvalidOperationException("No se pudo encontrar fecha alternativa para el seed");

            seedResult = await InscripcionTestHelper.SeedSingleInscripcionConFechaPosteriorAsync(
                TestContainerHelper.ConnectionString,
                fallbackDate.Value.ToDateTime(TimeOnly.MinValue));
        }

        var (clienteId, idInscripcion) = seedResult!.Value;

        // Obtener el fkClase y fecha de la inscripción original para crear el destino con el MISMO tipo
        var claseOriginalRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT cp.fkClase, cp.fechaDeLaClase, cp.cupoMaximo
              FROM inscripcionesDeClases i
              INNER JOIN clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase
              WHERE i.idInscripcion = @IdInscripcion",
            new Dictionary<string, object?> { ["@IdInscripcion"] = idInscripcion })
            ?? throw new InvalidOperationException("No se encontró la inscripción original");

        var fechaOriginal = DateOnly.FromDateTime((DateTime)claseOriginalRow["fechaDeLaClase"]);

        // Crear una clase programada destino con fecha posterior a la original y el mismo fkClase
        // Usamos ObtenerHorariosDisponiblesFiltrados y filtramos manualmente para garantizar
        // que la fecha destino sea estrictamente posterior a la fecha original.
        var horariosDisponibles = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            TestContainerHelper.ConnectionString,
            FiltroFecha.Mayor,
            FiltroHora.SinFiltro);

        var horariosPosteriores = horariosDisponibles
            .Where(h => h["FechaDisponible"] != null
                        && DateOnly.FromDateTime(Convert.ToDateTime(h["FechaDisponible"])) > fechaOriginal)
            .ToList();

        var fechaDisponible = horariosPosteriores.Count > 0
            ? DateOnly.FromDateTime(Convert.ToDateTime(
                horariosPosteriores[new Random().Next(horariosPosteriores.Count)]["FechaDisponible"]))
            : fechaOriginal.AddDays(30);

        var idHoraFutura = await InscripcionTestHelper.GetIdHoraLaboralFuturaAsync(
            TestContainerHelper.ConnectionString);

        var idEstadoDisponible = await DatabaseHelper.ExecuteScalarAsync<int?>(
            TestContainerHelper.ConnectionString,
            "SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas")
            ?? 1;

        var destinoRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador)
              OUTPUT INSERTED.idProgramacionClase
              VALUES (@FkClase, @CupoMaximo, @Estado, @FechaDisponible, @FkEntrenador)",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = claseOriginalRow!["fkClase"],
                ["@CupoMaximo"] = claseOriginalRow["cupoMaximo"],
                ["@Estado"] = idEstadoDisponible,
                ["@FechaDisponible"] = fechaDisponible,
                ["@FkEntrenador"] = (await DatabaseHelper.ExecuteQuerySingleAsync(
                    TestContainerHelper.ConnectionString,
                    "EXEC dbo.sp_obtenerEntrenadoresDisponibles @fechaReferencia = @Fecha",
                    new Dictionary<string, object?> { ["@Fecha"] = DateTime.Now }))!["UsuarioID"]
            });

        var idClaseDestino = Convert.ToInt32(destinoRow!["idProgramacionClase"]);

        await DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral)
              VALUES (@FkClaseProgramada, @FkHorarioLaboral)",
            new Dictionary<string, object?>
            {
                ["@FkClaseProgramada"] = idClaseDestino,
                ["@FkHorarioLaboral"] = idHoraFutura
            });

        // Act
        var result = await _service.ReagendarInscripcionAsync
            (idInscripcion, idClaseDestino, clienteId);

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().BeTrue();
    }

    #endregion

    #region Edge Cases — Casos con BD

    [Fact]
    public async Task ReagendarInscripcionAsync_InscripcionInexistente_ReturnsNotFound()
    {
        // Act — ID alto que seguro no existe en BD
        var result = await _service.ReagendarInscripcionAsync(999999, 1, "cliente-id");

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(404);
        result.errors.Should().Contain(e => e.message.Contains("no existe"));
    }

    [Fact]
    public async Task ReagendarInscripcionAsync_InscripcionFechaPasada_ReturnsBadRequest()
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
        string idCliente;

        if (existingRow != null)
        {
            idInscripcion = Convert.ToInt32(existingRow["idInscripcion"]);

            var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
                TestContainerHelper.ConnectionString,
                "SELECT fkCliente FROM inscripcionesDeClases WHERE idInscripcion = @Id",
                new Dictionary<string, object?> { ["@Id"] = idInscripcion });

            idCliente = clienteRow?["fkCliente"]?.ToString() ?? "cliente-id";
        }
        else
        {
            // No hay clases pasadas → crear una con fecha de ayer
            (idCliente, idInscripcion) = await InscripcionTestHelper.SeedSingleInscripcionConFechaPasadaAsync(
                TestContainerHelper.ConnectionString);
        }

        // Crear clase destino válida (misma fkClase, fecha futura, horario futuro)
        var idClaseDestino = await InscripcionTestHelper.CreateValidDestinationClassForReagendarAsync(
            TestContainerHelper.ConnectionString, idInscripcion)
            ?? throw new InvalidOperationException("No se pudo crear una clase destino para el test");

        // Act
        var result = await _service.ReagendarInscripcionAsync(idInscripcion, idClaseDestino, idCliente);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("finalizó"));
    }

    [Fact]
    public async Task ReagendarInscripcionAsync_InscripcionHoyHoraPasada_ReturnsBadRequest()
    {
        // Arrange
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
        string idCliente;

        if (existingRow != null)
        {
            idInscripcion = Convert.ToInt32(existingRow["idInscripcion"]);

            var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
                TestContainerHelper.ConnectionString,
                "SELECT fkCliente FROM inscripcionesDeClases WHERE idInscripcion = @Id",
                new Dictionary<string, object?> { ["@Id"] = idInscripcion });

            idCliente = clienteRow?["fkCliente"]?.ToString() ?? "cliente-id";
        }
        else
        {
            // 2. No existe inscripción con hora pasada → crear una directamente
            //    con fecha hoy y hora laboral anterior a la actual
            (idCliente, idInscripcion) = await InscripcionTestHelper.SeedSingleInscripcionConHoraPasadaAsync(
                TestContainerHelper.ConnectionString);
        }

        // Crear clase destino válida (misma fkClase, fecha futura, horario futuro)
        var idClaseDestino = await InscripcionTestHelper.CreateValidDestinationClassForReagendarAsync(
            TestContainerHelper.ConnectionString, idInscripcion)
            ?? throw new InvalidOperationException("No se pudo crear una clase destino para el test");

        // Act
        var result = await _service.ReagendarInscripcionAsync(idInscripcion, idClaseDestino, idCliente);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("comenzó"));
    }

    [Fact]
    public async Task ReagendarInscripcionAsync_ClaseDestinoInexistente_ReturnsNotFound()
    {
        // Arrange — generar inscripción válida con fecha futura
        var seedResult = await InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync(
            TestContainerHelper.ConnectionString);

        if (seedResult == null)
        {
            var fallbackDate = await InscripcionTestHelper.SeedFallbackAsync(
                TestContainerHelper.ConnectionString, DateTime.Today.Year);

            if (fallbackDate == null)
                throw new InvalidOperationException("No se pudo encontrar fecha alternativa para el seed");

            seedResult = await InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync(
                TestContainerHelper.ConnectionString,
                fallbackDate.Value.ToDateTime(TimeOnly.MinValue));
        }

        var (clienteId, idInscripcion) = seedResult!.Value;

        // Act — pasar idClaseProgramada que no existe (la validación de fecha pasa primero,
        // luego busca la clase destino y no la encuentra)
        var result = await _service.ReagendarInscripcionAsync(idInscripcion, 999999, clienteId);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(404);
        result.errors.Should().Contain(e => e.message.Contains("no existe"));
    }

    [Fact]
    public async Task ReagendarInscripcionAsync_TipoClaseDestinoDiferente_ReturnsBadRequest()
    {
        // Arrange — generar inscripción con fecha futura
        var seedResult = await InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync(
            TestContainerHelper.ConnectionString);

        if (seedResult == null)
        {
            var fallbackDate = await InscripcionTestHelper.SeedFallbackAsync(
                TestContainerHelper.ConnectionString, DateTime.Today.Year);

            if (fallbackDate == null)
                throw new InvalidOperationException("No se pudo encontrar fecha alternativa para el seed");

            seedResult = await InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync(
                TestContainerHelper.ConnectionString,
                fallbackDate.Value.ToDateTime(TimeOnly.MinValue));
        }

        var (clienteId, idInscripcion) = seedResult!.Value;

        // Obtener el fkClase original de la inscripción
        var claseOriginalRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT cp.fkClase
              FROM inscripcionesDeClases i
              INNER JOIN clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase
              WHERE i.idInscripcion = @IdInscripcion",
            new Dictionary<string, object?> { ["@IdInscripcion"] = idInscripcion });

        var fkClaseOriginal = Convert.ToInt32(claseOriginalRow!["fkClase"]);

        // Buscar una clase de distinto tipo
        var otraClaseRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 ClaseID, Cupo FROM Clases WHERE ClaseID != @FkClase ORDER BY NEWID()",
            new Dictionary<string, object?> { ["@FkClase"] = fkClaseOriginal })
            ?? throw new InvalidOperationException("No hay clases de distinto tipo en la tabla Clases");

        var fkClaseDistinta = Convert.ToInt32(otraClaseRow["ClaseID"]);
        var cupoMaximo = Convert.ToInt32(otraClaseRow["Cupo"]);

        // Crear clase programada destino con tipo distinto y fecha futura (para pasar validación de fecha).
        // No necesita horariosDeClasesProgramadas porque la validación de fkClase (paso 11) ocurre
        // antes de ejecutar el SP.
        var idEstadoDisponible = await DatabaseHelper.ExecuteScalarAsync<int?>(
            TestContainerHelper.ConnectionString,
            "SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas")
            ?? 1;

        var destinoRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase)
              OUTPUT INSERTED.idProgramacionClase
              VALUES (@FkClase, @CupoMaximo, @Estado, DATEADD(DAY, 1, CAST(GETDATE() AS DATE)))",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = fkClaseDistinta,
                ["@CupoMaximo"] = cupoMaximo,
                ["@Estado"] = idEstadoDisponible
            });

        var idClaseDestino = Convert.ToInt32(destinoRow!["idProgramacionClase"]);

        // Act
        var result = await _service.ReagendarInscripcionAsync(idInscripcion, idClaseDestino, clienteId);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("tipo de clase"));
    }

    [Fact]
    public async Task ReagendarInscripcionAsync_FechaDestinoMenorOIgual_ReturnsBadRequest()
    {
        // Arrange — generar inscripción con fecha futura
        var seedResult = await InscripcionTestHelper.SeedSingleInscripcionConFechaPosteriorAsync(
            TestContainerHelper.ConnectionString);

        if (seedResult == null)
        {
            var fallbackDate = await InscripcionTestHelper.SeedFallbackAsync(
                TestContainerHelper.ConnectionString, DateTime.Today.Year);

            if (fallbackDate == null)
                throw new InvalidOperationException("No se pudo encontrar fecha alternativa para el seed");

            seedResult = await InscripcionTestHelper.SeedSingleInscripcionConFechaPosteriorAsync(
                TestContainerHelper.ConnectionString,
                fallbackDate.Value.ToDateTime(TimeOnly.MinValue));
        }

        var (clienteId, idInscripcion) = seedResult!.Value;

        // Obtener datos originales: fkClase, fkEntrenador, fkHorarioLaboral
        var claseOriginalRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT cp.fkClase, cp.fechaDeLaClase, cp.fkEntrenador, hcp.fkHorarioLaboral
              FROM inscripcionesDeClases i
              INNER JOIN clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase
              INNER JOIN horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
              WHERE i.idInscripcion = @IdInscripcion",
            new Dictionary<string, object?> { ["@IdInscripcion"] = idInscripcion })
            ?? throw new InvalidOperationException("No se encontró la inscripción original");

        const int cupoMaximo = 99;

        var fkClaseOriginal = Convert.ToInt32(claseOriginalRow["fkClase"]);
        var fkEntrenadorOriginal = claseOriginalRow["fkEntrenador"]?.ToString()
            ?? throw new InvalidOperationException("La inscripción original no tiene entrenador");
        var fkHorarioLaboralOriginal = Convert.ToInt32(claseOriginalRow["fkHorarioLaboral"]);

        var idEstadoDisponible = await DatabaseHelper.ExecuteScalarAsync<int?>(
            TestContainerHelper.ConnectionString,
            "SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas")
            ?? 1;

        // Insertar clase destino con fecha = AYER para que falle la validación
        // de fecha destino (clase ya finalizó).
        // Se incluye el MISMO entrenador y horario que la original.
        var fechaAyer = DateOnly.FromDateTime(DateTime.Today.AddDays(-1));
        var destinoRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador)
              OUTPUT INSERTED.idProgramacionClase
              VALUES (@FkClase, @CupoMaximo, @Estado, @FechaClase, @FkEntrenador)",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = fkClaseOriginal,
                ["@CupoMaximo"] = cupoMaximo,
                ["@Estado"] = idEstadoDisponible,
                ["@FechaClase"] = fechaAyer,
                ["@FkEntrenador"] = fkEntrenadorOriginal
            });

        var idClaseDestino = Convert.ToInt32(destinoRow!["idProgramacionClase"]);

        // Insertar horario con el MISMO fkHorarioLaboral que la original
        await DatabaseHelper.ExecuteNonQueryAsync(
            TestContainerHelper.ConnectionString,
            @"INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral)
              VALUES (@FkClaseProgramada, @FkHorarioLaboral)",
            new Dictionary<string, object?>
            {
                ["@FkClaseProgramada"] = idClaseDestino,
                ["@FkHorarioLaboral"] = fkHorarioLaboralOriginal
            });

        // Act
        var result = await _service.ReagendarInscripcionAsync(idInscripcion, idClaseDestino, clienteId);

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
        result.errors.Should().Contain(e => e.message.Contains("menor"));
    }

    #endregion
}
