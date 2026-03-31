using DataAccess.EntityFramework;
using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Helpers;

public static class InscripcionClaseHelper
{
    public static async Task<int> InsertarInscripcionAsync(string connectionString, InscripcionesDeClase inscripcion)
    {
        var result = await DatabaseHelper.ExecuteScalarAsync<decimal>(
            connectionString,
            @"INSERT INTO inscripcionesDeClases (fkProgramacionClase, fechaDeInscripcion, fkEstadoInscripcion, fkCliente) 
              VALUES (@FkProgramacionClase, @FechaDeInscripcion, @FkEstadoInscripcion, @FkCliente);
              SELECT SCOPE_IDENTITY();",
            new Dictionary<string, object?>
            {
                ["@FkProgramacionClase"] = inscripcion.FkProgramacionClase,
                ["@FechaDeInscripcion"] = inscripcion.FechaDeInscripcion ?? DateTime.Now,
                ["@FkEstadoInscripcion"] = inscripcion.FkEstadoInscripcion,
                ["@FkCliente"] = inscripcion.FkCliente
            });

        return Convert.ToInt32(result);
    }

    public static async Task<int> ObtenerConteoInscripcionesAsync(string connectionString)
    {
        return await DatabaseHelper.ExecuteScalarAsync<int>(
            connectionString,
            "SELECT COUNT(*) FROM inscripcionesDeClases");
    }

    public static async Task<int> ObtenerEstadoInscripcionAsync(string connectionString, int idInscripcion)
    {
        var result = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT fkEstadoInscripcion FROM inscripcionesDeClases WHERE IdInscripcion = @Id",
            new Dictionary<string, object?> { ["@Id"] = idInscripcion });

        return result != null ? Convert.ToInt32(result["fkEstadoInscripcion"]) : 0;
    }

    public static async Task<string?> ObtenerClienteIdAsync(string connectionString, int idInscripcion)
    {
        var result = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT fkCliente FROM inscripcionesDeClases WHERE IdInscripcion = @Id",
            new Dictionary<string, object?> { ["@Id"] = idInscripcion });

        return result?["fkCliente"]?.ToString();
    }

    public static async Task<int?> ObtenerClaseProgramadaIdAsync(string connectionString, int idInscripcion)
    {
        var result = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT fkProgramacionClase FROM inscripcionesDeClases WHERE IdInscripcion = @Id",
            new Dictionary<string, object?> { ["@Id"] = idInscripcion });

        return result != null ? Convert.ToInt32(result["fkProgramacionClase"]) : null;
    }
}