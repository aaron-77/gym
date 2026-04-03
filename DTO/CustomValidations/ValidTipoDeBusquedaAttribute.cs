using System.ComponentModel.DataAnnotations;

public class ValidTipoDeBusquedaAttribute : ValidationAttribute
{
    private static readonly string[] ValoresPermitidos = { "MES", "AÑO" };

    public ValidTipoDeBusquedaAttribute() : base("El campo tipoDeBusqueda debe tener un valor válido: MES o AÑO") { }

    public override bool IsValid(object? value)
    {
        if (value == null) return false;
        if (value is string strValue)
        {
            return ValoresPermitidos.Contains(strValue.ToUpper());
        }
        return false;
    }
}
