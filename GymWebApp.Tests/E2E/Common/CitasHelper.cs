using DTO.Dtos;
using GymWebApp.Tests.SharedHelpers;

namespace GymWebApp.Tests.E2E.Common;

public static class CitasHelper
{
    /// <summary>
    /// Obtiene el ID de un usuario por su rol.
    /// </summary>
    /// <param name="connectionString">Connection string para la base de datos</param>
    /// <param name="roleName">Nombre del rol (ej: "cliente", "empleado")</param>
    /// <returns>GUID del usuario</returns>
    /// <exception cref="InvalidOperationException">Si no se encuentra usuario con el rol especificado</exception>
    public static async Task<string> GetUserIdByRoleAsync(string connectionString, string roleName)
    {
        var user = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 u.Id FROM AspNetUsers u
              INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId
              INNER JOIN AspNetRoles r ON ur.RoleId = r.Id
              WHERE r.Name = @RoleName",
            new() { ["@RoleName"] = roleName }
        );
        return user?["Id"]?.ToString() 
            ?? throw new InvalidOperationException($"No user found with role '{roleName}'");
    }

    /// <summary>
    /// Obtiene el ID de un cliente.
    /// </summary>
    /// <param name="connectionString">Connection string para la base de datos</param>
    /// <returns>GUID del cliente</returns>
    public static async Task<string> GetClienteIdAsync(string connectionString)
        => await GetUserIdByRoleAsync(connectionString, "cliente");

    /// <summary>
    /// Obtiene el ID de un empleado/entrenador.
    /// </summary>
    /// <param name="connectionString">Connection string para la base de datos</param>
    /// <returns>GUID del empleado</returns>
    public static async Task<string> GetEntrenadorIdAsync(string connectionString)
        => await GetUserIdByRoleAsync(connectionString, "empleado");

    /// <summary>
    /// Genera un objeto Cita con datos válidos para pruebas E2E.
    /// </summary>
    /// <param name="connectionString">Connection string para la base de datos</param>
    /// <returns>Cita con datos de prueba</returns>
    public static async Task<Cita> GenerarCitaObject(string connectionString)
    {
        var clienteId = await GetClienteIdAsync(connectionString);
        var entrenadorId = await GetEntrenadorIdAsync(connectionString);

        var fechaInicio = DateTime.Now.AddDays(7).Date.AddHours(9);
        var fechaFin = fechaInicio.AddHours(1);

        return new Cita
        {
            fechaInicioCita = fechaInicio,
            fechaFinCita = fechaFin,
            fkCliente = clienteId,
            fkEntrenador = entrenadorId,
            tipoCita = "Medicion",
            estado = "Agendada"
        };
    }

    /// <summary>
    /// Registra una cita directamente en la base de datos.
    /// </summary>
    public static async Task RegistrarCitaEnBd(string connectionString, Cita cita)
    {
        await DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            @"INSERT INTO Citas (FechaHora, TipoCita, Estado, FechaHoraFin, EntrenadorId, UserId)
              VALUES (@FechaHora, @TipoCita, @Estado, @FechaHoraFin, @EntrenadorId, @UserId)",
            new()
            {
                ["@FechaHora"] = cita.fechaInicioCita,
                ["@TipoCita"] = cita.tipoCita,
                ["@Estado"] = cita.estado ?? "Agendada",
                ["@FechaHoraFin"] = cita.fechaFinCita,
                ["@EntrenadorId"] = new Guid(cita.fkEntrenador),
                ["@UserId"] = new Guid(cita.fkCliente)
            }
        );
    }

    /// <summary>
    /// Genera una cita y la registra en BD. Retorna la Cita populada.
    /// </summary>
    public static async Task<Cita> GenerarYRegistrarCitaObject(string connectionString)
    {
        var cita = await GenerarCitaObject(connectionString);
        await RegistrarCitaEnBd(connectionString, cita);
        return cita;
    }
}