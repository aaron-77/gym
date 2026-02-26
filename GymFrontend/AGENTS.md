# AGENTS.md - GymFrontend Project Guidelines

## Project Overview

- **Framework:** .NET 8 with ASP.NET Core MVC
- **Architecture:** MVC pattern (Controllers → BL → DataAccess → DTO)
- **Database:** SQL Server with Entity Framework Core
- **Authentication:** JWT Bearer with Identity
- **Logging:** Serilog

## Project Structure

```
GymFrontend/
├── Controllers/      # MVC Controllers (return Views)
├── Services/         # Frontend-specific services (CookieService, etc.)
├── Models/           # ViewModels specific to frontend
├── Views/            # Razor Views (.cshtml)
├── TagHelpers/      # Custom Tag Helpers
├── wwwroot/          # Static assets (CSS, JS, images)
└── Program.cs        # Entry point, DI configuration
```

## Build Commands

```bash
# Build entire solution
dotnet build

# Build GymFrontend project only
dotnet build GymFrontend/GymFrontend.csproj

# Run all tests
dotnet test

# Run tests with coverage
dotnet test --collect:"XPlat Code Coverage"

# Run single test (filter by namespace, class, or method)
dotnet test --filter "FullyQualifiedName~Namespace.ClassName.MethodName"

# Example: Run specific test
dotnet test --filter "FullyQualifiedName~GymWebApp.Tests.UnitTest1.Test1"
```

## Code Style

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Classes/Methods | PascalCase | `UsersController`, `ExecuteSignIn` |
| Parameters | camelCase | `userCredentials`, `credenciales` |
| Private fields | camelCase (no prefix) or `_camelCase` | `manager`, `_logger`, `config` |
| DTOs | `DTO` prefix | `DTOResponse<T>`, `DTOLoggedUser` |
| Controllers | `Controller` suffix | `UsersController`, `HomeController` |
| Services | `Service` suffix | `CookieService` |
| Views | PascalCase matching controller | `Login.cshtml`, `Index.cshtml` |

### Imports Order

1. System namespaces
2. Third-party (`Microsoft`, `Newtonsoft`)
3. Project namespaces (`BL`, `BL.Utils`, `DataAccess.EntityFramework`, `DTO.Dtos`)

### Type Usage

- **ImplicitUsings** enabled - no explicit `using System;`
- **Nullable** reference types enabled - use `?` for optional
- Use `async/await` for I/O operations
- Return `Task<IActionResult>` for async controller methods

```csharp
public async Task<IActionResult> ExecuteSignIn([FromForm] UserCredentials credenciales) { }
public async Task<DTOResponse<DTOLoggedUser>> LoginAsync(string username, string password) { }
```

## Controller Pattern

```csharp
public class UsersController : Controller
{
    private readonly IConfiguration _config;
    private readonly UsersManager _manager;
    private readonly ILogger<UsersController> _logger;

    public UsersController(
        IConfiguration config,
        UsersManager manager,
        ILogger<UsersController> logger
    )
    {
        _config = config;
        _manager = manager;
        _logger = logger;
    }

    [HttpGet]
    [Route("signIn")]
    public IActionResult Index()
    {
        try
        {
            _logger.LogInformation("Start UsersController.Index (GET signIn)");
            return View("Login", new UserCredentials());
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: Index | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message}";
            Console.WriteLine(logMessage);
            _logger.LogError(ex, "Error Index");
            return View("Login", new UserCredentials());
        }
    }

    [HttpPost]
    [Route("signIn")]
    public async Task<IActionResult> ExecuteSignIn([FromForm] UserCredentials credenciales)
    {
        try
        {
            if (!ModelState.IsValid)
                return View("Login", credenciales);

            var respuesta = await _manager.login(credenciales);
            if (respuesta?.success == false)
            {
                ViewBag.message = "Usuario y/o contraseña incorrectos";
                return View("Login");
            }

            // Use cookie service to set tokens
            _cookieService.AgregarCookie(Response, "AuthToken", respuesta.payload.IdToken);
            return RedirectToAction("Index", "Home");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error in ExecuteSignIn");
            return View("Login", credenciales);
        }
    }
}
```

