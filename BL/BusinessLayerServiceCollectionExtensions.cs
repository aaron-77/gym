using BL.Utils;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Http;

namespace BL
{
    public static class BusinessLayerServiceCollectionExtensions
    {
        public static IServiceCollection AddBusinessLayer(this IServiceCollection services)
        {
            
            services.AddScoped<JwtTokenGenerator>();
            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            // Aquí se pueden añadir otros servicios del BL

            return services;
        }
    }
} 