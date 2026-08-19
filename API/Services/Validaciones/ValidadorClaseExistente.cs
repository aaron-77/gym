using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;

namespace API.Services.Validaciones;

/// <summary>
/// Validador que verifica existencia de clase usando FitnessCenterDbContext.
/// Ubicado en API porque requiere acceso a BD.
/// </summary>
public class ValidadorClaseExistente : IValidadorClaseExistente
{
    private readonly FitnessCenterDbContext _context;

    public ValidadorClaseExistente(FitnessCenterDbContext context)
    {
        _context = context;
    }

    public async Task<(bool Existe, Clase? Clase)> ValidarAsync(int idClase)
    {
        var clase = await _context.Clases.FindAsync(idClase);
        return (clase is not null, clase);
    }
}
