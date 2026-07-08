using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Helpers
{
    public static class PreReservaDeHorarioHelper
    {
        public static async Task<TestDTOFkNecesariasParaPreReserva> obtenerRegistrosNecesarios(string connectionString)
        {
            try
            {
                // 1. Obtener Cliente (usuario con rol 'cliente')
                var userIdObj = await DatabaseHelper.ExecuteScalarAsync<string>(
                    connectionString,
                    "SELECT TOP 1 u.Id FROM AspNetUsers u JOIN AspNetUserRoles ur ON u.Id = ur.UserId JOIN AspNetRoles r ON ur.RoleId = r.Id WHERE r.Name = 'cliente'");
                string userId = userIdObj?.ToString()
                    ?? throw new Exception("Error: No se encontró ningún usuario con rol 'cliente'. Ejecutar seed de BD.");

                // 2. Obtener horario disponible usando sp_obtenerHorariosDisponibles
                //    Esta función ya filtra slots ocupados por clases programadas, pre-reservas activas y días festivos
                var horariosDisponibles = await DatabaseHelper.ExecuteQueryAsync(
                    connectionString,
                    "EXEC sp_obtenerHorariosDisponibles @Fecha = @Fecha",
                    new Dictionary<string, object?> { ["@Fecha"] = DateTime.Today });

                if (horariosDisponibles.Count == 0)
                    throw new Exception("No hay horarios disponibles para la fecha actual. Verificar datos de backup.");

                var primerHorario = horariosDisponibles[0];
                int idHoraLaboral = Convert.ToInt32(primerHorario["idHora"]);
                var fechaDisponible = (DateTime)primerHorario["FechaDisponible"];
                var horaInicio = (TimeSpan)primerHorario["horaInicio"];

                // 3. Obtener entrenador disponible para esa fecha/hora específica usando sp_obtenerEntrenadoresDisponibles
                //    Esta función filtra entrenadores que ya tienen clases programadas en ese horario
                DateTime fechaHoraReferencia = fechaDisponible.Date.Add(horaInicio);

                var entrenadoresDisponibles = await DatabaseHelper.ExecuteQueryAsync(
                    connectionString,
                    "EXEC sp_obtenerEntrenadoresDisponibles @fechaReferencia = @fechaReferencia",
                    new Dictionary<string, object?> { ["@fechaReferencia"] = fechaHoraReferencia });

                if (entrenadoresDisponibles.Count == 0)
                    throw new Exception("No hay entrenadores disponibles para la fecha/hora seleccionada.");

                string trainerId = entrenadoresDisponibles[0]["UsuarioID"]?.ToString()
                    ?? throw new Exception("Error: No se encontró entrenador disponible.");

                // 4. Obtener Clase
                var claseIdObj = await DatabaseHelper.ExecuteScalarAsync<int>(
                    connectionString,
                    "SELECT TOP 1 ClaseID FROM Clases");
                int claseId = claseIdObj;

                // 5. Fecha reservada es SOLO fecha (date-only), sin hora.
                //    La hora se maneja mediante HoraLaboralId (FK a horasLaborales).
                DateTime fechaReservada = fechaDisponible.Date;

                return new TestDTOFkNecesariasParaPreReserva
                {
                    UserId = userId,
                    TrainerId = trainerId,
                    ClaseId = claseId,
                    HoraLaboralId = idHoraLaboral,
                    FechaReservada = fechaReservada
                };
            }
            catch (Exception ex)
            {
                Console.WriteLine($"MENSAJE  {ex.Message}");
                throw;
            }
        }
    }
}