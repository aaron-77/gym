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
    /// Al SP se le envía la fecha a secas (Date); el filtrado de horas no deseadas lo
    /// hace este método en memoria con la referencia horaria resuelta.
    /// Con <see cref="FiltroHora.Mayor"/>, la referencia de hora se resuelve con
    /// ceil: sin fecha explícita se redondea hacia arriba (ceil) a la próxima hora
    /// completa desde la hora actual; con fecha explícita se conservan los minutos y
    /// segundos para decidir (con minutos/segundos se aplica ceil a la próxima hora
    /// completa; con hora exacta se toma tal cual). La normalización de fin de mes y
    /// año se resuelve en <see cref="NormalizarFechaReferencia"/>.
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
        // Guard de fin de jornada: si la hora de la fecha de referencia entrante es igual o
        // mayor a la última hora laboral, no quedan horarios disponibles ese día. Se salta
        // a la siguiente fecha disponible calculada, cuya fecha devuelta es segura (solo
        // contiene días con horarios anteriores a la hora máxima laboral). La fecha a usar
        // se decide AQUÍ, antes de normalizar, para que la normalización ocurra UNA sola vez.
        var (_, maxHoraLaboral) = await GetRangoHoraInicioAsync(connectionString);

        var fechaRefBase = fecha ?? DateTime.Today;

        if (fechaRefBase.Hour >= maxHoraLaboral.Hours)
        {
            var siguiente = await CalcularSiguienteFechaDisponible(
                connectionString, DateOnly.FromDateTime(fechaRefBase));

            // Solo se reemplaza la fecha base si hay una siguiente fecha disponible.
            if (siguiente.HasValue)
            {
                fechaRefBase = siguiente.Value.ToDateTime(TimeOnly.MinValue);
            }
        }

        // Normalizar UNA sola vez la fecha (la original o la calculada por el guard).
        var fechaRef = NormalizarFechaReferencia(fechaRefBase);

        TimeSpan? horaRef = null;

        // Con filtro de hora (único restante: Mayor): ceil de hora si hay minutos/segundos.
        if (filtroHora != FiltroHora.SinFiltro)
        {
            // Referencia de hora: sin fecha explícita se redondea hacia arriba (ceil)
            // de DateTime.Now; con fecha explícita se conservan los minutos y segundos
            // para decidir — si hay minutos/segundos la hora señalada ya empezó y se
            // aplica ceil a la próxima hora completa; con hora exacta (0 min, 0 seg)
            // se toma tal cual.
            horaRef = ResolverHoraReferencia(fecha, DateTime.Now);

            // El salto de día ya está resuelto por NormalizarFechaReferencia al inicio.
            // No se necesita guard adicional contra maxHora.
        }

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

        // Aplicar filtro de hora: horaInicio > horaRef (filtro único Mayor)
        if (horaRef is not null)
        {
            horarios = horarios
                .Where(r => r["horaInicio"] != null
                            && (TimeSpan)r["horaInicio"] >= horaRef.Value)
                .ToList();
        }

        return horarios;
    }

    /// <summary>
    /// Consulta la primera y última hora de inicio laboral (MIN/MAX de horaInicio)
    /// en un solo round-trip a la BD. Usado por el guard de fin de jornada.
    /// </summary>
    /// <param name="connectionString">Connection string de la BD de pruebas.</param>
    /// <returns>Tupla (MinHora, MaxHora) con el rango de horas laborales.</returns>
    private static async Task<(TimeSpan MinHora, TimeSpan MaxHora)> GetRangoHoraInicioAsync(string connectionString)
    {
        var row = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT MIN(horaInicio) AS MinHora, MAX(horaInicio) AS MaxHora FROM horasLaborales")
            ?? throw new InvalidOperationException("No hay horas laborales registradas");

        return ((TimeSpan)row["MinHora"], (TimeSpan)row["MaxHora"]);
    }

    /// <summary>
    /// Redondea la hora actual hacia arriba (ceil) a la próxima hora completa.
    /// Con minutos y segundos en cero devuelve la hora exacta (sin ceil).
    /// </summary>
    /// <param name="ahora">Marca de tiempo actual.</param>
    /// <returns>Próxima hora completa (o la hora exacta si no hay minutos/segundos).</returns>
    private static TimeSpan CeilHoraActual(DateTime ahora) =>
        ahora.Minute > 0 || ahora.Second > 0
            ? new TimeSpan(ahora.Hour + 1, 0, 0)
            : new TimeSpan(ahora.Hour, 0, 0);

    /// <summary>
    /// Resuelve la referencia horaria del filtro aplicando guard clauses que solo
    /// modifican el valor de la referencia según su propio valor:
    /// 1. Si la hora suministrada es la hora 0 (00:00, medianoche) → devuelve null,
    ///    ya que significa que no hay hora configurada.
    /// 2. Sin fecha de referencia explícita → ceil de la hora actual (próxima hora completa).
    /// 3. Fecha explícita con minutos o segundos → ceil a la próxima hora completa
    ///    (la hora señalada ya empezó y sus slots quedan descartados por el filtro).
    /// 4. Fecha explícita con hora exacta (0 minutos, 0 segundos) → se toma tal cual.
    /// </summary>
    /// <param name="fecha">Fecha de referencia explícita (opcional, null = usar hora actual).</param>
    /// <param name="ahora">Marca de tiempo actual usada por la guard clause 2.</param>
    /// <returns>Referencia horaria (TimeSpan) con minutos y segundos en cero, o null si la
    /// hora suministrada es la hora 0 (no hay hora configurada).</returns>
    private static TimeSpan? ResolverHoraReferencia(DateTime? fecha, DateTime ahora)
    {
        // Guard 1: hora 0 (00:00) → no hay hora configurada, devolver null.
        if (fecha.HasValue && fecha.Value.Hour == 0 && fecha.Value.Minute == 0 && fecha.Value.Second == 0)
            return null;

        // Guard 2: sin fecha explícita → ceil de la hora actual.
        if (!fecha.HasValue)
            return CeilHoraActual(ahora);

        // Guard 3: fecha explícita con minutos o segundos → ceil a la próxima hora completa.
        if (fecha.Value.Minute > 0 || fecha.Value.Second > 0)
            return CeilHoraActual(fecha.Value);

        // Guard 4: hora exacta (0 min, 0 seg) → se toma tal cual.
        return new TimeSpan(fecha.Value.Hour, 0, 0);
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
    /// Calcula la siguiente fecha disponible (mínima única) estrictamente posterior a la fecha base,
    /// sin filtrar por hora. Delega la consulta a <see cref="ObtenerHorariosDisponiblesFiltrados"/>
    /// con filtro de fecha Mayor y filtro de hora SinFiltro, agrupa los resultados por día,
    /// los ordena de menor a mayor y devuelve la fecha del primer día.
    /// </summary>
    /// <param name="connectionString">Connection string de la BD de pruebas.</param>
    /// <param name="fecha">Fecha base de tipo <see cref="DateOnly"/> desde la cual buscar el próximo día disponible.</param>
    /// <returns>La fecha mínima única (día) con al menos un horario disponible posterior a la fecha base,
    /// o null si no hay ningún horario disponible.</returns>
    public static async Task<DateOnly?> CalcularSiguienteFechaDisponible(
        string connectionString,
        DateOnly fecha)
    {
        var horarios = await ObtenerHorariosDisponiblesFiltrados(
            connectionString, FiltroFecha.Mayor, FiltroHora.SinFiltro,
            fecha.ToDateTime(TimeOnly.MinValue));

        // Agrupar por día y quedarnos con los días únicos que tienen disponibilidad.
        var diasDisponibles = horarios
            .Where(r => r["FechaDisponible"] != null)
            .Select(r => DateOnly.FromDateTime(Convert.ToDateTime(r["FechaDisponible"])))
            .Distinct()
            .OrderBy(d => d)
            .ToList();

        // Devolver la fecha mínima única, o null si no hay nada.
        return diasDisponibles.Count > 0 ? diasDisponibles[0] : null;
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
