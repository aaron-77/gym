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
        var fechaReferencia = NormalizarFechaReferencia(fecha ?? DateTime.Today);

        var horarios = await DatabaseHelper.ExecuteQueryAsync(
            connectionString, 
            "EXEC sp_obtenerHorariosDisponibles @Fecha = @Fecha",
            new Dictionary<string, object?> { ["@Fecha"] = fechaReferencia });

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
        // Normalizar la fecha de referencia y usarla tanto para el SP como para el filtro,
        // para mantener consistencia cuando la consulta se hace el último día del mes.
        var fechaRef = NormalizarFechaReferencia(fecha?.Date ?? DateTime.Today);
        var horarios = await ObtenerHorariosDisponibles(connectionString, fechaRef);

        // Aplicar filtro de fecha usando la fecha normalizada como referencia
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
            var horaActualFloored = new TimeSpan(fecha?.Hour ?? DateTime.Now.Hour, 0, 0);

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
    /// <param name="fecha">Fecha base para consultar (opcional, default null = hoy).</param>
    /// <returns>Tupla con (FechaDisponible, IdHora) de un slot disponible aleatorio,
    /// o null si no hay horarios disponibles con los filtros especificados.</returns>
    public static async Task<(DateOnly FechaDisponible, int IdHora)?> ObtenerUnHorarioDisponible(
        string connectionString,
        FiltroFecha filtroFecha,
        FiltroHora filtroHora,
        DateOnly? fecha = null)
    {
        var horarios = await ObtenerHorariosDisponiblesFiltrados(
            connectionString, filtroFecha, filtroHora,
            fecha?.ToDateTime(TimeOnly.MinValue));

        if (horarios.Count == 0)
            return null;

        var random = new Random();
        var slot = horarios[random.Next(horarios.Count)];

        var fechaDisponible = DateOnly.FromDateTime(Convert.ToDateTime(slot["FechaDisponible"]));
        var idHora = Convert.ToInt32(slot["idHora"]);

        return (fechaDisponible, idHora);
    }

    /// <summary>
    /// Normaliza la fecha de referencia para que la consulta al SP nunca quede sin días disponibles.
    /// sp_obtenerHorariosDisponibles genera el calendario de TODO el mes de @Fecha y filtra f.Fecha >= @Fecha;
    /// si la fecha es el último día del mes, el resultado quedaría casi vacío (y vacío si la hora actual ya pasó),
    /// haciendo fallar los tests. Se avanza al primer día del mes siguiente para regenerar el mes completo.
    /// Esto cubre también el fin de año (31 de diciembre → 1 de enero del año siguiente, AddMonths maneja el año).
    /// </summary>
    /// <param name="fecha">Fecha de referencia a normalizar.</param>
    /// <returns>Primer día del mes siguiente si la fecha cae el último día del mes; si no, la fecha original.</returns>
    private static DateTime NormalizarFechaReferencia(DateTime fecha)
    {
        var fechaSolo = fecha.Date;

        // Si es el último día del mes, mover la referencia al primer día del mes siguiente.
        // AddMonths maneja el fin de año de forma nativa (diciembre → enero del año siguiente).
        if (fechaSolo.Day == DateTime.DaysInMonth(fechaSolo.Year, fechaSolo.Month))
        {
            var mesSiguiente = fechaSolo.AddMonths(1);
            return new DateTime(mesSiguiente.Year, mesSiguiente.Month, 1);
        }

        return fechaSolo;
    }
}
