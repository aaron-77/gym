using DataAccess.EntityFramework;
using DataAccess.Identity;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using DataAccess.Repositories;
using System;

namespace API.Services
{
    public class TokensService
    {
        private readonly IAccessTokenRepository _accessTokenRepository;
        private readonly IRefreshTokenRepository _refreshTokenRepository;

        public TokensService(IAccessTokenRepository accessTokenRepository, IRefreshTokenRepository refreshTokenRepository)
        {
            _accessTokenRepository = accessTokenRepository;
            _refreshTokenRepository = refreshTokenRepository;
        }

        public async Task RegisterAccessTokenAsync(
            string accessTokenString, 
        string userId,
         string clientId,
          DateTime expiresAt,
           string? ipAddress,
            string? userAgent)
        {
            try
            {
                var accessToken = new AccessToken
                {
                    AccessTokenId = Guid.NewGuid(),
                    UserId = userId,
                    ClientId = clientId,
                    TokenHash = HashToken(accessTokenString),
                    IssuedAt = DateTime.UtcNow,
                    ExpiresAt = expiresAt,
                    IpAddress = ipAddress,
                    UserAgent = userAgent
                };
                await _accessTokenRepository.AddAccessTokenAsync(accessToken);
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Error al registrar el Access Token.", ex);
            }
        }

        public async Task RegisterIdTokenAsync(string idTokenString, string userId, string clientId, DateTime expiresAt, string? ipAddress, string? userAgent)
        {
            try
            {
                var idToken = new AccessToken 
                {
                    AccessTokenId = Guid.NewGuid(),
                    UserId = userId,
                    ClientId = clientId,
                    TokenHash = HashToken(idTokenString),
                    IssuedAt = DateTime.UtcNow,
                    ExpiresAt = expiresAt,
                    IpAddress = ipAddress,
                    UserAgent = userAgent
                };
                await _accessTokenRepository.AddAccessTokenAsync(idToken);
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Error al registrar el ID Token.", ex);
            }
        }

        public async Task RegisterRefreshTokenAsync(string refreshTokenString, string userId, string clientId, DateTime expiresAt, string? ipAddress, string? userAgent)
        {
            try
            {
                var refreshToken = new RefreshToken
                {
                    RefreshTokenId = Guid.NewGuid(),
                    UserId = userId,
                    ClientId = clientId,
                    TokenHash = HashToken(refreshTokenString),
                    IssuedAt = DateTime.UtcNow,
                    ExpiresAt = expiresAt,
                    IpAddress = ipAddress,
                    UserAgent = userAgent
                };
                await _refreshTokenRepository.AddRefreshTokenAsync(refreshToken);
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Error al registrar el Refresh Token.", ex);
            }
        }

        public async Task<string?> ValidateRefreshTokenAsync(string refreshTokenString)
        {
            try
            {
                var tokenHash = HashToken(refreshTokenString);
                var refreshToken = await _refreshTokenRepository.GetRefreshTokenByTokenHashAsync(tokenHash);

                if (refreshToken == null || refreshToken.RevokedAt != null || refreshToken.ExpiresAt <= DateTime.UtcNow)
                {
                    return null;
                }
                return refreshToken.UserId;
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Error al validar el Refresh Token.", ex);
            }
        }

        public async Task RevokeRefreshTokenAsync(string refreshTokenString)
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
                throw new ApplicationException("Error al hashear el token.", ex);
            }
        }
    }
} 