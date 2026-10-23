using Microsoft.Data.SqlClient;
using DotNet.Testcontainers.Builders;
using DotNet.Testcontainers.Containers;
using DotNet.Testcontainers.Networks;
using Respawn;
using Respawn.Graph;
using Testcontainers;
using Testcontainers.MsSql;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using DatabaseHelper = GymWebApp.Tests.SharedHelpers.DatabaseHelper;

namespace GymWebApp.Tests.E2E.Common;

public class E2eContainerHelper : IAsyncLifetime
{
    private MsSqlContainer? _msSqlContainer;
    private IContainer? _apiContainer;
    private IContainer? _frontendContainer;
    private IContainer? _nginxContainer;
    private INetwork? _network;
    private Respawner? _respawner;

    // Puertos externos
    private const int NginxExternalPort = 5080;
    private const int ApiInternalPort = 5274;
    private const int FrontendInternalPort = 5062;
    private const int SqlServerInternalPort = 1433;
    private const int NginxInternalPort = 80;

    // Puertos externos dinámicos
    private int _apiExternalPort;
    private int _nginxExternalPort;
    private int _frontendExternalPort;

    public static E2eContainerHelper Instance { get; private set; } = null!;

    public string FrontendBaseUrl => $"http://localhost:{_frontendExternalPort}";
    public string ApiBaseUrl => $"http://localhost:{_apiExternalPort}";
    public string? ConnectionString { get; private set; }
    public string? HostConnectionString { get; private set; }
    public string NginxBaseUrl => $"http://localhost:{_nginxExternalPort}";

