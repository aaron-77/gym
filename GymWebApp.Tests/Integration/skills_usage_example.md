# Ejemplo: Relación entre Skills de Testing

Este documento muestra cómo usar los skills en conjunto para crear tests de integración.

## Scenario: Crear tests para endpoint de Citas

### 1. Crear la Factory (Bogus Factory)

```csharp
// Integration/Factories/CitaFactory.cs
using Bogus;
using DataAccess.EntityFramework;

namespace GymWebApp.Tests.Integration.Factories;

public static class CitaFactory
{
    public static Cita Crear(
        string? tipoCita = null,
        DateTime? fechaHora = null)
    {
        return new Faker<Cita>("es")
            .RuleFor(c => c.FechaHora, f => fechaHora ?? f.Date.Future())
            .RuleFor(c => c.TipoCita, _ => tipoCita ?? "Entrenamiento Personal")
            .Generate();
    }
}
```

### 2. Crear Helper si es necesario (Test Helper)

```csharp
// Integration/Common/Helpers/SeedHelper.cs
using DataAccess.EntityFramework;
using Microsoft.AspNetCore.Identity;

namespace GymWebApp.Tests.Integration.Common.Helpers;

public static class SeedHelper
{
    public static async Task<string> SeedUsuarioAsync(
        UserManager<ApplicationUser> userManager,
        string email)
    {
        var user = new ApplicationUser
        {
            Id = Guid.NewGuid().ToString(),
            Email = email,
            UserName = email,
            NombreCompleto = "Test User"
        };
        
        await userManager.CreateAsync(user, "Test123!");
        return user.Id;
    }
}
```

### 3. Crear la clase base (Integration Test Base)

```csharp
// Integration/Common/IntegrationTestBase.cs
using Microsoft.AspNetCore.Mvc.Testing;

namespace GymWebApp.Tests.Integration.Common;

public abstract class IntegrationTestBase<TFactory> : IClassFixture<TFactory>
    where TFactory : CitasApiWebApplicationFactory<Program>
{
    protected readonly TFactory Factory;
    protected readonly HttpClient Client;

    protected IntegrationTestBase(TFactory factory)
    {
        Factory = factory;
        Client = factory.CreateClient();
    }
}
```

### 4. Crear los tests (Features)

```csharp
// Integration/Features/Citas/CitasApiTests.cs
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Factories;
using GymWebApp.Tests.Integration.Common.Helpers;

namespace GymWebApp.Tests.Integration;

public class CitasApiTests : IntegrationTestBase<CitasApiWebApplicationFactory<Program>>
{
    public CitasApiTests(CitasApiWebApplicationFactory<Program> factory) 
        : base(factory) { }

    [Fact]
    public async Task RegistrarCita_WithValidData_ReturnsOk()
    {
        // Arrange - Usar Bogus Factory
        var cita = CitaFactory.Crear(tipoCita: "Medición");
        
        // Act
        var response = await Client.PostAsJsonAsync("/api/RegistrarCita", cita);

        // Assert - Usar FluentAssertions
        response.StatusCode.Should().Be(HttpStatusCode.OK);
    }
}
```

## Diagrama de relaciones

```
┌─────────────────────────────────────────────────────────────┐
│              IntegrationTestBase                              │
│                                                             │
│   USA:                                                      │
│   ├─► CustomWebApplicationFactory                          │
│   ├─► Helpers (métodos estáticos)                         │
│   └─► Bogus Factories                                     │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        │ (hereda)
                        ▼
┌─────────────────────────────────────────────────────────────┐
│              CitasApiTests                                  │
│                                                             │
│   USA:                                                      │
│   └─► IntegrationTestBase                                  │
└─────────────────────────────────────────────────────────────┘
```

## Leyenda

| Símbolo | Significado |
|---------|------------|
| `USA` | Utiliza / Depende de |
| `hereda` | Herencia de clase |

## Resumen de relaciones

| Componente | Relación |
|-----------|----------|
| `IntegrationTestBase` | **Usa** CustomWebApplicationFactory, Helpers, Bogus Factories |
| `CitasApiTests` | **Hereda** de IntegrationTestBase |

## Resumen de uso

| Skill | Se usa en | Para |
|-------|-----------|------|
| **Bogus Factory** | Tests | Generar datos aleatorios |
| **Test Helper** | Tests, Base | Métodos estáticos reutilizables |
| **Integration Test Base** | Tests | Heredar setup común (Client, Factory) |
