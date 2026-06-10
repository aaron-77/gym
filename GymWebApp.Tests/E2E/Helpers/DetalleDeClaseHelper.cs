using System.Data;
using DataAccess.EntityFramework;
using GymWebApp.Tests.SharedHelpers;

namespace GymWebApp.Tests.E2E.Helpers;

public static class DetalleDeClaseHelper
{
    /// <summary>
    /// Persiste una entidad Clase y devuelve el ClaseId generado.
    /// </summary>
    public static async Task<int> GuardarClaseAsync(string connectionString, Clase clase)
    {
        var result = await DatabaseHelper.ExecuteScalarAsync<int>(
            connectionString,
            @"INSERT INTO Clases (NombreClase, SubtituloClase, Cupo, Descripcion, duracionEnMinutos, fkIntensidad, fkDificultad, tiempoDeDescansoEnMinutos, duracionEnMinutosConDescansoIncluido, fkEstadoClase, InstructorId)
              VALUES (@NombreClase, @SubtituloClase, @Cupo, @Descripcion, @DuracionEnMinutos, @FkIntensidad, @FkDificultad, @TiempoDeDescansoEnMinutos, @DuracionEnMinutosConDescansoIncluido, @FkEstadoClase, @InstructorId);
              SELECT CAST(SCOPE_IDENTITY() AS INT);",
            new()
            {
                ["@NombreClase"] = clase.NombreClase,
                ["@SubtituloClase"] = (object?)clase.SubtituloClase ?? DBNull.Value,
                ["@Cupo"] = clase.Cupo,
                ["@Descripcion"] = (object?)clase.Descripcion ?? DBNull.Value,
                ["@DuracionEnMinutos"] = (object?)clase.DuracionEnMinutos ?? DBNull.Value,
                ["@FkIntensidad"] = (object?)clase.FkIntensidad ?? DBNull.Value,
                ["@FkDificultad"] = (object?)clase.FkDificultad ?? DBNull.Value,
                ["@TiempoDeDescansoEnMinutos"] = clase.TiempoDeDescansoEnMinutos,
                ["@DuracionEnMinutosConDescansoIncluido"] = clase.DuracionEnMinutosConDescansoIncluido,
                ["@FkEstadoClase"] = (object?)clase.FkEstadoClase ?? DBNull.Value,
                ["@InstructorId"] = (object?)clase.InstructorId ?? DBNull.Value
            });

        return result ;
    }

