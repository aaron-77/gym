# AGENTS.md - DataAccess Layer

## Project Overview

- **Framework:** .NET 8 with Entity Framework Core
- **Database:** SQL Server
- **Authentication:** ASP.NET Identity
- **Layer Role:** Data persistence, repositories, EF Core DbContext

## Project Structure

```
DataAccess/
├── EntityFramework/     # DbContext + Entities (50+ entities)
├── Repositories/         # IRepository interfaces + implementations
├── Identity/            # ApplicationUser (ASP.NET Identity)
├── Infraestructure/      # DB execution utilities, seed configs
├── Migrations/          # EF Core migrations
└── DataAccessServiceCollectionExtensions.cs  # DI registration
```

## Build & Test Commands

```bash
# Build solution
dotnet build
dotnet build DataAccess/DataAccess.csproj

# Run tests
dotnet test

# Run single test
dotnet test --filter "FullyQualifiedName~Namespace.ClassName.MethodName"

# EF Core migrations (from API project)
dotnet ef migrations add MigrationName -s API
dotnet ef database update -s API
```

## Code Style

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Entities | PascalCase | `RefreshToken`, `Clase`, `Usuario` |
| DbContext | PascalCase | `FitnessCenterDbContext` |
| Repository interfaces | `I` prefix | `IRefreshTokenRepository` |
| Repository implementations | No prefix | `RefreshTokenRepository` |
| DbSet properties | PascalCase | `RefreshTokens`, `Clases` |
| Columns/Keys | Database conventions | `RefreshTokenId`, `UserId` |

### Imports Order

1. System namespaces
2. Third-party (`Microsoft.EntityFrameworkCore`)
3. Project (`DataAccess.EntityFramework`, `DataAccess.Identity`, `DataAccess.Repositories`)

### Type Usage

- **ImplicitUsings** enabled
- **Nullable** reference types enabled - use `?` for optional navigation properties
- Use `async/await` for all DB operations; return `Task<T>`

## DbContext Pattern

```csharp
public partial class FitnessCenterDbContext : IdentityDbContext<ApplicationUser>
{
    public FitnessCenterDbContext(DbContextOptions<FitnessCenterDbContext> options)
        : base(options) { }

    public virtual DbSet<RefreshToken> RefreshTokens { get; set; }
    public virtual DbSet<Clase> Clases { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
    }
}
```

## Repository Pattern

### Interface

```csharp
public interface IRefreshTokenRepository
{
    Task AddRefreshTokenAsync(RefreshToken refreshToken);
    Task<RefreshToken?> GetRefreshTokenByTokenHashAsync(string tokenHash);
    Task UpdateRefreshTokenAsync(RefreshToken refreshToken);
}
```

### Implementation

```csharp
public class RefreshTokenRepository : IRefreshTokenRepository
{
    private readonly FitnessCenterDbContext _context;

    public RefreshTokenRepository(FitnessCenterDbContext context)
    {
        _context = context;
    }

    public async Task<RefreshToken?> GetRefreshTokenByTokenHashAsync(string tokenHash)
    {
        try
        {
            return await _context.RefreshTokens
                .SingleOrDefaultAsync(rt => rt.TokenHash == tokenHash);
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException("Error al obtener RefreshToken.", ex);
        }
    }

    public async Task AddRefreshTokenAsync(RefreshToken refreshToken)
    {
        await _context.RefreshTokens.AddAsync(refreshToken);
        await _context.SaveChangesAsync();
    }
}
```

## Entity Configuration

```csharp
public partial class RefreshToken
{
    public Guid RefreshTokenId { get; set; }
    public string UserId { get; set; } = null!;
    public string TokenHash { get; set; } = null!;
    public DateTime IssuedAt { get; set; }
    public DateTime ExpiresAt { get; set; }
    public DateTime? RevokedAt { get; set; }
    public virtual ApplicationUser User { get; set; } = null!;
}
```

## Dependency Injection

In `DataAccessServiceCollectionExtensions.cs`:

```csharp
public static IServiceCollection AddDataAccess(this IServiceCollection services)
{
    var DB_CONNECTION_STRING = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING");

    services.AddDbContext<FitnessCenterDbContext>(options =>
        options.UseSqlServer(DB_CONNECTION_STRING));
    
    services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();

    return services;
}
```

## Migrations

- Migrations stored in `DataAccess/Migrations/`
- Use `dotnet ef` commands from the API project (has reference to DataAccess)
- Snapshot file: `FitnessCenterDbContextModelSnapshot.cs`

## Configuration

- Connection string: Environment variable `DB_CONNECTION_STRING`
- SQL Server provider: `options.UseSqlServer()`
- Use `appsettings.json` for non-sensitive settings
- Never commit secrets to version control

## Specs (Specifications)

Ver [AGENTS.md principal](../AGENTS.md#specs-specifications) para reglas de specs.
Plantilla: `specs/spect-skeleton.md`
