// File: Services/HorariosService.cs
using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;

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
                    tipoDeDia = h.fechaReservada.DayOfWeek == DayOfWeek.Saturday || h.fechaReservada.DayOfWeek == DayOfWeek.Sunday ? "Fin de semana" : "Laboral",
                    idUsuarioQueReserva = h.idUsuarioQueReserva,
                    fechaReservada = h.fechaReservada,
                    fechaDeExpiracionDeLaReserva = h.fechaDeExpiracionDeLaReserva
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
                
                var parametros = new SqlParameter[]
                {
                    new SqlParameter("@idUsuarioQueReserva", preReserva.idUsuarioQueReserva ?? (object)DBNull.Value),
                    new SqlParameter("@fechaTentativa", fechaDateTime),
                    new SqlParameter("@idHoraLaboral", preReserva.idHoraLaboral),
                    new SqlParameter("@idClase", preReserva.idClase ?? (object)DBNull.Value),
                    new SqlParameter("@idEntrenador", preReserva.idEntrenador ?? (object)DBNull.Value),
                    new SqlParameter("@idPrereservaOut", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    }
                };

                await _context.Database.ExecuteSqlRawAsync(
                    "EXEC sp_preReservarHorario @idUsuarioQueReserva, @fechaTentativa, @idHoraLaboral, @idClase, @idEntrenador, @idPrereservaOut OUTPUT",
                    parametros
                );

                int idPreReserva = (int)parametros[parametros.Length - 1].Value;

                return idPreReserva;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: RegistrarPreReservaDeHorario(HorariosService) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | PreReserva.UserId: {preReserva?.idUsuarioQueReserva} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);

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
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerClaseProgramadaConNuevoCupo (HorariorsService) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);

                throw;
            }
        }
    }
}