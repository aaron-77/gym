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
                    idHora = h.idHora,
                    idPreReserva = h.idPreReserva,
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
                // Ejecutar el procedimiento almacenado para obtener los horarios disponibles usando DTOHorariosDisponibles
                var horariosDisponiblesRaw = await _context
                    .DtoHorariosDisponibles
                    .FromSqlInterpolated($"EXEC sp_obtenerHorariosDisponibles @fecha={fechaConsulta}")
                    .ToListAsync();

                // Proyección a DTOHorarioVisualizacion
                var horariosDisponibles = horariosDisponiblesRaw.Select(h => new DTOHorarioVisualizacion
                {
                    idHora = h.idHora,
                    idPreReserva = null, // No hay idPreReserva en horarios disponibles
                    diaDeLaSemana = h.fechaDisponible.DayOfWeek.ToString(),
                    fechaDisponible = h.fechaDisponible,
                    horaInicio = h.horaInicio,
                    horaFin = h.horaFin,
                    tipoDeDia = h.fechaDisponible.DayOfWeek == DayOfWeek.Saturday || h.fechaDisponible.DayOfWeek == DayOfWeek.Sunday ? "Fin de semana" : "Laboral"
                }).ToList();

                return horariosDisponibles;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<int> RegistrarPreReservaDeHorario(DTOPreReservaDeHorario preReserva)
        {
            try
            {
                var fechaDateTime = preReserva.fechaTentativa.ToDateTime(TimeOnly.MinValue);
                
                // Ejecutar el procedimiento almacenado sp_preReservarHorario
                var idPreReserva = await _context.Database.ExecuteSqlInterpolatedAsync($@"
                    EXEC sp_preReservarHorario  @idUsuarioQueReserva={preReserva.idUsuarioQueReserva}, @fechaTentativa={fechaDateTime}, @idHoraLaboral={preReserva.idHoraLaboral}");
                return idPreReserva;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<List<DTOClaseProgramadaView>> obtenerClaseProgramadaConNuevoCupo(int idProgramacionClase)
        {
            try
            {
                var claseProgramada = await _context
                    .DTOClasesProgramadaView
                    .FromSqlInterpolated($"SELECT * FROM dbo.fn_obtenerClasesProgramadaPorIdProgramacionClase({idProgramacionClase})")
                    .ToListAsync();

                return claseProgramada;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}