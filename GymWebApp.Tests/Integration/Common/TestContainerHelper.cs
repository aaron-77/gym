using Microsoft.EntityFrameworkCore;
using Respawn;
using Respawn.Graph;
using Testcontainers.MsSql;
using FitnessCenterDbContext = DataAccess.EntityFramework.FitnessCenterDbContext;

namespace GymWebApp.Tests.Integration.Common;

public static class TestContainerHelper
{
    private static MsSqlContainer? _msSqlContainer;
    private static Respawner? _respawner;
    private static string? _connectionString;
    private static bool _isInitialized;
    private static readonly SemaphoreSlim _initLock = new(1, 1);

    public static string ConnectionString
    {
        get
        {
            if (string.IsNullOrEmpty(_connectionString))
            {
                InitializeAsync().GetAwaiter().GetResult();
                Thread.Sleep(2000);
            }
            return _connectionString!;
        }
    }

    public static async Task InitializeAsync()
    {
        if (_isInitialized)
            return;

        await _initLock.WaitAsync();
        try
        {
            if (_isInitialized)
                return;

            var sqlPassword = ConfigHelper.GetProperty("SqlServer:Password");

            var backupHostPath = "/mnt/archivos/estudio/proyectos/gym/bd/respaldosbd";

            // Forzar recrear el container para aplicar el bind mount
            if (_msSqlContainer != null)
            {
                try { await _msSqlContainer.DisposeAsync(); } catch { }
                _msSqlContainer = null;
            }

            _msSqlContainer = new MsSqlBuilder()
                .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
                .WithPassword(sqlPassword)
                //.WithReuse(true)
                .WithBindMount(backupHostPath, "/backup")
                .Build();

            await _msSqlContainer.StartAsync();

            await WaitForContainerReady();

            // First connect to master to restore the database
            _connectionString = _msSqlContainer.GetConnectionString();
            await RestoreDatabaseFromBackupAsync();

            // Now connect to FitnessCenterDB with timeout
            _connectionString = _msSqlContainer.GetConnectionString() + ";Database=FitnessCenterDB;Connect Timeout=60;TrustServerCertificate=True";

            await InitializeRespawnAsync();

            _isInitialized = true;
        }
        finally
        {
            _initLock.Release();
        }
    }

    private static async Task WaitForContainerReady()
    {
        var maxRetries = 30;
        var delay = TimeSpan.FromSeconds(1);

        for (int i = 0; i < maxRetries; i++)
        {
            try
            {
                await using var connection = DatabaseHelper.GetSqlConnection(_msSqlContainer!.GetConnectionString());
                await connection.OpenAsync();
                return;
            }
            catch
            {
                await Task.Delay(delay);
            }
        }

        throw new Exception("SQL Server container failed to start");
    }

