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
            // 1. Obtener Cliente (usuario con rol 'cliente')
            var userIdObj = await DatabaseHelper.ExecuteScalarAsync<string>(
                "SELECT TOP 1 u.Id FROM AspNetUsers u JOIN AspNetUserRoles ur ON u.Id = ur.UserId JOIN AspNetRoles r ON ur.RoleId = r.Id WHERE r.Name = 'cliente'", 
                connectionString);
            string userId = userIdObj?.ToString() 
                ?? throw new Exception("Error: No se encontró ningún usuario con rol 'cliente'. Ejecutar seed de BD.");

            // 2. Obtener Entrenador (usuario con rol 'empleado' o 'entrenador')
            var trainerIdObj = await DatabaseHelper.ExecuteScalarAsync<string>(
                "SELECT TOP 1 u.Id FROM AspNetUsers u JOIN AspNetUserRoles ur ON u.Id = ur.UserId JOIN AspNetRoles r ON ur.RoleId = r.Id WHERE r.Name IN ('empleado', 'entrenador')", 
                connectionString);
            string trainerId = trainerIdObj?.ToString() 
                ?? throw new Exception("Error: No se encontró ningún usuario con rol 'empleado' o 'entrenador'. Ejecutar seed de BD.");

            // 3. Obtener Clase (usando ClaseID del esquema FitnessGymSchemaV720260424.sql)
            var claseIdObj = await DatabaseHelper.ExecuteScalarAsync<int>(
                "SELECT TOP 1 ClaseID FROM Clases", 
                connectionString);
            int claseId = claseIdObj;

            // 4. Obtener Hora Laboral (idHora del esquema)
            var horaIdObj = await DatabaseHelper.ExecuteScalarAsync<int>(
                "SELECT TOP 1 idHora FROM horasLaborales", 
                connectionString);
            int horaLaboralId = horaIdObj;

            // 5. Obtener horaInicio y construir fechaReservada (manejo seguro de tipos)
            var horaInicio = await DatabaseHelper.ExecuteScalarAsync<TimeSpan>(
                $"SELECT horaInicio FROM horasLaborales WHERE idHora = {horaLaboralId}", 
                connectionString);

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
    }
}