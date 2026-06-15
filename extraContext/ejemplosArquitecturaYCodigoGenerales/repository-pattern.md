## Repository Pattern

Implement repositories with interface and dependency injection.

```csharp
public class RefreshTokenRepository : IRefreshTokenRepository
{
    private readonly FitnessCenterDbContext _context;
    public RefreshTokenRepository(FitnessCenterDbContext context) => _context = context;

    public async Task<RefreshToken?> GetRefreshTokenByTokenHashAsync(string tokenHash)
        => await _context.RefreshTokens.SingleOrDefaultAsync(rt => rt.TokenHash == tokenHash);
}
```
