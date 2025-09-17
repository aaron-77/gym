using DataAccess.Repositories;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;
namespace DataAccess
{
    public static class DataAccessServiceCollectionExtensions
    {
        public static IServiceCollection AddDataAccess(this IServiceCollection services)
        {
            
            services.AddDbContext<DataAccess.EntityFramework.FitnessCenterDbContext>(options =>
            {
                options.UseSqlServer("Server=localhost ;Authentication=SqlPassword;Integrated Security=False ;User Id=aaronlogin;Password=Terrabreak13;Database=FitnessCenterDB;TrustServerCertificate=True;Trusted_Connection=False");
            });
            
            services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();
            services.AddScoped<IAccessTokenRepository, AccessTokenRepository>();
            // Aquí se pueden añadir otros repositorios de DataAccess

            return services;
        }
    }
} 