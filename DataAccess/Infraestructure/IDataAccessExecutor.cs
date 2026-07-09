namespace DataAccess.Infraestructure;

/// <summary>
/// Ejecuta consultas SQL planas (FromSql, ExecuteSql) y procedimientos almacenados
/// de forma inyectable y 100% mockeable para testing.
/// Reemplaza el uso directo de:
///   - FromSqlInterpolated / FromSqlRaw
///   - ExecuteSqlInterpolatedAsync / ExecuteSqlRawAsync
///   - DatabaseExecutor (estático)
/// </summary>
public interface IDataAccessExecutor
{
    /// <summary>
    /// Ejecuta una consulta SQL que retorna una lista de entidades (FROM SQL).
    /// Internamente usa FromSqlInterpolated.
    /// </summary>
    Task<List<T>> QueryAsync<T>(FormattableString sql) where T : class;

    /// <summary>
    /// Ejecuta un comando SQL que no retorna filas (INSERT, UPDATE, DELETE, EXEC SP).
    /// Internamente usa ExecuteSqlInterpolatedAsync.
    /// </summary>
    Task<int> ExecuteAsync(FormattableString sql);

    /// <summary>
    /// Ejecuta un procedimiento almacenado con parámetros de entrada/salida,
    /// retorna DatabaseExecutionResult (como DatabaseExecutor.ExecuteStoredProcedureAsync).
    /// Útil para SPs con RETURN VALUE o parámetros OUTPUT.
    /// </summary>
    Task<DatabaseExecutionResult> ExecuteStoredProcedureAsync(
        string procedureName,
        Dictionary<string, object>? parameters = null,
        int? commandTimeout = null);

    /// <summary>
    /// Ejecuta un procedimiento almacenado que retorna un DataSet (resultados).
    /// Útil para SPs que devuelven múltiples tablas o consultas complejas.
    /// </summary>
    Task<DatabaseQueryResult> ExecuteStoredProcedureWithResultsAsync(
        string procedureName,
        Dictionary<string, object>? parameters = null,
        int? commandTimeout = null);
}