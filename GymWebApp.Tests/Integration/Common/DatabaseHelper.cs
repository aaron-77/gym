using System.Data;
using System.Reflection;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using DataAccess.EntityFramework;

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

    // ──────────────────────────────────────────────
    //  Transaction helpers
    // ──────────────────────────────────────────────

    /// <summary>
    /// Ejecuta un bloque de operaciones DDL dentro de una transacción.
    /// Abre conexión, inicia transacción, ejecuta el callback, y hace Commit o Rollback automáticamente.
    /// </summary>
    public static async Task<T> WithTransactionAsync<T>(
        string connectionString,
        Func<SqlConnection, SqlTransaction, Task<T>> operation,
        IsolationLevel isolationLevel = IsolationLevel.ReadCommitted)
    {
        await using var connection = new SqlConnection(connectionString);
        await connection.OpenAsync();
        await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync(isolationLevel);
        try
        {
            var result = await operation(connection, transaction);
            await transaction.CommitAsync();
            return result;
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }

    /// <summary>
    /// Ejecuta un bloque de operaciones DDL sin valor de retorno, dentro de una transacción.
    /// </summary>
    public static async Task WithTransactionAsync(
        string connectionString,
        Func<SqlConnection, SqlTransaction, Task> operation,
        IsolationLevel isolationLevel = IsolationLevel.ReadCommitted)
    {
        await using var connection = new SqlConnection(connectionString);
        await connection.OpenAsync();
        await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync(isolationLevel);
        try
        {
            await operation(connection, transaction);
            await transaction.CommitAsync();
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }

    // ──────────────────────────────────────────────
    //  QueryAsync — retorna lista de dictionaries
    // ──────────────────────────────────────────────

    /// <summary>
    /// Executes a query and returns a list of dictionaries, where each dictionary represents a row.
    /// </summary>
    public static async Task<List<Dictionary<string, object?>>> ExecuteQueryAsync(
        string connectionString, 
        string sql, 
        Dictionary<string, object?>? parameters = null)
    {
        await using var connection = GetSqlConnection(connectionString);
        await connection.OpenAsync();

        return await ExecuteQueryAsync(connection, null, sql, parameters);
    }

    /// <summary>
    /// Executes a query within an existing connection/transaction and returns a list of dictionaries.
    /// </summary>
    public static async Task<List<Dictionary<string, object?>>> ExecuteQueryAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        string sql,
        Dictionary<string, object?>? parameters = null)
    {
        var results = new List<Dictionary<string, object?>>();

        await using var command = connection.CreateCommand();
        command.Transaction = transaction;
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
    /// Executes a query within an existing connection/transaction and returns a single row.
    /// </summary>
    public static async Task<Dictionary<string, object?>?> ExecuteQuerySingleAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        string sql,
        Dictionary<string, object?>? parameters = null)
    {
        var results = await ExecuteQueryAsync(connection, transaction, sql, parameters);
        return results.Count > 0 ? results[0] : null;
    }

    // ──────────────────────────────────────────────
    //  ExecuteNonQueryAsync
    // ──────────────────────────────────────────────

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

        return await ExecuteNonQueryAsync(connection, null, sql, parameters);
    }

    /// <summary>
    /// Executes a non-query SQL statement within an existing connection/transaction.
    /// </summary>
    public static async Task<int> ExecuteNonQueryAsync(
        SqlConnection connection,
        SqlTransaction? transaction,
        string sql,
        Dictionary<string, object?>? parameters = null)
    {
        await using var command = connection.CreateCommand();
        command.Transaction = transaction;
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

    // ──────────────────────────────────────────────
    //  ExecuteScalarAsync
    // ──────────────────────────────────────────────

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

        return await ExecuteScalarAsync<T>(connection, null, sql, parameters);
    }

    /// <summary>
    /// Executes a query within an existing connection/transaction and returns a scalar value.
    /// </summary>
    public static async Task<T?> ExecuteScalarAsync<T>(
        SqlConnection connection,
        SqlTransaction? transaction,
        string sql,
        Dictionary<string, object?>? parameters = null)
    {
        await using var command = connection.CreateCommand();
        command.Transaction = transaction;
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

        var targetType = Nullable.GetUnderlyingType(typeof(T)) ?? typeof(T);
        return (T)Convert.ChangeType(result, targetType);
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
