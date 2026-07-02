# AGENTS.md - BL (Business Logic) Layer

## Project Overview

- **Framework:** .NET 8 with ASP.NET Core
- **Layer Role:** HTTP client communication with API, data transformation
- **Dependencies:** DTO project, System.Net.Http.Json

## Project Structure

```
BL/
├── *.cs           # Manager classes (UsersManager, ClasesManager, etc.)
├── Utils/         # ResponseManager, JwtTokenGenerator, EndpointsManager
├── CustomValidations/  # Custom validation attributes
└── ErrorHandling/      # Error display utilities
```

## Build & Test Commands

```bash
# Build solution or specific project
dotnet build
dotnet build BL/BL.csproj

# Run tests
dotnet test

# Run single test by method name
dotnet test --filter "FullyQualifiedName~Namespace.ClassName.MethodName"
# Example: dotnet test --filter "FullyQualifiedName~GymWebApp.Tests.UsersManagerTests.Login_ReturnsUser"

# Run with coverage
dotnet test --collect:"XPlat Code Coverage"
```

## Code Style

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Classes/Methods | PascalCase | `UsersManager`, `login` |
| Parameters/Private fields | camelCase | `credenciales`, `httpClient` |
| DTOs | `DTO` prefix | `DTOResponse<T>`, `DTOLoggedUser` |

### Imports Order

1. System namespaces, 2. Third-party (`Microsoft`, `Newtonsoft`), 3. Project (`BL`, `BL.Utils`, `DTO.Dtos`)

### Type Usage

- **ImplicitUsings** enabled - no explicit `using System;`
- **Nullable** reference types enabled - use `?` for optional
- Use `async/await` for I/O; return `Task<T>`
- Use `JsonContent.Create()` for HTTP request bodies

## Manager Pattern

```csharp
public class UsersManager
{
    private readonly HttpCustomClient httpClient;

    public UsersManager(HttpCustomClient httpClient) => this.httpClient = httpClient;

    public async Task<DTOResponse<DTOLoggedUser>> login(UserCredentials credenciales)
    {
        JsonContent jsonCon = JsonContent.Create(credenciales);
        string response = await httpClient.post("api/autenticar", jsonCon);

        try
        {
            return JsonSerializer.Deserialize<DTOResponse<DTOLoggedUser>>(response,
                new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
        }
        catch (ArgumentNullException ex) { LogError("login", ex); return null; }
        catch (Exception ex) { LogError("login", ex); return null; }
    }

    private void LogError(string methodName, Exception ex)
    {
        string logMessage = $"[ERROR] Método: {methodName} - {ex.GetType().Name} | " +
            $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
            $"Causa: {ex.Message}";
        Console.WriteLine(logMessage);
    }
}
```

## Response Pattern

Use `ResponseManager.BuildResponse<T>()` from `BL.Utils`:

```csharp
return ResponseManager.BuildResponse<bool>(true, 200, "Operación exitosa", null, payload);
```

### DTOResponse Structure

```csharp
public class DTOResponse<T>
{
    public bool success { get; set; }
    public int httpCode { get; set; }
    public string message { get; set; }
    public List<ErrorModel> errors { get; set; }
    public T payload { get; set; }
}
```

## Error Handling

```csharp
catch (ArgumentNullException ex)
{
    string logMessage = $"[ERROR] Método: MethodName - ArgumentNullException | " +
        $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
        $"Causa: {ex.GetType().Name} - {ex.Message}";
    Console.WriteLine(logMessage);
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

## HTTP Client Usage

```csharp
JsonContent jsonBody = JsonContent.Create(request);
string apiResponse = await httpClient.post("api/endpoint", jsonBody);
return JsonSerializer.Deserialize<DTOResponse<T>>(apiResponse,
    new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
```

## Validation

Use DataAnnotations and custom attributes from `BL.CustomValidations`:

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

## Configuration

- Environment variables for API base URLs and secrets
- Endpoints via `EndpointsManager` in `BL/Utils/`
- JWT settings in `JwtSettings` DTO class

## Specs (Specifications)

Ver [AGENTS.md principal](../AGENTS.md#specs-specifications) para reglas de specs.
Plantilla: `specs/spect-skeleton.md`
