# SignalR Hub Test Example

## Basic Structure

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

## InvokeAsync Pattern

### Method Signature

```csharp
await _hubConnection.InvokeAsync("MethodName", arg1, arg2);
```

### Complete Pattern: Arrange → Invoke → Assert

1. **Arrange**: Setup listener with `_hubConnection.On<T>(...)`
2. **Act**: Invoke method with `await _hubConnection.InvokeAsync("MethodName", args)`
3. **Assert**: Verify listener received expected message

### Examples

```csharp
// Invoke with arguments
await _hubConnection.InvokeAsync("SendMessage", "super_user", "Hello World!!");

// Invoke without arguments
await _hubConnection.InvokeAsync("GetAllReservations");

// Invoke with return value
var result = await _hubConnection.InvokeAsync<IEnumerable<ReservationDto>>("GetReservations");
```

## Key Requirements

1. **Heredar de `SignalRIntegrationTestBase`** - Proporciona métodos para crear conexiones Hub
2. **Usar `CitasApiWebApplicationFactory<Program>`** - Tipado explícito con la clase Program
3. **Inicializar servidor antes de acceder a Server**: `_factory.CreateClient()` antes de `_factory.Server`
4. **IAsyncLifetime ya implementado**: `IntegrationTestBase` ya implementa `IAsyncLifetime`, no duplicar en clases derivadas
5. **Implementar `GetHubName()`**: Cada clase de test debe especificar su nombre de hub

## Notes

> **Nota**: El enfoque actual usa `StartConnectionAsync` con `HttpMessageHandler` manual y `Closed` handler con lógica de reconexión.

> **Nota importante**: Los ejemplos en esta sección son **conceptuales**, no literales. Adaptar según las necesidades específicas del test.