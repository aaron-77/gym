using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Helpers;

/// <summary>
/// Helper para generar tokens JWT en tests de integración.
/// Lee la configuración desde appsettings.Testing.json y genera tokens
/// firmados con la misma clave que usa la API.
/// </summary>
public static class JwtTestHelper
{
    /// <summary>
    /// Genera un JWT firmado con claims arbitrarios.
    /// Usa la misma SecretKey, Issuer y Audience que la API valida.
    /// </summary>
    /// <param name="userId">Valor para ClaimTypes.NameIdentifier (ej: Guid.NewGuid().ToString())</param>
    /// <param name="role">Rol del usuario (ej: "empleado", "cliente")</param>
    /// <param name="email">Email del usuario (para ClaimTypes.Name)</param>
    /// <param name="expiryMinutes">Minutos de expiración (default: 60)</param>
    public static string GenerarJwtPersonalizado(
        string userId,
        string role,
        string email,
        int expiryMinutes = 60)
    {
        // La API usa SECRET_TOKEN_KEY del environment (seteado por CitasApiWebApplicationFactory)
        // Si no está disponible, fallback a appsettings.Testing.json
        var secretKey = Environment.GetEnvironmentVariable("SECRET_TOKEN_KEY")
            ?? ConfigHelper.GetSection("JwtSettings")["SecretKey"]
            ?? throw new InvalidOperationException(
                "No se encontró SECRET_TOKEN_KEY ni JwtSettings:SecretKey en configuración");

        var issuer = ConfigHelper.GetSection("JwtSettings")["Issuer"]
            ?? throw new InvalidOperationException("JwtSettings:Issuer no encontrado");

        var audience = ConfigHelper.GetSection("JwtSettings")["BackendAudiencie"]
            ?? throw new InvalidOperationException("JwtSettings:BackendAudiencie no encontrado");

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, userId),
            new Claim(ClaimTypes.Role, role),
            new Claim(ClaimTypes.Name, email)
        };

        var token = new JwtSecurityToken(
            issuer: issuer,
            audience: audience,
            claims: claims,
            expires: DateTime.Now.AddMinutes(expiryMinutes),
            signingCredentials: credentials);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
