# AGENTS.md - GymWebApp.Tests

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
- **Alcance**: Solo deben cubrir el **Happy Path** (casos de éxito).
- **Ubicación**: `Integration/Features/{Dominio}/`.

### Tests Unitarios
- **Propósito**: Validar lógica de negocio, manejo de errores y edge cases.
- **Alcance**: Cubren casos como 404, 500, validaciones fallidas y lógica condicional compleja.
- **Ubicación**: `Unit/{Dominio}/`.

## Reglas de Implementación de Tests

- **ESTRICTAMENTE SEGÚN SPEC**: Solo se deben implementar las pruebas definidas explícitamente en la especificación. No se acepta ninguna prueba que no esté documentada en el spec al momento de la implementación.
- **PROHIBIDO TESTS DERIVADOS**: Bajo ninguna circunstancia se deben implementar pruebas secundarias, adicionales o "casos que se te ocurran" sin preguntar.
- **CONSULTA OBLIGATORIA**: Si identificás la necesidad de cubrir un escenario extra, debés proponerlo primero y esperar la confirmación del usuario antes de implementar.
- **NO HELPERS EN TESTS**: No escribir lógica de helper dentro de las clases de prueba. Usar clases helper existentes (DatabaseHelper, TestContainerHelper) o crear nuevas en GymWebApp.Tests/Integration/Helpers/ y llamarlas desde los tests.
- **CONSULTAR ESQUEMA DE BD**: Antes de escribir queries SQL, verificar los nombres de columnas 
  en bd/scripsOrdenadosParaMigrarBd/3tablas/tablas.sql. El esquema es la fuente de verdad.

## Directorios de Especificaciones (Requerimientos)

| Directorio | Descripción |
|------------|-------------|
| `specs/` | Especificaciones de integración (Happy Path). |
| `specs/unit/` | Especificaciones unitarias (lógica, errores, edge cases). |

## Directorios de Pruebas (Código)

| Directorio | Descripción |
|------------|-------------|
| `GymWebApp.Tests/Integration/Features/{Dominio}/` | Tests de integración (Happy Path). |
| `GymWebApp.Tests/Unit/{Dominio}/` | Tests unitarios (lógica, errores). |

## Carpetas y responsabilidades

| Carpeta | Responsabilidad |
|---------|----------------|
| `Unit/` | Tests unitarios - lógica y errores |
| `Integration/Common/` | Clases base, fixtures, helpers reutilizables |
| `Integration/Features/` | Tests de integración por dominio |
| `Integration/Factories/` | Generadores de datos con Bogus |
| `Integration/TestData/` | Datos estáticos (JSON) |

## Skills disponibles

- **Bogus Factory:** Generar datos de prueba
- **Integration Test Base:** Clases base para tests de integración
- **Test Helper:** Crear helpers con métodos estáticos
- **Respawn Helper:** Limpieza de BD entre tests
- **Database Helper:** Obtener conexiones y DbContext

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

## Ejemplo de relaciones

Ver [extraContext/skillsUsageInstructions.md] para ver cómo se relacionan los skills entre sí.

## Comandos de tests

```bash
# Ejecutar todos los tests
dotnet test

# Ejecutar tests de integración
dotnet test --filter "FullyQualifiedName~Integration"

# Ejecutar un test específico
dotnet test --filter "FullyQualifiedName~Namespace.Clase.Metodo"

# Ejecutar con coverage
dotnet test --collect:"XPlat Code Coverage"
```