## Service Pattern

```csharp
public class CookieService
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public CookieService(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public void AgregarCookie(HttpResponse response, string key, string value, CookieOptions? options = null)
    {
        try
        {
            if (response == null)
                throw new ArgumentNullException(nameof(response));

            var cookieOptions = options ?? new CookieOptions
            {
                HttpOnly = true,
                Secure = false,
                SameSite = SameSiteMode.Strict,
                Path = "/"
            };

            response.Cookies.Append(key, value ?? string.Empty, cookieOptions);
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: AgregarCookie | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message}";
            Console.WriteLine(logMessage);
            throw;
        }
    }
}
```

## Logging

- **Controller/Service Layer:** Serilog with `_logger.LogError(ex, message)` or `Console.WriteLine()` for critical errors
- Include method name, line number, exception type, message
- Use structured logging: `_logger.LogInformation("Message {Param}", value)`

```csharp
_logger.LogInformation("Start UsersController.Index (GET signIn)");
_logger.LogError(ex, "Error in ExecuteSignIn");
```

## Error Handling

```csharp
try { /* business logic */ }
catch (ArgumentNullException ex)
{
    string logMessage = $"[ERROR] Método: MethodName - ArgumentNullException | " +
        $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
        $"Causa: {ex.GetType().Name} - {ex.Message}";
    Console.WriteLine(logMessage);
    _logger.LogError(ex, logMessage);
    throw;
}
catch (Exception ex)
{
    string logMessage = $"[ERROR] Método: MethodName | " +
        $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
        $"Causa: {ex.GetType().Name} - {ex.Message}";
    Console.WriteLine(logMessage);
    _logger.LogError(ex, logMessage);
    throw;
}
```

## Response Pattern (DTO)

Frontend uses DTOs from the DTO project:

```csharp
DTOResponse<DTOLoggedUser> respuesta = await _manager.login(credenciales);
if (respuesta?.success == false)
{
    ViewBag.message = "Error message";
    return View("ErrorView");
}

ViewBag.data = respuesta.payload;
return View("SuccessView");
```

## View Pattern

Razor Views return with models:

```html
@model UserCredentials

@{
    ViewData["Title"] = "Login";
}

<form asp-action="ExecuteSignIn" asp-controller="Users" method="post">
    <input asp-for="correo" class="form-control" />
    <input asp-for="contrasena" class="form-control" />
    <button type="submit">Login</button>
</form>

@if (!string.IsNullOrEmpty(ViewBag.message))
{
    <div class="alert alert-danger">@ViewBag.message</div>
}
```

## Authentication

- JWT tokens stored in cookies via `CookieService`
- Use `[Authorize]` attribute for protected routes
- Get roles from claims: `_jwtTokenGenerator.GetRoles(claims)`
- Redirect based on role: `if (roles.Contains("empleado")) return Redirect(empleadoPage);`

## Testing

- Test files go in `GymWebApp.Tests/`
- Use xUnit with `[Fact]` attribute
- Use Moq for mocking dependencies

```csharp
namespace GymWebApp.Tests;

public class UsersControllerTests
{
    [Fact]
    public async Task ExecuteSignIn_WithValidCredentials_RedirectsToHome()
    {
        var mockManager = new Mock<UsersManager>();
        var mockLogger = new Mock<ILogger<UsersController>>();
        
        var controller = new UsersController(
            Mock.Of<IConfiguration>(),
            mockManager.Object,
            mockLogger.Object
        );
        
        // arrange, act, assert
    }
}
```

## Configuration

- `appsettings.json` for non-sensitive settings
- Environment-specific: `appsettings.Development.json`, `appsettings.Production.json`, `appsettings.Staging.json`
- JWT settings configured in Program.cs
- Page redirects configured in `appsettings.json` under `pages:empleados` and `pages:clientes`
- Environment variables for secrets (never commit)
