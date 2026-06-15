## Validation

Use DataAnnotations and custom `ValidationAttribute` for model validation.

```csharp
public class ValidarPasswordAttribute : ValidationAttribute
{
    protected override ValidationResult IsValid(object value, ValidationContext validationContext)
    {
        var modelo = (User)validationContext.ObjectInstance;
        if (modelo.Contrasena != modelo.ContrasenaConfirmacion)
            return new ValidationResult("Las contraseñas no coinciden");
        return ValidationResult.Success;
    }
}
```
