using DataAccess.Identity;
using Microsoft.AspNetCore.Identity;

namespace API.Services.Validaciones;

/// <summary>
/// Validador que verifica existencia de usuario usando UserManager.
/// Ubicado en API porque requiere acceso a Identity (UserManager).
/// </summary>
public class ValidadorUsuarioExistente : IValidadorUsuarioExistente
{
    private readonly UserManager<ApplicationUser> _userManager;

    public ValidadorUsuarioExistente(UserManager<ApplicationUser> userManager)
    {
        _userManager = userManager;
    }

    public async Task<(bool Existe, ApplicationUser? Usuario)> ValidarAsync(string idUsuario)
    {
        var usuario = await _userManager.FindByIdAsync(idUsuario);
        return (usuario is not null, usuario);
    }
}
