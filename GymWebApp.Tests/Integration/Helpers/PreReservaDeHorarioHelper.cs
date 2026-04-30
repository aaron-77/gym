using System;
using System.Data;
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

            // 2. Obtener Entrenador (usuario con rol 'empleado' o 'entrenador')
            var trainerIdObj = await DatabaseHelper.ExecuteScalarAsync<string>(
                connectionString,
                "SELECT TOP 1 u.Id FROM AspNetUsers u JOIN AspNetUserRoles ur ON u.Id = ur.UserId JOIN AspNetRoles r ON ur.RoleId = r.Id WHERE r.Name IN ('empleado', 'entrenador')");
            string trainerId = trainerIdObj?.ToString() 
                ?? throw new Exception("Error: No se encontró ningún usuario con rol 'empleado' o 'entrenador'. Ejecutar seed de BD.");

            // 3. Obtener Clase (usando ClaseID del esquema FitnessGymSchemaV720260424.sql)
            var claseIdObj = await DatabaseHelper.ExecuteScalarAsync<int>(
                connectionString,
                "SELECT TOP 1 ClaseID FROM Clases");
            int claseId = claseIdObj;

            // 4. Obtener Hora Laboral (idHora del esquema)
            var horaIdObj = await DatabaseHelper.ExecuteScalarAsync<int>(
                connectionString,
                "SELECT TOP 1 idHora FROM horasLaborales");
            int horaLaboralId = horaIdObj;

            // 5. Obtener horaInicio y construir fechaReservada (manejo seguro de tipos)
            var horaInicio = await DatabaseHelper.ExecuteScalarAsync<TimeSpan>(
                connectionString,
                $"SELECT horaInicio FROM horasLaborales WHERE idHora = {horaLaboralId}");

            DateTime fechaReservada = DateTime.Today.Add(horaInicio);

            return new TestDTOFkNecesariasParaPreReserva
            {
                UserId = userId,
                TrainerId = trainerId,
                ClaseId = claseId,
                HoraLaboralId = horaLaboralId,
                FechaReservada = fechaReservada
            };

            }
            catch (Exception ex)
            {
                //string logMessage = $"[ERROR] Método: obtenerRegistrosNecesarios (PreReservaDeHorarioHelper) | Línea: {new System.Diagnostics.StackTrace(e, true).GetFrame(0)?.GetFileLineNumber()} | MESAJE: {e.GetType().Name} - {e.Message}|CAUSA {e.InnerException.Message}  | Stack Trace: {e.StackTrace}";
                Console.WriteLine($"MENSAJE  {ex.Message}");
                throw;
            }
            
        }
    }
}