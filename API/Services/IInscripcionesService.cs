using DTO.Dtos;

namespace API.Services;

/// <summary>
/// Servicio unificado para operaciones relacionadas con inscripciones.
/// </summary>
public interface IInscripcionesService
{
    /// <summary>
    /// Consulta las inscripciones vigentes de un cliente en clases futuras.
    /// </summary>
    /// <param name="idUsuario">ID del cliente (GUID).</param>
    /// <returns>Lista de inscripciones del cliente.</returns>
    Task<DTOResponse<List<DTOInscripcionDelCliente>>> ConsultarInscripcionesDeClienteAsync(string idUsuario);

    /// <summary>
    /// Cancela una inscripción validando que exista, que la clase no haya finalizado,
    /// y ejecuta el procedimiento almacenado de cancelación.
    /// </summary>
    /// <param name="idInscripcion">ID de la inscripción a cancelar.</param>
    /// <returns>DTOResponse con true si se canceló exitosamente.</returns>
    Task<DTOResponse<bool>> CancelarInscripcionAsync(int idInscripcion);
}
