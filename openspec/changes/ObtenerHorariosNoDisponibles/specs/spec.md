# Spec: `ObtenerHorariosNoDisponibles`

## Descripción

Método helper en `InscripcionTestHelper` que consulta y retorna un conjunto de fechas no disponibles (bloqueadas) para un año dado, de modo que los tests de integración puedan elegir fechas seguras sin riesgo de fallar por seleccionar un día festivo, feriado variable, fecha con clase ya programada o con pre-reserva activa.

## Dependencias

- Proposal: `openspec/changes/ObtenerHorariosNoDisponibles/proposal.md`
- Función BD: `fn_obtenerDiasFestivosVariablesActuales` (debe existir en la BD de test)
- Helper: `DatabaseHelper.ExecuteQueryAsync`

## Comportamiento Esperado

### Escenario 1: Fechas de festivos fijos incluídas
**Given** que existen registros en `diasFestivosYDescansos` con `fkEstadoActividadLaboral` apuntando a 'no se labora'
**When** se ejecuta `ObtenerHorariosNoDisponibles`
**Then** las fechas de esos registros DEBEN estar en el resultado

### Escenario 2: Fechas de festivos variables del año indicado
**Given** que existen registros en `diasFestivosVariables` con estado activo
**When** se ejecuta `ObtenerHorariosNoDisponibles` con un año específico
**Then** las fechas calculadas por `fn_obtenerDiasFestivosVariablesActuales` para ese año DEBEN estar en el resultado

### Escenario 3: Fechas con clases programadas incluídas
**Given** que existen registros en `clasesProgramadas` con `fechaDeLaClase` no nula
**When** se ejecuta `ObtenerHorariosNoDisponibles`
**Then** las fechas distintas de esos registros DEBEN estar en el resultado

### Escenario 4: Fechas con pre-reservas incluídas
**Given** que existen registros en `preReservasDeHorario` con `fechaDeLaClase` no nula
**When** se ejecuta `ObtenerHorariosNoDisponibles`
**Then** las fechas distintas de esos registros DEBEN estar en el resultado

### Escenario 5: Sin fechas bloqueadas
**Given** que las 4 fuentes están vacías
**When** se ejecuta `ObtenerHorariosNoDisponibles`
**Then** el resultado DEBE ser un `HashSet<DateOnly>` vacío (Count = 0)

### Escenario 6: Fechas duplicadas entre fuentes
**Given** que una misma fecha existe en múltiples fuentes (ej: festivo fijo + clase programada)
**When** se ejecuta `ObtenerHorariosNoDisponibles`
**Then** la fecha DEBE aparecer una sola vez en el resultado

## Firma del Método

```csharp
public static async Task<HashSet<DateOnly>> ObtenerHorariosNoDisponibles(
    string connectionString,
    int anio)
```

## Query SQL

Una sola query con UNION ALL + DISTINCT externo:

```sql
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
) AS Fuentes
```

## Criterios de Aceptación

- [ ] Método público estático `async Task<HashSet<DateOnly>>`
- [ ] Parámetros: `connectionString` y `anio` (int)
- [ ] Usa `DatabaseHelper.ExecuteQueryAsync` para ejecutar la query
- [ ] No modifica BD (solo lecturas)
- [ ] Sigue el mismo patrón que otros métodos en `InscripcionTestHelper`
