using DotNet.Testcontainers.Builders;
using Respawn;
using Respawn.Graph;
using Testcontainers.MsSql;
using GymWebApp.Tests.Integration.Helpers;

namespace GymWebApp.Tests.Integration.Common;

public class TestContainerHelper : IAsyncLifetime
{
    private MsSqlContainer? _msSqlContainer;
    private Respawner? _respawner;
    private string? _connectionString;

    public static TestContainerHelper Instance { get; private set; } = null!;

    // Respaldo de BD en el repo (bd/FitnessGymDB.bak, gitignored). La ruta se
    // resuelve desde el output de tests (bin/Debug/net8.0 → raíz del repo).
    private static string BdBackupPath { get; } =
        Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "bd", "FitnessGymDB.bak"));

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

        // Fail-fast con mensaje accionable: sin el .bak local la imagen nueva no puede
        // restaurar FitnessCenterDB y el healthcheck nunca llega a healthy (timeout).
        if (!File.Exists(BdBackupPath))
            throw new FileNotFoundException(
                $"No existe el respaldo de BD en '{BdBackupPath}'. La imagen fitnessgymbd ya no lo trae horneado: copiá el archivo a bd/FitnessGymDB.bak.");

        var sqlPassword = ConfigHelper.GetProperty("SqlServer:Password");

        if (_msSqlContainer != null)
        {
            // Un contenedor huérfano de una corrida anterior no debe impedir el arranque.
            try { await _msSqlContainer.DisposeAsync(); }
            catch { /* limpieza best-effort: la nueva instancia arranca limpia igual */ }
            _msSqlContainer = null;
        }

        _msSqlContainer = new MsSqlBuilder()
            .WithImage("fitnessgymbd:latest")
            .WithPassword(sqlPassword)
            .WithEnvironment("TZ", "America/Mexico_City")
            // Nuevo contrato de imagen BD (rediseño 2026-10-25): la imagen NO trae
            // el .bak horneado - la BD entra por RUNTIME igual que en bd/docker-compose-local.yml:
            //   bind read-only del respaldo  -> configure-db.sh lo detecta y restaura
            //   MSSQL_APP_LOGIN_PASSWORD     -> create-login.sql lo recibe vía sqlcmd -v
            // Sin el bind, no hay FitnessCenterDB y el HEALTHCHECK baked (-d FitnessCenterDB)
            // falla eternamente -> timeout de UntilContainerIsHealthy.
            .WithBindMount(BdBackupPath, "/var/opt/mssql/backups/FitnessGymDB.bak")
            .WithEnvironment("MSSQL_APP_LOGIN_PASSWORD", sqlPassword)
            // failingStreak 150 x intervalo 2s = 5 min de gracia: durante el recovery
            // el health reporta "starting" y cada poll cuenta como fallo.
            .WithWaitStrategy(Wait.ForUnixContainer()
                .UntilContainerIsHealthy(150, o => o
                    .WithInterval(TimeSpan.FromSeconds(2))
                    .WithTimeout(TimeSpan.FromMinutes(5))))
            .Build();

        await _msSqlContainer.StartAsync();

        var fullConnectionString = _msSqlContainer.GetConnectionString();
        var serverPart = fullConnectionString.Split(';')[0];

        var masterConnectionString = $"{serverPart};Database=master;User Id=sa;Password={sqlPassword};TrustServerCertificate=True";

        // Con la imagen rediseñada la BD entra por bind mount (ver arriba); el login
        // a nivel servidor se crea/verifica aquí (helper idempotente, abre su propia
        // conexión): garantiza la autenticación para el user que consulta desde el host.
        await FitnessGymLoginHelper.CreateAsync(masterConnectionString, sqlPassword);

        _connectionString = $"{serverPart};Database=FitnessCenterDB;User Id={FitnessGymLoginHelper.LoginName};Password={sqlPassword};TrustServerCertificate=True;Connect Timeout=60";

        await InitializeRespawnAsync();
    }

    Task IAsyncLifetime.InitializeAsync() => InitializeImplAsync();

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
