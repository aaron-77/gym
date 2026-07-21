namespace BL.Validaciones;

public class ValidadorFechasInscripcionesYClasesProgramadas : IValidadorFechasInscripcionesYClasesProgramadas
{
    public (bool EsValido, string MensajeError) Validar(DateOnly fechaClase, TimeOnly horaInicio)
    {
        var resultadoFecha = FechaMenorQueActual(fechaClase);
        if (!resultadoFecha.EsValido)
            return resultadoFecha;

        return FechaIgualYHoraMenorOIgual(fechaClase, horaInicio);
    }

    public (bool EsValido, string MensajeError) FechaMenorQueActual(DateOnly fechaClase)
    {
        if (fechaClase < DateOnly.FromDateTime(DateTime.Now))
            return (false, "No se puede cancelar una inscripción a una clase que ya finalizó.");

        return (true, string.Empty);
    }

    public (bool EsValido, string MensajeError) FechaIgualYHoraMenorOIgual(DateOnly fechaClase, TimeOnly horaInicio)
    {
        if (fechaClase == DateOnly.FromDateTime(DateTime.Now) &&
            horaInicio <= TimeOnly.FromDateTime(DateTime.Now))
            return (false, "No se puede cancelar una inscripción después de que la clase comenzó.");

        return (true, string.Empty);
    }

    public (bool EsValido, string MensajeError) ValidarFechaReagendacion(DateOnly fechaClase, TimeOnly horaInicio)
    {
        if (fechaClase < DateOnly.FromDateTime(DateTime.Now))
            return (false, "No se puede reagendar a una clase que ya finalizó.");

        if (fechaClase == DateOnly.FromDateTime(DateTime.Now))
        {
            var horaActualTruncada = new TimeOnly(DateTime.Now.Hour, 0, 0);
            if (horaInicio <= horaActualTruncada)
                return (false, "No se puede reagendar a una clase cuya hora ya pasó.");
        }

        return (true, string.Empty);
    }
}
