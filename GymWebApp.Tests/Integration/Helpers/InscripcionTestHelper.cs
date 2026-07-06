using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Helpers;

/// <summary>
/// Helper para tests de integración del feature Inscripciones.
/// Centraliza lógica de seeding de datos y consultas SQL repetitivas
/// para mantener los tests limpios y evitar lógica inline.
/// </summary>
public static class InscripcionTestHelper
{
    /// <summary>
    /// Genera clases programadas para hoy (sp_cron_generarClasesProgramadas),
    /// selecciona un cliente sin inscripciones previas y lo inscribe a una clase futura
    /// (sp_generarRegistroDePrueba_inscricionesDeClases).
    /// </summary>
    /// <returns>ID del cliente que fue inscrito.</returns>
    public static async Task<string> SeedFreshInscripcionAsync(string connectionString)
    {
        // 1. Generar clases programadas para hoy
        await DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            "EXEC dbo.sp_cron_generarClasesProgramadas");

        // 2. Tomar un cliente sin inscripciones previas (evita duplicados)
        var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 Id FROM AspNetUsers
              WHERE Id NOT IN (SELECT fkCliente FROM inscripcionesDeClases)
              ORDER BY NEWID()");
        var clienteId = clienteRow?["Id"]?.ToString()
            ?? throw new InvalidOperationException("No se encontró ningún usuario sin inscripciones en seed data");

        // 3. Seleccionar una clase que pase el MISMO filtro que fn_obtenerInscripcionesDelCliente
        //    (fecha futura, o fecha hoy con hora todavía no vencida)
        var claseRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 cp.idProgramacionClase
              FROM clasesProgramadas cp
              INNER JOIN horariosDeClasesProgramadas hcp
                  ON cp.idProgramacionClase = hcp.fkClaseProgramada
              INNER JOIN horasLaborales hl
                  ON hcp.fkHorarioLaboral = hl.idHora
              WHERE cp.fechaDeLaClase > CAST(GETDATE() AS DATE)
                 OR (cp.fechaDeLaClase = CAST(GETDATE() AS DATE)
                     AND hl.horaInicio > CAST(GETDATE() AS TIME))
              ORDER BY NEWID()");

        var idClaseProgramada = claseRow?["idProgramacionClase"] != null
            ? Convert.ToInt32(claseRow["idProgramacionClase"])
            : 0;

        if (idClaseProgramada <= 0)
            throw new InvalidOperationException("sp_cron_generarClasesProgramadas debió generar al menos una clase con horario futuro");

        // 4. Inscribir al cliente via SP (valida cupo, duplicados, etc.)
        await DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            "EXEC dbo.sp_generarRegistroDePrueba_inscricionesDeClases @idCliente = @Cliente, @idClaseProgramada = @Clase",
            new Dictionary<string, object?>
            {
                ["@Cliente"] = clienteId,
                ["@Clase"] = idClaseProgramada
            });

        return clienteId;
    }

    /// <summary>
    /// Obtiene el ID de un cliente que NO tenga inscripciones vigentes (futuras).
    /// Útil para tests que verifican el comportamiento con listas vacías.
    /// </summary>
    /// <returns>ID del cliente, o null si todos los clientes tienen inscripciones.</returns>
    public static async Task<string?> GetClienteSinInscripcionesVigentesAsync(string connectionString)
    {
        var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 u.Id FROM AspNetUsers u
              WHERE NOT EXISTS (
                  SELECT 1
                  FROM inscripcionesDeClases i
                      INNER JOIN clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase
                      INNER JOIN horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
                      INNER JOIN horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
                  WHERE i.fkCliente = u.Id
                      AND (
                          cp.fechaDeLaClase > CAST(GETDATE() AS DATE)
                          OR (cp.fechaDeLaClase = CAST(GETDATE() AS DATE) AND hl.horaInicio > CAST(GETDATE() AS TIME))
                      )
              )");

        return clienteRow?["Id"]?.ToString();
    }
}
