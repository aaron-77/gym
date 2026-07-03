namespace BL.Validaciones;

/// <summary>
/// Validador estático para IDs recibidos como string.
/// No requiere acceso a base de datos — solo validaciones de formato.
/// </summary>
public static class ValidadorStringId
{
    /// <summary>
    /// Valida que el ID no sea null, vacío o whitespace, y que tenga formato GUID válido.
    /// </summary>
    /// <param name="id">El ID a validar.</param>
    /// <param name="nombreParametro">Nombre del parámetro para el mensaje de error.</param>
    /// <returns>Tupla con (esValido, mensajeError). mensajeError es string.Empty si es válido.</returns>
    public static (bool EsValido, string MensajeError) Validar(string? id, string nombreParametro)
    {
        if (string.IsNullOrWhiteSpace(id))
        {
            return (false, $"El {nombreParametro} es obligatorio.");
        }

        if (!Guid.TryParse(id, out _))
        {
            return (false, $"El {nombreParametro} no tiene un formato GUID válido.");
        }

        return (true, string.Empty);
    }
}
