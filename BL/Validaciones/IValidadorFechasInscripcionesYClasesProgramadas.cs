namespace BL.Validaciones;

public interface IValidadorFechasInscripcionesYClasesProgramadas
{
    /// <summary>
    /// Valida que una clase pueda ser cancelada (fecha >= hoy, y si es hoy hora > actual).
    /// </summary>
    (bool EsValido, string MensajeError) Validar(DateOnly fechaClase, TimeOnly horaInicio);

    /// <summary>
    /// Valida que la fecha no sea menor a la fecha actual.
    /// </summary>
    (bool EsValido, string MensajeError) FechaMenorQueActual(DateOnly fechaClase);

    /// <summary>
    /// Valida que si la fecha es igual a la actual, la hora sea estrictamente mayor a la hora actual.
    /// </summary>
    (bool EsValido, string MensajeError) FechaIgualYHoraMenorOIgual(DateOnly fechaClase, TimeOnly horaInicio);

    /// <summary>
    /// Valida que la fecha de reagendación sea >= hoy, y si es hoy la hora debe ser mayor
    /// a la hora actual truncada al piso (ej: 2:30 → 2:00).
    /// </summary>
    (bool EsValido, string MensajeError) ValidarFechaReagendacion(DateOnly fechaClase, TimeOnly horaInicio);
}
