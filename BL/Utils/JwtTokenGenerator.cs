using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DataAccess.Repositories;
using DTO.Dtos;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace BL.Utils;

public class JwtTokenGenerator
{
    private readonly JwtSettings _jwtSettings;
    private readonly ClaimsSettings _claimsSettings;
    private readonly IAccessTokenRepository _accessTokenRepository;
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public JwtTokenGenerator(
        IOptions<JwtSettings> jwtOptions,
        IOptions<ClaimsSettings> claimsOptions,
        IAccessTokenRepository accessTokenRepository,
        IRefreshTokenRepository refreshTokenRepository,
        IHttpContextAccessor httpContextAccessor
    )
    {
        _jwtSettings = jwtOptions.Value;
        _claimsSettings = claimsOptions.Value;
        _accessTokenRepository = accessTokenRepository;
        _refreshTokenRepository = refreshTokenRepository;
        _httpContextAccessor = httpContextAccessor;
    }

    /// <summary>
    /// Crea un JwtSecurityToken con la configuración especificada según el tipo de token y esquema SSL
    /// </summary>
    /// <param name="tokenType">Tipo de token a generar (FrontendToken, BackendToken, RefreshToken)</param>
    /// <param name="ssl">Si es true, usa las audiencias SSL; si es false, usa las audiencias estándar</param>
    /// <param name="userValues">Diccionario con los valores del usuario (userId, userName, email, nombreCompleto, curp)</param>
    /// <param name="roles">Lista de roles del usuario</param>
    /// <returns>JwtSecurityToken configurado</returns>
    public JwtSecurityToken CreateTokenWithConfig(
        TokenType tokenType,
        bool ssl,
        Dictionary<string, string> userValues,
        IList<string> roles)
    {
        try
        {
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Environment.GetEnvironmentVariable("SECRET_TOKEN_KEY")));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            
            // Obtener expiryMinutes desde la configuración
            int expiryMinutes = _jwtSettings.ExpiryMinutes;
            var expires = DateTime.UtcNow.AddMinutes(expiryMinutes);

            string issuer = _jwtSettings.Issuer;
            string audience = GetAudienceForTokenType(tokenType, ssl);

            // Construir los claims según el tipo de token
            var claims = BuildClaimsForTokenType(tokenType, userValues, roles);

            var token = new JwtSecurityToken(
                issuer: issuer,
                audience: audience,
                claims: claims,
                expires: expires,
                signingCredentials: creds
            );

