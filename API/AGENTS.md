# AGENTS.md - FitnessGym API Project Guidelines

## Project Overview

- **Framework:** .NET 8 with ASP.NET Core Web API
- **Architecture:** N-layer (API → BL → DataAccess → DTO)
- **Database:** SQL Server with Entity Framework Core
- **Authentication:** JWT Bearer with Identity
- **Real-time:** SignalR Hubs
- **Background Jobs:** Quartz scheduler
- **Logging:** Serilog

## Project Structure

```
API/
├── Controllers/          # API endpoints (Web API controllers)
├── Services/             # Business logic services (reusable across controllers/hubs)
├── Hubs/                 # SignalR hubs for real-time communication
├── BackGroundWork/       # Quartz background jobs
├── Infraestructure/      # Auth, configuration, utilities
└── Program.cs            # Entry point, DI configuration
```

## Build Commands

```bash
# Build entire solution
dotnet build

# Build API project only
dotnet build API/API.csproj

# Run all tests
dotnet test

# Run tests with coverage
dotnet test --collect:"XPlat Code Coverage"

# Run single test (filter by namespace, class, or method)
dotnet test --filter "FullyQualifiedName~Namespace.ClassName.MethodName"

# Example: Run specific test
dotnet test --filter "FullyQualifiedName~GymWebApp.Tests.UserServiceTests.Login_WithValidCredentials_ReturnsUser"
```

## Code Style

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Classes/Methods | PascalCase | `UsersController`, `GetUsuariosAsync` |
| Parameters | camelCase | `userCredentials`, `tokenHash` |
| Private fields | `_camelCase` | `_context`, `_userManager`, `_logger` |
| DTOs | `DTO` prefix | `DTOResponse<T>`, `DTOLoggedUser` |
| Interfaces | `I` prefix | `IAuthService` |
| Enums | PascalCase | `UserRole` |
| Controllers | `Controller` suffix | `UsersController`, `ClasesController` |
| Services | `Service` suffix | `AuthService`, `TokensService` |
| Hubs | `Hub` suffix | `ReservacionesHub` |

### Imports Order

1. System namespaces
2. Third-party (`Microsoft`, `Twilio`, `BCrypt`)
3. Project namespaces (`API.Services`, `BL.Utils`, `DataAccess.EntityFramework`, `DTO.Dtos`)

### Type Usage

- **ImplicitUsings** enabled - no explicit `using System;`
- **Nullable** reference types enabled - use `?` for optional
- Use `async/await` for I/O operations
- Return `Task<T>` for async methods

```csharp
public async Task<DTOResponse<DTOLoggedUser>> Login(UserCredentials credenciales) { }
public async Task<ApplicationUser?> GetUserByIdAsync(string userId) { }
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
        
        var usuarios = await _db.Users
            .Select(u => new ExistingUser { Id = u.Id, NombreCompleto = u.NombreCompleto })
            .ToListAsync();
            
        var respuesta = ResponseManager.BuildResponse(
            success: true,
            httpCode: 200,
            message: "Consulta exitosa",
            errors: null,
            payload: usuarios
        );
        return Ok(respuesta);
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Error in GetUsuarios");
        var respuesta = ResponseManager.BuildResponse<List<ExistingUser>>(
            success: false,
            httpCode: 500,
            message: "Error al obtener usuarios",
            errors: new List<ErrorModel> { new ErrorModel { message = ex.Message, propiedad = null } },
            payload: null
        );
        return StatusCode(500, respuesta);
    }
}
```

## Service Pattern

```csharp
public class AuthService
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly SignInManager<ApplicationUser> _signInManager;
    private readonly ILogger<AuthService> _logger;

    public AuthService(
        UserManager<ApplicationUser> userManager,
        SignInManager<ApplicationUser> signInManager,
        ILogger<AuthService> logger
    )
    {
        _userManager = userManager;
        _signInManager = signInManager;
        _logger = logger;
    }

    public async Task<DTOLoggedUser?> AuthenticateUser(string username, string password)
    {
        try { /* business logic */ }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error in AuthenticateUser username={Username}", username);
            return null;
        }
    }
}
```

## SignalR Hub Pattern

```csharp
public class ReservacionesHub : Hub
{
    private readonly ILogger<ReservacionesHub> _logger;

    public ReservacionesHub(ILogger<ReservacionesHub> logger)
    {
        _logger = logger;
    }

    public async Task JoinGroup(string groupName)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, groupName);
    }

    public override async Task OnConnectedAsync()
    {
        _logger.LogInformation("Client connected: {ConnectionId}", Context.ConnectionId);
        await base.OnConnectedAsync();
    }
}
```

## Response Pattern

All API responses use `DTOResponse<T>` with `ResponseManager.BuildResponse<T>()`:

```csharp
return ResponseManager.BuildResponse<bool>(
    success: true,
    httpCode: 200,
    message: "Operación exitosa",
    errors: null,
    payload: true
);
```

## Logging

- Use Serilog with structured logging: `_logger.LogInformation("Message {Param}", value)`
- Include relevant context in log messages
- Log method start and end for important operations
- Use log levels: `LogInformation`, `LogWarning`, `LogError`

```csharp
_logger.LogInformation("Start GetUsuarios rol={Rol} estado={Estado}", rol, estado);
_logger.LogError(ex, "Error in GetUsuarios");
```

## Error Handling

```csharp
try { /* business logic */ }
catch (ArgumentNullException ex)
{
    string logMessage = $"[ERROR] Método: MethodName | " +
        $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
        $"Causa: {ex.GetType().Name} - {ex.Message}";
    _logger.LogError(ex, logMessage);
    return BadRequest(ResponseManager.BuildResponse<T>(false, 400, "Datos inválidos", ...));
}
catch (Exception ex)
{
    _logger.LogError(ex, "Error in MethodName");
    return StatusCode(500, ResponseManager.BuildResponse<T>(false, 500, "Error interno", ...));
}
```

## Background Jobs (Quartz)

Jobs go in `BackGroundWork/` directory and implement `IJob`:

```csharp
public class ActualizarHorariosJob : IJob
{
    public async Task Execute(IJobExecutionContext context)
    {
        // Job logic
    }
}
```

## Authentication & Authorization

- Use `[Authorize]` attribute with roles: `[Authorize(Roles = "empleado,cliente")]`
- JWT Bearer authentication configured in Program.cs
- Use `UserManager<ApplicationUser>` for user operations
- Use `SignInManager<ApplicationUser>` for authentication

## Testing

```csharp
namespace GymWebApp.Tests;

public class AuthServiceTests
{
    [Fact]
    public async Task Login_WithValidCredentials_ReturnsUser()
    {
        var mockUserManager = new Mock<UserManager<ApplicationUser>>();
        var mockSignInManager = new Mock<SignInManager<ApplicationUser>>();
        
        var service = new AuthService(
            mockUserManager.Object,
            mockSignInManager.Object,
            Mock.Of<ILogger<AuthService>>()
        );
        
        // arrange, act, assert
    }
}
```

## Configuration

- `appsettings.json` for non-sensitive settings
- Environment-specific: `appsettings.Development.json`, `appsettings.Production.json`, `appsettings.Staging.json`
- JWT settings in `JwtSettings` class (configured in Program.cs)
- Environment variables for secrets (never commit)

## Cursor Rules (from .cursor/rules/)

- **Controllers/**: Contains API endpoint controllers
- **BackGroundWork/**: Background functionality, typically executed via Quartz
- **Hubs/**: SignalR hubs for real-time functionality
- **Services/**: Reusable business logic classes, accessible from controllers or hub methods
