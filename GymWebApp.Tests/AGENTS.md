# AGENTS.md - GymWebApp.Tests

## Rules

- NEVER run git commands directly from main context. Use the **git-workflow-manager** subagent for ALL git operations (commit, push, etc.). Running git directly dirties the context with pre-commit hooks and code review output.

## Stack de pruebas

| Librería | Propósito |
|----------|-----------|
| **xUnit** | Framework de testing |
| **WebApplicationFactory** | API en memoria para pruebas de integración |
| **FluentAssertions** | Aserciones fluidas |
| **Respawn** | Limpieza de BD entre tests |
| **NSubstitute** | Mocks |
| **Bogus** | Generación de datos aleatorios |
| **Playwright .NET** | E2E y componentes frontend |
| **TSQL** | Pruebas de lógica en BD |
| **TestContainers** | BD de pruebas en Docker |

## Arquitectura de pruebas

```
GymWebApp.Tests/
├── UnitTest1.cs, *.cs              # Tests unitarios antiguos (deprecar)
├── Unit/                           # Tests unitarios por dominio
│   └── Clases/
│       └── ClasesControllerTests.cs
└── Integration/
    ├── Common/
    │   ├── IntegrationTestBase.cs  # Clase base
    │   ├── DatabaseHelper.cs       # Helper de BD
    │   ├── RespawnHelper.cs       # Helper de limpieza
    │   └── CitasApiWebApplicationFactory.cs
    ├── Features/                  # Tests por feature
    │   └── Citas/
    │       └── CitasApiTests.cs
    ├── Factories/                  # Bogus factories
    │   └── ApplicationUserFactory.cs
    └── TestData/                   # Datos estáticos
```

## Estrategia de Testing

### Tests de Integración
- **Propósito**: Verificar el flujo completo (end-to-end interno).
- **Alcance**: Happy Path + Sad Path de acceso sin autenticación al endpoint.
- **Ubicación**: `Integration/Features/{Dominio}/`.

### Tests Unitarios
- **Propósito**: Validar lógica de negocio, manejo de errores y edge cases.
- **Alcance**: Cubren casos como 404, 500, validaciones fallidas y lógica condicional compleja.
- **Ubicación**: `Unit/{Dominio}/`.

### Tests E2E
- **Propósito**: Verificar flujos críticos del usuario a través de toda la pila (browser → Nginx → API → BD → Frontend → browser).
- **Alcance**: Solo rutas críticas de usuario. Autenticación, navegación, flujos completos de UI.
- **Ubicación**: `E2E/Features/{FeatureName}E2ETests.cs`.
- **Infraestructura**: Playwright .NET + Testcontainers (SQL Server + API + Frontend + Nginx).
- **Especificaciones**: `specs/e2e-infraestructura.md` (infraestructura) y `specs/e2e-tests.md` (escenarios).
- **Principio**: Más tests unitarios, menos tests de integración, mínimos tests E2E.
- **Ver specs de E2E para**: arquitectura de contenedores, configuración de Nginx, estrategia de seeding, patrones de aserción, y escenarios aprobados.

## Reglas de Implementación de Tests

- **ESTRICTAMENTE SEGÚN SPEC**: Solo se deben implementar las pruebas definidas explícitamente en la especificación. No se acepta ninguna prueba que no esté documentada en el spec al momento de la implementación.
- **PROHIBIDO TESTS DERIVADOS**: Bajo ninguna circunstancia se deben implementar pruebas secundarias, adicionales o "casos que se te ocurran" sin preguntar.
- **CONSULTA OBLIGATORIA**: Si identificás la necesidad de cubrir un escenario extra, debés proponerlo primero y esperar la confirmación del usuario antes de implementar.
- **NO HELPERS EN TESTS**: No escribir lógica de helper dentro de las clases de prueba. Usar clases helper existentes (DatabaseHelper, TestContainerHelper) o crear nuevas en GymWebApp.Tests/Integration/Helpers/ y llamarlas desde los tests.
- **CONSULTAR ESQUEMA DE BD**: Antes de escribir queries SQL, verificar los nombres de columnas
  en bd/esquemaBdsDeReferenciaParaIa/FitnessGymSchemaActual.sql. El esquema es la fuente de verdad.

### Reglas específicas para Tests E2E

