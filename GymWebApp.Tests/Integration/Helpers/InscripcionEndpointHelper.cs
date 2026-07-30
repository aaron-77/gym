using Microsoft.Data.SqlClient;
using BL.Utils.Enums;
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
        // 1. Tomar un cliente activo sin inscripciones previas
        var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 u.Id
              FROM AspNetUsers u
              JOIN AspNetUserRoles aur ON u.Id = aur.UserId
              JOIN AspNetRoles r ON aur.RoleId = r.Id AND r.Name = 'cliente'
              WHERE u.Estado = 'activo'
                AND u.Id NOT IN (SELECT fkCliente FROM inscripcionesDeClases)
              ORDER BY NEWID()");

        // Fallback: si todos los clientes activos ya tienen inscripciones,
        // tomar un cliente activo con inscripciones en clases de hoy
        if (clienteRow == null)
        {
            clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
                connectionString,
                @"SELECT TOP 1 u.Id
                  FROM AspNetUsers u
                  JOIN AspNetUserRoles aur ON u.Id = aur.UserId
                  JOIN AspNetRoles r ON aur.RoleId = r.Id AND r.Name = 'cliente'
                  WHERE u.Estado = 'activo'
                    AND u.Id IN (
                        SELECT DISTINCT i.fkCliente
                        FROM inscripcionesDeClases i
                        INNER JOIN clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase
                        WHERE cp.fechaDeLaClase = CAST(GETDATE() AS DATE)
                    )
                  ORDER BY NEWID()");

            return clienteRow?["Id"]?.ToString()
                ?? throw new InvalidOperationException("No se encontró ningún cliente activo en la BD");
        }

        var clienteId = clienteRow["Id"]?.ToString()
            ?? throw new InvalidOperationException("El cliente seleccionado tiene Id nulo");

        // 2. Obtener datos base para los INSERTs (lecturas fuera de transacción)
        var claseRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 claseId FROM Clases WHERE fkEstadoClase = 1");
        var fkClase = Convert.ToInt32(claseRow?["claseId"] ?? 1);

        var entrenadorRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 Id FROM AspNetUsers");
        var fkEntrenador = entrenadorRow?["Id"]?.ToString()
            ?? throw new InvalidOperationException("No users found in database");

        var estadoRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 idEstadoClaseProgramada FROM estadosClasesProgramadas");
        var fkEstado = Convert.ToInt32(estadoRow?["idEstadoClaseProgramada"] ?? 1);

        // 2. Obtener un slot realmente disponible vía sp_obtenerHorariosDisponibles
        var horariosDisponibles = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            connectionString,
            FiltroFecha.Mayor,
            FiltroHora.SinFiltro);

        if (horariosDisponibles.Count == 0)
            throw new InvalidOperationException("No hay horarios disponibles para crear la inscripción de prueba");

        var random = new Random();
        var slot = horariosDisponibles[random.Next(horariosDisponibles.Count)];
        var fechaDisponible = DateOnly.FromDateTime(Convert.ToDateTime(slot["FechaDisponible"]));
        var idHorario = Convert.ToInt32(slot["idHora"]);

        var estadoInscripcionRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 idEstadoInscripcion FROM estadosInscripciones WHERE idEstadoInscripcion = 1");
        var fkEstadoInscripcion = Convert.ToInt32(estadoInscripcionRow?["idEstadoInscripcion"] ?? 1);

        // Escrituras dentro de transacción
        return await DatabaseHelper.WithTransactionAsync(connectionString, async (connection, transaction) =>
        {
            var idClaseProgramada = await DatabaseHelper.ExecuteScalarAsync<int>(
                connection, transaction,
                @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador) 
                  VALUES (@FkClase, 20, @FkEstado, @Fecha, @FkEntrenador);
                  SELECT SCOPE_IDENTITY();",
                new Dictionary<string, object?>
                {
                    ["@FkClase"] = fkClase,
                    ["@FkEstado"] = fkEstado,
                    ["@Fecha"] = fechaDisponible,
                    ["@FkEntrenador"] = fkEntrenador
                });

            await DatabaseHelper.ExecuteNonQueryAsync(
                connection, transaction,
                "INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral) VALUES (@FkClaseProg, @FkHorario)",
                new Dictionary<string, object?>
                {
                    ["@FkClaseProg"] = idClaseProgramada,
                    ["@FkHorario"] = idHorario
                });

            await DatabaseHelper.ExecuteNonQueryAsync(
                connection, transaction,
                @"INSERT INTO inscripcionesDeClases (fkProgramacionClase, fechaDeInscripcion, fkEstadoInscripcion, fkCliente)
                  VALUES (@FkProgramacionClase, GETDATE(), @FkEstadoInscripcion, @FkCliente)",
                new Dictionary<string, object?>
                {
                    ["@FkProgramacionClase"] = idClaseProgramada,
                    ["@FkEstadoInscripcion"] = fkEstadoInscripcion,
                    ["@FkCliente"] = clienteId!
                });

            return clienteId!;
        });
        
        
    }
}
