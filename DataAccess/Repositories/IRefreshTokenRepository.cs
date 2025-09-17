using DataAccess.EntityFramework;
using System;
using System.Threading.Tasks;

namespace DataAccess.Repositories
{
    public interface IRefreshTokenRepository
    {
        Task AddRefreshTokenAsync(RefreshToken refreshToken);
        Task<RefreshToken?> GetRefreshTokenByTokenHashAsync(string tokenHash);
        Task UpdateRefreshTokenAsync(RefreshToken refreshToken);
    }
} 