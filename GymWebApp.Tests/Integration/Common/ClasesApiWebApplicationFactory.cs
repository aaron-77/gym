using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using GymWebApp.Tests.Integration.Common;
using FitnessCenterDbContext = DataAccess.EntityFramework.FitnessCenterDbContext;

namespace GymWebApp.Tests.Integration;

public class ClasesApiWebApplicationFactory<TProgram> : WebApplicationFactory<TProgram> where TProgram : class
{
    private readonly string _connectionString;

    public ClasesApiWebApplicationFactory()
    {
        ConfigHelper.RegisterConfig("appsettings.Testing.json");
        _connectionString = TestContainerHelper.ConnectionString;
        
        // Solo configuramos estas variables para el entorno de testing
        // La API usará ConnectionStrings:DefaultConnection que se configura en ConfigureWebHost
        Environment.SetEnvironmentVariable("SECRET_TOKEN_KEY", "__development_secret_key_replace_for_production__");
    }

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseSetting("ConnectionStrings:DefaultConnection", _connectionString);

        builder.ConfigureAppConfiguration((context, config) =>
        {
            config.AddJsonFile("appsettings.Testing.json", optional: false, reloadOnChange: true);
        });

        builder.ConfigureServices(services =>
        {
            var descriptor = services.SingleOrDefault(
                d => d.ServiceType == typeof(DbContextOptions<FitnessCenterDbContext>));

            if (descriptor != null)
            {
                services.Remove(descriptor);
            }

            services.AddDbContext<FitnessCenterDbContext>(options =>
                options.UseSqlServer(_connectionString));
        });

        builder.UseEnvironment("Testing");
    }
}
