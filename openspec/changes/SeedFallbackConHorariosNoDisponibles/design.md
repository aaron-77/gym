# Design: SeedFallbackConHorariosNoDisponibles

## Dependencias

- Spec: `openspec/changes/SeedFallbackConHorariosNoDisponibles/specs/seed-fallback-gaps/spec.md`

## Decisiones Técnicas

### D1: `FindAvailableDateGapAsync` como método estático público

| Atributo | Decisión |
|----------|----------|
| Ubicación | `InscripcionTestHelper` (mismo helper que tiene `ObtenerHorariosNoDisponibles`) |
| Visibilidad | `public` (lo usan los tests) |
| Tipo | Lógica pura en memoria. NO recibe connectionString, NO toca BD |

Rationale: Es una función de búsqueda sobre un HashSet. Ponerla en el helper
evita crear un archivo nuevo solo para esto y mantiene cohesión con
`ObtenerHorariosNoDisponibles` que produce el HashSet de entrada.

### D2: `SeedFallbackAsync` como método estático público

| Atributo | Decisión |
|----------|----------|
| Ubicación | `InscripcionTestHelper` |
| Visibilidad | `public` |
| Rol | Orquestador que combina BD + FindAvailableDateGapAsync + verificación SP |

### D3: HorariosHelper.ObtenerHorariosDisponiblesFiltrados usa fechaReferencia

Cambiar filtro de fecha para que use la `fecha` recibida como parámetro
en vez de `DateTime.Today`:

```csharp
// Antes:
var hoy = DateTime.Today;

// Después:
var fechaRef = fecha?.Date ?? DateTime.Today;
```

Backward-compatible: sin fecha usa Today (mismo comportamiento).

### D4: Seeds retornan nullable ValueTuple

`(string, int)?` en C# es `Nullable<ValueTuple<string, int>>`. Los tests
que deconstruyen la tupla deben verificar null antes.

```csharp
// Antes (podía lanzar):
var (clienteId, idInscripcion) = await seedAsync(...);

// Después (nullable):
var resultado = await seedAsync(...);
if (resultado == null)
{
    var fechaFallback = await SeedFallbackAsync(...);
    resultado = await seedAsync(...);
}
var (clienteId, idInscripcion) = resultado.Value;
```

### D5: FindAvailableDateGapAsync cruce de año

Para cumplir "no cruzar año", se calcula el límite superior como
el mínimo entre hoy+rangoDias y 31-dic del año de hoy:

```csharp
var hoy = DateOnly.FromDateTime(DateTime.Today);
var finDeAnio = new DateOnly(hoy.Year, 12, 31);
var tope = DateOnly.FromDayNumber(Math.Min(
    hoy.DayNumber + rangoDias,
    finDeAnio.DayNumber));
```

Luego se itera desde hoy hasta tope.

### D6: SeedFallbackAsync limita rango por año

Usa la misma lógica de D5 para que el rango efectivo no supere fin de año.
Además, llama `ObtenerHorariosNoDisponibles` con el año de hoy, no con un
año arbitrario (simplifica y asegura cobertura).

## Arquitectura

```
Test llama seed → retorna null?
    │
    ├── No → usa resultado normalmente
    │
    └── Sí → llama SeedFallbackAsync(connStr, anio, rango)
                  │
                  ├── ObtenerHorariosNoDisponibles(connStr, anio) → HashSet<DateOnly>
                  │
                  ├── FindAvailableDateGapAsync(fechas, rango) → DateOnly?
                  │       └── Itera [hoy, min(hoy+rango, 31-dic)] buscando gaps
                  │
                  ├── gap == null → return null
                  │
                  ├── gap != null → ObtenerHorariosDisponibles(connStr, gap) 
                  │       └── ¿tiene resultados?
                  │           ├── Sí → return gap
                  │           └── No → return null  (gap no confirmado por SP)
                  │
                  └── Test recibe fecha → reintenta seed con fecha=fechaReferencia
```

## Firmas de Métodos

### FindAvailableDateGapAsync

```csharp
/// <summary>
/// Busca una fecha en el rango [hoy, hoy+rangoDias] que NO esté en fechasOcupadas.
/// No cruza el límite del año actual. Lógica pura en memoria.
/// </summary>
/// <param name="fechasOcupadas">Set de fechas no disponibles (ej: de ObtenerHorariosNoDisponibles).</param>
/// <param name="rangoDias">Cantidad de días a analizar desde hoy (default 365).</param>
/// <returns>Una fecha disponible aleatoria, o null si no hay gaps.</returns>
public static async Task<DateOnly?> FindAvailableDateGapAsync(
    HashSet<DateOnly> fechasOcupadas,
    int rangoDias = 365)
```

