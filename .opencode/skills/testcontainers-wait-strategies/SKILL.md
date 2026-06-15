---
name: testcontainers-wait-strategies
description: >
  Testcontainers for .NET wait strategies para espera de contenedores listos.
  Trigger: When configuring Testcontainers to wait for containers to be ready (HTTP, TCP ports, health checks, logs, files).
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## When to Use

- Configuring any container to wait until the service inside is ready
- Choosing the correct wait strategy based on what the container exposes
- Avoiding race conditions where tests try to use containers before they're ready
- Setting up test infrastructure with multiple containers

## Decision Tree

```
¿Qué expone el contenedor?
│
├─ ¿Endpoint HTTP?
│   └─ Sí → UntilHttpRequestIsSucceeded
│
├─ ¿HEALTHCHECK definido en Dockerfile?
│   └─ Sí → UntilContainerIsHealthy
│
├─ ¿Puerto TCP interno Listening?
│   └─ Sí → UntilPortIsAvailable
│
├─ ¿Genera archivo cuando está listo?
│   └─ Sí → UntilFileExists
│
├─ ¿Escribe log cuando está listo?
│   └─Sí → UntilMessageIsLogged
│
└─ ¿Contenedor termina tras completar tarea?
    └─ Sí → WaitStrategyMode.OneShot
```

## Wait Strategies Disponibles

### 1. UntilHttpRequestIsSucceeded

**Cuándo**: El contenedor ejecuta un servidor HTTP (API, Web, Frontend, etc.)

**Por qué**: Verifica que el servidor HTTP está respondiendo, no solo que el puerto está abierto

```csharp
// Esperar a que endpoint devuelva cualquier status (200, 401, etc)
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilHttpRequestIsSucceeded(r => r.ForPath("/")))

// Esperar status específico (200 OK)
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilHttpRequestIsSucceeded(r => r
        .ForPath("/health")
        .ForStatusCode(HttpStatusCode.OK)))

// Aceptar múltiples status codes como exitosos
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilHttpRequestIsSucceeded(r => r
        .ForPath("/")
        .ForStatusCode(HttpStatusCode.OK)
        .ForStatusCode(HttpStatusCode.MovedPermanently)))

// Usar predicado para rangos de status
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilHttpRequestIsSucceeded(r => r
        .ForPath("/")
        .ForStatusCodeMatching(status => status >= HttpStatusCode.OK && status < HttpStatusCode.MultipleChoices)))

// HTTPS
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilHttpRequestIsSucceeded(r => r
        .ForPath("/")
        .UsingTls()))

// Puerto específico (si no usa el default)
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilHttpRequestIsSucceeded(r => r
        .ForPort(8080)
        .ForPath("/health")))
```

**Nota**: NO existe `ForPort()` en la API actual. Testcontainers detecta el puerto automáticamente desde la configuración del contenedor.

---

### 2. UntilPortIsAvailable

**Cuándo**: Verificar que un servicio dentro del contenedor está escuchando en un puerto TCP

**Por qué**: Confirma que la aplicación dentro del contenedor ha iniciado y está aceptando conexiones

**Nota**: Esta es la API para Testcontainers 4.x (versión del proyecto usa 4.1.0)

**IMPORTANTE - MsSqlBuilder**: El módulo `MsSqlBuilder` de Testcontainers ya incluye un wait strategy por defecto que ejecuta `sqlcmd -Q "SELECT 1"` para verificar que SQL Server está listo. NO es necesario agregar un wait strategy manualmente a menos que necesites un comportamiento específico.

```csharp
// MsSqlBuilder YA incluye wait strategy por defecto - NO agregar manualmente
var msSqlContainer = new MsSqlBuilder()
    .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
    .WithPassword("password")
    .Build();  // Wait strategy ya incluido!
// .WithWaitStrategy(...) // ← NO necesario, ya viene por defecto
```

Si necesitas overriding:
```csharp
// Override solo si es necesario
var msSqlContainer = new MsSqlBuilder()
    .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
    .WithPassword("password")
    .WithWaitStrategy(Wait.ForUnixContainer()
        .UntilPortIsAvailable(1433))  // Override del default
    .Build();
```

