using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Common;

public class GymFrontendWebApplicationFactory<TProgram> : WebApplicationFactory<TProgram> where TProgram : class
{
    private readonly string _connectionString;

    public GymFrontendWebApplicationFactory()
    {
        ConfigHelper.RegisterConfig("appsettings.Testing.json");
        _connectionString = TestContainerHelper.ConnectionString;
        
        Environment.SetEnvironmentVariable("DB_CONNECTION_STRING", _connectionString);
        Environment.SetEnvironmentVariable("SECRET_TOKEN_KEY", "__development_secret_key_replace_for_production__");
    }

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseSetting("ConnectionStrings:DefaultConnection", _connectionString);

        builder.ConfigureAppConfiguration((context, config) =>
        {
            config.AddJsonFile("appsettings.Testing.json", optional: false, reloadOnChange: true);
        });

        builder.UseEnvironment("Testing");
    }
}