Nota: `async Task<>` para consistencia con el resto del helper, aunque
la lógica es 100% sincrónica (en memoria).

### SeedFallbackAsync

```csharp
/// <summary>
/// Orquesta el fallback completo: consulta fechas no disponibles, busca gaps,
/// verifica contra el SP y retorna una fecha alternativa viable.
/// </summary>
/// <param name="connectionString">Connection string de BD de pruebas.</param>
/// <param name="anio">Año para calcular días festivos variables.</param>
/// <param name="rangoDias">Rango máximo desde hoy (default 365, limitado a fin de año).</param>
/// <returns>Fecha gap confirmada por el SP, o null si no se encontró ninguna.</returns>
public static async Task<DateOnly?> SeedFallbackAsync(
    string connectionString,
    int anio,
    int rangoDias = 365)
```

### HorariosHelper.ObtenerUnHorarioDisponible (modificado)

```csharp
// Antes:
public static async Task<(DateOnly FechaDisponible, int IdHora)> ObtenerUnHorarioDisponible(...)

// Después:
public static async Task<(DateOnly FechaDisponible, int IdHora)?> ObtenerUnHorarioDisponible(...)
```

### InscripcionTestHelper seeds (modificados)

```csharp
// Antes:
public static async Task<(string ClienteId, int IdInscripcion)> SeedSingleInscripcionConHoraFuturaAsync(...)

// Después:
public static async Task<(string ClienteId, int IdInscripcion)?> SeedSingleInscripcionConHoraFuturaAsync(...)
```

Aplica a: `SeedSingleInscripcionConHoraFuturaAsync`, `SeedSingleInscripcionConFechaPosteriorAsync`,
`SeedSingleInscripcionConFechaYHoraPosterioresAsync`, `SeedSingleInscripcionConFechaMayorIgualSinFiltroHoraAsync`,
`SeedSingleInscripcionConFechaIgualSinFiltroHoraAsync`, `SeedSingleInscripcionWithClientAsync`,
`SeedFreshInscripcionAsync`, `SeedFreshInscripcionAndReturnIdAsync`.

```csharp
// CreateValidDestinationClassForReagendarAsync (retorna int, no tupla):
// Antes:
public static async Task<int> (...)
// Después:
public static async Task<int?> (...)
```

## Flujo de Test con Fallback

```
// Pattern en tests (ServiceConsultarInscripcionesDeClienteIntegrationTests, etc.)
var resultadoSeed = await InscripcionTestHelper.SeedSingleInscripcionConHoraFuturaAsync(
    TestContainerHelper.ConnectionString);

string clienteId;
int idInscripcion;

if (resultadoSeed == null)
{
    var fechaFallback = await InscripcionTestHelper.SeedFallbackAsync(
        TestContainerHelper.ConnectionString, DateTime.Today.Year);
    
    if (fechaFallback == null)
        throw new SkipTestException("No se pudo encontrar una fecha alternativa para el seed");
    
    resultadoSeed = await InscripcionTestHelper.SeedSingleInscripcionConHoraFuturaAsync(
        TestContainerHelper.ConnectionString, fechaFallback.Value.ToDateTime(TimeOnly.MinValue));
}

(clienteId, idInscripcion) = resultadoSeed.Value;
```

## Archivos Afectados

| Archivo | Cambio |
|---------|--------|
| `GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs` | `ObtenerHorariosDisponiblesFiltrados` usa `fechaReferencia`, `ObtenerUnHorarioDisponible` nullable |
| `GymWebApp.Tests/Integration/Helpers/InscripcionTestHelper.cs` | +2 métodos, 7 seeds modificados a nullable |
| `GymWebApp.Tests/SharedHelpers/ClasesProgramadasHelper.cs` | `RegistrarClaseProgramadaActual` maneja nullable |
| `GymWebApp.Tests/Integration/Features/Inscripciones/ServiceConsultarInscripcionesDeClienteIntegrationTests.cs` | Fallback en 2 tests |
| `GymWebApp.Tests/Integration/Features/Inscripciones/ServiceReagendarInscripcionTests.cs` | Fallback en 6 tests |
| `GymWebApp.Tests/Integration/Features/Inscripciones/ServiceCancelarInscripcionTests.cs` | Fallback en 1 test |

## Riesgos

| Riesgo | Mitigación |
|--------|------------|
| `(string, int)?` puede sorprender a devs acostumbrados a tuplas no-nullables | Documentar bien los XML comments |
| `FindAvailableDateGapAsync` itera hasta 365 días, O(365 * O(1)) = trivial | Medir no es necesario, es microsegundos |
| Tests pueden saltarse (skip) si no hay gaps | Mensaje claro: "No se pudo encontrar una fecha alternativa"