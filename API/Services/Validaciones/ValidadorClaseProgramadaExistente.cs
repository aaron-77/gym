using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;

namespace API.Services.Validaciones;

/// <summary>
/// Validador que verifica existencia de clase programada usando FitnessCenterDbContext.
/// Ubicado en API porque requiere acceso a BD.
/// </summary>
public class ValidadorClaseProgramadaExistente : IValidadorClaseProgramadaExistente
{
    private readonly FitnessCenterDbContext _context;

    public ValidadorClaseProgramadaExistente(FitnessCenterDbContext context)
    {
        _context = context;
    }

    public async Task<(bool Existe, ClasesProgramada? ClaseProgramada)> ValidarAsync(int idClaseProgramada)
    {
        var claseProgramada = await _context.ClasesProgramadas.FindAsync(idClaseProgramada);
        return (claseProgramada is not null, claseProgramada);
    }
}
