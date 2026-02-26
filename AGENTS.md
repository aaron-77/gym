# AGENTS.md - FitnessGym Project Guidelines

## Project Overview

- **Framework:** .NET 8 with ASP.NET Core
- **Architecture:** N-layer (API → BL → DataAccess → DTO)
- **Database:** SQL Server with Entity Framework Core
- **Testing:** xUnit with Moq
- **Authentication:** JWT Bearer with Identity

## Project Structure

```
FitnessGym/
├── API/              # ASP.NET Core Web API (entry point)
├── BL/               # Business Logic layer
├── DataAccess/       # EF Core DbContext, Repositories, Entities
├── DTO/              # Data Transfer Objects
├── GymFrontend/      # Frontend Blazor app
└── GymWebApp.Tests/  # Unit tests (xUnit)
```
## Test workflow

4. tdd-test-first: Create tests - USE for each functionality
5. git-workflow-manager: Commit RED phase
6. dotnet-test-implementer: Implement - USE after tests fail
7. git-workflow-manager: Commit GREEN phase

## Git Strategy (NO OpenCode mentions)

- Architecture: "feat: add [feature] architecture"
- Tests: "test: add [feature] tests (RED)"
- Implementation: "feat: implement [feature] (GREEN)"
- Security: "fix: security improvements"

## Build Commands

```bash
# Build entire solution
dotnet build

# Build specific project
dotnet build API/API.csproj

# Run all tests
dotnet test

# Run single test by method name
dotnet test --filter "FullyQualifiedName~Namespace.ClassName.MethodName"
# Example: dotnet test --filter "FullyQualifiedName~GymWebApp.Tests.UnitTest1.Test1"

# Run tests with coverage
dotnet test --collect:"XPlat Code Coverage"
```

## Code Style

### Naming Conventions

- **Classes/Methods/Enums:** PascalCase (`UsersManager`, `GetUsuariosAsync`)
- **Parameters/Private fields:** camelCase (`userCredentials`, `_context`)
- **DTOs:** `DTO` prefix (`DTOResponse<T>`, `DTOLoggedUser`)
- **Interfaces:** `I` prefix (`IRefreshTokenRepository`)

### Imports Order

1. System namespaces, 2. Third-party (`Microsoft`, `Twilio`, `BCrypt`), 3. Project namespaces (`DTO.Dtos`, `BL`, `DataAccess.EntityFramework`)

### Type Usage

- **ImplicitUsings** enabled - don't add explicit `using System;`
- **Nullable** reference types enabled - use `?` for optional
- Use `async/await` for I/O; return `Task<T>`

```csharp
public async Task<DTOResponse<DTOLoggedUser>> Login(UserCredentials credenciales) { }
public async Task<RefreshToken?> GetRefreshTokenByTokenHashAsync(string tokenHash) { }
```
### Best Practices
- use solid principles, clean code, and meaningful variable/method names

## Error Handling

```csharp
try { /* business logic */ }
catch (ArgumentNullException ex)
{
    string logMessage = $"[ERROR] Método: MethodName - ArgumentNullException | " +
        $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
        $"Causa: {ex.GetType().Name} - {ex.Message}";
    Console.WriteLine(logMessage);  // Serilog in API layer
    return null;
}
catch (Exception ex)
{
    string logMessage = $"[ERROR] Método: MethodName | " +
        $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
        $"Causa: {ex.GetType().Name} - {ex.Message}";
    Console.WriteLine(logMessage);
    return null;
}
```

## Response Pattern

```csharp
return ResponseManager.BuildResponse<bool>(true, 200, "Operación exitosa", null, payload);
```

## Repository Pattern

```csharp
public class RefreshTokenRepository : IRefreshTokenRepository
{
    private readonly FitnessCenterDbContext _context;
    public RefreshTokenRepository(FitnessCenterDbContext context) => _context = context;

    public async Task<RefreshToken?> GetRefreshTokenByTokenHashAsync(string tokenHash)
        => await _context.RefreshTokens.SingleOrDefaultAsync(rt => rt.TokenHash == tokenHash);
}
```

## Validation

Use DataAnnotations and custom `ValidationAttribute`:

```csharp
public class ValidarPasswordAttribute : ValidationAttribute
{
    protected override ValidationResult IsValid(object value, ValidationContext validationContext)
    {
        var modelo = (User)validationContext.ObjectInstance;
        if (modelo.Contrasena != modelo.ContrasenaConfirmacion)
            return new ValidationResult("Las contraseñas no coinciden");
        return ValidationResult.Success;
    }
}
```

## Controller Pattern

```csharp
[Authorize(Roles = "empleado")]
[HttpGet]
[Route("api/obtenerUsuarios")]
public async Task<IActionResult> GetUsuarios()
{
    try
    {
        _logger.LogInformation("Start GetUsuarios");
        var usuarios = await _userManager.Users.Select(u => new ExistingUser { }).ToListAsync();
        return Ok(respuesta);
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, logMessage);
        return StatusCode(500, respuesta);
    }
}
```

## Logging

- **BL Layer:** `Console.WriteLine()`
- **API Layer:** Serilog with `_logger.LogError(ex, message)`
- Include method name, line number, exception type, message

## Testing

```csharp
namespace GymWebApp.Tests;

public class UserManagerTests
{
    [Fact]
    public void Login_WithValidCredentials_ReturnsUser()
    {
        var mockHttpClient = new Mock<IHttpCustomClient>();
        // arrange, act, assert
    }
}
```

## Database

- SQL Server with EF Core; migrations in `DataAccess/Migrations/`
- Stored procedures in `bd/` directory
- Use `dotnet ef` commands

## Configuration

- Environment variables for secrets (never commit)
- `appsettings.json` for non-sensitive settings
- JWT settings in `JwtSettings` DTO class
