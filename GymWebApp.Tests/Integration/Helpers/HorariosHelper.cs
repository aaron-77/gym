using Microsoft.Data.SqlClient;
using BL.Utils.Enums;
using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Helpers;

/// <summary>
/// Helper para consultar horarios disponibles en tests de integración.
/// Centraliza llamadas a sp_obtenerHorariosDisponibles.
/// </summary>
public static class HorariosHelper
{
    /// <summary>
    /// Ejecuta sp_obtenerHorariosDisponibles y devuelve el resultado crudo.
    /// Cada fila contiene: FechaDisponible, idHora, horaInicio, horaFin, DiaDeLaSemana, TipoDeDia.
    /// </summary>
    /// <param name="connectionString">Connection string de la BD de pruebas.</param>
    /// <param name="fecha">Fecha base para consultar (opcional, default hoy).</param>
    /// <returns>Lista de filas con todas las columnas del SP.</returns>
    public static async Task<List<Dictionary<string, object?>>> ObtenerHorariosDisponibles(
        string connectionString,
        DateTime? fecha = null)
    {
        var horarios = await DatabaseHelper.ExecuteQueryAsync(
            connectionString,
            "EXEC sp_obtenerHorariosDisponibles @Fecha = @Fecha",
            new Dictionary<string, object?> { ["@Fecha"] = fecha ?? DateTime.Today });

        return horarios;
    }

    /// <summary>
    /// Ejecuta sp_obtenerHorariosDisponibles y aplica filtros de fecha y hora.
    /// </summary>
    /// <param name="connectionString">Connection string de la BD de pruebas.</param>
    /// <param name="filtroFecha">Filtro de fecha a aplicar.</param>
    /// <param name="filtroHora">Filtro de hora a aplicar.</param>
    /// <param name="fecha">Fecha base para consultar (opcional, default hoy).</param>
    /// <returns>Lista de filas filtradas.</returns>
    public static async Task<List<Dictionary<string, object?>>> ObtenerHorariosDisponiblesFiltrados(
        string connectionString,
        FiltroFecha filtroFecha,
        FiltroHora filtroHora,
        DateTime? fecha = null)
    {
        var horarios = await ObtenerHorariosDisponibles(connectionString, fecha);

        // Aplicar filtro de fecha usando la fecha recibida como referencia
        var fechaRef = fecha?.Date ?? DateTime.Today;
        horarios = filtroFecha switch
        {
            FiltroFecha.Igual => horarios
                .Where(r => r["FechaDisponible"] != null
                            && Convert.ToDateTime(r["FechaDisponible"]).Date == fechaRef)
                .ToList(),
            FiltroFecha.Mayor => horarios
                .Where(r => r["FechaDisponible"] != null
                            && Convert.ToDateTime(r["FechaDisponible"]).Date > fechaRef)
                .ToList(),
            FiltroFecha.MayorIgual => horarios
                .Where(r => r["FechaDisponible"] != null
                            && Convert.ToDateTime(r["FechaDisponible"]).Date >= fechaRef)
                .ToList(),
            _ => horarios
        };

        // Aplicar filtro de hora
        if (filtroHora != FiltroHora.SinFiltro)
        {
            var horaActualFloored = new TimeSpan(DateTime.Now.Hour, 0, 0);

            horarios = filtroHora switch
            {
                FiltroHora.Igual => horarios
                    .Where(r => r["horaInicio"] != null
                                && (TimeSpan)r["horaInicio"] == horaActualFloored)
                    .ToList(),
                FiltroHora.Mayor => horarios
                    .Where(r => r["horaInicio"] != null
                                && (TimeSpan)r["horaInicio"] > horaActualFloored)
                    .ToList(),
                FiltroHora.MayorIgual => horarios
                    .Where(r => r["horaInicio"] != null
                                && (TimeSpan)r["horaInicio"] >= horaActualFloored)
                    .ToList(),
                _ => horarios
            };
        }

        return horarios;
    }

    /// <summary>
    /// Registra un horario para una clase programada.
    /// Si no se especifica idEstadoHorario, se resuelve automáticamente el estado 'activo'
    /// desde la tabla estadosHorarioClaseProgramada.
    /// </summary>
    /// <param name="connectionString">Connection string de la BD de pruebas.</param>
    /// <param name="idClaseProgramada">FK a clasesProgramadas.</param>
    /// <param name="idHoraLaboral">FK a horasLaborales.</param>
    /// <param name="idEstadoHorario">FK a estadosHorarioClaseProgramada (opcional, default activo).</param>
    /// <returns>ID del registro insertado (idHorarioDeClaseProgramada).</returns>
    public static async Task<int> RegistrarHorarioDeClaseProgramada(
        string connectionString,
        int idClaseProgramada,
        int idHoraLaboral,
        int? idEstadoHorario = null)
    {
        // Resolver estado por defecto si no se especificó (lectura fuera de transacción)
        if (idEstadoHorario == null)
        {
            idEstadoHorario = await DatabaseHelper.ExecuteScalarAsync<int>(
                connectionString,
                "SELECT idEstadoHorarioClase FROM estadosHorarioClaseProgramada WHERE nombreEstadoHorario = 'activo'");
        }

        var estadoHorario = idEstadoHorario.Value;

        // INSERT dentro de transacción
        return await DatabaseHelper.WithTransactionAsync(connectionString, async (connection, transaction) =>
        {
            var result = await DatabaseHelper.ExecuteScalarAsync<decimal>(
                connection, transaction,
                @"INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral, fkEstadoHorarioClase)
                  VALUES (@FkClaseProgramada, @FkHorarioLaboral, @FkEstadoHorarioClase);
                  SELECT SCOPE_IDENTITY();",
                new Dictionary<string, object?>
                {
                    ["@FkClaseProgramada"] = idClaseProgramada,
                    ["@FkHorarioLaboral"] = idHoraLaboral,
                    ["@FkEstadoHorarioClase"] = estadoHorario
                });

            return Convert.ToInt32(result);
        });
    }

    /// <summary>
    /// Obtiene un único horario disponible aleatorio aplicando los filtros especificados.
    /// Wrapper sobre ObtenerHorariosDisponiblesFiltrados que valida, selecciona al azar
    /// y devuelve una tupla limpia (FechaDisponible, IdHora).
    /// </summary>
    /// <param name="connectionString">Connection string de la BD de pruebas.</param>
    /// <param name="filtroFecha">Filtro de fecha a aplicar.</param>
    /// <param name="filtroHora">Filtro de hora a aplicar.</param>
    /// <param name="fecha">Fecha base para consultar (opcional, default hoy).</param>
    /// <returns>Tupla con (FechaDisponible, IdHora) de un slot disponible aleatorio,
    /// o null si no hay horarios disponibles con los filtros especificados.</returns>
    public static async Task<(DateOnly FechaDisponible, int IdHora)?> ObtenerUnHorarioDisponible(
        string connectionString,
        FiltroFecha filtroFecha,
        FiltroHora filtroHora,
        DateTime? fecha = null)
    {
        var horarios = await ObtenerHorariosDisponiblesFiltrados(
            connectionString, filtroFecha, filtroHora, fecha);

        if (horarios.Count == 0)
            return null;

        var random = new Random();
        var slot = horarios[random.Next(horarios.Count)];

        var fechaDisponible = DateOnly.FromDateTime(Convert.ToDateTime(slot["FechaDisponible"]));
        var idHora = Convert.ToInt32(slot["idHora"]);

        return (fechaDisponible, idHora);
    }
}
