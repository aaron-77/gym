# Design: `ObtenerHorariosNoDisponibles`

## Resumen técnico

Método estático que ejecuta una única consulta SQL unificando 4 fuentes de fechas bloqueadas y retorna un `HashSet<DateOnly>` para que los tests puedan evaluar membresía en O(1).

## Arquitectura

```
[Test]
    → InscripcionTestHelper.ObtenerHorariosNoDisponibles(connectionString, anio)
        → DatabaseHelper.ExecuteQueryAsync(sql, @Anio)
            → SQL Server: UNION ALL (4 fuentes) + SELECT DISTINCT externo
                → diasFestivosYDescansos (festivos fijos)
                → fn_obtenerDiasFestivosVariablesActuales (festivos variables)
                → clasesProgramadas.fechaDeLaClase
                → preReservasDeHorario.fechaDeLaClase
        → Mapper: row → DateOnly
        → return HashSet<DateOnly>
```

## Decisiones técnicas

### 1. Única query vs múltiples queries
Se usa **una sola query con UNION ALL** porque:
- Menos round-trips a BD (crítico con TestContainers en Docker)
- SQL Server optimiza el plan completo
- Código más simple en C# (un solo ExecuteQueryAsync + un mapper)

### 2. UNION ALL + SELECT DISTINCT vs UNION
Se usa **UNION ALL** (concatena sin dedup) + **SELECT DISTINCT** externo porque:
- UNION hace sort implícito por cada sub-query para eliminar duplicados
- UNION ALL solo concatena, el DISTINCT final es un solo sort
- Más eficiente con múltiples fuentes

### 3. No incluir festivos variables de año siguiente
Se recibe `anio` como parámetro explícito. El test decide qué año(s) consultar.
Si necesita cubrir año actual + siguiente, el test llama al método dos veces y unifica.

### 4. HashSet<DateOnly> como tipo de retorno
- `DateOnly` porque SQL almacena fechas sin hora
- `HashSet` porque el principal uso es `fechasNoDisponibles.Contains(fecha)` — O(1)
- Inmutable desde afuera (el caller no debería modificarlo)

## Código

```csharp
/// <summary>
/// Obtiene todas las fechas no disponibles para un año dado, combinando:
/// - Días festivos fijos (diasFestivosYDescansos, estado 'no se labora')
/// - Días festivos variables calculados para el año
/// - Fechas con clases programadas (clasesProgramadas)
/// - Fechas con pre-reservas activas (preReservasDeHorario)
/// Útil para que tests de integración determinen rápidamente qué fechas evitar.
/// </summary>
/// <param name="connectionString">Connection string de la BD de pruebas.</param>
/// <param name="anio">Año para el cual calcular días festivos variables.</param>
/// <returns>HashSet con las fechas no disponibles.</returns>
public static async Task<HashSet<DateOnly>> ObtenerHorariosNoDisponibles(
    string connectionString,
    int anio)
{
    const string sql = @"
        SELECT DISTINCT Fecha FROM (
            SELECT CAST(fechaFestivaODescanso AS DATE) AS Fecha
            FROM dbo.diasFestivosYDescansos dfd
            INNER JOIN dbo.estadosDeActividadLaboral eal
                ON dfd.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
            WHERE eal.nombreEstadoActividadLaboral = 'no se labora'

            UNION ALL

            SELECT CAST(fechaExacta AS DATE) AS Fecha
            FROM dbo.fn_obtenerDiasFestivosVariablesActuales(@Anio)

            UNION ALL

            SELECT DISTINCT CAST(fechaDeLaClase AS DATE) AS Fecha
            FROM dbo.clasesProgramadas
            WHERE fechaDeLaClase IS NOT NULL

            UNION ALL

            SELECT DISTINCT CAST(fechaDeLaClase AS DATE) AS Fecha
            FROM dbo.preReservasDeHorario
            WHERE fechaDeLaClase IS NOT NULL
        ) AS Fuentes";

    var rows = await DatabaseHelper.ExecuteQueryAsync(
        connectionString,
        sql,
        new Dictionary<string, object?> { ["@Anio"] = anio });

    var result = new HashSet<DateOnly>();
    foreach (var row in rows)
    {
        if (row["Fecha"] is DateTime fecha)
        {
            result.Add(DateOnly.FromDateTime(fecha));
        }
    }

    return result;
}
```

## Orden de inserción en InscripcionTestHelper

El método debe agregarse **antes de `BulkSeedFreshInscripcionAsync`** y después de los campos/helpers privados, siguiendo el orden lógico:
1. Métodos públicos de consulta (como `GetClienteSinInscripcionesVigentesAsync`)
2. Este nuevo método de consulta
3. Métodos que hacen seed/escritura (como `BulkSeedFreshInscripcionAsync`)

## Flujo de datos

```
Entrada: connectionString, anio
  ↓
ExecuteQueryAsync → SQL Server
  ↓
Executes 4 sub-queries UNION ALL
  ↓
SELECT DISTINCT externo elimina duplicados
  ↓
Filas: { Fecha: DateTime }
  ↓
Mapper: DateTime → DateOnly → HashSet<DateOnly>
  ↓
Salida: HashSet<DateOnly>
```

## Casos borde

| Caso | Comportamiento |
|------|---------------|
| No hay festivos ni clases ni pre-reservas | HashSet vacío |
| Un año sin festivos variables registrados | fn_obtenerDiasFestivosVariablesActuales retorna vacío |
| Fecha NULL en clasesProgramadas | Filtrada por WHERE fechaDeLaClase IS NOT NULL |
| Fecha NULL en preReservasDeHorario | Filtrada por WHERE fechaDeLaClase IS NOT NULL |
| Misma fecha en múltiples fuentes | SELECT DISTINCT la deja una sola vez |
| `row["Fecha"]` no es DateTime | Se omite (no debería ocurrir con CAST a DATE) |

## Archivo de salida

| Archivo | Acción |
|---------|--------|
| `GymWebApp.Tests/Integration/Helpers/InscripcionTestHelper.cs` | Agregar método público |
