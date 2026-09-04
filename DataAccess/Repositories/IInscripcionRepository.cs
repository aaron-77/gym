using DataAccess.EntityFramework;
using DTO.Dtos;

namespace DataAccess.Repositories;

public interface IInscripcionRepository
{
    Task<List<DTOInscripcionDelCliente>> ObtenerInscripcionesDelClienteAsync(string idUsuario);
    Task<InscripcionesDeClase?> ObtenerInscripcionConClaseYHorariosAsync(int idInscripcion);
    Task<ClasesProgramada?> ObtenerClaseProgramadaConHorariosAsync(int idClaseProgramada);
    Task EjecutarCancelacionAsync(int idInscripcion);
    Task EjecutarReagendacionAsync(int idInscripcion, int idClaseProgramada, string idCliente);
    Task<List<PreReservasDeHorario>> EncontrarPreReservasAsync(int fkHoraLaboral, DateOnly fechaReservada, int idClase, string idEntrenador);
    Task<int> EliminarPreReservasEspecificasAsync(ICollection<int> idsPreReserva);
}
