using Microsoft.Extensions.Configuration;

namespace GymWebApp.Tests.E2E.Common;

/// <summary>
/// Provides test configuration from appsettings.Testing.json.
/// Singleton that loads configuration once on first access.
/// </summary>
public static class E2ETestSettings
{
    private static IConfiguration? _configuration;

    private static IConfiguration Configuration
    {
        get
        {
            if (_configuration == null)
            {
                var basePath = AppContext.BaseDirectory;
                _configuration = new ConfigurationBuilder()
                    .SetBasePath(basePath)
                    .AddJsonFile("appsettings.Testing.json", optional: false, reloadOnChange: false)
                    .Build();
            }
            return _configuration;
        }
    }

    public static string TestUserEmail => Configuration["TestUser:Email"] ?? throw new InvalidOperationException("TestUser:Email not configured");
    public static string TestUserPassword => Configuration["TestUser:Password"] ?? throw new InvalidOperationException("TestUser:Password not configured");
    public static string TestUserClienteEmail => Configuration["TestUserCliente:Email"] ?? throw new InvalidOperationException("TestUserCliente:Email not configured");
    public static string TestUserClientePassword => Configuration["TestUserCliente:Password"] ?? throw new InvalidOperationException("TestUserCliente:Password not configured");
}
