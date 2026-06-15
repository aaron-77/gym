using DataAccess.EntityFramework;
using System;
using System.Threading.Tasks;

namespace DataAccess.Repositories
{
    public interface IAccessTokenRepository
    {
        Task AddAccessTokenAsync(AccessToken accessToken);
        Task<AccessToken?> GetAccessTokenByTokenHashAsync(string tokenHash);
        Task UpdateAccessTokenAsync(AccessToken accessToken);
    }
} 