using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Helpers;

/// <summary>
/// Helper para tests del endpoint de inscripciones.
/// </summary>
public static class InscripcionEndpointHelper
{
    /// <summary>
    /// Crea datos frescos de clases programadas e inscripciones via inserts directos.
    /// Usa <see cref="SlotDisponibleParaClaseProgramadaHelper"/> para armar por construcción
    /// el dataset completo (slot realmente disponible con fecha futura, entrenador activo,
    /// clase activa y cliente libre en ese horario).
    /// </summary>
    /// <returns>ID del cliente que fue inscrito.</returns>
    public static async Task<string> SeedFreshInscripcionAsync(string connectionString)
    {
        // Dataset completo por construcción: slot libre (fecha futura) + entrenador activo + clase activa + cliente libre.
        var dto = await SlotDisponibleParaClaseProgramadaHelper
            .obtenerSlotDisponibleParaClaseProgramadaAsync(connectionString);

        if (dto == null)
            throw new InvalidOperationException("No hay horarios disponibles para crear la inscripción de prueba");

        var idEstadoDisponible = await DatabaseHelper.ExecuteScalarAsync<int?>(
            connectionString,
            "SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas")
            ?? 1;

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
                  VALUES (@FkClase, @CupoMaximo, @Estado, @Fecha, @FkEntrenador);
                  SELECT SCOPE_IDENTITY();",
                new Dictionary<string, object?>
                {
                    ["@FkClase"] = dto.ClaseId,
                    ["@CupoMaximo"] = dto.Cupo,
                    ["@Estado"] = idEstadoDisponible,
                    ["@Fecha"] = dto.FechaDisponible,
                    ["@FkEntrenador"] = dto.EntrenadorId
                });

            await DatabaseHelper.ExecuteNonQueryAsync(
                connection, transaction,
                "INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral) VALUES (@FkClaseProg, @FkHorario)",
                new Dictionary<string, object?>
                {
                    ["@FkClaseProg"] = idClaseProgramada,
                    ["@FkHorario"] = dto.IdHoraLaboral
                });

            await DatabaseHelper.ExecuteNonQueryAsync(
                connection, transaction,
                @"INSERT INTO inscripcionesDeClases (fkProgramacionClase, fechaDeInscripcion, fkEstadoInscripcion, fkCliente)
                  VALUES (@FkProgramacionClase, GETDATE(), @FkEstadoInscripcion, @FkCliente)",
                new Dictionary<string, object?>
                {
                    ["@FkProgramacionClase"] = idClaseProgramada,
                    ["@FkEstadoInscripcion"] = fkEstadoInscripcion,
                    ["@FkCliente"] = dto.ClienteId
                });

            return dto.ClienteId;
        });
    }
}
