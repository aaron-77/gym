---
name: integration-test-base
description: >
  Crear clases base para tests de integración en .NET 8.
  Trigger: Cuando se necesitan tests de integración con WebApplicationFactory.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## When to Use

- Crear tests de integración con WebApplicationFactory
- Necesitar una clase base reutilizable para múltiples clases de tests
- Evitar duplicar código de setup en cada clase de tests

## Ejemplo de IntegrationTestBase

Ver [assets/IntegrationTestBase.cs.template](assets/IntegrationTestBase.cs.template)

## Ejemplo de Uso

```csharp
// Tu WebApplicationFactory
public class CitasApiWebApplicationFactory<TProgram> : WebApplicationFactory<TProgram> 
    where TProgram : class
{
    // Configuración de la factory
}

// Tu clase de tests hereda de la base
public class CitasApiTests : IntegrationTestBase<CitasApiWebApplicationFactory<Program>>
{
    public CitasApiTests(CitasApiWebApplicationFactory<Program> factory) 
        : base(factory) { }

    [Fact]
    public async Task Test1()
    {
        // Ya tienes Client configurado
        var response = await Client.GetAsync("/api/endpoint");
    }
}
```
