# AGENTS.md - DTO (Data Transfer Objects) Layer

## Project Overview

- **Framework:** .NET 8
- **Layer Role:** Data Transfer Objects shared across all layers (API, BL, Frontend)
- **Dependencies:** None (minimal project)

## Project Structure

```
DTO/
├── Dtos/                      # DTO classes (100+ files)
├── Enums/                     # C# enumerations
├── CustomValidations/         # Custom validation attributes
├── convertersAndSerializers/ # JSON converters/deserializers
└── DTO.csproj
```

## Build & Test Commands

```bash
# Build solution or DTO project
dotnet build
dotnet build DTO/DTO.csproj

# Run tests
dotnet test

# Run single test
dotnet test --filter "FullyQualifiedName~Namespace.ClassName.MethodName"
```

## Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| DTOs | `DTO` prefix | `DTOResponse<T>`, `DTOLoggedUser`, `DTOClase` |
| Regular classes | No prefix | `UserCredentials`, `User`, `ErrorModel` |
| Enums | PascalCase | `TipoDeElemento` |

## Code Style

- **ImplicitUsings** enabled
- **Nullable** reference types enabled - use `?` for optional
- Properties can use camelCase or PascalCase

## DTO Examples

### Generic Response Wrapper

```csharp
public class DTOResponse<T>
{
    public bool success { get; set; }
    public int httpCode { get; set; }
    public string message { get; set; }
    public List<ErrorModel> errors { get; set; }
    public T payload { get; set; }

    public DTOResponse()
    {
        errors = new List<ErrorModel>();
    }
}
```

### Logged User DTO

```csharp
public class DTOLoggedUser
{
    public string Id { get; set; }
    public string NombreCompleto { get; set; }
    public DateTime FechaDeNacimiento { get; set; }
    public string Correo { get; set; }
    public string AccessToken { get; set; }
    public string IdToken { get; set; }
    public string RefreshToken { get; set; }
}
```

### Request with Validation

```csharp
public class UserCredentials
{
    [Required(ErrorMessage = "Introduce una cuenta de correo")]
    [EmailAddress(ErrorMessage = "El correo no es válido")]
    public string correo { get; set; }

    [Required(ErrorMessage = "No ingresaste tu contraseña")]
    public string contrasena { get; set; }
}
```

### Error Model

```csharp
public class ErrorModel
{
    public string message { get; set; }
    public string propiedad { get; set; }
}
```

## Validation

Use DataAnnotations:

```csharp
[Required] public string Nombre { get; set; }
[EmailAddress] public string Correo { get; set; }
[MinLength(6)] public string Contrasena { get; set; }
```

## Custom Serializers

JSON converters in `convertersAndSerializers/`:

```csharp
public class ConsejosStringToArrayConverter : JsonConverter<string[]>
{
    public override string[] Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        // Custom deserialization logic
    }

    public override void Write(Utf8JsonWriter writer, string[] value, JsonSerializerOptions options)
    {
        // Custom serialization logic
    }
}
```

## Cursor Rules (from .cursor/rules/)

- **Dtos/**: Contains all data transfer objects used in the application
- **Enums/**: Contains C# enumerations used in DTOs
- **CustomValidations/**: Custom validation attributes
- **convertersAndSerializers/**: Custom JSON deserialization classes

## Usage

```csharp
using DTO.Dtos;

// Deserialize API response
var response = JsonSerializer.Deserialize<DTOResponse<DTOLoggedUser>>(json);

// Create response
return Ok(new DTOResponse<User> { success = true, payload = user });
```

## Specs (Specifications)

Ver [AGENTS.md principal](../AGENTS.md#specs-specifications) para reglas de specs.
Plantilla: `specs/spect-skeleton.md`
