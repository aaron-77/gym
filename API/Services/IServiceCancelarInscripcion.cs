using DTO.Dtos;

namespace API.Services;

public interface IServiceCancelarInscripcion
{
    /// <summary>
    /// Cancela una inscripción validando que exista, que la clase no haya finalizado,
    /// y ejecuta el procedimiento almacenado de cancelación.
    /// </summary>
    /// <param name="idInscripcion">ID de la inscripción a cancelar.</param>
    /// <returns>DTOResponse con true si se canceló exitosamente, false en caso contrario.</returns>
    Task<DTOResponse<bool>> CancelarInscripcionAsync(int idInscripcion);
}
