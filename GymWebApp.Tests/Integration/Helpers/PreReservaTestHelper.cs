using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Helpers;

/// <summary>
/// Helper para seeding de pre-reservas con datos controlados (spec 83).
/// Inserta filas en <c>preReservasDeHorario</c> y consulta conteos de verificación.
/// La columna <c>fechaDeLaClase</c> se inserta NULL a propósito: el índice único
/// filtrado <c>UX_preReservasDeHorario_Unique</c> solo aplica cuando idClase,
/// fechaDeLaClase e idEntrenador son NOT NULL; con fechaDeLaClase NULL se permite
/// sembrar múltiples filas con el mismo (fkHoraLaboral, fechaReservada, idClase,
/// idEntrenador). <c>EncontrarPreReservasAsync</c> no filtra por fechaDeLaClase.
/// </summary>
public static class PreReservaTestHelper
{
    /// <summary>
    /// Obtiene un idHora válido de la tabla horasLaborales (FK de fkHoraLaboral).
    /// </summary>
    public static async Task<int> ObtenerIdHoraLaboralAsync(string connectionString)
    {
        var fila = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 idHora FROM horasLaborales");

        return Convert.ToInt32(fila?["idHora"] ?? 1);
    }

    /// <summary>
    /// Inserta una pre-reserva con los 4 datos controlados y devuelve el idPreReserva generado.
    /// </summary>
    public static async Task<int> InsertarPreReservaAsync(
        string connectionString,
        int fkHoraLaboral,
        DateTime fechaReservada,
        int idClase,
        string? idEntrenador,
        string? idUsuarioQueReserva = null)
    {
        var id = await DatabaseHelper.ExecuteScalarAsync<int>(
            connectionString,
            @"INSERT INTO preReservasDeHorario
                (fkHoraLaboral, fechaReservada, fechaInicioDeLaReserva, fechaDeExpiracionDeLaReserva, idUsuarioQueReserva, idClase, fechaDeLaClase, idEntrenador)
              VALUES
                (@FkHoraLaboral, @FechaReservada, @FechaInicio, @FechaExpiracion, @IdUsuarioQueReserva, @IdClase, NULL, @IdEntrenador);
              SELECT SCOPE_IDENTITY();",
            new Dictionary<string, object?>
            {
                ["@FkHoraLaboral"] = fkHoraLaboral,
                ["@FechaReservada"] = fechaReservada,
                ["@FechaInicio"] = DateTime.Now,
                ["@FechaExpiracion"] = DateTime.Now.AddHours(2),
                ["@IdUsuarioQueReserva"] = idUsuarioQueReserva,
                ["@IdClase"] = idClase,
                ["@IdEntrenador"] = idEntrenador
            });

        return id;
    }

    /// <summary>
    /// Conteo de pre-reservas que coinciden con los 4 datos (misma semántica de WHERE
    /// que <see cref="DataAccess.Repositories.InscripcionRepository.EncontrarPreReservasAsync"/>).
    /// </summary>
    public static async Task<int> ObtenerConteoPorFiltroAsync(
        string connectionString,
        int fkHoraLaboral,
        DateTime fechaReservada,
        int idClase,
        string? idEntrenador)
    {
        return await DatabaseHelper.ExecuteScalarAsync<int>(
            connectionString,
            @"SELECT COUNT(*) FROM preReservasDeHorario
              WHERE fkHoraLaboral = @FkHoraLaboral
                AND fechaReservada = @FechaReservada
                AND idClase = @IdClase
                AND idEntrenador = @IdEntrenador",
            new Dictionary<string, object?>
            {
                ["@FkHoraLaboral"] = fkHoraLaboral,
                ["@FechaReservada"] = fechaReservada,
                ["@IdClase"] = idClase,
                ["@IdEntrenador"] = idEntrenador
            });
    }

    /// <summary>
    /// Conteo de pre-reservas por idPreReserva (para verificar eliminaciones puntuales).
    /// </summary>
    public static async Task<int> ObtenerConteoPorIdAsync(string connectionString, int idPreReserva)
    {
        return await DatabaseHelper.ExecuteScalarAsync<int>(
            connectionString,
            "SELECT COUNT(*) FROM preReservasDeHorario WHERE idPreReserva = @IdPreReserva",
            new Dictionary<string, object?> { ["@IdPreReserva"] = idPreReserva });
    }
}