using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using DataAccess.EntityFramework;
using System.Data;
using System.Reflection;

namespace GymWebApp.Tests.SharedHelpers;

public static class DatabaseHelper
{
    public static FitnessCenterDbContext GetDbContext(string connectionString)
    {
        var options = new DbContextOptionsBuilder<FitnessCenterDbContext>()
            .UseSqlServer(connectionString)
            .Options;
        
        return new FitnessCenterDbContext(options);
    }

    public static SqlConnection GetSqlConnection(string connectionString)
    {
        return new SqlConnection(connectionString);
    }

    /// <summary>
    /// Executes a query and returns a list of dictionaries, where each dictionary represents a row.
    /// </summary>
    public static async Task<List<Dictionary<string, object?>>> ExecuteQueryAsync(
        string connectionString, 
        string sql, 
        Dictionary<string, object?>? parameters = null)
    {
        var results = new List<Dictionary<string, object?>>();

        await using var connection = GetSqlConnection(connectionString);
        await connection.OpenAsync();

        await using var command = connection.CreateCommand();
        command.CommandText = sql;

        if (parameters != null)
        {
            foreach (var param in parameters)
            {
                command.Parameters.AddWithValue(param.Key, param.Value ?? DBNull.Value);
            }
        }

        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            var row = new Dictionary<string, object?>();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                row[reader.GetName(i)] = reader.IsDBNull(i) ? null : reader.GetValue(i);
            }
            results.Add(row);
        }

        return results;
    }

    /// <summary>
    /// Executes a query and returns a single row as a dictionary.
    /// </summary>
    public static async Task<Dictionary<string, object?>?> ExecuteQuerySingleAsync(
        string connectionString, 
        string sql, 
        Dictionary<string, object?>? parameters = null)
    {
        var results = await ExecuteQueryAsync(connectionString, sql, parameters);
        return results.Count > 0 ? results[0] : null;
    }

    /// <summary>
    /// Executes a non-query SQL statement (INSERT, UPDATE, DELETE) and returns the number of rows affected.
    /// </summary>
    public static async Task<int> ExecuteNonQueryAsync(
        string connectionString, 
        string sql, 
        Dictionary<string, object?>? parameters = null)
    {
        await using var connection = GetSqlConnection(connectionString);
        await connection.OpenAsync();

        await using var command = connection.CreateCommand();
        command.CommandText = sql;

        if (parameters != null)
        {
            foreach (var param in parameters)
            {
                command.Parameters.AddWithValue(param.Key, param.Value ?? DBNull.Value);
            }
        }

        return await command.ExecuteNonQueryAsync();
    }

    /// <summary>
    /// Executes a query and returns the first column of the first row (scalar value).
    /// </summary>
    public static async Task<T?> ExecuteScalarAsync<T>(
        string connectionString, 
        string sql, 
        Dictionary<string, object?>? parameters = null)
    {
        await using var connection = GetSqlConnection(connectionString);
        await connection.OpenAsync();

        await using var command = connection.CreateCommand();
        command.CommandText = sql;

        if (parameters != null)
        {
            foreach (var param in parameters)
            {
                command.Parameters.AddWithValue(param.Key, param.Value ?? DBNull.Value);
            }
        }

        var result = await command.ExecuteScalarAsync();
        if (result == null || result == DBNull.Value)
            return default;

        return (T)Convert.ChangeType(result, typeof(T));
    }

    /// <summary>
    /// Executes a query and maps each row to a type T using the provided mapper function.
    /// </summary>
    public static async Task<List<T>> ExecuteQueryAsync<T>(
        string connectionString, 
        string sql, 
        Func<Dictionary<string, object?>, T> mapper, 
        Dictionary<string, object?>? parameters = null)
    {
        var rows = await ExecuteQueryAsync(connectionString, sql, parameters);
        return rows.Select(mapper).ToList();
    }

    /// <summary>
    /// Inserts an entity into the specified table and returns the saved entity with generated ID.
    /// Throws exception on failure.
    /// </summary>
    public static async Task<T> NonQueryAsyncTyped<T>(
        string connectionString,
        string tableName,
        T entity,
        Action<SqlCommand, T>? configureParameters = null) where T : class
    {
        try
        {
            var sqlCompatibleTypes = new HashSet<Type>
            {
                typeof(string),
                typeof(int), typeof(int?),
                typeof(decimal), typeof(decimal?),
                typeof(DateTime), typeof(DateTime?),
                typeof(bool), typeof(bool?),
                typeof(Guid), typeof(Guid?),
                typeof(byte), typeof(byte?),
                typeof(double), typeof(double?),
                typeof(float), typeof(float?),
                typeof(long), typeof(long?),
                typeof(short), typeof(short?),
                typeof(char),
                typeof(char?)
            };

            var excludePropertyNames = new HashSet<string>
            {
                "ClaseId", "IdClassImage", "RefreshTokenId", "UsuarioId",
                "IdPreReserva", "IdReservacion", "IdHorario", "Id"
            };

            var properties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance)
                .Where(p => !excludePropertyNames.Contains(p.Name))
                .Where(p => sqlCompatibleTypes.Contains(p.PropertyType))
                .ToList();

            var columns = string.Join(", ", properties.Select(p => p.Name));
            var paramNames = string.Join(", ", properties.Select(p => $"@{p.Name}"));

            var sql = $"INSERT INTO {tableName} ({columns}) VALUES ({paramNames}); SELECT SCOPE_IDENTITY();";

            await using var connection = GetSqlConnection(connectionString);
            await connection.OpenAsync();

            await using var command = connection.CreateCommand();
            command.CommandText = sql;

            foreach (var prop in properties)
            {
                var value = prop.GetValue(entity);
                command.Parameters.AddWithValue($"@{prop.Name}", value ?? DBNull.Value);
            }

            configureParameters?.Invoke(command, entity);

            var result = await command.ExecuteScalarAsync();
            if (result == null || result == DBNull.Value)
                throw new InvalidOperationException($"Failed to insert into {tableName}. No identity generated.");

            var generatedId = Convert.ToInt32(result);

            var idProperty = typeof(T).GetProperty("ClaseId") ?? typeof(T).GetProperty("IdClassImage");
            idProperty?.SetValue(entity, generatedId);

            return entity;
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException($"Error inserting {typeof(T).Name} into {tableName}: {ex.Message}", ex);
        }
    }

}