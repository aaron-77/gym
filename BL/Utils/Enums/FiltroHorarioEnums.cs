namespace BL.Utils.Enums;

/// <summary>
/// Enumeración para filtrar por fecha en consultas de horarios disponibles.
/// </summary>
public enum FiltroFecha
{
    /// <summary>fechaDeLaClase == GETDATE() — solo hoy</summary>
    Igual,
    /// <summary>fechaDeLaClase > GETDATE() — estrictamente después de hoy</summary>
    Mayor,
    /// <summary>fechaDeLaClase >= GETDATE() — hoy en adelante</summary>
    MayorIgual
}

/// <summary>
/// Enumeración para filtrar por hora en consultas de horarios disponibles.
/// La referencia de hora se redondea hacia arriba (ceil) a la próxima hora completa
/// cuando deriva de la hora actual; si la referencia supera la última hora laboral,
/// la consulta se desplaza al primer horario del día siguiente (guard de fin de jornada).
/// </summary>
public enum FiltroHora
{
    /// <summary>horaInicio > referencia ceil (próxima hora completa)</summary>
    Mayor,
    /// <summary>Sin filtro de hora</summary>
    SinFiltro
}
