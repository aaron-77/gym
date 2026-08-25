using DataAccess.EntityFramework;

namespace API.Services.Validaciones;

/// <summary>
/// Validador que verifica si una clase programada existe en la base de datos.
/// Requiere acceso a BD — implementado en API/Services/Validaciones/.
/// </summary>
public interface IValidadorClaseProgramadaExistente
{
    /// <summary>
    /// Valida que exista una clase programada con el ID especificado.
    /// </summary>
    /// <param name="idClaseProgramada">ID de la clase programada a verificar.</param>
    /// <returns>Tupla con (existe, claseProgramada). claseProgramada es null si no existe.</returns>
    Task<(bool Existe, ClasesProgramada? ClaseProgramada)> ValidarAsync(int idClaseProgramada);
}
