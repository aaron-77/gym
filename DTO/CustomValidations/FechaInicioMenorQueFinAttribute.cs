using System.ComponentModel.DataAnnotations;


namespace DTO.CustomValidations
{
    public class FechaInicioMenorQueFinAttribute : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext context)
        {
            var instance = context.ObjectInstance;
            var fechaInicioProp = instance.GetType().GetProperty("fechaInicioCita");
            var fechaFinProp = instance.GetType().GetProperty("fechaFinCita");

            var fechaInicio = fechaInicioProp.GetValue(instance) as DateTime?;
            var fechaFin = fechaFinProp.GetValue(instance) as DateTime?;

            if (fechaInicio == null || fechaFin == null)
                return new ValidationResult("Ambas fechas son requeridas");

            if (fechaInicio >= fechaFin)
                return new ValidationResult("La fecha de inicio debe ser menor a la fecha de fin");

            return ValidationResult.Success;
        }
    }
}
