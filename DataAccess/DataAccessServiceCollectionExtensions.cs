using DataAccess.Repositories;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;
namespace DataAccess
{
    public static class DataAccessServiceCollectionExtensions
    {
        public static IServiceCollection AddDataAccess(this IServiceCollection services)
        {
            /*
            var connString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING");

            services.AddDbContext<DataAccess.EntityFramework.FitnessCenterDbContext>(options =>
            {
                var cs = connString ?? throw new InvalidOperationException(
                    "La variable de entorno 'DB_CONNECTION_STRING' no est� configurada. " +
                    "Config�rala antes de ejecutar comandos de EF Core o iniciar la API.");
                options.UseSqlServer(cs);
            });
            */
            services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();
            services.AddScoped<IAccessTokenRepository, AccessTokenRepository>();
            services.AddScoped<IClasesRepository, ClasesRepository>();
            // Aquí se pueden añadir otros repositorios de DataAccess

            return services;
        }
    }
} 