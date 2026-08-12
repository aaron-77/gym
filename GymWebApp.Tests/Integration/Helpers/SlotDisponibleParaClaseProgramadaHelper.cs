using BL.Utils.Enums;
using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Helpers;

/// <summary>
/// DTO con el dataset completo de una inscripción consistente por construcción:
/// slot disponible (fecha + hora laboral), entrenador activo, clase activa y cliente libre.
/// Sin campo de hora: la hora no se usa en ninguna decisión (el SP de entrenadores se invoca solo con la fecha).
/// </summary>
public sealed class SlotDisponibleParaClaseProgramadaDto
{
    public DateOnly FechaDisponible { get; set; }
    public int IdHoraLaboral { get; set; }
    public string EntrenadorId { get; set; } = string.Empty;
    public string NombreEntrenador { get; set; } = string.Empty;
    public int ClaseId { get; set; }
    public int Cupo { get; set; }
    public string ClienteId { get; set; } = string.Empty;
}

/// <summary>
/// Arma por construcción todo el dataset de una inscripción (slot + entrenador + clase + cliente libre)
/// usando los SPs de disponibilidad. Reemplaza los seeds que adivinaban datos.
/// </summary>
public static class SlotDisponibleParaClaseProgramadaHelper
{
    /// <summary>
    /// Orquesta en orden: slot → entrenador → clase → cliente.
    /// 1. Slot: <see cref="HorariosHelper.ObtenerUnHorarioDisponible"/> con FiltroFecha.Mayor y
    ///    FiltroHora.SinFiltro (el filtro Mayor ya maneja fecha &gt; fechaBase internamente; sin filtrado manual).
    ///    Sin slot → retorna null sin ejecutar los pasos restantes.
    /// 2. Entrenador: sp_obtenerEntrenadoresDisponibles con SOLO la fecha del slot (00:00 → todos los activos;
    ///    disponible == activo: si el slot está libre no hay clase programada ahí).
    /// 3. Clase: fkClase recibido o TOP 1 con fkEstadoClase = 1. Cupo real de Clases.
    /// 4. Cliente: obtenerClienteDisponibleParaSlotAsync con (FechaDisponible, IdHoraLaboral).
    /// </summary>
    /// <param name="connectionString">Connection string de la BD de pruebas.</param>
    /// <param name="fecha">Fecha de referencia para el slot (opcional, default null = hoy).</param>
    /// <param name="fkClase">Clase específica a usar (opcional; si es null se toma la primera activa).</param>
    /// <returns>DTO con el dataset completo, o null si no hay horarios disponibles.</returns>
    public static async Task<SlotDisponibleParaClaseProgramadaDto?> obtenerSlotDisponibleParaClaseProgramadaAsync(
        string connectionString, DateOnly? fecha = null, int? fkClase = null)
    {
        // 1. Slot realmente disponible (EXCEPT de slots ocupados garantiza nadie inscrito ahí)
        var slot = await HorariosHelper.ObtenerUnHorarioDisponible(
            connectionString, FiltroFecha.Mayor, FiltroHora.SinFiltro, fecha);

        if (slot == null)
            return null;

        // 2. Entrenador: SOLO la fecha del slot (hora 00:00 → el SP devuelve todos los activos;
        //    disponible == activo: slot libre ⇒ nadie da clase ahí ⇒ todos los activos están libres)
        var entrenadorRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "EXEC dbo.sp_obtenerEntrenadoresDisponibles @fechaReferencia = @Fecha",
            new Dictionary<string, object?>
            {
                ["@Fecha"] = slot.Value.FechaDisponible.ToDateTime(TimeOnly.MinValue)
            });

        var entrenadorId = entrenadorRow?["UsuarioID"]?.ToString()
            ?? throw new InvalidOperationException("No se encontró ningún entrenador disponible");

        var nombreEntrenador = $"{entrenadorRow?["Nombre"]} {entrenadorRow?["Apellido"]}".Trim();

