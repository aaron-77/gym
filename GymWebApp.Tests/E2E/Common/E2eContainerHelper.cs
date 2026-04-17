using System.Text;
using Microsoft.Data.SqlClient;
using DotNet.Testcontainers.Builders;
using DotNet.Testcontainers.Containers;
using DotNet.Testcontainers.Networks;
using Testcontainers;
using Testcontainers.MsSql;
using GymWebApp.Tests.Integration.Common;

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
    private const int NginxInternalPort = 80;

    // Puertos externos dinámicos
    private static int _apiExternalPort;
    private static int _nginxExternalPort;
    private static int _frontendExternalPort;

    // Backup configuration
    private const string BackupHostPath = "/mnt/archivos/estudio/proyectos/gym/bd/respaldosbd";
    private const string BackupFileName = "FitnessCenterDB20260331.bak";

    // Nginx configuration
    private const string NginxConfPath = "/mnt/archivos/estudio/proyectos/gym/GymWebApp.Tests/E2E/Common/nginx.conf";

    public static string FrontendBaseUrl => $"http://localhost:{_frontendExternalPort}";
    public static string ApiBaseUrl => $"http://localhost:{_apiExternalPort}";
    public static string NginxBaseUrl => $"http://localhost:{_nginxExternalPort}";
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
            var sqlPassword = "Terrabreak13";
            _msSqlContainer = new MsSqlBuilder()
                .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
                .WithPassword(sqlPassword)
                .WithPortBinding(SqlServerInternalPort, true)
                .WithNetwork(_network)
                .WithNetworkAliases("sqlserver")
                .WithBindMount(BackupHostPath, "/backup")
                .Build();

            await _msSqlContainer.StartAsync();
            var sqlMappedPort = _msSqlContainer.GetMappedPublicPort(SqlServerInternalPort);
            Console.WriteLine($"[E2E] SQL Server container started on port {sqlMappedPort}");

            // Restaurar base de datos desde backup
            var masterConnectionString = $"Server=127.0.0.1,{sqlMappedPort};Database=master;User Id=sa;Password={sqlPassword};TrustServerCertificate=True";
            await RestoreDatabaseFromBackupAsync(masterConnectionString, sqlPassword);
            Console.WriteLine("[E2E] Database restored from backup");

            // Connection string para FitnessCenterDB (usando alias de red)
            ConnectionString = $"Server=sqlserver,{SqlServerInternalPort};Database=FitnessCenterDB;User Id=sa;Password={sqlPassword};TrustServerCertificate=True;Connect Timeout=60";

            // 3. Iniciar API (placeholder - requiere imagen real del proyecto)
            _apiContainer = new ContainerBuilder()
                .WithImage("fitnessgymapi:latest")
                .WithOutputConsumer(Consume.RedirectStdoutAndStderrToConsole())
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
                //.WithWaitStrategy(Wait.ForUnixContainer()
                 //   .UntilHttpRequestIsSucceeded(r => r.ForPath("/health")))
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
                    ["ConnectionStrings:FitnessCenterDB"] = ConnectionString,
                    ["SECRET_TOKEN_KEY"] = "SuperSecretKey12345678901234567890123456789012"
                })
                .WithPortBinding(FrontendInternalPort, true)
                .WithNetwork(_network)
                .WithNetworkAliases("frontend")
                .WithWaitStrategy(Wait.ForUnixContainer()
                    .UntilPortIsAvailable(FrontendInternalPort)
                    //.UntilHttpRequestIsSucceeded(r => r.ForPath("/health"))
                )
                .Build();

            await _frontendContainer.StartAsync();
            _frontendExternalPort = _frontendContainer.GetMappedPublicPort(FrontendInternalPort);
            Console.WriteLine($"[E2E] Frontend container started on port {_frontendExternalPort}");

            // 5. Iniciar Nginx como reverse proxy
            _nginxContainer = new ContainerBuilder()
                .WithImage("nginx:alpine")
                .WithPortBinding(NginxInternalPort, true)
                .WithNetwork(_network)
                .WithNetworkAliases("nginx")
                .WithBindMount(NginxConfPath, "/etc/nginx/nginx.conf")
                .WithWaitStrategy(Wait.ForUnixContainer().UntilPortIsAvailable(80))
                .Build();

            await _nginxContainer.StartAsync();
            _nginxExternalPort = _nginxContainer.GetMappedPublicPort(NginxInternalPort);
            Console.WriteLine($"[E2E] Nginx container started on port {_nginxExternalPort}");

            _isInitialized = true;
        }
        finally
        {
            _initLock.Release();
        }
    }

    private static async Task RestoreDatabaseFromBackupAsync(string masterConnectionString, string sqlPassword)
    {
        var backupPath = "/backup/" + BackupFileName;
        var databaseName = "FitnessCenterDB";

        try
        {
            await using var masterConnection = DatabaseHelper.GetSqlConnection(masterConnectionString);
            await masterConnection.OpenAsync();

            var fileListSql = "RESTORE FILELISTONLY FROM DISK = @BackupPath";
            List<string> moveStatements = new();

            await using (var fileListCommand = masterConnection.CreateCommand())
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

            await using var command = masterConnection.CreateCommand();
            command.CommandText = sql;
            command.Parameters.AddWithValue("@BackupPath", backupPath);
            await command.ExecuteNonQueryAsync();

            Console.WriteLine("[E2E] Database restored successfully");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[E2E] ERROR restoring database: {ex.Message}");
            throw;
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
            disposeTasks.Add(_network.DisposeAsync().AsTask());

        await Task.WhenAll(disposeTasks);

        _isInitialized = false;
    }
}