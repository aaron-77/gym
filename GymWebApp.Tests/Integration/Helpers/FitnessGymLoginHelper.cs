using Microsoft.Data.SqlClient;
using DatabaseHelper = GymWebApp.Tests.Integration.Common.DatabaseHelper;

namespace GymWebApp.Tests.Integration.Helpers;

/// <summary>
/// Crea el login con el que los tests se conectan a la base de datos.
///
/// El respaldo (.bak) trae únicamente el USER de base de datos. Los logins nunca viajan en un
/// respaldo porque pertenecen al servidor y no a la base. Restaurado el .bak, el user queda
/// huérfano: existe y tiene sus permisos, pero nadie puede autenticarse para llegar a él.
///
/// Este helper cierra ese hueco en dos pasos: crea el login a nivel servidor y religa el user
/// que el respaldo ya trae, conservando los permisos que trae adentro.
///
/// El nombre del login es deliberadamente distinto al del user, de modo que al inspeccionar
/// sys.server_principals y sys.database_principals se pueda distinguir de un vistazo cuál es
/// el login (ámbito servidor) y cuál es el user (ámbito base de datos).
/// </summary>
public static class FitnessGymLoginHelper
{
    /// <summary>
    /// Login a nivel servidor. Es el identificador que se usa en las connection strings.
    /// </summary>
    public const string LoginName = "fitnessgymlogin";

    /// <summary>
    /// User a nivel base de datos. Ya existe dentro del .bak, con sus permisos sobre el esquema
    /// de la aplicación, ligado todavía a un login que no existe en el servidor.
    /// </summary>
    public const string UserName = "fitnessgymuser";

    /// <summary>
    /// Crea el login y religa el user del respaldo. Es idempotente: se puede ejecutar más de una
    /// vez sobre la misma base sin producir errores.
    /// </summary>
    /// <param name="masterConnectionString">
    /// Conexión a la base <c>master</c> con un login que tenga permisos de servidor (<c>sa</c>).
    /// Hace falta por dos motivos: el <c>CREATE LOGIN</c> se ejecuta a nivel servidor y el login
    /// aún no existe en el momento en que corre el restore.
    /// </param>
    /// <param name="password">
    /// Contraseña del login. Debe ser exactamente la misma que declaran las connection strings,
    /// de lo contrario la autenticación se rechaza.
    /// </param>
    public static async Task CreateAsync(string masterConnectionString, string password)
    {
        await CreateLoginAsync(masterConnectionString, password);
        await LinkUserToLoginAsync(masterConnectionString);
    }

    private static async Task CreateLoginAsync(string connectionString, string password)
    {
        // El DDL de SQL Server no admite variables ni siquiera dentro de sp_executesql:
        // "CREATE LOGIN x WITH PASSWORD = @pwd" revienta con "Incorrect syntax near '@pwd'"
        // probado contra SQL Server 2022. Por eso la contraseña va como literal.
        //
        // Se escapan las comillas simples duplicándolas, que es la única regla de una literal
        // T-SQL. El valor no viene del usuario sino de la configuración de la suite de tests,
        // así que no hay superficie de inyección.
        //
        // El nombre del login se interpola directamente: es constante de este archivo.
        var escapedPassword = password.Replace("'", "''", StringComparison.Ordinal);

        var sql = $@"
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'{LoginName}')
    ALTER LOGIN [{LoginName}] WITH PASSWORD = N'{escapedPassword}';
ELSE
    CREATE LOGIN [{LoginName}]
        WITH PASSWORD           = N'{escapedPassword}',
             DEFAULT_DATABASE    = [FitnessCenterDB],
             DEFAULT_LANGUAGE    = [Español],
             CHECK_POLICY        = OFF,
             CHECK_EXPIRATION    = OFF;";

        await using var connection = DatabaseHelper.GetSqlConnection(connectionString);
        await connection.OpenAsync();
        await using var command = connection.CreateCommand();
        command.CommandText = sql;
        await command.ExecuteNonQueryAsync();
    }

    private static async Task LinkUserToLoginAsync(string masterConnectionString)
    {
        // ALTER USER ... WITH LOGIN cambia únicamente la ligadura del user al login. No toca los
        // permisos: un DROP USER en cambio los borraría y habría que volver a concederlos a mano.
        var fitnessCenterDbConnectionString = masterConnectionString
            .Replace("Database=master", "Database=FitnessCenterDB");

        var sql = $@"
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'{UserName}')
   AND EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'{LoginName}')
    ALTER USER [{UserName}] WITH LOGIN = [{LoginName}];";

        await using var connection = DatabaseHelper.GetSqlConnection(fitnessCenterDbConnectionString);
        await connection.OpenAsync();
        await using var command = connection.CreateCommand();
        command.CommandText = sql;
        await command.ExecuteNonQueryAsync();
    }
}
