using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Helpers;

/// <summary>
/// Helper para tests del endpoint de inscripciones.
/// </summary>
public static class InscripcionEndpointHelper
{
    /// <summary>
    /// Crea datos frescos de clases programadas e inscripciones via inserts directos.
    /// Garantiza el estado de datos necesario para el test sin depender de SPs del negocio.
    /// </summary>
    /// <returns>ID del cliente que fue inscrito.</returns>
    public static async Task<string> SeedFreshInscripcionAsync(string connectionString)
    {
        // 1. Tomar un cliente existente de seed data
        var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 Id FROM AspNetUsers
              WHERE Id NOT IN (SELECT fkCliente FROM inscripcionesDeClases)
              ORDER BY NEWID()");

        var clienteId = clienteRow?["Id"]?.ToString();
        if (clienteId == null)
        {
            // Si todos los usuarios tienen inscripciones, crear uno nuevo
            clienteId = Guid.NewGuid().ToString();
            await DatabaseHelper.ExecuteNonQueryAsync(
                connectionString,
                @"INSERT INTO AspNetUsers (Id, UserName, NormalizedUserName, Email, EmailConfirmed, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEnabled, AccessFailedCount, NombreCompleto, FechaDeRegistro)
                  VALUES (@Id, @Id, @Id, @Id + '@test.com', 0, 0, 0, 0, 0, 'Test User', GETDATE())",
                new Dictionary<string, object?> { ["@Id"] = clienteId });

            var rolRow = await DatabaseHelper.ExecuteQuerySingleAsync(
                connectionString,
                "SELECT TOP 1 Id FROM AspNetRoles WHERE Name = 'cliente'");
            var rolId = rolRow?["Id"]?.ToString();
            if (rolId != null)
            {
                await DatabaseHelper.ExecuteNonQueryAsync(
                    connectionString,
                    "INSERT INTO AspNetUserRoles (UserId, RoleId) VALUES (@UserId, @RoleId)",
                    new Dictionary<string, object?>
                    {
                        ["@UserId"] = clienteId,
                        ["@RoleId"] = rolId
                    });
            }
        }

        // 2. Obtener una clase y un entrenador existente
        var claseRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 claseId FROM Clases WHERE fkEstadoClase = 1");
        var fkClase = Convert.ToInt32(claseRow?["claseId"] ?? 1);

        var entrenadorRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 Id FROM AspNetUsers");
        var fkEntrenador = entrenadorRow?["Id"]?.ToString() ?? throw new InvalidOperationException("No users found in database");

        var estadoRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 idEstadoClaseProgramada FROM estadosClasesProgramadas");
        var fkEstado = Convert.ToInt32(estadoRow?["idEstadoClaseProgramada"] ?? 1);

        // 3. Crear clase programada en el futuro
        var fechaFutura = DateOnly.FromDateTime(DateTime.Now.AddDays(30));
        var idClaseProgramada = await DatabaseHelper.ExecuteScalarAsync<int>(
            connectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador) 
              VALUES (@FkClase, 20, @FkEstado, @Fecha, @FkEntrenador);
              SELECT SCOPE_IDENTITY();",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = fkClase,
                ["@FkEstado"] = fkEstado,
                ["@Fecha"] = fechaFutura,
                ["@FkEntrenador"] = fkEntrenador
            });

        // 4. Asociar un horario a la clase programada
        var horarioRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 idHora, horaInicio, horaFin FROM horasLaborales ORDER BY NEWID()");
        var idHorario = horarioRow != null ? Convert.ToInt32(horarioRow["idHora"]) : 1;

        await DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            "INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral) VALUES (@FkClaseProg, @FkHorario)",
            new Dictionary<string, object?>
            {
                ["@FkClaseProg"] = idClaseProgramada,
                ["@FkHorario"] = idHorario
            });

        // 5. Crear inscripción vigente (estado 1 = Vigente)
        var estadoInscripcionRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 idEstadoInscripcion FROM estadosInscripciones WHERE idEstadoInscripcion = 1");
        var fkEstadoInscripcion = Convert.ToInt32(estadoInscripcionRow?["idEstadoInscripcion"] ?? 1);

        await DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            @"INSERT INTO inscripcionesDeClases (fkProgramacionClase, fechaDeInscripcion, fkEstadoInscripcion, fkCliente)
              VALUES (@FkProgramacionClase, GETDATE(), @FkEstadoInscripcion, @FkCliente)",
            new Dictionary<string, object?>
            {
                ["@FkProgramacionClase"] = idClaseProgramada,
                ["@FkEstadoInscripcion"] = fkEstadoInscripcion,
                ["@FkCliente"] = clienteId!
            });

        return clienteId!;
    }
}