        // 3. Clase: fkClase explícito o primera clase activa (fkEstadoClase = 1), con Cupo real
        var claseSql = fkClase.HasValue
            ? "SELECT ClaseID, Cupo FROM Clases WHERE ClaseID = @FkClase"
            : "SELECT TOP 1 ClaseID, Cupo FROM Clases WHERE fkEstadoClase = 1";

        var claseParams = fkClase.HasValue
            ? new Dictionary<string, object?> { ["@FkClase"] = fkClase.Value }
            : null;

        var claseRow = await DatabaseHelper.ExecuteQuerySingleAsync(connectionString, claseSql, claseParams)
            ?? throw new InvalidOperationException("No se encontró ninguna clase activa");

        var claseId = Convert.ToInt32(claseRow["ClaseID"]);
        var cupo = Convert.ToInt32(claseRow["Cupo"]);

        // 4. Cliente sin inscripción vigente en el slot (una sola consulta, sin rol)
        var clienteId = await obtenerClienteDisponibleParaSlotAsync(
            connectionString, slot.Value.FechaDisponible, slot.Value.IdHora);

        return new SlotDisponibleParaClaseProgramadaDto
        {
            FechaDisponible = slot.Value.FechaDisponible,
            IdHoraLaboral = slot.Value.IdHora,
            EntrenadorId = entrenadorId,
            NombreEntrenador = nombreEntrenador,
            ClaseId = claseId,
            Cupo = cupo,
            ClienteId = clienteId
        };
    }

    /// <summary>
    /// Busca el primer cliente con inscripciones vigentes que NO tenga ninguna inscripción
    /// vigente en la (fecha, horario) de referencia. Una sola consulta desde
    /// inscripcionesDeClases (JOIN clasesProgramadas + horariosDeClasesProgramadas):
    /// NOT EXISTS sobre el conjunto de clientes ocupados en esa fecha y hora.
    /// No se filtra por rol 'cliente': todas las inscripciones son de clientes por construcción.
    /// Las inscripciones canceladas no cuentan (solo vigentes vía v_idEstadoVigenteInscripcionAClase).
    /// </summary>
    /// <param name="connectionString">Connection string de la BD de pruebas.</param>
    /// <param name="fecha">Fecha del slot.</param>
    /// <param name="idHoraLaboral">Hora laboral del slot.</param>
    /// <returns>Id del primer cliente sin inscripción vigente en el slot.</returns>
    /// <exception cref="InvalidOperationException">
    /// Guard defensivo inalcanzable (el EXCEPT de slots ocupados del SP de horarios garantiza que el slot
    /// elegido no tiene inscripciones): si ningún cliente cumple, se lanza con texto literal.
    /// </exception>
    public static async Task<string> obtenerClienteDisponibleParaSlotAsync(
        string connectionString, DateOnly fecha, int idHoraLaboral)
    {
        var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 i.fkCliente
              FROM inscripcionesDeClases i
              INNER JOIN clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase
              INNER JOIN horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
              WHERE i.fkEstadoInscripcion = (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase)
                AND NOT EXISTS (
                    SELECT 1
                    FROM inscripcionesDeClases i2
                    INNER JOIN clasesProgramadas cp2 ON i2.fkProgramacionClase = cp2.idProgramacionClase
                    INNER JOIN horariosDeClasesProgramadas hcp2 ON cp2.idProgramacionClase = hcp2.fkClaseProgramada
                    WHERE i2.fkCliente = i.fkCliente
                      AND i2.fkEstadoInscripcion = (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase)
                      AND cp2.fechaDeLaClase = @Fecha
                      AND hcp2.fkHorarioLaboral = @IdHoraLaboral
                )",
            new Dictionary<string, object?>
            {
                ["@Fecha"] = fecha,
                ["@IdHoraLaboral"] = idHoraLaboral
            });

        var clienteId = clienteRow?["fkCliente"]?.ToString();

        if (clienteId is null)
            throw new InvalidOperationException(
                "El cliente con id {idCliente} ya está inscrito a una clase en ese horario");

        return clienteId;
    }
}