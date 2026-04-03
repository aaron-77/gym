using System.ComponentModel.DataAnnotations;

public class ValidGuidAttribute : ValidationAttribute
{
    public ValidGuidAttribute() : base("El campo {0} debe tener un formato GUID válido") { }

    public override bool IsValid(object? value)
    {
        if (value == null) return false;
        if (value is string strValue)
        {
            return !string.IsNullOrWhiteSpace(strValue) && Guid.TryParse(strValue, out _);
        }
        return false;
    }
}
