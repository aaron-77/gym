using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using System;

namespace DataAccess.Repositories
{
    public class RefreshTokenRepository : IRefreshTokenRepository
    {
        private readonly FitnessCenterDbContext _context;

        public RefreshTokenRepository(FitnessCenterDbContext context)
        {
            _context = context;
        }

        public async Task AddRefreshTokenAsync(RefreshToken refreshToken)
        {
            try
            {
                await _context.RefreshTokens.AddAsync(refreshToken);
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                // Considerar loggear la excepción aquí
                throw new InvalidOperationException("Error al añadir RefreshToken a la base de datos.", ex);
            }
        }

        public async Task<RefreshToken?> GetRefreshTokenByTokenHashAsync(string tokenHash)
        {
            try
            {
                return await _context.RefreshTokens.SingleOrDefaultAsync(rt => rt.TokenHash == tokenHash);
            }
            catch (Exception ex)
            {
                // Considerar loggear la excepción aquí
                throw new InvalidOperationException("Error al obtener RefreshToken de la base de datos.", ex);
            }
        }

        public async Task UpdateRefreshTokenAsync(RefreshToken refreshToken)
        {
            try
            {
                _context.RefreshTokens.Update(refreshToken);
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                // Considerar loggear la excepción aquí
                throw new InvalidOperationException("Error al actualizar RefreshToken en la base de datos.", ex);
            }
        }
    }
} 