using DTO.Dtos;
using System.Security.Claims;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using System.IdentityModel.Tokens.Jwt;

namespace BL.Utils;

public class JwtTokenGenerator
{
    private readonly JwtSettings _jwtSettings;

    public JwtTokenGenerator(IOptions<JwtSettings> jwtOptions)
    {
        _jwtSettings = jwtOptions.Value;
    }

    public string GenerateToken(ApplicationUser user, IList<string> roles)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, user.Id),
            new(ClaimTypes.Name, user.UserName!)
        };

        foreach (var role in roles)
        {
            claims.Add(new Claim(ClaimTypes.Role, role));
        }

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.SecretKey));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        var expires = DateTime.UtcNow.AddMinutes(_jwtSettings.ExpiryMinutes);

        var token = new JwtSecurityToken(
            issuer: _jwtSettings.Issuer,
            audience: _jwtSettings.Audience,
            claims: claims,
            expires: expires,
            signingCredentials: creds);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    public IDictionary<string, string> ValidateToken(string token)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.UTF8.GetBytes(_jwtSettings.SecretKey);
        var validationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(key),
            ValidateIssuer = true,
            ValidIssuer = _jwtSettings.Issuer,
            ValidateAudience = true,
            ValidAudience = _jwtSettings.Audience,
            ValidateLifetime = true, // valida expiración
            ClockSkew = TimeSpan.Zero // sin tolerancia en expiración
        };

        try
        {
            var principal = tokenHandler.ValidateToken(token, validationParameters, out var validatedToken);
            // Extrae claims a diccionario solo si el token es válido
            var claims = principal.Claims.ToDictionary(c => c.Type, c => c.Value);
            if (claims.Count == 0)
            {
                claims = null;
            }

            return claims;
        }
        catch
        {
            // Retorna null si el token no es válido
            return null;
        }
    }

    public IList<string> GetRoles(IDictionary<string, string> claims)
    {
        return claims
            .Where(c => c.Key == ClaimTypes.Role || c.Key == "role")
            .Select(c => c.Value)
            .ToList();
    }

    public  string GetUserName(IDictionary<string, string> claims)
    {
        return claims.ContainsKey(ClaimTypes.Name) ? claims[ClaimTypes.Name] : null;
    }
}
