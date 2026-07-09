using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;
using System.Data;
using System.Data.Common;

namespace DataAccess.Infraestructure;

public class DataAccessExecutor : IDataAccessExecutor
{
    private readonly FitnessCenterDbContext _context;

    public DataAccessExecutor(FitnessCenterDbContext context)
    {
        _context = context;
    }

    // ──────────────────────────────────────────────
    //  QueryAsync — FromSqlInterpolated
    // ──────────────────────────────────────────────

    public async Task<List<T>> QueryAsync<T>(FormattableString sql) where T : class
    {
        return await _context
            .Set<T>()
            .FromSqlInterpolated(sql)
            .ToListAsync();
    }

    // ──────────────────────────────────────────────
    //  ExecuteAsync — ExecuteSqlInterpolatedAsync
    // ──────────────────────────────────────────────

    public async Task<int> ExecuteAsync(FormattableString sql)
    {
        return await _context.Database.ExecuteSqlInterpolatedAsync(sql);
    }

    // ──────────────────────────────────────────────
    //  ExecuteStoredProcedureAsync — wrapper del helper estático
    // ──────────────────────────────────────────────

    public async Task<DatabaseExecutionResult> ExecuteStoredProcedureAsync(
        string procedureName,
        Dictionary<string, object>? parameters = null,
        int? commandTimeout = null)
    {
        var connection = _context.Database.GetDbConnection();
        return await DatabaseExecutor.ExecuteStoredProcedureAsync(
            connection,
            procedureName,
            parameters,
            commandTimeout);
    }

    // ──────────────────────────────────────────────
    //  ExecuteStoredProcedureWithResultsAsync — wrapper del helper estático
    // ──────────────────────────────────────────────

    public async Task<DatabaseQueryResult> ExecuteStoredProcedureWithResultsAsync(
        string procedureName,
        Dictionary<string, object>? parameters = null,
        int? commandTimeout = null)
    {
        var connection = _context.Database.GetDbConnection();
        return await DatabaseExecutor.ExecuteStoredProcedureWithResultsAsync(
            connection,
            procedureName,
            parameters,
            commandTimeout);
    }
}