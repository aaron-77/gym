using DTO.Dtos;
using System.Security.Claims;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Cryptography;
using DataAccess.EntityFramework;
using System.Threading.Tasks;
using DataAccess.Identity;
using DataAccess.Repositories;
using Microsoft.AspNetCore.Http;
using System;

namespace BL.Utils;

public class JwtTokenGenerator
{
    private readonly JwtSettings _jwtSettings;
    private readonly IAccessTokenRepository _accessTokenRepository;
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public JwtTokenGenerator(IOptions<JwtSettings> jwtOptions, IAccessTokenRepository accessTokenRepository, IRefreshTokenRepository refreshTokenRepository, IHttpContextAccessor httpContextAccessor)
    {
        _jwtSettings = jwtOptions.Value;
        _accessTokenRepository = accessTokenRepository;
        _refreshTokenRepository = refreshTokenRepository;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<string> GenerateAccessToken(ApplicationUser user, IList<string> roles)
    {
        try
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
                audience: _jwtSettings.BackendAudiencie,
                claims: claims,
                expires: expires,
                signingCredentials: creds
            );

            var accessToken = new AccessToken
            {
                AccessTokenId = Guid.NewGuid(),
                UserId = user.Id,
                ClientId = "gymAppFrontend", // Asumiendo un cliente fijo para el frontend
                TokenHash = HashToken(new JwtSecurityTokenHandler().WriteToken(token)),
                IssuedAt = DateTime.UtcNow,
                ExpiresAt = expires,
                IpAddress = _httpContextAccessor.HttpContext?.Connection.RemoteIpAddress?.ToString(),
                UserAgent = _httpContextAccessor.HttpContext?.Request.Headers["User-Agent"].ToString()
            };

            await _accessTokenRepository.AddAccessTokenAsync(accessToken);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
        catch (Exception ex)
        {
            // Considerar loggear la excepción aquí
            throw new ApplicationException("Error al generar el Access Token.", ex);
        }
    }

    public string GenerateIdToken(ApplicationUser user,IList<string> roles)
    {
        try
        {
            var claims = new List<Claim>
            {
                new("sub", user.Id), // Subject
                new("name", user.UserName!), // Name
                new("email", user.Email!), // Email
                new("preferred_username", user.UserName!),
                new("given_name", user.NombreCompleto), // Asumiendo que NombreCompleto es el nombre de pila
                new("family_name", user.NumeroDeIdentificacion), // Asumiendo que NumeroDeIdentificacion es el apellido o un identificador familiar
            };

            foreach (var role in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.SecretKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var expires = DateTime.UtcNow.AddMinutes(_jwtSettings.ExpiryMinutes); // Mismo tiempo de expiración que el access token

            var token = new JwtSecurityToken(
                issuer: _jwtSettings.Issuer,
                audience: _jwtSettings.FrontAudiencie,
                claims: claims,
                expires: expires,
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
        catch (Exception ex)
        {
            // Considerar loggear la excepción aquí
            throw new ApplicationException("Error al generar el ID Token.", ex);
        }
    }

    public async Task<string> GenerateRefreshToken(string userId, string clientId)
    {
        try
        {
            var randomNumber = new byte[32];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(randomNumber);
                var token = Convert.ToBase64String(randomNumber);

                var ipAddress = _httpContextAccessor.HttpContext?.Connection.RemoteIpAddress?.ToString();
                var userAgent = _httpContextAccessor.HttpContext?.Request.Headers["User-Agent"].ToString();

                var refreshToken = new RefreshToken
                {
                    RefreshTokenId = Guid.NewGuid(),
                    UserId = userId,
                    ClientId = clientId,
                    TokenHash = HashToken(token),
                    IssuedAt = DateTime.UtcNow,
                    ExpiresAt = DateTime.UtcNow.AddDays(_jwtSettings.RefreshTokenExpiryDays),
                    IpAddress = ipAddress,
                    UserAgent = userAgent
                };

                await _refreshTokenRepository.AddRefreshTokenAsync(refreshToken);

                return token;
            }
        }
        catch (Exception ex)
        {
            // Considerar loggear la excepción aquí
            throw new ApplicationException("Error al generar el Refresh Token.", ex);
        }
    }

    public async Task<string?> ValidateRefreshToken(string refreshTokenString)
    {
        try
        {
            var tokenHash = HashToken(refreshTokenString);
            var refreshToken = await _refreshTokenRepository.GetRefreshTokenByTokenHashAsync(tokenHash);

            if (refreshToken == null || refreshToken.RevokedAt != null || refreshToken.ExpiresAt <= DateTime.UtcNow)
            {
                return null; // Refresh token inválido, expirado o revocado
            }
            return refreshToken.UserId;
        }
        catch (Exception ex)
        {
            // Considerar loggear la excepción aquí
            throw new ApplicationException("Error al validar el Refresh Token.", ex);
        }
    }

    public async Task RevokeRefreshToken(string refreshTokenString)
    {
        try
        {
            var tokenHash = HashToken(refreshTokenString);
            var refreshToken = await _refreshTokenRepository.GetRefreshTokenByTokenHashAsync(tokenHash);

            if (refreshToken != null && refreshToken.RevokedAt == null)
            {
                refreshToken.RevokedAt = DateTime.UtcNow;
                await _refreshTokenRepository.UpdateRefreshTokenAsync(refreshToken);
            }
        }
        catch (Exception ex)
        {
            // Considerar loggear la excepción aquí
            throw new ApplicationException("Error al revocar el Refresh Token.", ex);
        }
    }

    private string HashToken(string token)
    {
        try
        {
            using (var sha256 = SHA256.Create())
            {
                var bytes = Encoding.UTF8.GetBytes(token);
                var hash = sha256.ComputeHash(bytes);
                return Convert.ToBase64String(hash);
            }
        }
        catch (Exception ex)
        {
            // Considerar loggear la excepción aquí
            throw new ApplicationException("Error al hashear el token.", ex);
        }
    }

    public IDictionary<string, string> ValidateAccessToken(string token)
    {
        try
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
                ValidAudience = _jwtSettings.BackendAudiencie,
                ValidateLifetime = true,
                ClockSkew = TimeSpan.Zero
            };

            var principal = tokenHandler.ValidateToken(token, validationParameters, out var validatedToken);
            var claims = principal.Claims.ToDictionary(c => c.Type, c => c.Value);
            return claims.Count > 0 ? claims : null;
        }
        catch (Exception ex)
        {
            // Considerar loggear la excepción aquí
            return null;
        }
    }

    public IDictionary<string, string> ValidateIdToken(string token)
    {
        try
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
                ValidAudience = _jwtSettings.FrontAudiencie,
                ValidateLifetime = true,
                ClockSkew = TimeSpan.Zero
            };

            var principal = tokenHandler.ValidateToken(token, validationParameters, out var validatedToken);
            var claims = principal.Claims.ToDictionary(c => c.Type, c => c.Value);
            return claims.Count > 0 ? claims : null;
        }
        catch (Exception ex)
        {
            // Considerar loggear la excepción aquí
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
