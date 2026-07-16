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
/// La hora de referencia se calcula como TimeOnly(DateTime.Now.Hour, 0, 0).
/// </summary>
public enum FiltroHora
{
    /// <summary>horaInicio == horaActualFloored</summary>
    Igual,
    /// <summary>horaInicio > horaActualFloored</summary>
    Mayor,
    /// <summary>horaInicio >= horaActualFloored</summary>
    MayorIgual,
    /// <summary>Sin filtro de hora</summary>
    SinFiltro
}
