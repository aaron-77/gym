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
    /// Busca una inscripción existente para hoy con clase futura que todavía no haya comenzado.
    /// Si no existe, genera clases programadas (sp_cron_generarClasesProgramadas),
    /// selecciona un cliente (con rol cliente) y lo inscribe
    /// a una clase futura (sp_generarRegistroDePrueba_inscricionesDeClases).
    /// Genera MÚLTIPLES clases al llamar a sp_cron_generarClasesProgramadas.
    /// </summary>
    /// <returns>ID del cliente (existente o recién inscrito).</returns>
    public static async Task<string> BulkSeedFreshInscripcionAsync(string connectionString)
    {
        // 1. Verificar si ya existe una inscripción válida para hoy
        //    (clase futura de hoy que todavía no haya comenzado)
        var existingRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 i.fkCliente AS Id
              FROM inscripcionesDeClases i
              INNER JOIN clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase
              INNER JOIN horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
              INNER JOIN horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
              WHERE cp.fechaDeLaClase = CAST(GETDATE() AS DATE)
                AND i.fkEstadoInscripcion = 1
                AND hl.horaInicio > CAST(GETDATE() AS TIME)
                AND DATEDIFF(MINUTE, CAST(GETDATE() AS TIME), hl.horaInicio) >= 1
              ORDER BY NEWID()");

        if (existingRow?.Count > 0)
        {
            return existingRow["Id"]?.ToString()
                ?? throw new InvalidOperationException("El cliente de la inscripción existente tiene Id nulo");
        }

        // 2. No hay inscripción válida existente → generar clases programadas para hoy
        await DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            "EXEC dbo.sp_cron_generarClasesProgramadas");

        // 3. Tomar un cliente con rol cliente
        var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 u.Id
              FROM AspNetUsers u
              INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId
              INNER JOIN AspNetRoles r ON ur.RoleId = r.Id
              WHERE r.Name = 'cliente'
              ORDER BY NEWID()");

        if (clienteRow == null)
            throw new InvalidOperationException("No se encontró ningún cliente en la BD");

        var clienteId = clienteRow["Id"]?.ToString()
            ?? throw new InvalidOperationException("El cliente seleccionado tiene Id nulo");

        // 4. Seleccionar una clase que pase el MISMO filtro que fn_obtenerInscripcionesDelCliente
        //    (fecha futura, o fecha hoy con hora todavía no vencida)
        var claseRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 cp.idProgramacionClase
              FROM clasesProgramadas cp
              INNER JOIN horariosDeClasesProgramadas hcp
                  ON cp.idProgramacionClase = hcp.fkClaseProgramada
              INNER JOIN horasLaborales hl
                  ON hcp.fkHorarioLaboral = hl.idHora
              WHERE (cp.fechaDeLaClase > CAST(GETDATE() AS DATE)
                 OR (cp.fechaDeLaClase = CAST(GETDATE() AS DATE)
                     AND hl.horaInicio > CAST(GETDATE() AS TIME)))
                AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas)
              ORDER BY NEWID()");

        var idClaseProgramada = claseRow?["idProgramacionClase"] != null
            ? Convert.ToInt32(claseRow["idProgramacionClase"])
            : 0;

        if (idClaseProgramada <= 0)
            throw new InvalidOperationException("sp_cron_generarClasesProgramadas debió generar al menos una clase con horario futuro");

        // 5. Inscribir al cliente via SP (valida cupo, duplicados, etc.)
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
    /// Crea UNA inscripción fresca con hora futura desde cero, sin depender de
    /// sp_cron_generarClasesProgramadas. No busca inscripciones existentes — siempre crea una nueva.
    /// </summary>
    /// <returns>Tupla con (clienteId, idInscripcion).</returns>
    public static async Task<(string ClienteId, int IdInscripcion)> SeedFreshInscripcionAsync(string connectionString)
        => await SeedSingleInscripcionConHoraFuturaAsync(connectionString);

    /// <summary>
    /// Retorna una inscripción existente válida para hoy (clase futura o con inicio en los últimos 30 min).
    /// Si no existe ninguna, genera clases programadas, inscribe un cliente y retorna
    /// tanto el ID del cliente como el ID de la inscripción generada.
    /// Útil para tests que necesitan el idInscripcion
    /// (ej: CancelarInscripcionAsync, ReagendarInscripcionAsync).
    /// </summary>
    /// <returns>Tupla con (clienteId, idInscripcion).</returns>
    public static async Task<(string ClienteId, int IdInscripcion)> SeedFreshInscripcionAndReturnIdAsync(string connectionString)
        => await SeedFreshInscripcionAsync(connectionString);

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

    /// <summary>
    /// Inserta un nuevo registro en horasLaborales con la hora inicio y hora fin especificadas.
    /// </summary>
    /// <returns>ID del nuevo registro insertado.</returns>
    private static async Task<int> InsertNewHoraLaboralAsync(
        string connectionString, TimeSpan horaInicio, TimeSpan horaFin)
    {
        var result = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"INSERT INTO horasLaborales (horaInicio, horaFin)
              OUTPUT INSERTED.idHora
              VALUES (@HoraInicio, @HoraFin)",
            new Dictionary<string, object?>
            {
                ["@HoraInicio"] = horaInicio,
                ["@HoraFin"] = horaFin
            });

        return Convert.ToInt32(result!["idHora"]);
    }

    /// <summary>
    /// Obtiene el idHora de una hora laboral anterior a la hora actual.
    /// Lógica:
    /// 1. Si hora truncada &lt; MIN(horaInicio) → inserta nueva hora y devuelve su id.
    /// 2. Si hora truncada &gt; MAX(horaInicio) → devuelve la hora más alta.
    /// 3. Dentro del rango → busca coincidencia exacta; si no hay, devuelve la hora más baja.
    /// </summary>
    public static async Task<int> GetIdHoraLaboralAnteriorAsync(string connectionString)
    {
        var now = DateTime.Now;
        var horaTruncada = new TimeSpan(now.Hour, 0, 0);

        // 1. Obtener MIN y MAX de horasLaborales
        var minMaxRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT MIN(horaInicio) AS MinHora, MAX(horaInicio) AS MaxHora FROM horasLaborales");

        var horaMinima = (TimeSpan)minMaxRow!["MinHora"];
        var horaMaxima = (TimeSpan)minMaxRow!["MaxHora"];

        // 2. hora truncada < hora mínima → insertar nueva hora laboral
        if (horaTruncada < horaMinima)
        {
            var horaFin = horaTruncada.Add(TimeSpan.FromHours(1));
            return await InsertNewHoraLaboralAsync(connectionString, horaTruncada, horaFin);
        }

        // 3. hora truncada > hora máxima → devolver la hora más alta
        if (horaTruncada > horaMaxima)
        {
            var row = await DatabaseHelper.ExecuteQuerySingleAsync(
                connectionString,
                "SELECT TOP 1 idHora FROM horasLaborales ORDER BY horaInicio DESC");
            return Convert.ToInt32(row!["idHora"]);
        }

        // 4. Dentro del rango → buscar coincidencia exacta
        var matchRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT idHora FROM horasLaborales WHERE horaInicio = @Hora",
            new Dictionary<string, object?> { ["@Hora"] = horaTruncada });

        if (matchRow != null)
            return Convert.ToInt32(matchRow["idHora"]);

        // Fallback: devolver la hora más baja del rango
        var fallbackRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 idHora FROM horasLaborales ORDER BY horaInicio ASC");
        return Convert.ToInt32(fallbackRow!["idHora"]);
    }

    /// <summary>
    /// Obtiene el idHora de una hora laboral futura (posterior a la hora actual).
    /// Lógica:
    /// 1. Busca la hora laboral estrictamente mayor a la hora actual real.
    /// 2. Si no existe, inserta un nuevo slot en el próximo horario en punto.
    /// </summary>
    public static async Task<int?> GetIdHoraLaboralFuturaAsync(string connectionString)
    {
        var horaActual = DateTime.Now.TimeOfDay;

        // 1. Buscar la hora laboral más próxima ESTRICTAMENTE MAYOR a la hora actual
        var matchRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 idHora FROM horasLaborales WHERE horaInicio > @HoraActual ORDER BY horaInicio ASC",
            new Dictionary<string, object?> { ["@HoraActual"] = horaActual });

        if (matchRow != null)
            return Convert.ToInt32(matchRow["idHora"]);

        // 2. No hay horas futuras → insertar una nueva hora (próximo slot en punto)
        var horaRedondeada = new TimeSpan(DateTime.Now.Hour + 1, 0, 0);
        var horaFin = horaRedondeada.Add(TimeSpan.FromHours(1));
        return await InsertNewHoraLaboralAsync(connectionString, horaRedondeada, horaFin);
    }

    /// <summary>
    /// Crea una inscripción con fecha de hoy y hora pasada desde cero:
    /// 1. Obtiene un idHora de hora laboral pasada (via GetIdHoraLaboralAnteriorAsync).
    /// 2. Toma un cliente y una clase existentes.
    /// 3. Inserta en clasesProgramadas, horariosDeClasesProgramadas e inscripcionesDeClases.
    /// </summary>
    /// <returns>Tupla con (clienteId, idInscripcion).</returns>
    public static async Task<(string ClienteId, int IdInscripcion)> SeedSingleInscripcionConHoraPasadaAsync(
        string connectionString)
    {
        // 1. Obtener idHora de una hora laboral pasada
        var idHoraLaboral = await GetIdHoraLaboralAnteriorAsync(connectionString);

        // 2. Obtener un cliente cualquiera
        var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 Id FROM AspNetUsers ORDER BY NEWID()")
            ?? throw new InvalidOperationException("No hay clientes en AspNetUsers");

        var clienteId = clienteRow["Id"]?.ToString()
            ?? throw new InvalidOperationException("El cliente seleccionado tiene Id nulo");

        // 3. Obtener una clase existente
        var claseRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 ClaseID, Cupo FROM Clases ORDER BY NEWID()")
            ?? throw new InvalidOperationException("No hay clases en la tabla Clases");

        var fkClase = Convert.ToInt32(claseRow["ClaseID"]);
        var cupoMaximo = Convert.ToInt32(claseRow["Cupo"]);

        // 4. Insertar en clasesProgramadas (fecha hoy, estado = 1 "disponible")
        var claseProgramadaRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase)
              OUTPUT INSERTED.idProgramacionClase
              VALUES (@FkClase, @CupoMaximo, 1, CAST(GETDATE() AS DATE))",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = fkClase,
                ["@CupoMaximo"] = cupoMaximo
            });

        var idProgramacionClase = Convert.ToInt32(claseProgramadaRow!["idProgramacionClase"]);

        // 5. Insertar en horariosDeClasesProgramadas con la hora pasada
        await DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            @"INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral)
              VALUES (@FkClaseProgramada, @FkHorarioLaboral)",
            new Dictionary<string, object?>
            {
                ["@FkClaseProgramada"] = idProgramacionClase,
                ["@FkHorarioLaboral"] = idHoraLaboral
            });

        // 6. Insertar en inscripcionesDeClases (estado = 1 "vigente")
        var inscripcionRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"INSERT INTO inscripcionesDeClases (fkProgramacionClase, fkEstadoInscripcion, fkCliente)
              OUTPUT INSERTED.idInscripcion
              VALUES (@FkProgramacionClase, 1, @FkCliente)",
            new Dictionary<string, object?>
            {
                ["@FkProgramacionClase"] = idProgramacionClase,
                ["@FkCliente"] = clienteId
            });

        var idInscripcion = Convert.ToInt32(inscripcionRow!["idInscripcion"]);

        return (clienteId, idInscripcion);
    }

    /// <summary>
    /// Crea una inscripción con fecha de hoy y hora futura desde cero:
    /// 1. Obtiene un idHora de hora laboral futura (via GetIdHoraLaboralFuturaAsync).
    /// 2. Toma un cliente con rol 'cliente' y una clase existente.
    /// 3. Inserta en clasesProgramadas, horariosDeClasesProgramadas e inscripcionesDeClases.
    /// </summary>
    /// <returns>Tupla con (clienteId, idInscripcion).</returns>
    public static async Task<(string ClienteId, int IdInscripcion)> SeedSingleInscripcionConHoraFuturaAsync(
        string connectionString)
    {
        // 1. Obtener idHora de una hora laboral futura
        var idHoraLaboral = await GetIdHoraLaboralFuturaAsync(connectionString);

        // 2. Obtener un cliente con rol 'cliente'
        var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 u.Id
              FROM AspNetUsers u
              INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId
              INNER JOIN AspNetRoles r ON ur.RoleId = r.Id
              WHERE r.Name = 'cliente'
              ORDER BY NEWID()")
            ?? throw new InvalidOperationException("No hay clientes con rol 'cliente' en AspNetUsers");

        var clienteId = clienteRow["Id"]?.ToString()
            ?? throw new InvalidOperationException("El cliente seleccionado tiene Id nulo");

        // 3. Obtener una clase existente
        var claseRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 ClaseID, Cupo FROM Clases ORDER BY NEWID()")
            ?? throw new InvalidOperationException("No hay clases en la tabla Clases");

        var fkClase = Convert.ToInt32(claseRow["ClaseID"]);
        var cupoMaximo = Convert.ToInt32(claseRow["Cupo"]);

        // 4. Obtener un entrenador disponible via SP
        var entrenadorRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "EXEC dbo.sp_obtenerEntrenadoresDisponibles @fechaReferencia = @Fecha",
            new Dictionary<string, object?> { ["@Fecha"] = DateTime.Now });

        var fkEntrenador = entrenadorRow?["UsuarioID"]?.ToString()
            ?? throw new InvalidOperationException("No se encontró ningún entrenador disponible");

        // 5. Insertar en clasesProgramadas (fecha hoy, estado disponible)
        var idEstadoDisponible = await DatabaseHelper.ExecuteScalarAsync<int?>(
            connectionString,
            "SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas")
            ?? 1;

        var claseProgramadaRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador)
              OUTPUT INSERTED.idProgramacionClase
              VALUES (@FkClase, @CupoMaximo, @Estado, CAST(GETDATE() AS DATE), @FkEntrenador)",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = fkClase,
                ["@CupoMaximo"] = cupoMaximo,
                ["@Estado"] = idEstadoDisponible,
                ["@FkEntrenador"] = fkEntrenador
            });

        var idProgramacionClase = Convert.ToInt32(claseProgramadaRow!["idProgramacionClase"]);

        // 6. Insertar en horariosDeClasesProgramadas con la hora futura
        await DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            @"INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral)
              VALUES (@FkClaseProgramada, @FkHorarioLaboral)",
            new Dictionary<string, object?>
            {
                ["@FkClaseProgramada"] = idProgramacionClase,
                ["@FkHorarioLaboral"] = idHoraLaboral
            });

        // 7. Insertar en inscripcionesDeClases (estado = 1 "vigente")
        var inscripcionRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"INSERT INTO inscripcionesDeClases (fkProgramacionClase, fkEstadoInscripcion, fkCliente)
              OUTPUT INSERTED.idInscripcion
              VALUES (@FkProgramacionClase, 1, @FkCliente)",
            new Dictionary<string, object?>
            {
                ["@FkProgramacionClase"] = idProgramacionClase,
                ["@FkCliente"] = clienteId
            });

        var idInscripcion = Convert.ToInt32(inscripcionRow!["idInscripcion"]);

        return (clienteId, idInscripcion);
    }

    /// <summary>
    /// Crea una inscripción con fecha posterior a la última clase programada existente
    /// y hora futura desde cero:
    /// 1. Calcula la próxima fecha disponible (MAX(fechaDeLaClase) + 1 día, o hoy si no hay clases).
    /// 2. Obtiene un idHora de hora laboral futura (via GetIdHoraLaboralFuturaAsync).
    /// 3. Toma un cliente con rol 'cliente' y una clase existente.
    /// 4. Inserta en clasesProgramadas, horariosDeClasesProgramadas e inscripcionesDeClases.
    /// Garantiza que no colisiona con el index IX_entrenadorfechahora.
    /// </summary>
    /// <returns>Tupla con (clienteId, idInscripcion).</returns>
    public static async Task<(string ClienteId, int IdInscripcion)> SeedSingleInscripcionConFechaPosteriorAsync(
        string connectionString)
    {
        // 1. Calcular la próxima fecha disponible
        var ultimaFechaRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT MAX(fechaDeLaClase) AS UltimaFecha FROM clasesProgramadas WHERE fechaDeLaClase >= CAST(GETDATE() AS DATE)");

        var fechaClase = ultimaFechaRow?["UltimaFecha"] != null
            ? DateOnly.FromDateTime(Convert.ToDateTime(ultimaFechaRow["UltimaFecha"])).AddDays(1)
            : DateOnly.FromDateTime(DateTime.Today);

        // 2. Obtener idHora de una hora laboral futura
        var idHoraLaboral = await GetIdHoraLaboralFuturaAsync(connectionString);

        // 3. Obtener un cliente con rol 'cliente'
        var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 u.Id
              FROM AspNetUsers u
              INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId
              INNER JOIN AspNetRoles r ON ur.RoleId = r.Id
              WHERE r.Name = 'cliente'
              ORDER BY NEWID()")
            ?? throw new InvalidOperationException("No hay clientes con rol 'cliente' en AspNetUsers");

        var clienteId = clienteRow["Id"]?.ToString()
            ?? throw new InvalidOperationException("El cliente seleccionado tiene Id nulo");

        // 4. Obtener una clase existente
        var claseRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT TOP 1 ClaseID, Cupo FROM Clases ORDER BY NEWID()")
            ?? throw new InvalidOperationException("No hay clases en la tabla Clases");

        var fkClase = Convert.ToInt32(claseRow["ClaseID"]);
        var cupoMaximo = Convert.ToInt32(claseRow["Cupo"]);

        // 5. Obtener un entrenador disponible via SP
        var entrenadorRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "EXEC dbo.sp_obtenerEntrenadoresDisponibles @fechaReferencia = @Fecha",
            new Dictionary<string, object?> { ["@Fecha"] = DateTime.Now });

        var fkEntrenador = entrenadorRow?["UsuarioID"]?.ToString()
            ?? throw new InvalidOperationException("No se encontró ningún entrenador disponible");

        // 6. Insertar en clasesProgramadas (fecha posterior, estado disponible)
        var idEstadoDisponible = await DatabaseHelper.ExecuteScalarAsync<int?>(
            connectionString,
            "SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas")
            ?? 1;

        var claseProgramadaRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase, fkEntrenador)
              OUTPUT INSERTED.idProgramacionClase
              VALUES (@FkClase, @CupoMaximo, @Estado, @FechaClase, @FkEntrenador)",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = fkClase,
                ["@CupoMaximo"] = cupoMaximo,
                ["@Estado"] = idEstadoDisponible,
                ["@FechaClase"] = fechaClase,
                ["@FkEntrenador"] = fkEntrenador
            });

        var idProgramacionClase = Convert.ToInt32(claseProgramadaRow!["idProgramacionClase"]);

        // 7. Insertar en horariosDeClasesProgramadas con la hora futura
        await DatabaseHelper.ExecuteNonQueryAsync(
            connectionString,
            @"INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral)
              VALUES (@FkClaseProgramada, @FkHorarioLaboral)",
            new Dictionary<string, object?>
            {
                ["@FkClaseProgramada"] = idProgramacionClase,
                ["@FkHorarioLaboral"] = idHoraLaboral
            });

        // 8. Insertar en inscripcionesDeClases (estado = 1 "vigente")
        var inscripcionRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"INSERT INTO inscripcionesDeClases (fkProgramacionClase, fkEstadoInscripcion, fkCliente)
              OUTPUT INSERTED.idInscripcion
              VALUES (@FkProgramacionClase, 1, @FkCliente)",
            new Dictionary<string, object?>
            {
                ["@FkProgramacionClase"] = idProgramacionClase,
                ["@FkCliente"] = clienteId
            });

        var idInscripcion = Convert.ToInt32(inscripcionRow!["idInscripcion"]);

        return (clienteId, idInscripcion);
    }
}
