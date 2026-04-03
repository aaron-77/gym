using System.ComponentModel.DataAnnotations;

public class ValidEspaciadoTemporalAttribute : ValidationAttribute
{
    private static readonly string[] ValoresPermitidos = { "individual", "promedio" };

    public ValidEspaciadoTemporalAttribute() : base("El campo espaciadoTemporal debe tener un valor válido: individual o promedio") { }

    public override bool IsValid(object? value)
    {
        if (value == null) return false;
        if (value is string strValue)
        {
            return ValoresPermitidos.Contains(strValue.ToLower());
        }
        return false;
    }
}
