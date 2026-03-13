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

## Estructura de pruebas

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

## Ejemplo de relaciones

Ver [Integration/skills-usage_example.md](Integration/skills_usage_example.md) para ver cómo se relacionan los skills entre sí.

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
