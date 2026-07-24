using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

using DataAccess.Repositories;

namespace DataAccess
{
    public static class DataAccessServiceCollectionExtensions
    {
        public static IServiceCollection AddDataAccess(this IServiceCollection services)
        {
            services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();
            services.AddScoped<IAccessTokenRepository, AccessTokenRepository>();
            services.AddScoped<IClasesRepository, ClasesRepository>();
            services.AddScoped<IInscripcionRepository, InscripcionRepository>();
            services.AddScoped<Infraestructure.IDataAccessExecutor, Infraestructure.DataAccessExecutor>();

            return services;
        }
    }
} 