            return token;
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: CreateTokenWithConfig | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | TokenType: {tokenType} | Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            throw;
        }
    }

    /// <summary>
    /// Construye los claims para el tipo de token especificado usando la configuración
    /// </summary>
    private List<Claim> BuildClaimsForTokenType(
        TokenType tokenType,
        Dictionary<string, string> userValues,
        IList<string> roles)
    {
        try
        {
            var claims = new List<Claim>();

            switch (tokenType)
            {
                case TokenType.BackendToken:
                    // Agregar claims desde la configuración de BackendTokenClaims
                    claims.Add(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
                    claims.Add(new Claim(ClaimTypes.NameIdentifier, userValues.GetValueOrDefault("userId") ?? ""));
                    claims.Add(new Claim(ClaimTypes.Name, userValues.GetValueOrDefault("userName") ?? ""));
                    break;

                case TokenType.FrontendToken:
                    // Agregar claims desde la configuración de FrontendTokenClaims
                    claims.Add(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
                    claims.Add(new Claim("sub", userValues.GetValueOrDefault("userId") ?? ""));
                    claims.Add(new Claim("name", userValues.GetValueOrDefault("userName") ?? ""));
                    claims.Add(new Claim("email", userValues.GetValueOrDefault("email") ?? ""));
                    claims.Add(new Claim("preferred_username", userValues.GetValueOrDefault("userName") ?? ""));
                    claims.Add(new Claim("given_name", userValues.GetValueOrDefault("nombreCompleto") ?? ""));
                    claims.Add(new Claim("family_name", userValues.GetValueOrDefault("curp") ?? ""));
                    break;

                case TokenType.RefreshToken:
                    // Agregar claims mínimos para RefreshToken
                    claims.Add(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
                    claims.Add(new Claim("sub", userValues.GetValueOrDefault("userId") ?? ""));
                    claims.Add(new Claim("name", userValues.GetValueOrDefault("userName") ?? ""));
                    break;
            }

            // Agregar roles a todos los tipos de token
            foreach (var role in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }

            return claims;
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: BuildClaimsForTokenType | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | TokenType: {tokenType} | Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            throw;
        }
    }

    /// <summary>
    /// Obtiene la audiencia correcta según el tipo de token y el esquema SSL
    /// </summary>
    private string GetAudienceForTokenType(TokenType tokenType, bool ssl)
    {
        try
        {
            return tokenType switch
            {
                TokenType.BackendToken => ssl ? _jwtSettings.BackendAudienceSsl : _jwtSettings.BackendAudiencie,
                TokenType.FrontendToken => ssl ? _jwtSettings.FrontendAudienceSsl : _jwtSettings.FrontAudiencie,
                TokenType.RefreshToken => ssl ? _jwtSettings.BackendAudienceSsl : _jwtSettings.BackendAudiencie,
                _ => throw new ArgumentException("Tipo de token no válido", nameof(tokenType))
            };
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: GetAudienceForTokenType | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | TokenType: {tokenType} | Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            throw;
        }
    }

    public async Task<string> GenerateAccessToken(ApplicationUser user, IList<string> roles)
    {
        try
        {
            var userValues = new Dictionary<string, string>
            {
                { "userId", user.Id },
                { "userName", user.UserName! }
            };
            bool useSsl = false;
            var token = CreateTokenWithConfig(TokenType.BackendToken, useSsl, userValues, roles);

            var accessToken = new AccessToken
            {
                AccessTokenId = Guid.NewGuid(),
                UserId = user.Id,
                ClientId = "gymAppFrontend",
                TokenHash = HashToken(new JwtSecurityTokenHandler().WriteToken(token)),
                IssuedAt = DateTime.UtcNow,
                ExpiresAt = token.ValidTo,
                IpAddress =
                    _httpContextAccessor.HttpContext?.Connection.RemoteIpAddress?.ToString(),
                UserAgent = _httpContextAccessor
                    .HttpContext?.Request.Headers["User-Agent"]
                    .ToString(),
            };

            await _accessTokenRepository.AddAccessTokenAsync(accessToken);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: GenerateAccessToken | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"UserId: {user?.Id} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
            throw new ApplicationException("Error al generar el Access Token.", ex);
        }
    }

    public string GenerateIdToken(ApplicationUser user, IList<string> roles)
    {
        try
        {
            var userValues = new Dictionary<string, string>
            {
                { "userId", user.Id },
                { "userName", user.UserName! },
                { "email", user.Email! },
                { "nombreCompleto", user.NombreCompleto },
                { "curp", user.Curp }
            };
            bool useSsl = false;
            var token = CreateTokenWithConfig(TokenType.FrontendToken, useSsl, userValues, roles);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: GenerateIdToken | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"UserId: {user?.Id} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
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

                var ipAddress =
                    _httpContextAccessor.HttpContext?.Connection.RemoteIpAddress?.ToString();
                var userAgent = _httpContextAccessor
                    .HttpContext?.Request.Headers["User-Agent"]
                    .ToString();

                var refreshToken = new RefreshToken
                {
                    RefreshTokenId = Guid.NewGuid(),
                    UserId = userId,
                    ClientId = clientId,
                    TokenHash = HashToken(token),
                    IssuedAt = DateTime.UtcNow,
                    ExpiresAt = DateTime.UtcNow.AddDays(_jwtSettings.RefreshTokenExpiryDays),
                    IpAddress = ipAddress,
                    UserAgent = userAgent,
                };

                await _refreshTokenRepository.AddRefreshTokenAsync(refreshToken);

                return token;
            }
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: GenerateRefreshToken | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"UserId: {userId}, ClientId: {clientId} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
            throw new ApplicationException("Error al generar el Refresh Token.", ex);
        }
    }

    public async Task<string?> ValidateRefreshToken(string refreshTokenString)
    {
        try
        {
            var tokenHash = HashToken(refreshTokenString);
            var refreshToken = await _refreshTokenRepository.GetRefreshTokenByTokenHashAsync(
                tokenHash
            );

            if (
                refreshToken == null
                || refreshToken.RevokedAt != null
                || refreshToken.ExpiresAt <= DateTime.UtcNow
            )
            {
                return null;
            }
            return refreshToken.UserId;
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: ValidateRefreshToken | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
            throw new ApplicationException("Error al validar el Refresh Token.", ex);
        }

    }

    public async Task RevokeRefreshToken(string refreshTokenString)
    {
        try
        {
            var tokenHash = HashToken(refreshTokenString);
            var refreshToken = await _refreshTokenRepository.GetRefreshTokenByTokenHashAsync(
                tokenHash
            );

            if (refreshToken != null && refreshToken.RevokedAt == null)
            {
                refreshToken.RevokedAt = DateTime.UtcNow;
                await _refreshTokenRepository.UpdateRefreshTokenAsync(refreshToken);
            }
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: RevokeRefreshToken | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
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
            string logMessage = $"[ERROR] Método: HashToken | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
            throw new ApplicationException("Error al hashear el token.", ex);
        }
    }

    public IDictionary<string, string> ValidateAccessToken(string token)
    {
        try
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.UTF8.GetBytes(Environment.GetEnvironmentVariable("SECRET_TOKEN_KEY"));

            // Determinar si la petición es SSL
            string audience = _jwtSettings.BackendAudiencie;
            
            var validationParameters = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(key),
                ValidateIssuer = true,
                ValidIssuer = _jwtSettings.Issuer,
                ValidateAudience = true,
                ValidAudience = audience, // Usar una sola audiencia en lugar de un arreglo
                ValidateLifetime = true,
                ClockSkew = TimeSpan.Zero,
            };

            var principal = tokenHandler.ValidateToken(
                token,
                validationParameters,
                out var validatedToken
            );
            var claims = principal.Claims.ToDictionary(c => c.Type, c => c.Value);
            return claims.Count > 0 ? claims : null;
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: ValidateAccessToken | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
            return null;
        }
    }

    public IDictionary<string, string> ValidateIdToken(string token)
    {
        try
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.UTF8.GetBytes(Environment.GetEnvironmentVariable("SECRET_TOKEN_KEY"));

            // Determinar si la petición es SSL
            string audience = _jwtSettings.FrontAudiencie;
            
            var validationParameters = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(key),
                ValidateIssuer = true,
                ValidIssuer = _jwtSettings.Issuer,
                ValidateAudience = true,
                ValidAudience = audience, // Usar una sola audiencia en lugar de un arreglo
                ValidateLifetime = true,
                ClockSkew = TimeSpan.Zero,
            };

            var principal = tokenHandler.ValidateToken(
                token,
                validationParameters,
                out var validatedToken
            );
            var claims = principal
                .Claims.GroupBy(c => c.Type)
                .ToDictionary(
                    g => g.Key,
                    g =>
                        g.Key == "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"
                            ? string.Join(",", g.Select(c => c.Value))
                            : g.First().Value
                );
            return claims.Count > 0 ? claims : null;
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: ValidateIdToken | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
            return null;
        }
    }

    public IList<string> GetRoles(IDictionary<string, string> claims)
    {
        try
        {
            if (
                !claims.TryGetValue(ClaimTypes.Role, out var rolesValue)
                && !claims.TryGetValue("role", out rolesValue)
            )
            {
                return new List<string>();
            }

            return rolesValue
                .Split(',', StringSplitOptions.RemoveEmptyEntries)
                .Select(r => r.Trim())
                .ToList();
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: GetRoles | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            return new List<string>();
        }
    }

    public string GetUserName(IDictionary<string, string> claims)
    {
        try
        {
            return claims.ContainsKey(ClaimTypes.Name) ? claims[ClaimTypes.Name] : null;
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: GetUserName | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            return null;
        }
    }
    
    
    public static string? GetClaimValue(string token, string claimType)
    {
        try
        {
            var handler = new JwtSecurityTokenHandler();

            if (!handler.CanReadToken(token))
                throw new ArgumentException("El token proporcionado no tiene un formato JWT válido.");

            var jwtToken = handler.ReadJwtToken(token);

            var claim = jwtToken.Claims.FirstOrDefault(c => c.Type == claimType);

            return claim?.Value;
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: GetClaimValue | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"ClaimType: {claimType} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
            throw new ApplicationException($"Error al obtener el claim '{claimType}' del token.", ex);
        }
    }
}