    private static async Task InitializeRespawnAsync()
    {
        await using var connection = DatabaseHelper.GetSqlConnection(_connectionString!);
        await connection.OpenAsync();

        _respawner = await Respawner.CreateAsync(connection, new RespawnerOptions
        {
            DbAdapter = DbAdapter.SqlServer,
            TablesToIgnore = new Table[]
            {
                new Table("__EFMigrationsHistory"),
                new Table("__Databases"),
                new Table("AspNetRoles"),
                new Table("AspNetUserClaims"),
                new Table("AspNetUserLogins"),
                new Table("AspNetUserRoles"),
                new Table("AspNetUserTokens"),
                new Table("AspNetRoleClaims"),
                new Table("horasLaborales"),
                new Table("intenciones"),
                new Table("medidas"),
                new Table("metas"),
                new Table("nivelesDeDificultadDeClase"),
                new Table("nivelesDeIntensidadDeClase"),
                new Table("nivelesDeLogro"),
                new Table("tiposDeRecurrenciaDeDiasFestivos"),
                new Table("unidadesDeMedida"),
                new Table("AspNetUsers"),
                new Table("Clases"),
                new Table("Usuarios"),
                new Table("Ejercicios"),
                new Table("Equipos"),
                new Table("Servicios"),
                new Table("Cupones"),
                new Table("Descuentos"),
                new Table("Pagos"),
                new Table("Roles"),
                new Table("Rutinas"),
                new Table("TipoRutina"),
                new Table("beneficiosDeClase"),
                new Table("estructuraDeClase"),
                new Table("consejosParaLasClases"),
                new Table("imagesForClases"),
                new Table("imagesForExercises"),
                new Table("iconsForParameters"),
                new Table("parametrosDeMedicion"),
                new Table("parametros_unidadesDeMedida"),
                new Table("EjercicioEquipos"),
                new Table("ejercicios_parametrosDeMedicion"),
                new Table("estadosDeClases"),
                new Table("estadosClasesProgramadas"),
                new Table("estadosDeActividadLaboral"),
                new Table("estadosHorarioClaseProgramada"),
                new Table("estadosInscripciones"),
                new Table("diasFestivosYDescansos"),
                new Table("diasFestivosVariables"),
                new Table("duracionCitas"),
                new Table("inscripcionesDeClases"),
                new Table("clasesProgramadas"),
                new Table("horariosDeClasesProgramadas"),
                // new Table("preReservasDeHorario"), // Se limpia
                // new Table("RegistrosEntrenamiento"), // Se limpia
                // new Table("DetalleEntrenamiento"), // Se limpia
                new Table("RutinaEjercicios"),
                new Table("LogErrores"),
                new Table("AccessTokens"),
                new Table("RefreshTokens"),
                new Table("sysdiagrams")
            }
        });
    }

    private static async Task RestoreDatabaseFromBackupAsync()
    {
        // Use the mounted path inside the container
        var backupPath = "/backup/respaldoporfindaws.bak";

        var databaseName = "FitnessCenterDB";

        await using var connection = DatabaseHelper.GetSqlConnection(_connectionString!);
        await connection.OpenAsync();

        // First, get the file list from the backup to know logical names
        var fileListSql = "RESTORE FILELISTONLY FROM DISK = @BackupPath";
        
        List<string> moveStatements = new();
        
        await using (var fileListCommand = connection.CreateCommand())
        {
            fileListCommand.CommandText = fileListSql;
            fileListCommand.Parameters.AddWithValue("@BackupPath", backupPath);
            
            await using var reader = await fileListCommand.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                var logicalName = reader.GetString(0); // LogicalName
                var type = reader.GetString(2); // Type (D = data, L = log)
                
                var extension = type == "L" ? ".ldf" : ".mdf";
                var newPath = $"/var/opt/mssql/data/{databaseName}{extension}";
                moveStatements.Add($"MOVE '{logicalName}' TO '{newPath}'");
            }
        }

        var moveClause = string.Join(", ", moveStatements);
        
        // Try RESTORE first (creates DB if not exists), then set to single user if exists
        var sql = $@"
            BEGIN TRY
                RESTORE DATABASE [{databaseName}] FROM DISK = @BackupPath WITH REPLACE, RECOVERY, {moveClause};
            END TRY
            BEGIN CATCH
                ALTER DATABASE [{databaseName}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                RESTORE DATABASE [{databaseName}] FROM DISK = @BackupPath WITH REPLACE, RECOVERY, {moveClause};
            END CATCH;
        ";

        await DatabaseHelper.ExecuteNonQueryAsync(_connectionString!, sql, new() { ["@BackupPath"] = backupPath });
    }

    public static async Task ResetDatabaseAsync()
    {
        if (_respawner == null)
            throw new InvalidOperationException("Respawner not initialized. Call InitializeAsync first.");

        if (string.IsNullOrEmpty(_connectionString))
            throw new InvalidOperationException("Connection string not set.");

        await using var connection = DatabaseHelper.GetSqlConnection(_connectionString);
        await connection.OpenAsync();
        await _respawner.ResetAsync(connection);
    }
}
