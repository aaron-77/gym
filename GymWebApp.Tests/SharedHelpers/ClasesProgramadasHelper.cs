using System.Data;
using System.Transactions;

using Microsoft.Data.SqlClient;

using DTO.Dtos;
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
        int claseId = 0;
        string entrenadorId = string.Empty;
        int horaLaboralId = 0;

        try
        {
            using var connection = new SqlConnection(connectionString);
            await connection.OpenAsync();
            
            // Consulta 1: Obtener ClaseID activa
            using (var cmd1 = connection.CreateCommand())
            {
                cmd1.CommandText = "SELECT TOP 1 ClaseID FROM Clases WHERE fkEstadoClase = 1";
                var result1 = await cmd1.ExecuteScalarAsync();
                if (result1 != null && result1 != DBNull.Value)
                {
                    claseId = Convert.ToInt32(result1);
                }
            }

            // Consulta 2: Obtener primera hora laboral orden por idHora
            TimeSpan horaInicio = TimeSpan.Zero;
            using (var cmd3 = connection.CreateCommand())
            {
                cmd3.CommandText = "SELECT TOP 1 idHora, horaInicio FROM horasLaborales ORDER BY idHora";
                using (var reader = await cmd3.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        horaLaboralId = reader.GetInt32(0);
                        horaInicio = reader.GetTimeSpan(1);
                    }
                }
            }

            // Consulta 3: Obtener entrenador disponible usando SP
            var fechaReferencia = DateTime.Now.Date.AddDays(1).Add(horaInicio);
            using (var cmd2 = connection.CreateCommand())
            {
                cmd2.CommandText = "sp_obtenerEntrenadoresDisponibles";
                cmd2.CommandType = CommandType.StoredProcedure;
                cmd2.Parameters.AddWithValue("@fechaReferencia", fechaReferencia);
                
                var result2 = await cmd2.ExecuteScalarAsync();
                if (result2 != null && result2 != DBNull.Value)
                {
                    entrenadorId = result2.ToString()!;
                }
            }

            // Crear y retornar el DTO
            var dto = new DTODatosClaseProgramada
            {
                fkClase = claseId,
                fkEntrenador = entrenadorId,
                fkEstadoClaseProgramada = 1, // Disponible
                fechaDeLaClase = DateOnly.FromDateTime(DateTime.Now),
                idUsuarioQueReserva = null, // Para pre-reserva sin cliente
                fkHoraLaboral = horaLaboralId,
                cupoMaximo = 20
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
    /// <see cref="HorariosHelper.registrarHorarioDeClaseProgramada"/>.
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
        var idHorario = await HorariosHelper.registrarHorarioDeClaseProgramada(
            connectionString,
            idClaseProgramada,
            datos.fkHoraLaboral);

        // Si llegamos acá sin excepciones, confirmamos la transacción
        scope.Complete();

        return (idClaseProgramada, idHorario);
    }
}