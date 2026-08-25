using DataAccess.EntityFramework;

namespace API.Services.Validaciones;

/// <summary>
/// Validador que verifica si una clase existe en la base de datos.
/// Requiere acceso a BD — implementado en API/Services/Validaciones/.
/// </summary>
public interface IValidadorClaseExistente
{
    /// <summary>
    /// Valida que exista una clase con el ID especificado.
    /// </summary>
    /// <param name="idClase">ID de la clase a verificar.</param>
    /// <returns>Tupla con (existe, clase). clase es null si no existe.</returns>
    Task<(bool Existe, Clase? Clase)> ValidarAsync(int idClase);
}