- **TODOS los tests E2E DEBEN heredar de `PlaywrightTestBase`** — Esto garantiza que los contenedores estén inicializados. Tests que solo necesitan HTTP (sin browser) deben ser tests de integración, no E2E.
- **Las credenciales de prueba DEBEN venir de `appsettings.Testing.json`** — NUNCA hardcodear email/password en los archivos de test. Usar `TestUser` (empleado) o `TestUserCliente` (cliente).
- **Las aserciones DEBEN verificar contenido real, no solo existencia** — DO: `Expect(heading).ToHaveTextAsync(new Regex("Clases"))`. DON'T: solo `WaitForAsync` sin verificar texto.
- **Naming convention E2E**: `{Feature}_{Action}_{ExpectedResult}` (ej: `Login_ValidCredentials_RedirectsToHomepage`).
- **Aislamiento**: Todos los tests E2E comparten la misma base de datos. Los tests NO deben depender del orden de ejecución entre clases.

## Reglas de Implementación de Tests

- **ESTRICTAMENTE SEGÚN SPEC**: Solo se deben implementar las pruebas definidas explícitamente en la especificación. No se acepta ninguna prueba que no esté documentada en el spec al momento de la implementación.
- **PROHIBIDO TESTS DERIVADOS**: Bajo ninguna circunstancia se deben implementar pruebas secundarias, adicionales o "casos que se te ocurran" sin preguntar.
- **CONSULTA OBLIGATORIA**: Si identificás la necesidad de cubrir un escenario extra, debés proponerlo primero y esperar la confirmación del usuario antes de implementar.
- **NO HELPERS EN TESTS**: No escribir lógica de helper dentro de las clases de prueba. Usar clases helper existentes (DatabaseHelper, TestContainerHelper) o crear nuevas en GymWebApp.Tests/Integration/Helpers/ y llamarlas desde los tests.
- **CONSULTAR ESQUEMA DE BD**: Antes de escribir queries SQL, verificar los nombres de columnas 
  en bd/esquemaBdsDeReferenciaParaIa/FitnessGymSchemaActual.sql. El esquema es la fuente de verdad.

## Directorios de Especificaciones (Requerimientos)

| Directorio | Descripción |
|------------|-------------|
| `specs/` | Especificaciones de integración (Happy Path). |
| `specs/unit/` | Especificaciones unitarias (lógica, errores, edge cases). |
| `specs/e2e-infraestructura.md` | Especificación de infraestructura E2E (contenedores, Nginx, seeding). |
| `specs/e2e-tests.md` | Especificación de escenarios E2E (flujos de usuario aprobados). |

### Reglas de Specs de Pruebas

