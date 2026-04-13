using System.Text;
using DotNet.Testcontainers.Builders;
using Testcontainers;
using Testcontainers.MsSql;

namespace GymWebApp.Tests.E2E.Common;

public static class E2eContainerHelper
{
    private static MsSqlContainer? _msSqlContainer;
    private static IContainer? _apiContainer;
    private static IContainer? _frontendContainer;
    private static IContainer? _nginxContainer;
    private static INetwork? _network;
    private static bool _isInitialized;
    private static readonly SemaphoreSlim _initLock = new(1, 1);

    // Puertos externos
    private const int NginxExternalPort = 5080;
    private const int ApiInternalPort = 5274;
    private const int FrontendInternalPort = 5062;
    private const int SqlServerInternalPort = 1433;

    public static string FrontendBaseUrl => $"http://localhost:{NginxExternalPort}";
    public static string ApiBaseUrl => $"http://localhost:{ApiInternalPort}";
    public static string? ConnectionString { get; private set; }

    public static async Task InitializeAsync()
    {
        if (_isInitialized)
            return;

        await _initLock.WaitAsync();
        try
        {
            if (_isInitialized)
                return;

            // 1. Crear red Docker para comunicación entre contenedores
            _network = new NetworkBuilder()
                .WithName($"gym-e2e-network-{Guid.NewGuid():N}")
                .Build();

            await _network.CreateAsync();

            // 2. Iniciar SQL Server
            var sqlPassword = "Your_password123";
            _msSqlContainer = new MsSqlBuilder()
                .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
                .WithPassword(sqlPassword)
                .WithPortBinding(SqlServerInternalPort, true)
                .WithNetwork(_network)
                .WithNetworkAliases("sqlserver")
                .Build();

            await _msSqlContainer.StartAsync();

            // Extraer connection string del contenedor SQL Server
            var sqlServerHost = _msSqlContainer.Hostname;
            var sqlServerPort = _msSqlContainer.GetMappedPublicPort(SqlServerInternalPort);
            ConnectionString = $"Server={sqlServerHost},{sqlServerPort};Database=FitnessCenterDB;User Id=sa;Password={sqlPassword};TrustServerCertificate=True;Connect Timeout=60";

            // 3. Iniciar API (placeholder - requiere imagen real del proyecto)
            _apiContainer = new ContainerBuilder()
                .WithImage("mcr.microsoft.com/dotnet/aspnet:8.0")
                .WithEnvironment(new Dictionary<string, string>
                {
                    ["ASPNETCORE_URLS"] = $"http://+:{ApiInternalPort}",
                    ["ConnectionStrings:FitnessCenterDB"] = ConnectionString,
                    ["Jwt:Key"] = "SuperSecretKey12345678901234567890123456789012",
                    ["Jwt:Issuer"] = "FitnessGym",
                    ["Jwt:Audience"] = "FitnessGymUsers"
                })
                .WithPortBinding(ApiInternalPort, true)
                .WithNetwork(_network)
                .WithNetworkAliases("api")
                .WithWaitStrategy(Wait.ForUnixContainer().UntilPortIsAvailable(ApiInternalPort))
                .Build();

            await _apiContainer.StartAsync();

            // 4. Iniciar Frontend (Blazor Server - placeholder requiere imagen real del proyecto)
            _frontendContainer = new ContainerBuilder()
                .WithImage("mcr.microsoft.com/dotnet/aspnet:8.0")
                .WithEnvironment(new Dictionary<string, string>
                {
                    ["ASPNETCORE_URLS"] = $"http://+:{FrontendInternalPort}",
                    ["ConnectionStrings:FitnessCenterDB"] = ConnectionString
                })
                .WithPortBinding(FrontendInternalPort, true)
                .WithNetwork(_network)
                .WithNetworkAliases("frontend")
                .WithWaitStrategy(Wait.ForUnixContainer().UntilPortIsAvailable(FrontendInternalPort))
                .Build();

            await _frontendContainer.StartAsync();

            // 5. Iniciar Nginx como reverse proxy
            _nginxContainer = new ContainerBuilder()
                .WithImage("nginx:alpine")
                .WithPortBinding(NginxExternalPort, true)
                .WithNetwork(_network)
                .WithNetworkAliases("nginx")
                .WithWaitStrategy(Wait.ForUnixContainer().UntilPortIsAvailable(80))
                .Build();

            await _nginxContainer.StartAsync();

            _isInitialized = true;
        }
        finally
        {
            _initLock.Release();
        }
    }

    public static async Task DisposeAsync()
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
            dispositionTasks.Add(_network.DisposeAsync().AsTask());

        await Task.WhenAll(disposeTasks);

        _isInitialized = false;
    }
}