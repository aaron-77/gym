using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using DataAccess.EntityFramework;
using System.Data;

namespace GymWebApp.Tests.Integration.Common;

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

        return (T)result;
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
}