    /// <summary>
    /// Persiste una imagen de clase.
    /// </summary>
    public static async Task GuardarImagenAsync(string connectionString, ImagesForClase imagen)
    {
        await DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            @"INSERT INTO imagesForClases (fkClase, urlParaBanner, urlParaParaDescripcionDeClase, urlParaBloqueConsejos, FechaDeCreacion, FechaDeModificacion)
              VALUES (@fkClase, @UrlParaBanner, @UrlParaParaDescripcionDeClase, @UrlParaBloqueConsejos, @FechaDeCreacion, @FechaDeModificacion);",
            new()
            {
                ["@fkClase"] = imagen.FkClase,
                ["@UrlParaBanner"] = (object?)imagen.UrlParaBanner ?? DBNull.Value,
                ["@UrlParaParaDescripcionDeClase"] = (object?)imagen.UrlParaParaDescripcionDeClase ?? DBNull.Value,
                ["@UrlParaBloqueConsejos"] = (object?)imagen.UrlParaBloqueConsejos ?? DBNull.Value,
                ["@FechaDeCreacion"] = imagen.FechaDeCreacion,
                ["@FechaDeModificacion"] = imagen.FechaDeModificacion
            });
    }

    /// <summary>
    /// Persiste una lista de beneficios de clase.
    /// </summary>
    public static async Task GuardarListaBeneficiosAsync(string connectionString, List<BeneficiosDeClase> beneficios)
    {
        foreach (var beneficio in beneficios)
        {
            await DatabaseHelper.ExecuteNonQueryAsync(
                connectionString,
                @"INSERT INTO beneficiosDeClase (fkClase, beneficio, fechaDeCreacion, fechaDeModificacion, fkIcon, descripcionBeneficio)
                  VALUES (@fkClase, @Beneficio, @FechaDeCreacion, @FechaDeModificacion, @FkIcon, @DescripcionBeneficio);",
                new()
                {
                    ["@fkClase"] = beneficio.FkClase,
                    ["@Beneficio"] = beneficio.Beneficio,
                    ["@FechaDeCreacion"] = (object?)beneficio.FechaDeCreacion ?? DBNull.Value,
                    ["@FechaDeModificacion"] = (object?)beneficio.FechaDeModificacion ?? DBNull.Value,
                    ["@FkIcon"] = (object?)beneficio.FkIcon ?? DBNull.Value,
                    ["@DescripcionBeneficio"] = (object?)beneficio.DescripcionBeneficio ?? DBNull.Value
                });
        }
    }

    /// <summary>
    /// Persiste una lista de bloques de estructura de clase.
    /// </summary>
    public static async Task GuardarListaBloquesAsync(string connectionString, List<EstructuraDeClase> bloques)
    {
        foreach (var bloque in bloques)
        {
            await DatabaseHelper.ExecuteNonQueryAsync(
                connectionString,
                @"INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
                  VALUES (@fkClase, @NumeroConsecutivoDelBloque, @DuracionMenorEnMinutos, @DuracionMayorEnMinutos, @TituloBloque, @DescripcionBloque, @FechaDeCreacion, @FechaDeModificacion);",
                new()
                {
                    ["@fkClase"] = bloque.FkClase,
                    ["@NumeroConsecutivoDelBloque"] = bloque.NumeroConsecutivoDelBloque,
                    ["@DuracionMenorEnMinutos"] = bloque.DuracionMenorEnMinutos,
                    ["@DuracionMayorEnMinutos"] = bloque.DuracionMayorEnMinutos,
                    ["@TituloBloque"] = bloque.TituloBloque,
                    ["@DescripcionBloque"] = bloque.DescripcionBloque,
                    ["@FechaDeCreacion"] = (object?)bloque.FechaDeCreacion ?? DBNull.Value,
                    ["@FechaDeModificacion"] = (object?)bloque.FechaDeModificacion ?? DBNull.Value
                });
        }
    }

    /// <summary>
    /// Persiste un consejo de clase.
    /// </summary>
    public static async Task GuardarConsejoAsync(string connectionString, ConsejosParaLasClase consejo)
    {
        await DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            @"INSERT INTO consejosParaLasClases (fkClase, introduccionDeConsejo, consejos)
              VALUES (@fkClase, @IntroduccionDeConsejo, @Consejos);",
            new()
            {
                ["@fkClase"] = (object?)consejo.FkClase ?? DBNull.Value,
                ["@IntroduccionDeConsejo"] = consejo.IntroduccionDeConsejo,
                ["@Consejos"] = consejo.Consejos
            });
    }

    /// <summary>
    /// Persiste una lista de clases programadas y devuelve los IdProgramacionClase generados.
    /// </summary>
    public static async Task<List<int>> GuardarListaClasesProgramadasAsync(string connectionString, List<ClasesProgramada> clasesProgramadas)
    {
        var ids = new List<int>();

        foreach (var cp in clasesProgramadas)
        {
            var result = await DatabaseHelper.ExecuteScalarAsync<int>(
                connectionString,
                @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaCreacion, fechaModificacion, fkEntrenador, fechaDeLaClase)
                  VALUES (@fkClase, @CupoMaximo, @FkEstadoClaseProgramada, @FechaCreacion, @FechaModificacion, @FkEntrenador, @FechaDeLaClase);
                  SELECT CAST(SCOPE_IDENTITY() AS INT);",
                new()
                {
                    ["@fkClase"] = cp.FkClase,
                    ["@CupoMaximo"] = cp.CupoMaximo,
                    ["@FkEstadoClaseProgramada"] = cp.FkEstadoClaseProgramada,
                    ["@FechaCreacion"] = (object?)cp.FechaCreacion ?? DBNull.Value,
                    ["@FechaModificacion"] = (object?)cp.FechaModificacion ?? DBNull.Value,
                    ["@FkEntrenador"] = (object?)cp.FkEntrenador ?? DBNull.Value,
                    ["@FechaDeLaClase"] = (object?)cp.FechaDeLaClase ?? DBNull.Value
                });

            ids.Add(result);
        }

        return ids;
    }

    /// <summary>
    /// Persiste una lista de horarios de clase programada.
    /// </summary>
    public static async Task GuardarListaHorariosAsync(string connectionString, List<HorariosDeClasesProgramada> horarios)
    {
        foreach (var horario in horarios)
        {
            await DatabaseHelper.ExecuteNonQueryAsync(
                connectionString,
                @"INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral, fkEstadoHorarioClase)
                  VALUES (@fkClaseProgramada, @fkHorarioLaboral, @fkEstadoHorarioClase);",
                new()
                {
                    ["@fkClaseProgramada"] = horario.FkClaseProgramada,
                    ["@fkHorarioLaboral"] = horario.FkHorarioLaboral,
                    ["@fkEstadoHorarioClase"] = horario.FkEstadoHorarioClase
                });
        }
    }

    /// <summary>
    /// Obtiene el ID de un entrenador existente en la BD para usar como FK.
    /// </summary>
    public static async Task<string?> ObtenerEntrenadorIdAsync(string connectionString)
    {
        var result = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 u.Id FROM AspNetUsers u
              INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId
              INNER JOIN AspNetRoles r ON ur.RoleId = r.Id
              WHERE r.Name = @RoleName",
            new() { ["@RoleName"] = "empleado" });

        return result?["Id"]?.ToString();
    }

    /// <summary>
    /// Obtiene los IDs de horas laborales existentes para usar como FK.
    /// </summary>
    public static async Task<List<int>> ObtenerHorasLaboralesAsync(string connectionString)
    {
        return await DatabaseHelper.ExecuteQueryAsync(
            connectionString,
            "SELECT idHora FROM horasLaborales ORDER BY idHora",
            row => Convert.ToInt32(row["idHora"]));
    }
}