```csharp
// Puerto interno del contenedor
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilPortIsAvailable(8080))

// SQL Server
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilPortIsAvailable(1433))

// Redis
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilPortIsAvailable(6379))
```

**Nota**: Solo porque el puerto está disponible no significa que el servicio está listo para manejar requests. Para mayor reliability, usar HTTP wait o log messages.

---

### 3. UntilExternalTcpPortIsAvailable

**Cuándo**: Verificar que el puerto mapeado es accesible desde el test host

**Por qué**: Confirma que el port mapping está establecido y la conexión puede realizarse

```csharp
// Verificar puerto externo mapeado
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilExternalTcpPortIsAvailable(8080))
```

**Nota**: Solo verifica que el puerto mapeado es reachable, no que el servicio dentro del contenedor está listo.

---

### 4. UntilContainerIsHealthy

**Cuándo**: La imagen Docker tiene HEALTHCHECK definido en el Dockerfile

**Por qué**: Usa el mecanismo native de Docker para determinar cuando el contenedor está healthy

```csharp
// Dockerfile ejemplo:
// FROM nginx:alpine
// HEALTHCHECK --interval=1s CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

// Usar en Testcontainers
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilContainerIsHealthy())
```

**Requiere**: Imagen con HEALTHCHECK definido

---

### 5. UntilFileExists

**Cuándo**: El contenedor crea un archivo cuando está listo (ej: archivo de lock, marker)

**Por qué**: Verifica que el proceso dentro del contenedor completó su setup

```csharp
// Archivo dentro del contenedor
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilFileExists("/tmp/healthy"))

// Múltiples archivos (todos deben existir)
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilFileExists("/tmp/foo")
    .UntilFileExists("/tmp/bar"))
```

---

### 6. UntilMessageIsLogged

**Cuándo**: La aplicación escribe un log específico cuando está lista

**Por qué**: Espera a que el mensaje de "started" o "ready" aparezca en los logs

```csharp
// Esperar mensaje en stdout/stderr
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilMessageIsLogged("Server started"))

// Con timeout personalizado
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilMessageIsLogged("Server started", o => o
        .WithTimeout(TimeSpan.FromMinutes(2))))

// Expresiones regulares
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilMessageIsLogged(new Regex("Started.*\\d+ms")))
```

---

### 7. WaitStrategyMode.OneShot

**Cuándo**: El contenedor está diseñado para ejecutar una tarea y terminar (migration scripts, setup scripts)

**Por qué**: Por defecto Testcontainers espera que el contenedor siga corriendo. OneShot trata la exit normal como success.

```csharp
// Contenedor que ejecuta migración y termina
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilMessageIsLogged("Migration completed", o => o
        .WithMode(WaitStrategyMode.OneShot)))
```

---

## Chaining Wait Strategies

Puedes combinar múltiples wait strategies:

```csharp
// Ejemplo: esperar puerto TCP Y luego HTTP (más robusto)
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilPortIsAvailable(8080)
    .UntilHttpRequestIsSucceeded(r => r.ForPath("/health")))

// Ejemplo: esperar archivo Y mensaje de log
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilFileExists("/tmp/ready")
    .UntilMessageIsLogged("Application ready"))
```

**Nota**: El orden importa. Es común primero esperar el puerto TCP (verificar que el servicio escucha) y luego verificar HTTP (verificar que responde requests).

---

## Configuración Adicional

### Timeout Personalizado

```csharp
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilHttpRequestIsSucceeded(r => r.ForPath("/"))
    .WithStartupTimeout(TimeSpan.FromMinutes(2)))
```

### Retry Configuration

```csharp
// Configurar reintentos, intervalo y timeout
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilMessageIsLogged("Started", o => o
        .WithTimeout(TimeSpan.FromMinutes(1))
        .WithInterval(TimeSpan.FromSeconds(5))
        .WithRetries(10)))
```

---

## Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `ContainerStartupException` | Contenedor inició pero app no está lista | Usar HTTP wait o UntilMessageIsLogged |
| Timeout en UntilInternalTcpPortIsAvailable | Puerto no está escuchando dentro del contenedor | Verificar que el servicio dentro del contenedor escucha en ese puerto |
| Timeout en UntilExternalTcpPortIsAvailable | Puerto no mapeado correctamente | Verificar port binding configuration |
| 404 en UntilHttpRequestIsSucceeded | Path incorrecto | Usar endpoint que siempre exista |
| Contenedor sale inesperadamente | Servicio dentro falló | Revisar logs del contenedor |
| Usar `ForPort()` | API no existe en versión actual | Eliminar, Testcontainers detecta puerto automáticamente |

---

## Ejemplo Genérico Multi-Contenedor

```csharp
public static class TestContainerHelper
{
    // Puertos internos como constantes
    private const int HttpPort = 80;
    private const int DbPort = 5432;
    private const int CachePort = 6379;

    public static async Task<IContainer> StartApiContainer(INetwork network)
    {
        return await new ContainerBuilder()
            .WithImage("mi-api:latest")
            .WithPortBinding(8080, true)
            .WithNetwork(network)
            .WithNetworkAliases("api")
            .WithEnvironment("ASPNETCORE_ENVIRONMENT", "Testing")
            .WithWaitStrategy(Wait.ForUnixContainer()
                .UntilHttpRequestIsSucceeded(r => r.ForPath("/health")))
            .Build()
            .StartAsync();
    }

    public static async Task<IContainer> StartDatabaseContainer(INetwork network)
    {
        return await new ContainerBuilder()
            .WithImage("postgres:15")
            .WithPortBinding(5432, true)
            .WithNetwork(network)
            .WithNetworkAliases("postgres")
            .WithEnvironment("POSTGRES_PASSWORD", "test")
            .WithWaitStrategy(Wait.ForUnixContainer()
                .UntilInternalTcpPortIsAvailable(DbPort))
            .Build()
            .StartAsync();
    }

public static async Task<IContainer> StartCacheContainer(INetwork network)
    {
        return await new ContainerBuilder()
            .WithImage("redis:alpine")
            .WithPortBinding(6379, true)
            .WithNetwork(network)
            .WithNetworkAliases("redis")
            .WithWaitStrategy(Wait.ForUnixContainer()
                .UntilInternalTcpPortIsAvailable(CachePort))
            .Build()
            .StartAsync();
    }

    // Nginx: puerto interno fijo (80), externo dinámico
    public static async Task<IContainer> StartNginxContainer(INetwork network)
    {
        const int internalPort = 80;  // Puerto fijo dentro del contenedor
        
        var nginxContainer = new ContainerBuilder()
            .WithImage("nginx:alpine")
            .WithPortBinding(internalPort, true)  // externo dinámico, interno fijo
            .WithBindMount("/path/to/nginx.conf", "/etc/nginx/nginx.conf")
            .WithNetwork(network)
            .WithNetworkAliases("nginx")
            .WithWaitStrategy(Wait.ForUnixContainer()
                .UntilInternalTcpPortIsAvailable(internalPort)))
            .Build();
        
        await nginxContainer.StartAsync();
        
        // Obtener puerto externo mapeado dinámicamente
        var externalPort = nginxContainer.GetMappedPublicPort(internalPort);
        
        return nginxContainer;
    }
}
```

等待 for nginx container - usa UntilInternalTcpPortIsAvailable porque nginx no expone HTTP

**Forma correcta de usar WithPortBinding:**
- `WithPortBinding(internalPort, true)` - asigna puerto externo dinámico
- `WithPortBinding(externalPort, internalPort)` - fija ambos puertos (solo si necesitas特定)

```csharp
const int internalPort = 80;  // Solo interno como constante

var nginx = new ContainerBuilder()
    .WithImage("nginx:alpine")
    .WithPortBinding(internalPort, true)  // true = puerto externo dinámico
    .WithNetwork(network)
    .WithWaitStrategy(Wait.ForUnixContainer()
        .UntilInternalTcpPortIsAvailable(internalPort)))
    .Build();

await nginx.StartAsync();

// Obtener el puerto externo asignado dinámicamente
var mappedPort = nginx.GetMappedPublicPort(internalPort);
```

---

## Recursos

- **Documentation**: https://dotnet.testcontainers.org/api/wait_strategies/
- **Testcontainers Modules**: https://dotnet.testcontainers.org/modules/