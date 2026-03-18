using DTO.Dtos;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace API.Services
{
    public interface IClasesService
    {
        Task<List<DTODificultad>> GetNivelesDeDificultadAsync();
        Task<List<DTOIntensidad>> GetNivelesDeIntensidadAsync();
        Task<List<QueryUser>> GetInstructoresAsync();
        Task<List<DTOClasePreview>> GetPreviewDeClasesAsync();
    }
}
