using Microsoft.Data.SqlClient;
using Respawn;
using Respawn.Graph;
using Testcontainers.MsSql;

namespace GymWebApp.Tests.Integration.Common;

public class TestContainerHelper : IAsyncLifetime
{
    private MsSqlContainer? _msSqlContainer;
    private Respawner? _respawner;
    private string? _connectionString;

    public static TestContainerHelper Instance { get; private set; } = null!;

    public string ConnectionString
    {
        get
        {
            if (string.IsNullOrEmpty(_connectionString))
            {
                throw new InvalidOperationException("TestContainerHelper not initialized. Ensure ICollectionFixture<TestContainerHelper> is used.");
            }
            return _connectionString!;
        }
    }

    public async Task InitializeImplAsync()
    {
        ConfigHelper.RegisterConfig("appsettings.Testing.json");
        Instance = this;

        var sqlPassword = ConfigHelper.GetProperty("SqlServer:Password");

        var backupHostPath = "/mnt/archivos/estudio/proyectos/gym/bd/respaldosbd";

        if (_msSqlContainer != null)
        {
            try { await _msSqlContainer.DisposeAsync(); } catch { }
            _msSqlContainer = null;
        }

        _msSqlContainer = new MsSqlBuilder()
            .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
            .WithPassword(sqlPassword)
            .WithEnvironment("TZ", "America/Mexico_City")
            .WithBindMount(backupHostPath, "/backup")
            .Build();

        await _msSqlContainer.StartAsync();

        await WaitForContainerReady();

        var fullConnectionString = _msSqlContainer.GetConnectionString();
        var serverPart = fullConnectionString.Split(';')[0];

        var masterConnectionString = $"{serverPart};Database=master;User Id=sa;Password={sqlPassword};TrustServerCertificate=True";

        await using var masterConnection = DatabaseHelper.GetSqlConnection(masterConnectionString);
        await masterConnection.OpenAsync();
        await RestoreDatabaseFromBackupAsync(masterConnection);

        _connectionString = $"{serverPart};Database=FitnessCenterDB;User Id=sa;Password={sqlPassword};TrustServerCertificate=True;Connect Timeout=60";

        await InitializeRespawnAsync();
    }

    Task IAsyncLifetime.InitializeAsync() => InitializeImplAsync();

    private async Task WaitForContainerReady()
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

    private async Task InitializeRespawnAsync()
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
                new Table("beneficiosDeClase"),
                new Table("estructuraDeClase"),
                new Table("consejosParaLasClases"),
                new Table("imagesForClases"),
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
                new Table("RutinaEjercicios"),
                new Table("LogErrores"),
                new Table("AccessTokens"),
                new Table("RefreshTokens"),
                new Table("sysdiagrams")
            }
        });
    }

    private async Task RestoreDatabaseFromBackupAsync(SqlConnection connection)
    {
        var backupPath = "/backup/FitnessGymBackup20260714.bak";
        var databaseName = "FitnessCenterDB";

        var fileListSql = "RESTORE FILELISTONLY FROM DISK = @BackupPath";

        List<string> moveStatements = new();

        await using (var fileListCommand = connection.CreateCommand())
        {
            fileListCommand.CommandText = fileListSql;
            fileListCommand.Parameters.AddWithValue("@BackupPath", backupPath);

            await using var reader = await fileListCommand.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                var logicalName = reader.GetString(0);
                var type = reader.GetString(2);

                var extension = type == "L" ? ".ldf" : ".mdf";
                var newPath = $"/var/opt/mssql/data/{databaseName}{extension}";
                moveStatements.Add($"MOVE '{logicalName}' TO '{newPath}'");
            }
        }

        var moveClause = string.Join(", ", moveStatements);

        var sql = $@"
            BEGIN TRY
                RESTORE DATABASE [{databaseName}] FROM DISK = @BackupPath WITH REPLACE, RECOVERY, {moveClause};
            END TRY
            BEGIN CATCH
                ALTER DATABASE [{databaseName}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                RESTORE DATABASE [{databaseName}] FROM DISK = @BackupPath WITH REPLACE, RECOVERY, {moveClause};
            END CATCH;
        ";

        await using var command = connection.CreateCommand();
        command.CommandText = sql;
        command.Parameters.AddWithValue("@BackupPath", backupPath);
        await command.ExecuteNonQueryAsync();
    }

    public async Task ResetDatabaseAsync()
    {
        if (_respawner == null)
            throw new InvalidOperationException("Respawner not initialized. Call InitializeAsync first.");

        if (string.IsNullOrEmpty(_connectionString))
            throw new InvalidOperationException("Connection string not set.");

        await using var connection = DatabaseHelper.GetSqlConnection(_connectionString);
        await connection.OpenAsync();
        await _respawner.ResetAsync(connection);
    }

    public async Task DisposeImplAsync()
    {
        if (_msSqlContainer != null)
        {
            await _msSqlContainer.DisposeAsync();
            _msSqlContainer = null;
        }
        _respawner = null;
        _connectionString = null;
    }

    Task IAsyncLifetime.DisposeAsync() => DisposeImplAsync();
}
