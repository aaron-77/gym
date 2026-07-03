using DTO.Dtos;

namespace API.Services
{
    public interface IServiceConsultarInscripcionesDeCliente
    {
        Task<DTOResponse<List<DTOInscripcionDelCliente>>> ConsultarInscripcionesAsync(string idUsuario);
    }
}
