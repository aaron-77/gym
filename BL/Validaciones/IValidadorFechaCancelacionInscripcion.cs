namespace BL.Validaciones;

public interface IValidadorFechaCancelacionInscripcion
{
    (bool EsValido, string MensajeError) Validar(DateOnly fechaClase, TimeOnly horaInicio);

    (bool EsValido, string MensajeError) FechaMenorQueActual(DateOnly fechaClase);

    (bool EsValido, string MensajeError) FechaIgualYHoraMenorOIgual(DateOnly fechaClase, TimeOnly horaInicio);
}
