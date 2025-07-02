// File: Services/HorariosService.cs
using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Services
{
    public class HorariosService
    {
        private readonly FitnessCenterDbContext _context;

        public HorariosService(FitnessCenterDbContext context)
        {
            _context = context;
        }

        public async Task<List<DTOHorarioVisualizacion>> ObtenerPreReservasDeHorario(DateTime? fecha = null)
        {
            try
            {
                // Usar la fecha proporcionada o la actual
                var fechaConsulta = fecha ?? DateTime.Now;

                // Ejecutar la función SQL para obtener los horarios pre reservados
                var horariosRaw = await _context
                    .DtoHorariosPreReservados
                    .FromSqlInterpolated($"SELECT * FROM dbo.fn_consultarHorariosPreReservados({fechaConsulta})")
                    .ToListAsync();

                // Proyección a DTOHorarioVisualizacion
                var horariosVisualizacion = horariosRaw.Select(h => new DTOHorarioVisualizacion
                {
                    idHora = h.idPreReserva,
                    diaDeLaSemana = h.fechaReservada.DayOfWeek.ToString(),
                    fechaDisponible = h.fechaReservada,
                    horaInicio = h.horaInicio,
                    horaFin = h.horaFin,
                    tipoDeDia = h.fechaReservada.DayOfWeek == DayOfWeek.Saturday || h.fechaReservada.DayOfWeek == DayOfWeek.Sunday ? "Fin de semana" : "Laboral"
                }).ToList();

                return horariosVisualizacion; // Devolver solo la lista
            }
            catch (Exception)
            {
                throw; // Lanzar la excepción para manejarla en el controlador
            }
        }

        public async Task<List<DTOHorarioVisualizacion>> consultarHorariosDisponibles(DateTime? fecha = null)
        {
            try
            {
                var fechaConsulta = fecha ?? DateTime.Now;
                // Ejecutar el procedimiento almacenado para obtener los horarios disponibles
                var horariosDisponibles = await _context
                    .DtoHorarioVisualizacion
                    .FromSqlInterpolated($"EXEC sp_obtenerHorariosDisponibles @fecha={fechaConsulta}")
                    .ToListAsync();

                return horariosDisponibles; // Devolver directamente la lista de DTOHorarioVisualizacion
            }
            catch (Exception)
            {
                throw; // Lanzar la excepción para manejarla en el controlador
            }
        }
    }
}