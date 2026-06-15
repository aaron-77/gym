# SignalR Hub Integration Testing Strategy

## Overview

Esta guía describe cómo escribir tests de integración para SignalR Hubs usando el patrón `IntegrationTestBase<TFactory>` con tipado explícito mediante `CitasApiWebApplicationFactory<Program>`.

> **Nota importante**: `IntegrationTestBase<TFactory>` ya implementa `IAsyncLifetime`, por lo que las clases derivadas NO deben implementarlo nuevamente.

## Typing Correcto

El proyecto usa el siguiente patrón de tipado:

```csharp
// Correcto: IntegrationTestBase<CitasApiWebApplicationFactory<Program>>
public abstract class SignalRIntegrationTestBase 
    : IntegrationTestBase<CitasApiWebApplicationFactory<Program>>
{
    // ...
}
```

**No usar:**
- ❌ `IntegrationBase<TProgram>` - No existe en el proyecto
- ❌ `SignalRWebApplicationFactory<Program>` - No existe en el proyecto
- ❌ `WebApplicationFactory<Program>` directamente - Usar el factory del proyecto

## Enfoque Principal (StartConnectionAsync - Recomendado)

Este es el enfoque por defecto en `SignalRIntegrationTestBase`. Usa `StartConnectionAsync` con `HttpMessageHandler` manual para crear la conexión Hub.

```csharp
// En SignalRIntegrationTestBase.cs - InitializeAsync()
public override async Task InitializeAsync()
{
    await base.InitializeAsync();

    // CRITICAL: CreateClient must be called before accessing Server property
    Factory.CreateClient();
    var server = Factory.Server;
    var handler = server.CreateHandler();

    _hubConnection = await StartConnectionAsync(handler, GetHubName());

    // Closed handler with reconnection logic
    _hubConnection.Closed += async error =>
    {
        await Task.Delay(new Random().Next(0, 5) * 1000);
        await _hubConnection.StartAsync();
    };
}
```

**Ventajas:**
- Control total sobre el handler
- Permite configuración avanzada de HTTP
- Reconnection logic integrada en el Closed handler
- Soporte para múltiples hubs mediante `GetHubName()`

**Cuándo usarlo:**
- Este es el enfoque **predeterminado** y recomendado para todos los tests de SignalR.

## SignalRIntegrationTestBase Class

La clase base del proyecto proporciona:

```csharp
public abstract class SignalRIntegrationTestBase 
    : IntegrationTestBase<CitasApiWebApplicationFactory<Program>>
{
    protected HubConnection? _hubConnection;

    protected SignalRIntegrationTestBase(CitasApiWebApplicationFactory<Program> factory) 
        : base(factory)
    {
    }

    private static async Task<HubConnection> StartConnectionAsync(
        HttpMessageHandler handler, 
        string hubName)
    {
        var hubConnection = new HubConnectionBuilder()
            .WithUrl($"ws://localhost/hubs/{hubName}", o =>
            {
                o.HttpMessageHandlerFactory = _ => handler;
            })
            .Build();

        await hubConnection.StartAsync();
        return hubConnection;
    }

    public override async Task InitializeAsync()
    {
        await base.InitializeAsync();

        // CRITICAL: CreateClient must be called before accessing Server
        Factory.CreateClient();
        var server = Factory.Server;
        var handler = server.CreateHandler();

        _hubConnection = await StartConnectionAsync(handler, GetHubName());

        // Closed handler with reconnection logic
        _hubConnection.Closed += async error =>
        {
            await Task.Delay(new Random().Next(0, 5) * 1000);
            await _hubConnection.StartAsync();
        };
    }

    /// <summary>
    /// Each test class must implement this to specify its hub name.
    /// </summary>
    protected abstract string GetHubName();

    public override async Task DisposeAsync()
    {
        if (_hubConnection != null)
        {
            await _hubConnection.StopAsync();
            await _hubConnection.DisposeAsync();
        }

        await base.DisposeAsync();
    }
}
```

## Invocando Métodos del Hub

Para invocar métodos en el SignalR Hub, se usa el patrón `InvokeAsync`:

```csharp
await _hubConnection.InvokeAsync("MethodName", arg1, arg2);
```

### Patrón Completo: Arrange → Invoke → Assert

1. **Arrange**: Configurar listener con `_hubConnection.On<T>(...)`
2. **Act**: Invocar método con `await _hubConnection.InvokeAsync("MethodName", args)`
3. **Assert**: Verificar que el listener recibió el mensaje esperado

### Ejemplos

```csharp
// Invocar con argumentos
await _hubConnection.InvokeAsync("SendMessage", "super_user", "Hello World!!");

// Invocar sin argumentos
await _hubConnection.InvokeAsync("GetAllReservations");

// Invocar con valor de retorno
var result = await _hubConnection.InvokeAsync<IEnumerable<ReservationDto>>("GetReservations");
```

Ver [signalRHubTestExample.md](signalRHubTestExample.md) para un ejemplo completo de test class.

## Inicialización del Servidor

**CRÍTICO**: Antes de acceder a `_factory.Server`, debes crear un cliente:

```csharp
// Esto es OBLIGATORIO - el servidor no está disponible hasta que se crea un cliente
_factory.CreateClient(); 
var server = _factory.Server;
var handler = server.CreateHandler();
```

## Ejemplo de Test Class

```csharp
public class ReservacionesHubTests : SignalRIntegrationTestBase
{
    public ReservacionesHubTests(CitasApiWebApplicationFactory<Program> factory) 
        : base(factory)
    {
    }

    // Cada clase debe implementar GetHubName()
    protected override string GetHubName() => "reservaciones";

    [Fact]
    public async Task WhenConnected_ShouldReceiveReservationUpdates()
    {
        // El _hubConnection ya está inicializado por InitializeAsync()
        var received = false;
        
        _hubConnection.On<string>("ReservationUpdated", message =>
        {
            received = true;
        });

        // ... lógica del test

        received.Should().BeTrue();
    }
}
```

## Notas Importantes

1. **IAsyncLifetime ya implementado**: `IntegrationTestBase<TFactory>` implementa `IAsyncLifetime`. Las clases derivadas NO deben implementarlo nuevamente.
2. **Siempre tipar con `Program`**: Usar `CitasApiWebApplicationFactory<Program>` no `WebApplicationFactory<Startup>`
3. **Crear cliente antes de Server**: `_factory.CreateClient()` debe llamarse antes de `_factory.Server`
4. **GetHubName() es abstracto**: Cada clase de test debe implementar `GetHubName()` para especificar su hub
5. **Closed handler con reconexión**: El handler de reconnection evita que el test falle por desconexión
6. **Dispose correcto**: Siempre limpiar el `HubConnection` en el `DisposeAsync` del test

## Referencias

- [extraContext/ejemplosArquitecturaYCodigoGenerales/testing.md](testing.md) - Patron general de testing
- [GymWebApp.Tests/AGENTS.md](../GymWebApp.Tests/AGENTS.md) - Configuración de tests del proyecto
- [GymWebApp.Tests/Integration/Common/SignalRIntegrationTestBase.cs](../GymWebApp.Tests/Integration/Common/SignalRIntegrationTestBase.cs) - Implementación real
- [signalRHubTestExample.md](signalRHubTestExample.md) - Ejemplo completo de test class SignalR