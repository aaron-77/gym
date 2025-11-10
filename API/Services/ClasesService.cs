// File: Services/HorariosService.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.EntityFrameworkCore;

namespace API.Services
{
    public class ClasesService
    {
        private readonly FitnessCenterDbContext _context;

        public ClasesService(FitnessCenterDbContext context)
        {
            _context = context;
        }

        public async Task<int> eliminarPreReservaDeClaseProgramada(
            int? idPreReserva
        )
        {
            int filas = 0;
            try
            {
                filas = await _context.PreReservasDeHorarios
                    .Where(p => p.IdPreReserva == idPreReserva)
                    .ExecuteDeleteAsync();
            }
            catch (Exception ex)
            {
                
                throw;
            }
            return filas;
        }
    }
}
