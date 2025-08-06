using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Threading.Tasks;

namespace DataAccess.Infraestructure
{
    
    public static class DatabaseExecutor
    {
        /// <summary>
        /// Ejecuta un procedimiento almacenado o función de forma asíncrona
        /// </summary>
    /// <param name="connection">Conexión a la base de datos</param>
    /// <param name="procedureName">Nombre del procedimiento o función</param>
    /// <param name="parameters">Parámetros de entrada y salida</param>
    /// <param name="commandTimeout">Tiempo de espera en segundos (opcional)</param>
    /// <returns>Resultado de la ejecución con valores de retorno y parámetros de salida</returns>
    public static async Task<DatabaseExecutionResult> ExecuteStoredProcedureAsync(
        DbConnection connection,
        string procedureName,
        Dictionary<string, object> parameters = null,
        int? commandTimeout = null)
    {
        var result = new DatabaseExecutionResult();
        
        try
        {
            if (connection.State != ConnectionState.Open)
                await connection.OpenAsync();

            using var command = connection.CreateCommand();
            command.CommandText = procedureName;
            command.CommandType = CommandType.StoredProcedure;
            
            if (commandTimeout.HasValue)
                command.CommandTimeout = commandTimeout.Value;

            var outputParameters = new List<DbParameter>();

            // Agregar parámetros
            if (parameters != null)
            {
                foreach (var param in parameters)
                {
                    var dbParam = command.CreateParameter();
                    dbParam.ParameterName = param.Key.StartsWith("@") ? param.Key : $"@{param.Key}";
                    
                    if (param.Value is DatabaseParameter customParam)
                    {
                        dbParam.Direction = customParam.Direction;
                        dbParam.DbType = customParam.DbType;
                        dbParam.Size = customParam.Size;
                        dbParam.Value = customParam.Value ?? DBNull.Value;
                        
                        if (customParam.Direction == ParameterDirection.Output || 
                            customParam.Direction == ParameterDirection.InputOutput ||
                            customParam.Direction == ParameterDirection.ReturnValue)
                        {
                            outputParameters.Add(dbParam);
                        }
                    }
                    else
                    {
                        dbParam.Direction = ParameterDirection.Input;
                        dbParam.Value = param.Value ?? DBNull.Value;
                    }
                    
                    command.Parameters.Add(dbParam);
                }
            }

            // Ejecutar el comando
            result.RecordsAffected = await command.ExecuteNonQueryAsync();

            // Obtener valores de parámetros de salida
            foreach (var outputParam in outputParameters)
            {
                var paramName = outputParam.ParameterName.TrimStart('@');
                result.OutputParameters[paramName] = outputParam.Value == DBNull.Value ? null : outputParam.Value;
            }

            result.Success = true;
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.ErrorMessage = ex.Message;
            result.Exception = ex;
        }

        return result;
    }

    /// <summary>
    /// Ejecuta un procedimiento almacenado que retorna un DataSet
    /// </summary>
    public static async Task<DatabaseQueryResult> ExecuteStoredProcedureWithResultsAsync(
        DbConnection connection,
        string procedureName,
        Dictionary<string, object> parameters = null,
        int? commandTimeout = null)
    {
        var result = new DatabaseQueryResult();
        
        try
        {
            if (connection.State != ConnectionState.Open)
                await connection.OpenAsync();

            using var command = connection.CreateCommand();
            command.CommandText = procedureName;
            command.CommandType = CommandType.StoredProcedure;
            
            if (commandTimeout.HasValue)
                command.CommandTimeout = commandTimeout.Value;

            var outputParameters = new List<DbParameter>();

            // Agregar parámetros (mismo código que arriba)
            if (parameters != null)
            {
                foreach (var param in parameters)
                {
                    var dbParam = command.CreateParameter();
                    dbParam.ParameterName = param.Key.StartsWith("@") ? param.Key : $"@{param.Key}";
                    
                    if (param.Value is DatabaseParameter customParam)
                    {
                        dbParam.Direction = customParam.Direction;
                        dbParam.DbType = customParam.DbType;
                        dbParam.Size = customParam.Size;
                        dbParam.Value = customParam.Value ?? DBNull.Value;
                        
                        if (customParam.Direction == ParameterDirection.Output || 
                            customParam.Direction == ParameterDirection.InputOutput ||
                            customParam.Direction == ParameterDirection.ReturnValue)
                        {
                            outputParameters.Add(dbParam);
                        }
                    }
                    else
                    {
                        dbParam.Direction = ParameterDirection.Input;
                        dbParam.Value = param.Value ?? DBNull.Value;
                    }
                    
                    command.Parameters.Add(dbParam);
                }
            }

            // Ejecutar y obtener resultados
            using var reader = await command.ExecuteReaderAsync();
            
            var dataSet = new DataSet();
            var tableIndex = 0;
            
            do
            {
                var dataTable = new DataTable($"Table{tableIndex}");
                dataTable.Load(reader);
                dataSet.Tables.Add(dataTable);
                tableIndex++;
            } while (!reader.IsClosed);

            result.DataSet = dataSet;

            // Obtener valores de parámetros de salida
            foreach (var outputParam in outputParameters)
            {
                var paramName = outputParam.ParameterName.TrimStart('@');
                result.OutputParameters[paramName] = outputParam.Value == DBNull.Value ? null : outputParam.Value;
            }

            result.Success = true;
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.ErrorMessage = ex.Message;
            result.Exception = ex;
        }

        return result;
    }

    /// <summary>
    /// Versión síncrona para ejecutar procedimientos almacenados
    /// </summary>
    public static DatabaseExecutionResult ExecuteStoredProcedure(
        DbConnection connection,
        string procedureName,
        Dictionary<string, object> parameters = null,
        int? commandTimeout = null)
    {
        return ExecuteStoredProcedureAsync(connection, procedureName, parameters, commandTimeout).GetAwaiter().GetResult();
    }
}
}






