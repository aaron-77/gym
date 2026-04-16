## Testcontainers Setup

**Referencia**: Ver skill **[testcontainers](../testcontainers/SKILL.md)** para configuración de contenedores Docker.

### Resumen Rápido

```csharp
using Testcontainers.MsSql;

public class DatabaseFixture : IAsyncLifetime
{
    private static readonly MsSqlContainer _msSqlContainer = new MsSqlBuilder()
        .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
        .WithPassword("YourStrong@Passw0rd")
        .WithReuse(true)
        .Build();

    public string ConnectionString => _msSqlContainer.GetConnectionString();

    public async Task InitializeAsync() => await _msSqlContainer.StartAsync();
    public async Task DisposeAsync() => await _msSqlContainer.DisposeAsync();
}
```

### Para E2E con Múltiples Contenedores

Ver [testcontainers skill - assets/01-testcontainers-setup.md](../testcontainers/assets/01-testcontainers-setup.md)

### Wait Strategies

Ver skill **[testcontainers-wait-strategies](../testcontainers-wait-strategies/SKILL.md)**

### Puntos Clave

- Usar campo estático para mantener el contenedor vivo entre tests
- `.WithReuse(true)` evita reinicio del contenedor
- Connection string se obtiene dinámicamente via `container.GetConnectionString()`
