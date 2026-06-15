# Specification for IHttpCustomClient Interface Refactoring

## Purpose

Refactor `HttpCustomClient` to use an interface (`IHttpCustomClient`) to improve testability and follow dependency inversion principle. This allows easier mocking in unit tests using NSubstitute instead of Moq.

## Integration Requirements

### Requirement: Create IHttpCustomClient Interface

The project MUST provide an interface for HTTP client operations.

#### Scenario: Interface creation

- GIVEN the project needs better testability for HTTP client
- WHEN creating IHttpCustomClient interface
- THEN the interface MUST define the same public methods as HttpCustomClient:
  - `Task<string> post(string endPointUrl, HttpContent body)`
  - `Task<string> put(string endPointUrl, HttpContent body)`
  - `Task<string> get(string endPointUrl)`

### Requirement: HttpCustomClient implements IHttpCustomClient

The concrete implementation MUST implement the interface.

#### Scenario: Class implementing interface

- GIVEN IHttpCustomClient interface exists
- WHEN HttpCustomClient is modified
- THEN HttpCustomClient MUST declare `implements IHttpCustomClient`

### Requirement: Dependency Injection with Interface

The DI registration MUST use the interface.

#### Scenario: Program.cs configuration

- GIVEN AddHttpClient is used
- WHEN registering the HTTP client
- THEN use `AddHttpClient<IHttpCustomClient, HttpCustomClient>` instead of `AddHttpClient<HttpCustomClient>`

### Requirement: Constructor Injection with Interface

All consumers MUST use the interface in their constructors.

#### Scenario: Manager and Controller constructors

- GIVEN HttpCustomClient is used in constructors
- WHEN updating the constructors
- THEN change parameter type from `HttpCustomClient` to `IHttpCustomClient`

## Affected Files

### BL Layer (New + Modified)

| File | Action |
|------|--------|
| `BL/IHttpCustomClient.cs` | **NEW** - Interface definition |
| `BL/HttpCustomClient.cs` | **MODIFIED** - Add `implements IHttpCustomClient` |
| `BL/UsersManager.cs` | **MODIFIED** - Constructor parameter type |
| `BL/ClasesManager.cs` | **MODIFIED** - Constructor parameter type |
| `BL/RutinasManager.cs` | **MODIFIED** - Constructor parameter type |
| `BL/MedidasManager.cs` | **MODIFIED** - Constructor parameter type |
| `BL/HorariosManager.cs` | **MODIFIED** - Constructor parameter type |
| `BL/EjerciciosManager.cs` | **MODIFIED** - Constructor parameter type |
| `BL/CitasManager.cs` | **MODIFIED** - Constructor parameter type |

### API Layer

| File | Action |
|------|--------|
| `API/Controllers/ClasesController.cs` | **MODIFIED** - Constructor parameter type |
| `API/Program.cs` | **MODIFIED** - DI registration |

### Frontend Layer

| File | Action |
|------|--------|
| `GymFrontend/Controllers/HomeController.cs` | **MODIFIED** - Constructor parameter type |
| `GymFrontend/Program.cs` | **MODIFIED** - DI registration |

### Tests Layer

| File | Action |
|------|--------|
| `GymWebApp.Tests/Unit/Clases/ReagendarInscripcionAClaseUnitTests.cs` | **MODIFIED** - Use `Substitute.For<IHttpCustomClient>()` |
| `GymWebApp.Tests/Unit/Clases/InscribirAClaseUnitTests.cs` | **MODIFIED** - Use `Substitute.For<IHttpCustomClient>()` |
| `GymWebApp.Tests/Unit/Clases/EliminarPrereservaDeClaseProgramadaUnitTests.cs` | **MODIFIED** - Use `Substitute.For<IHttpCustomClient>()` |
| `GymWebApp.Tests/Unit/Clases/ObtenerClasesControllerTests.cs` | **MODIFIED** - Use `Substitute.For<IHttpCustomClient>()` |

## Benefits

1. **Better testability** - NSubstitute can create mocks from interfaces easily
2. **Loose coupling** - Classes depend on abstraction, not concrete implementation
3. **Cleaner tests** - No need for Moq with complex constructor setup
4. **Future-proof** - Easy to swap implementations if needed

## Testing

After refactoring, verify:
1. All unit tests pass: `dotnet test --filter "FullyQualifiedName~Unit"`
2. Integration tests pass: `dotnet test --filter "FullyQualifiedName~Integration"`
3. Build succeeds: `dotnet build`

## Build Status

- **Build**: ✅ Successful
- **Unit Tests**: Pending verification
- **Integration Tests**: Pending verification

## Notes

This refactoring addresses the issue where NSubstitute cannot create proxies for concrete classes with constructor parameters. By using an interface, unit tests can now use `Substitute.For<IHttpCustomClient>()` cleanly.