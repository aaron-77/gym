using Microsoft.AspNetCore.Cors.Infrastructure;
using Microsoft.Extensions.DependencyInjection;

namespace API.Infraestructure;

/// <summary>
/// Extensión de <see cref="IServiceCollection"/> que centraliza la configuración
/// de la política CORS del API.
/// </summary>
public static class CorsServiceCollectionExtensions
{
    private static readonly HashSet<string> OrigenesLocalesPermitidos =
        new(StringComparer.OrdinalIgnoreCase) { "localhost", "127.0.0.1" };

    /// <summary>
    /// Registra las políticas CORS del API. En Staging se permite dinámicamente
    /// cualquier origen local (localhost/127.0.0.1); fuera de Staging se usa la
    /// lista explícita de orígenes permitidos.
    /// </summary>
    /// <param name="services">Colección de servicios.</param>
    /// <param name="esStaging">Indica si el entorno actual es Staging.</param>
    /// <param name="allowedOrigins">Lista explícita de orígenes permitidos (no-Staging).</param>
    public static IServiceCollection AddCorsConfiguration(
        this IServiceCollection services,
        bool esStaging,
        string[] allowedOrigins)
    {
        services.AddCors(options =>
        {
            options.AddPolicy("originsPolicyOne", policy =>
            {
                policy.AllowAnyHeader()
                      .AllowAnyMethod()
                      .AllowCredentials();

                if (esStaging)
                {
                    policy.SetIsOriginAllowed(EsOrigenPermitido);
                }
                else
                {
                    policy.WithOrigins(allowedOrigins);
                }
            });

            options.AddPolicy("public", policy =>
            {
                policy.AllowAnyOrigin()
                      .AllowAnyMethod()
                      .AllowAnyHeader();
            });
        });

        return services;
    }

    /// <summary>
    /// Determina si un origen local (localhost o 127.0.0.1) es permitido,
    /// ignorando el puerto y aceptando los protocolos http/https.
    /// Se rechazan (fail-closed) los orígenes vacíos o malformados.
    /// </summary>
    /// <param name="origin">Header Origin de la request.</param>
    public static bool EsOrigenPermitido(string? origin)
    {
        if (string.IsNullOrWhiteSpace(origin) ||
            !Uri.TryCreate(origin, UriKind.Absolute, out var uri))
        {
            return false;
        }

        if (uri.Scheme != Uri.UriSchemeHttp && uri.Scheme != Uri.UriSchemeHttps)
        {
            return false;
        }

        return OrigenesLocalesPermitidos.Contains(uri.Host);
    }
}