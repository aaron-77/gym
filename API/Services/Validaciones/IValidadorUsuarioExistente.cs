using DataAccess.Identity;

namespace API.Services.Validaciones;

/// <summary>
/// Validador que verifica si un usuario existe en la base de datos.
/// Requiere acceso a BD — implementado en API/Services/Validaciones/.
/// </summary>
public interface IValidadorUsuarioExistente
{
    /// <summary>
    /// Valida que exista un usuario con el ID especificado.
    /// </summary>
    /// <param name="idUsuario">ID del usuario a verificar.</param>
    /// <returns>Tupla con (existe, usuario). usuario es null si no existe.</returns>
    Task<(bool Existe, ApplicationUser? Usuario)> ValidarAsync(string idUsuario);
}
