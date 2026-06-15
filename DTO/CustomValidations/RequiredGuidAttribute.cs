using System.ComponentModel.DataAnnotations;

public class RequiredGuidAttribute : ValidationAttribute
{
    public RequiredGuidAttribute() : base("El ID de usuario es requerido") { }

    protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
    {
        if (value == null || string.IsNullOrWhiteSpace(value.ToString()))
        {
            return new ValidationResult("El ID de usuario es requerido");
        }

        if (!Guid.TryParse(value.ToString(), out _))
        {
            return new ValidationResult("El ID de usuario debe ser un GUID válido");
        }

        return ValidationResult.Success;
    }
}
