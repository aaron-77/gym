using System.Data;
using System.Transactions;
using Microsoft.Data.SqlClient;

using BL.Utils.Enums;
using DTO.Dtos;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;

namespace GymWebApp.Tests.SharedHelpers;

public static class ClasesProgramadasHelper
{
    /// <summary>
    /// Genera un objeto DTODatosClaseProgramada con datos válidos para pruebas.
    /// </summary>
    /// <param name="connectionString">Connection string para la base de datos</param>
    /// <returns>DTODatosClaseProgramada con datos de prueba</returns>
    public static async Task<DTODatosClaseProgramada> GenerarClaseProgramadaAsync(string connectionString)
    {
        try
        {
            // Delegar en el helper de slot que resuelve por construcción:
            // slot libre + entrenador alineado a la fecha + clase activa + cupo real
            var slot = await SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync(
                connectionString);

            if (slot == null)
            {
                throw new InvalidOperationException(
                    "No hay horarios disponibles para generar una clase programada de prueba.");
            }

            // Mapear el dataset del slot al DTO de clase programada
            var dto = new DTODatosClaseProgramada
            {
                fkClase = slot.ClaseId,
                fkEntrenador = slot.EntrenadorId,
                fkHoraLaboral = slot.IdHoraLaboral,
                fechaDeLaClase = slot.FechaDisponible,
                cupoMaximo = slot.Cupo,
                fkEstadoClaseProgramada = 1, // Disponible
                idUsuarioQueReserva = null,  // Pre-reserva sin cliente
                idPreservaDeHorario = null
            };

            return dto;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"ERROR en [ClasesProgramadasHelper.GenerarClaseProgramadaAsync]: {ex.Message}");
            Console.WriteLine($"Causa: {ex.InnerException?.Message ?? "N/A"}");
            throw;
        }
    }

    /// <summary>
    /// Registra una clase programada usando el stored procedure sp_registrarClaseProgramada.
    /// </summary>
    /// <param name="connectionString">Connection string para la base de datos</param>
    /// <param name="datos">Datos de la clase programada</param>
    public static async Task<DTODatosClaseProgramada> RegistrarClaseProgramadaAsync(string connectionString, DTODatosClaseProgramada datos)
    {
        try
        {
            using var connection = new SqlConnection(connectionString);
            await connection.OpenAsync();

            using var cmd = connection.CreateCommand();
            cmd.CommandText = "sp_registrarClaseProgramada";
            cmd.CommandType = CommandType.StoredProcedure;

            // Crear tabla para el parámetro @datos
            var dataTable = new DataTable();
            dataTable.Columns.Add("fkClase", typeof(int));
            dataTable.Columns.Add("fkEntrenador", typeof(string));
            dataTable.Columns.Add("cupoMaximo", typeof(int));
            dataTable.Columns.Add("fkEstadoClaseProgramada", typeof(int));
            dataTable.Columns.Add("fechaDeLaClase", typeof(DateOnly));
            dataTable.Columns.Add("idUsuarioQueReserva", typeof(string));
            dataTable.Columns.Add("fkHoraLaboral", typeof(int));
            dataTable.Columns.Add("idPreservaDeHorario", typeof(int));

            var row = dataTable.NewRow();
            row["fkClase"] = datos.fkClase ?? (object)DBNull.Value;
            row["fkEntrenador"] = datos.fkEntrenador ?? (object)DBNull.Value;
            row["cupoMaximo"] = datos.cupoMaximo;
            row["fkEstadoClaseProgramada"] = datos.fkEstadoClaseProgramada;
            row["fechaDeLaClase"] = datos.fechaDeLaClase;
            row["idUsuarioQueReserva"] = datos.idUsuarioQueReserva ?? (object)DBNull.Value;
            row["fkHoraLaboral"] = datos.fkHoraLaboral;
            row["idPreservaDeHorario"] = datos.fkHoraLaboral;

            dataTable.Rows.Add(row);

            var sqlParam = new SqlParameter("@datos", SqlDbType.Structured)
            {
                TypeName = "dbo.DatosClaseProgramada",
                Value = dataTable
            };
            cmd.Parameters.Add(sqlParam);

            await cmd.ExecuteNonQueryAsync();

            return datos;
        }
        catch (Exception ex)
        {
            
            Console.WriteLine($"ERROR en [ClasesProgramadasHelper.RegistrarClaseProgramadaAsync]: {ex.Message}");
            Console.WriteLine($"Causa: {ex.InnerException?.Message ?? "N/A"}");
            throw;
        }
    }

    /// <summary>
    /// Registra una clase programada a bajo nivel (solo insert en clasesProgramadas).
    /// Usa el DTO del endpoint de la API y el patrón moderno de helpers con DatabaseHelper.
    /// NO registra horarios — eso se maneja por separado.
    /// </summary>
    /// <param name="connectionString">Connection string para la base de datos</param>
    /// <param name="datos">Datos de la clase programada (DTODatosClaseProgramada)</param>
    /// <returns>ID de la clase programada registrada (idProgramacionClase)</returns>
    public static async Task<int> RegistrarClaseProgramadaLL(string connectionString, DTODatosClaseProgramada datos)
    {
        var result = await DatabaseHelper.ExecuteScalarAsync<decimal>(
            connectionString,
            @"INSERT INTO clasesProgramadas (fkClase, fkEntrenador, cupoMaximo, fkEstadoClaseProgramada, fechaDeLaClase)
              VALUES (@FkClase, @FkEntrenador, @CupoMaximo, @FkEstadoClaseProgramada, @FechaDeLaClase);
              SELECT SCOPE_IDENTITY();",
            new Dictionary<string, object?>
            {
                ["@FkClase"] = datos.fkClase,
                ["@FkEntrenador"] = datos.fkEntrenador,
                ["@CupoMaximo"] = datos.cupoMaximo,
                ["@FkEstadoClaseProgramada"] = datos.fkEstadoClaseProgramada,
                ["@FechaDeLaClase"] = datos.fechaDeLaClase
            });

        return Convert.ToInt32(result);
    }

    /// <summary>
    /// Registra una clase programada y su horario asociado en UNA SOLA TRANSACCIÓN.
    /// Orquesta <see cref="RegistrarClaseProgramadaLL"/> y
    /// <see cref="HorariosHelper.RegistrarHorarioDeClaseProgramada"/>.
    /// Si cualquiera de las dos operaciones falla, se revierte todo (rollback total).
    /// </summary>
    /// <param name="connectionString">Connection string para la base de datos</param>
    /// <param name="datos">Datos de la clase programada (DTODatosClaseProgramada)</param>
    /// <returns>
    /// Tupla con:
    /// <list type="bullet">
    ///   <item><description><c>IdClaseProgramada</c>: ID generado en <c>clasesProgramadas</c> (PK)</description></item>
    ///   <item><description><c>IdHorarioClaseProgramada</c>: ID generado en <c>horariosDeClasesProgramadas</c> (PK)</description></item>
    /// </list>
    /// </returns>
    public static async Task<(int IdClaseProgramada, int IdHorarioClaseProgramada)>
        RegistrarClaseProgramadaML(string connectionString, DTODatosClaseProgramada datos)
    {
        using var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);

        // Paso 1: Registrar la clase programada → obtiene idProgramacionClase
        var idClaseProgramada = await RegistrarClaseProgramadaLL(connectionString, datos);

        // Paso 2: Registrar el horario asociado → obtiene idHorarioDeClaseProgramada
        var idHorario = await HorariosHelper.RegistrarHorarioDeClaseProgramada(
            connectionString,
            idClaseProgramada,
            datos.fkHoraLaboral);

        // Si llegamos acá sin excepciones, confirmamos la transacción
        scope.Complete();

        return (idClaseProgramada, idHorario);
    }

    /// <summary>
    /// Registra una clase programada con fecha anterior al registro más antiguo.
    /// Obtiene la fecha inmediatamente anterior a la clase programada más vieja,
    /// cualquier idHoraLaboral disponible, una clase activa y un entrenador disponible,
    /// y delega en <see cref="RegistrarClaseProgramadaML"/> que maneja la transacción completa (clase + horario).
    /// </summary>
    /// <param name="connectionString">Connection string para la base de datos</param>
    /// <returns>
    /// Tupla con:
    /// <list type="bullet">
    ///   <item><description><c>IdClaseProgramada</c>: ID generado en <c>clasesProgramadas</c> (PK)</description></item>
    ///   <item><description><c>IdHorarioClaseProgramada</c>: ID generado en <c>horariosDeClasesProgramadas</c> (PK)</description></item>
    /// </list>
    /// </returns>
    public static async Task<(int IdClaseProgramada, int IdHorarioClaseProgramada)>
        RegistrarClaseProgramadaPasada(string connectionString)
    {
        try
        {
            // Paso 1: Obtener la fecha anterior al registro más antiguo
            var oldestDateRow = await DatabaseHelper.ExecuteQuerySingleAsync(
                connectionString,
                "SELECT MIN(fechaDeLaClase) AS OldestDate FROM clasesProgramadas")
                ?? throw new InvalidOperationException("No hay clases programadas registradas");

            var oldestDate = DateOnly.FromDateTime(
                Convert.ToDateTime(oldestDateRow["OldestDate"]));
            var pastDate = oldestDate.AddDays(-1);

            // Paso 2: Obtener cualquier idHoraLaboral
            var horaLaboralRow = await DatabaseHelper.ExecuteQuerySingleAsync(
                connectionString,
                "SELECT TOP 1 idHora FROM horasLaborales ORDER BY idHora")
                ?? throw new InvalidOperationException("No hay horas laborales disponibles");

            var idHoraLaboral = Convert.ToInt32(horaLaboralRow["idHora"]);

            // Paso 3: Obtener una clase activa
            var claseRow = await DatabaseHelper.ExecuteQuerySingleAsync(
                connectionString,
                "SELECT TOP 1 ClaseID FROM Clases WHERE fkEstadoClase = 1")
                ?? throw new InvalidOperationException("No hay clases activas disponibles");

            var fkClase = Convert.ToInt32(claseRow["ClaseID"]);

            // Paso 4: Obtener un entrenador disponible para la fecha pasada
            var entrenadorRow = await DatabaseHelper.ExecuteQuerySingleAsync(
                connectionString,
                "EXEC sp_obtenerEntrenadoresDisponibles @fechaReferencia = @Fecha",
                new Dictionary<string, object?> { ["@Fecha"] = pastDate.ToDateTime(TimeOnly.MinValue) })
                ?? throw new InvalidOperationException("No hay entrenadores disponibles");

            var fkEntrenador = entrenadorRow["UsuarioID"]?.ToString()
                ?? throw new InvalidOperationException("El entrenador seleccionado tiene Id nulo");

            // Paso 5: Construir DTO con los datos obtenidos
            var datos = new DTODatosClaseProgramada
            {
                fkClase = fkClase,
                fkEntrenador = fkEntrenador,
                cupoMaximo = 20,
                fkEstadoClaseProgramada = 1, // Disponible
                fechaDeLaClase = pastDate,
                idUsuarioQueReserva = null,
                fkHoraLaboral = idHoraLaboral,
                idPreservaDeHorario = null
            };

            // Paso 6: Delegar en RegistrarClaseProgramadaML (transacción completa)
            return await RegistrarClaseProgramadaML(connectionString, datos);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"ERROR en [ClasesProgramadasHelper.RegistrarClaseProgramadaPasada]: {ex.Message}");
            Console.WriteLine($"Causa: {ex.InnerException?.Message ?? "N/A"}");
            throw;
        }
    }

    /// <summary>
    /// Registra una clase programada para la fecha actual ("Actual" refiere a la fecha, no a la hora).
    /// Orquesta <see cref="HorariosHelper.ObtenerUnHorarioDisponible"/> con FiltroHora.Mayor
    /// (referencia ceil a la próxima hora completa + guard de fin de jornada) para obtener
    /// un slot disponible hoy con margen horario, consulta los datos necesarios
    /// (clase activa, entrenador disponible), y delega en <see cref="RegistrarClaseProgramadaML"/>
    /// que maneja la transacción completa (clase + horario).
    /// </summary>
    /// <remarks>
    /// Limitación conocida: el entrenador se consulta con la fecha/hora actual
    /// (sp_obtenerEntrenadoresDisponibles @fechaReferencia = DateTime.Now). Si el guard de
    /// fin de jornada desplaza la clase al día siguiente, el entrenador se elige por la
    /// disponibilidad de hoy, no por la de la fecha efectiva de la clase. El método no tiene
    /// callers activos en la suite; se documenta como limitación conocida y no se corrige.
    /// </remarks>
    /// <param name="connectionString">Connection string para la base de datos</param>
    /// <returns>
    /// Tupla con:
    /// <list type="bullet">
    ///   <item><description><c>IdClaseProgramada</c>: ID generado en <c>clasesProgramadas</c> (PK)</description></item>
    ///   <item><description><c>IdHorarioClaseProgramada</c>: ID generado en <c>horariosDeClasesProgramadas</c> (PK)</description></item>
    /// </list>
    /// </returns>
    public static async Task<(int IdClaseProgramada, int IdHorarioClaseProgramada)>
        RegistrarClaseProgramadaActual(string connectionString)
    {
        try
        {
            // Paso 1: Obtener un slot disponible para hoy con margen horario (filtro Mayor)
            var slotDisponible = await HorariosHelper.ObtenerUnHorarioDisponible(
                connectionString,
                FiltroFecha.Igual,
                FiltroHora.Mayor);

            if (slotDisponible == null)
                throw new InvalidOperationException(
                    "No hay horarios disponibles para hoy a la hora actual. " +
                    "Use SeedFallbackAsync para obtener una fecha alternativa.");

            var (fechaDisponible, idHoraLaboral) = slotDisponible.Value;

            // Paso 2: Obtener una clase activa
            var claseRow = await DatabaseHelper.ExecuteQuerySingleAsync(
                connectionString,
                "SELECT TOP 1 ClaseID FROM Clases WHERE fkEstadoClase = 1")
                ?? throw new InvalidOperationException("No hay clases activas disponibles");

            var fkClase = Convert.ToInt32(claseRow["ClaseID"]);

            // Paso 3: Obtener un entrenador disponible para la fecha/hora actual
            var entrenadorRow = await DatabaseHelper.ExecuteQuerySingleAsync(
                connectionString,
                "EXEC sp_obtenerEntrenadoresDisponibles @fechaReferencia = @Fecha",
                new Dictionary<string, object?> { ["@Fecha"] = DateTime.Now })
                ?? throw new InvalidOperationException("No hay entrenadores disponibles");

            var fkEntrenador = entrenadorRow["UsuarioID"]?.ToString()
                ?? throw new InvalidOperationException("El entrenador seleccionado tiene Id nulo");

            // Paso 4: Construir DTO con los datos obtenidos
            var datos = new DTODatosClaseProgramada
            {
                fkClase = fkClase,
                fkEntrenador = fkEntrenador,
                cupoMaximo = 20,
                fkEstadoClaseProgramada = 1, // Disponible
                fechaDeLaClase = fechaDisponible,
                idUsuarioQueReserva = null,
                fkHoraLaboral = idHoraLaboral,
                idPreservaDeHorario = null
            };

            // Paso 5: Delegar en RegistrarClaseProgramadaML (transacción completa)
            return await RegistrarClaseProgramadaML(connectionString, datos);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"ERROR en [ClasesProgramadasHelper.RegistrarClaseProgramadaActual]: {ex.Message}");
            Console.WriteLine($"Causa: {ex.InnerException?.Message ?? "N/A"}");
            throw;
        }
    }
}