- Separar specs de tests en archivos distintos a los de implementación
- NO incluir código en los specs
- Estructura: [specs/spect-skeleton.md](../specs/spect-skeleton.md)
- Reglas completas en [AGENTS.md principal](../AGENTS.md#specs-specifications)

## Directorios de Pruebas (Código)

| Directorio | Descripción |
|------------|-------------|
| `GymWebApp.Tests/Integration/Features/{Dominio}/` | Tests de integración (Happy Path). |
| `GymWebApp.Tests/Unit/{Dominio}/` | Tests unitarios (lógica, errores). |
| `GymWebApp.Tests/E2E/Features/{FeatureName}E2ETests.cs` | Tests E2E (flujos críticos de usuario). |

## Carpetas y responsabilidades

| Carpeta | Responsabilidad |
|---------|----------------|
| `Unit/` | Tests unitarios - lógica y errores |
| `Integration/Common/` | Clases base, fixtures, helpers reutilizables |
| `Integration/Features/` | Tests de integración por dominio |
| `Integration/Factories/` | Generadores de datos con Bogus |
| `Integration/TestData/` | Datos estáticos (JSON) |
| `E2E/Common/` | Infraestructura E2E (contenedores, Playwright base, Nginx config) |
| `E2E/Features/` | Tests E2E por feature |

## Skills disponibles

| Skill | Trigger | Propósito |
|-------|---------|-----------|
| **bogus-factory** | "Cuando cualquier prueba necesite crear objetos/datos de prueba" | Generar datos de prueba |
| **integration-test-base** | "Cuando se necesitan tests de integración con WebApplicationFactory" | Clases base - **DEBE REVISARSE PARA TODOS LOS TESTS DE INTEGRACIÓN** |
| **test-helper** | "Cuando se necesitan métodos reutilizables en tests de integración" | Helpers con métodos estáticos |
| **xunit-dotnet** | "Cuando se escriben tests unitarios para .NET" | Patrones de unit testing |
| **xunit-integration** | "Cuando se escriben tests de integración para .NET" | Patrones de integración |
| **sqlserver-dbtesting** | "Cuando se testing SQL Server stored procedures y functions" | Tests de lógica en BD |
| **dotnet-playwright** | "Cuando se escriben E2E tests para ASP.NET Core con Playwright" | E2E y componentes |
| **dotnet-ui-testing-core** | "Cuando se necesita Page Object Model, selectores estables o wait strategies" | Patrones de mantenimiento de tests UI |
| **dotnet-testing-strategy** | "Cuando se necesita decidir qué tipo de test usar (Unit/Integration/E2E)" | Estrategia de testing |
| **dotnet-add-testing** | "Cuando se necesita crear un nuevo proyecto de tests" | Scaffold de proyectos de test |
| **testcontainers** | "Cuando se usa Testcontainers para correr BD o servicios en Docker" | Contenedores Docker para tests |
| **testcontainers-wait-strategies** | "Cuando se configuran Testcontainers para esperar que contenedores estén listos" | Wait strategies HTTP y TCP |

> **IMPORTANTE**: El skill `integration-test-base` DEBE revisarse para CUALQUIER test de integración, incluyendo SignalR Hubs. Ver [signalRIntegrationTestStrategy.md](../extraContext/ejemplosArquitecturaYCodigoGenerales/signalRIntegrationTestStrategy.md) para tests de SignalR.

## HelpersBasicos

Helpers base disponibles en el proyecto de tests para todas las pruebas:

| Helper | Ubicación | Propósito |
|--------|------------|-----------|
| **IntegrationTestBase** | `Integration/Common/` | Clase base con WebApplicationFactory |
| **DatabaseHelper** | `Integration/Common/` | Obtener conexiones y DbContext |
| **RespawnHelper** | `Integration/Common/` | Limpieza de BD entre tests |
| **TestContainerHelper** | `Integration/Common/` | Gestión de Docker/SQL Server |
| **E2eContainerHelper** | `E2E/Common/` | Gestión de contenedores E2E (SQL Server + API + Frontend + Nginx) |
| **PlaywrightTestBase** | `E2E/Common/` | Clase base para tests E2E con Playwright (browser lifecycle) |

## Patron de dependencia de arquitectura de pruebas

Para garantizar la estabilidad y el aislamiento de los tests de integración, se debe seguir estrictamente este esquema de jerarquía y flujo de inicialización.

### 1. Jerarquía de Ejecución
1.  **Infraestructura (Nivel 0):** `TestContainerHelper`. Es el cimiento que levanta Docker (SQL Server). Debe inicializarse antes que cualquier componente dependiente de la base de datos.
2.  **Hosting (Nivel 1):** `WebApplicationFactory`. Levanta la API en memoria. Depende de la conexión provista por el Nivel 0.
3.  **Orquestación (Nivel 2):** **Clase de Prueba**. Hereda de `IClassFixture<TFactory>`. Es la encargada de asegurar que el entorno esté listo en su constructor.
4.  **Soporte (Nivel 3):** `Factories` (Generación de datos via Bogus) y `DatabaseHelper` (Consultas SQL directas para validación).

### 2. Ejemplo de Implementación (Patrón Constructor)
Toda prueba de integración debe inicializar el contenedor y resetear la base de datos (limpieza + seed) directamente en el constructor para asegurar un estado limpio:

```csharp
public class RegistrarClaseProgramadaTests : IClassFixture<ClasesApiWebApplicationFactory<Program>>
{
    private readonly ClasesApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public RegistrarClaseProgramadaTests(ClasesApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        
        // ORDEN CRÍTICO:
        // 1. Asegurar que el contenedor Docker esté arriba
        TestContainerHelper.InitializeAsync().GetAwaiter().GetResult();
        
        // 2. Limpiar tablas y ejecutar Seed Data
        TestContainerHelper.ResetDatabaseAsync().GetAwaiter().GetResult();
    }
}
```

### 3. Uso de Componentes
*   **`ClaseFactory`**: Único punto de verdad para la creación de objetos de prueba (`Clase` o `DTOClase`) usando Bogus. Evita la creación manual de DTOs en las pruebas.
*   **`AuthenticateAsync`**: Método del factory para obtener tokens JWT válidos según el rol necesario (ej. `empleado`).
*   **`DatabaseHelper`**: Utilizado exclusivamente en la fase de **Assert** para realizar `SELECT` directos y confirmar que los cambios del API se impactaron correctamente en el almacenamiento físico.

## Patrón de Tests Unitarios para Validaciones de Controladores

### Por qué se usa ModelState.AddModelError()

En tests unitarios de controladores ASP.NET Core, **SIEMPRE** debemos usar `_sut.ModelState.AddModelError()` para simular errores de validación. Esto ocurre porque:

1. **[ApiController]** valida automáticamente el modelo en requests HTTP reales
2. **Tests unitarios** llaman el método del controller directamente, saltando el pipeline de ASP.NET
3. Por lo tanto, la validación automática **NO ocurre** en tests unitarios

### Patrón Correcto

```csharp
[Fact]
public async Task WhenUsuarioIDIsNull_ReturnsBadRequest()
{
    // Arrange - usar factory para crear objeto
    var request = new ConsultarRutinasRequest { UsuarioID = null };
    
    // IMPORTANTE: Simular error de validación
    _sut.ModelState.AddModelError("UsuarioID", "El ID de usuario es requerido");

    // Act
    var result = await _sut.obtenerRutinasDeUusario(request);

    // Assert
    result.Should().BeOfType<BadRequestObjectResult>();
}
```

### No usar:
- ❌ Intentar que el controller valide automáticamente en tests unitarios
- ❌ Crear objetos con valores inválidos y esperar que ASP.NET valide

### Referencia:
- **Ejemplo completo:** `GymWebApp.Tests/Unit/Rutinas/ConsultarRutinasValidationTests.cs`
- **Patrón base:** `GymWebApp.Tests/Unit/Clases/InscribirAClaseUnitTests.cs` (líneas 72-73)

## SignalR Hub Testing

Para tests de integración de SignalR Hubs, se utiliza el patrón `SignalRIntegrationTestBase` con tipado correcto.

> **Nota importante**: Los ejemplos en esta sección son **conceptuales**, no literales. Adaptar según las necesidades específicas del test.

### Archivos de Referencia

| Archivo | Descripción |
|---------|-------------|
| [signalRIntegrationTestStrategy.md](../extraContext/ejemplosArquitecturaYCodigoGenerales/signalRIntegrationTestStrategy.md) | Guía completa de testing de SignalR Hubs |
| [signalRHubTestExample.md](../extraContext/ejemplosArquitecturaYCodigoGenerales/signalRHubTestExample.md) | Ejemplo completo de test class SignalR |
| [SignalRIntegrationTestBase.cs](../GymWebApp.Tests/Integration/Common/SignalRIntegrationTestBase.cs) | Implementación real de la clase base |

### Typing Correcto

Ver [signalRIntegrationTestStrategy.md](../extraContext/ejemplosArquitecturaYCodigoGenerales/signalRIntegrationTestStrategy.md) para el patrón correcto de tipado.

### Requisitos para Tests de SignalR

1. **Heredar de `SignalRIntegrationTestBase`** - Proporciona métodos para crear conexiones Hub
2. **Usar `CitasApiWebApplicationFactory<Program>`** - Tipado explícito con la clase Program
3. **Inicializar servidor antes de acceder a Server**: `_factory.CreateClient()` antes de `_factory.Server`
4. **IAsyncLifetime ya implementado**: `IntegrationTestBase` ya implementa `IAsyncLifetime`, no duplicar en clases derivadas
5. **Implementar `GetHubName()`**: Cada clase de test debe especificar su nombre de hub

### Estructura de un Test de SignalR

Ver [signalRHubTestExample.md](../extraContext/ejemplosArquitecturaYCodigoGenerales/signalRHubTestExample.md) para un ejemplo completo de test class.

### InvokeAsync Pattern

Ver [signalRHubTestExample.md](../extraContext/ejemplosArquitecturaYCodigoGenerales/signalRHubTestExample.md#invokeasync-pattern) para el patrón de invocación de métodos del hub.

## Ejemplo de relaciones

Ver [extraContext/skillsUsageInstructions.md] para ver cómo se relacionan los skills entre sí.

## Comandos de tests

```bash
# Ejecutar todos los tests
dotnet test

# Ejecutar tests de integración
dotnet test --filter "FullyQualifiedName~Integration"

# Ejecutar tests E2E
dotnet test --filter "FullyQualifiedName~E2E"

# Ejecutar un test específico
dotnet test --filter "FullyQualifiedName~Namespace.Clase.Metodo"

# Ejecutar con coverage
dotnet test --collect:"XPlat Code Coverage"
```
