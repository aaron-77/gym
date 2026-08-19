using System.ComponentModel.DataAnnotations;

namespace DTO.CustomValidations
{
    [AttributeUsage(AttributeTargets.Property | AttributeTargets.Field, AllowMultiple = false)]
    public class FechaMinimaValidaAttribute : ValidationAttribute
    {
        public int AnioMinimo { get; }

        public FechaMinimaValidaAttribute(int anioMinimo = 1890)
        {
            AnioMinimo = anioMinimo;
        }

        protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
        {
            if (value is null)
                return ValidationResult.Success;

            if (value is DateOnly fecha)
            {
                if (fecha.Year < AnioMinimo)
                {
                    return new ValidationResult(
                        ErrorMessage ?? $"La fecha tentativa debe tener un año válido ({AnioMinimo} o posterior).");
                }
            }

            return ValidationResult.Success;
        }
    }
}
