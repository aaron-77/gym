using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace DataAccess.Repositories
{
    public class ClasesRepository : IClasesRepository
    {
        private readonly FitnessCenterDbContext _context;

        public ClasesRepository(FitnessCenterDbContext context)
        {
            _context = context;
        }

        public async Task<List<VNivelesDeDificultad>> GetNivelesDeDificultadAsync()
        {
            try
            {
                // Consultar la vista v_nivelesDeDificultad
                return await _context.VNivelesDeDificultads
                    .FromSqlRaw("SELECT * FROM v_nivelesDeDificultad")
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("Error al obtener niveles de dificultad desde el repositorio.", ex);
            }
        }

        public async Task<List<VNivelesDeIntensidad>> GetNivelesDeIntensidadAsync()
        {
            try
            {
                // Consultar la vista v_nivelesDeIntensidad
                return await _context.VNivelesDeIntensidads
                    .FromSqlRaw("SELECT * FROM v_nivelesDeIntensidad")
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("Error al obtener niveles de intensidad desde el repositorio.", ex);
            }
        }

        public async Task<List<Clase>> GetPreviewDeClasesAsync()
        {
            try
            {
                // Obtener clases activas con imágenes de banner
                return await _context.Clases
                    .Include(c => c.ImagesForClases)
                    .Where(c => c.FkEstadoClase == 1 && c.ImagesForClases.Any(i => i.UrlParaBanner != null))
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("Error al obtener preview de clases desde el repositorio.", ex);
            }
        }
    }
}
