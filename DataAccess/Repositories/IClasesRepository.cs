using DataAccess.EntityFramework;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace DataAccess.Repositories
{
    public interface IClasesRepository
    {
        Task<List<VNivelesDeDificultad>> GetNivelesDeDificultadAsync();
        Task<List<VNivelesDeIntensidad>> GetNivelesDeIntensidadAsync();
        Task<List<Clase>> GetPreviewDeClasesAsync();
    }
}
