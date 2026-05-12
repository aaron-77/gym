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

## SignalR Hub Testing

Ver [assets/SignalRIntegrationTestBase.md.template](assets/SignalRIntegrationTestBase.md.template) para la plantilla de la clase base.

Ver [signalRHubTestExample.md](../extraContext/ejemplosArquitecturaYCodigoGenerales/signalRHubTestExample.md) para un ejemplo completo de test class con el patrón InvokeAsync.

### Ejemplo de SignalR Test

```csharp
public class ReservacionesHubTests : SignalRIntegrationTestBase
{
    public ReservacionesHubTests(CitasApiWebApplicationFactory<Program> factory)
        : base(factory)
    {
    }

    protected override string GetHubName() => "reservaciones";

    [Fact]
    public async Task SendMessage_ShouldBroadcastToClients()
    {
        // Arrange - Setup listener
        var receivedMessages = new List<string>();
        _hubConnection.On<string, string>("ReceiveMessage", (user, message) =>
        {
            receivedMessages.Add($"{user}: {message}");
        });

        // Act - Invoke hub method
        await _hubConnection.InvokeAsync("SendMessage", "super_user", "Hello World!!");

        // Assert
        receivedMessages.Should().Contain("super_user: Hello World!!");
    }
}
```

### InvokeAsync Pattern

```csharp
await _hubConnection.InvokeAsync("MethodName", arg1, arg2);
```
