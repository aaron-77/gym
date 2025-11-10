using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using System;

namespace DataAccess.Repositories
{
    public class AccessTokenRepository : IAccessTokenRepository
    {
        private readonly FitnessCenterDbContext _context;

        public AccessTokenRepository(FitnessCenterDbContext context)
        {
            _context = context;
        }

        public async Task AddAccessTokenAsync(AccessToken accessToken)
        {
            try
            {
                await _context.AccessTokens.AddAsync(accessToken);
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                // Considerar loggear la excepción aquí
                throw new InvalidOperationException("Error al añadir AccessToken a la base de datos.", ex);
            }
        }

        public async Task<AccessToken?> GetAccessTokenByTokenHashAsync(string tokenHash)
        {
            try
            {
                return await _context.AccessTokens.SingleOrDefaultAsync(at => at.TokenHash == tokenHash);
            }
            catch (Exception ex)
            {
                // Considerar loggear la excepción aquí
                throw new InvalidOperationException("Error al obtener AccessToken de la base de datos.", ex);
            }
        }

        public async Task UpdateAccessTokenAsync(AccessToken accessToken)
        {
            try
            {
                _context.AccessTokens.Update(accessToken);
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                // Considerar loggear la excepción aquí
                throw new InvalidOperationException("Error al actualizar AccessToken en la base de datos.", ex);
            }
        }
    }
} 