using DataAccess.Repositories;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;
namespace DataAccess
{
    public static class DataAccessServiceCollectionExtensions
    {
        public static IServiceCollection AddDataAccess(this IServiceCollection services)
        {
            var DB_CONNECTION_STRING = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING");

            services.AddDbContext<DataAccess.EntityFramework.FitnessCenterDbContext>(options =>
            {
                options.UseSqlServer(DB_CONNECTION_STRING);
            });
            
            services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();
            services.AddScoped<IAccessTokenRepository, AccessTokenRepository>();
            services.AddScoped<IClasesRepository, ClasesRepository>();
            // Aquí se pueden añadir otros repositorios de DataAccess

            return services;
        }
    }
} 