    public async Task InitializeImplAsync()
    {
        Instance = this;
        ConfigHelper.RegisterConfig("appsettings.Testing.json");

        // 1. Crear red Docker para comunicación entre contenedores
        _network = new NetworkBuilder()
            .WithName($"gym-e2e-network-{Guid.NewGuid():N}")
            .Build();

        await _network.CreateAsync();

        // 2. Iniciar SQL Server (la imagen ya trae FitnessCenterDB restaurada)
        var sqlPassword = ConfigHelper.GetProperty("SqlServer:Password");
        _msSqlContainer = new MsSqlBuilder()
            .WithImage("fitnessgymbd:latest")
            .WithPassword(sqlPassword)
            .WithEnvironment("TZ", "America/Mexico_City")
            // failingStreak 150 x intervalo 2s = 5 min de gracia: durante el recovery
            // el health reporta "starting" y cada poll cuenta como fallo.
            .WithWaitStrategy(Wait.ForUnixContainer()
                .UntilContainerIsHealthy(150, o => o
                    .WithInterval(TimeSpan.FromSeconds(2))
                    .WithTimeout(TimeSpan.FromMinutes(5))))
            .WithPortBinding(SqlServerInternalPort, true)
            .WithNetwork(_network)
            .WithNetworkAliases("sqlserver")
            .Build();

        await _msSqlContainer.StartAsync();
        var sqlMappedPort = _msSqlContainer.GetMappedPublicPort(SqlServerInternalPort);
        Console.WriteLine($"[E2E] SQL Server container started on port {sqlMappedPort}");

        var masterConnectionString = $"Server=127.0.0.1,{sqlMappedPort};Database=master;User Id=sa;Password={sqlPassword};TrustServerCertificate=True";

        // El login a nivel servidor se crea/verifica aquí: es idempotente y garantiza la
        // autenticación aunque la imagen se reconstruya sin el login.
        await FitnessGymLoginHelper.CreateAsync(masterConnectionString, sqlPassword);
        Console.WriteLine($"[E2E] Login '{FitnessGymLoginHelper.LoginName}' created");

        // Connection string para FitnessCenterDB (usando alias de red)
        ConnectionString = $"Server=sqlserver,{SqlServerInternalPort};Database=FitnessCenterDB;User Id={FitnessGymLoginHelper.LoginName};Password={sqlPassword};TrustServerCertificate=True;Connect Timeout=60";

        // Connection string for Respawn (runs from host, needs localhost + mapped port)
        HostConnectionString = $"Server=127.0.0.1,{sqlMappedPort};Database=FitnessCenterDB;User Id={FitnessGymLoginHelper.LoginName};Password={sqlPassword};TrustServerCertificate=True;Connect Timeout=60";

        // 3. Iniciar API (placeholder - requiere imagen real del proyecto)
        _apiContainer = new ContainerBuilder()
            .WithImage("fitnessgymapi:latest")
            .WithOutputConsumer(Consume.RedirectStdoutAndStderrToConsole())
            .WithEnvironment(new Dictionary<string, string>
            {
                ["ASPNETCORE_URLS"] = $"http://+:{ApiInternalPort}",
                ["ASPNETCORE_ENVIRONMENT"] = "Staging",
                ["DB_CONNECTION_STRING"] = ConnectionString,
                ["SECRET_TOKEN_KEY"] = ConfigHelper.GetProperty("JwtSettings:SecretKey"),
                ["Jwt:Issuer"] = ConfigHelper.GetProperty("JwtSettings:Issuer"),
                ["Jwt:Audience"] = ConfigHelper.GetProperty("JwtSettings:BackendAudiencie"),
                ["TZ"] = "America/Mexico_City"
            })
            .WithPortBinding(ApiInternalPort, true)
            .WithNetwork(_network)
            .WithNetworkAliases("fitnessgym_api")
            .WithWaitStrategy(Wait.ForUnixContainer()
                .UntilPortIsAvailable(ApiInternalPort))
            .Build();

        await _apiContainer.StartAsync();
        _apiExternalPort = _apiContainer.GetMappedPublicPort(ApiInternalPort);
        Console.WriteLine($"[E2E] API container started on port {_apiExternalPort}");

        // 4. Iniciar Frontend (Blazor Server - placeholder requiere imagen real del proyecto)
        _frontendContainer = new ContainerBuilder()
            .WithImage("fitnessgymfrontend:latest")
            .WithOutputConsumer(Consume.RedirectStdoutAndStderrToConsole())
            .WithEnvironment(new Dictionary<string, string>
            {
                ["ASPNETCORE_URLS"] = $"http://+:{FrontendInternalPort}",
                ["DB_CONNECTION_STRING"] = ConnectionString,
                ["ASPNETCORE_ENVIRONMENT"] = "Staging",
                ["SECRET_TOKEN_KEY"] = ConfigHelper.GetProperty("JwtSettings:SecretKey"),
                ["TZ"] = "America/Mexico_City"
            })
            .WithPortBinding(FrontendInternalPort, true)
            .WithNetwork(_network)
            .WithNetworkAliases("fitnessgym_frontend")
            .WithWaitStrategy(Wait.ForUnixContainer()
                .UntilPortIsAvailable(FrontendInternalPort))
            .Build();

        await _frontendContainer.StartAsync();
        _frontendExternalPort = _frontendContainer.GetMappedPublicPort(FrontendInternalPort);
        Console.WriteLine($"[E2E] Frontend container started on port {_frontendExternalPort}");

        // 5. Iniciar Nginx como reverse proxy
        // La imagen trae el template de producción (SSL + letsencrypt, no existe en el test).
        // Se monta el template local sin SSL y se anulan los dominios, igual que en compose.
        _nginxContainer = new ContainerBuilder()
            .WithImage("fitnessgymnginx:latest")
            .WithEnvironment(new Dictionary<string, string>
            {
                ["GYM_PRIMARY_DOMAIN"] = "localhost",
                ["GYM_APP_DOMAIN"] = "localhost"
            })
            .WithBindMount(
                "/mnt/archivos/estudio/proyectos/fitnessgymreverseproxy/nginx/nginx.local.conf.template",
                "/etc/nginx/templates/nginx.conf.template")
            .WithPortBinding(NginxInternalPort, true)
            .WithNetwork(_network)
            .WithNetworkAliases("nginx")
            .WithWaitStrategy(Wait.ForUnixContainer().UntilPortIsAvailable(80))
            .Build();

        await _nginxContainer.StartAsync();
        _nginxExternalPort = _nginxContainer.GetMappedPublicPort(NginxInternalPort);
        Console.WriteLine($"[E2E] Nginx container started on port {_nginxExternalPort}");

        // Initialize Respawn after DB restore
        await InitializeRespawnAsync();
        
    }

        Task IAsyncLifetime.InitializeAsync() => InitializeImplAsync();

    private async Task InitializeRespawnAsync()
    {
        if (string.IsNullOrEmpty(ConnectionString))
            throw new InvalidOperationException("Connection string not set.");

        await using var connection = DatabaseHelper.GetSqlConnection(HostConnectionString);
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
                new Table("AspNetUsers"),
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

        if (string.IsNullOrEmpty(ConnectionString))
            throw new InvalidOperationException("Connection string not set.");

        await using var connection = DatabaseHelper.GetSqlConnection(HostConnectionString);
        await connection.OpenAsync();
        await _respawner.ResetAsync(connection);
    }

    public async Task DisposeImplAsync()
    {
        var disposeTasks = new List<Task>();

        if (_nginxContainer is not null)
            disposeTasks.Add(_nginxContainer.DisposeAsync().AsTask());
        if (_frontendContainer is not null)
            disposeTasks.Add(_frontendContainer.DisposeAsync().AsTask());
        if (_apiContainer is not null)
            disposeTasks.Add(_apiContainer.DisposeAsync().AsTask());
        if (_msSqlContainer is not null)
            disposeTasks.Add(_msSqlContainer.DisposeAsync().AsTask());
        if (_network is not null)
            disposeTasks.Add(_network.DisposeAsync().AsTask());

        await Task.WhenAll(disposeTasks);

        _respawner = null;
    }
        Task IAsyncLifetime.DisposeAsync() => DisposeImplAsync();
}
