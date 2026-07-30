# Design: Filtrar horas pasadas en sp_obtenerHorariosDisponibles

## Technical Approach

Modificar el CTE `AllSlots` del SP existente agregando una condición que compare `horaInicio` contra la hora actual, usando dos variables `DECLARE` al inicio del SP para evitar evaluaciones repetidas de `GETDATE()`.

Esto se alinea con el approach del proposal y los escenarios del spec (Req 1 y 2 del delta).

## Architecture Decisions

| Opción | Tradeoff | Decisión |
|--------|----------|----------|
| **Variables al inicio vs GETDATE() inline en WHERE** | Inline evalúa GETDATE() por cada fila del CTE. `DECLARE` evalúa una vez → consistencia + mínima ganancia de perf. | **DECLARE @hoy, @horaActual** al inicio |
| **`>` vs `>=`** | `>` excluye el slot cuya horaInicio coincide exactamente con @horaActual. `>=` lo incluye. | **Usar `>`** — si la hora ya inició, se considera no disponible. El slot de las 15:30 NO se incluye si son las 15:30 |
| **Precisión de TIME** | `horasLaborales.horaInicio` es `TIME(7)` (por defecto). `CAST(GETDATE() AS TIME)` incluye milisegundos → el slot de las 15:30:00 queda excluido si @horaActual tiene ms. | **`CAST(GETDATE() AS TIME(0))`** — trunca a segundos, igual que la precisión real de horaInicio en datos cargados |
| **GETDATE() vs GETUTCDATE()** | GETDATE() = hora local del server. GETUTCDATE() = UTC independiente de zona. | **GETDATE()** — el sistema opera en hora local del server (Argentina), y ya existe ese patrón en el SP |
| **Filtro en CTE AllSlots vs en SELECT final** | En AllSlots elimina filas temprano en el pipeline. En SELECT final filtra después de la exclusión de ocupados. | **CTE AllSlots** — más eficiente, reduce filas antes de las uniones con OccupiedSlots |

## Data Flow

```
Inicio SP
  │
  ├─ DECLARE @hoy DATE = CAST(GETDATE() AS DATE)
  ├─ DECLARE @horaActual TIME(0) = CAST(GETDATE() AS TIME(0))
  │
  ├─ WITH FechasDelMes AS ( ... )
  │
  ├─ AllSlots AS (                        ← Filtro AGREGADO aquí
  │     SELECT ...
  │     FROM FechasDelMes f
  │     CROSS JOIN horasLaborales hl
  │     WHERE f.Fecha >= @Fecha           ← Rango desde @Fecha (parámetro)
  │       AND (f.Fecha <> @hoy            ← ← NUEVO: fechas ≠ hoy pasan sin filtro
  │            OR hl.horaInicio > @horaActual)  ← NUEVO: hoy, filtro de hora
  │  )
  │
  ├─ OccupiedByProgramadas / PreReservas / Holidays (sin cambios)
  ├─ OccupiedSlots (UNION de todos los ocupados)
  │
  └─ SELECT AllSlots EXCEPT OccupiedSlots (sin cambios)
```

## Lógica del filtro detallada

- **`f.Fecha >= @Fecha`** → arranca desde la fecha de referencia (el parámetro o hoy si NULL)
- **`f.Fecha <> @hoy`** → cualquier fecha que NO sea hoy pasa sin filtro de hora (short-circuit OR)
- **`hl.horaInicio > @horaActual`** → solo se evalúa cuando `f.Fecha = @hoy`: pasa si la hora NO ha iniciado
- **Combinación**: `f.Fecha >= @Fecha` + nueva condición:
  - Si `f.Fecha = @hoy` (hoy) → depende de `horaInicio > @horaActual`
  - Si `f.Fecha <> @hoy` (pasado O futuro) → `TRUE` directo, pasan todas las horas

## Edge Cases

| Caso | Análisis |
|------|----------|
| **Hora exacta 15:30:00.000** | Con `>` se excluye. El slot de 15:30 NO aparece porque la hora ya inició. Correcto por requerimiento. |
| **Hora con milisegundos (15:30:00.123)** | `TIME(0)` trunca a `15:30:00`. El slot de 15:30 se excluye (correcto: ya pasaron 123ms desde que inició). |
| **Medianoche (00:00:00)** | `@horaActual` = `00:00:00`. Slots con `horaInicio >= 00:00:00` = todos. Correcto: es temprano, ningún slot venció. |
| **Slot a las 23:59, son las 23:58** | Con `>=`, el slot de 23:59 se incluye. Correcto: todavía no venció. |
| **Diferencia entre DECLARE y WHERE inline** | Se calcula UNA VEZ al inicio del SP. No hay deriva temporal dentro de la misma ejecución. |
| **Zona horaria del server** | GETDATE() = hora local. Si el server cambia de zona, el comportamiento cambia. Actualmente es Argentina Time (UTC-3). |

## File Changes

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `bd/scripsOrdenadosParaMigrarBd/10procedimientos/sqlServer/sp_obtenerHorariosDisponibles.sql` | Modificar | +2 DECLARE, +1 línea en WHERE de AllSlots |
| `specs/06-horarios-disponibles.md` | Modificado (ya hecho) | Req 13 agregado con escenarios de filtro horario |

## SP modificado (cambios marcados)

```sql
CREATE PROCEDURE [dbo].[sp_obtenerHorariosDisponibles]
    @Fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- ▼▼▼ NUEVO: variables de tiempo para filtro de hora ▼▼▼
    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @horaActual TIME(0) = CAST(GETDATE() AS TIME(0));
    -- ▲▲▲ FIN NUEVO ▲▲▲

    SET @Fecha = ISNULL(@Fecha, @hoy);  -- usa @hoy en vez de CAST(GETDATE()...)

    WITH FechasDelMes AS ( ... ),  -- sin cambios

    AllSlots AS (
        SELECT ...
        FROM FechasDelMes f
        CROSS JOIN dbo.horasLaborales hl
        WHERE f.Fecha >= @Fecha      -- rango desde @Fecha
          -- ▼▼▼ NUEVO: filtrar horas vencidas solo del día actual ▼▼▼
          AND (f.Fecha <> @hoy OR hl.horaInicio > @horaActual)
          -- ▲▲▲ FIN NUEVO ▲▲▲
    ),

    -- El resto del SP sin cambios
    ...
```

## Impacto en plan de ejecución

Mínimo. Es un filtro adicional en el mismo CTE `AllSlots`. El optimizador de SQL Server puede usar el predicado para reducir filas antes de las siguientes CTEs, lo cual es beneficioso. No se agregan índices nuevos ni joins.

## Testing Strategy

| Tipo | Qué probar | Cómo |
|------|-----------|------|
| **Unitario (SP)** | Hoy a las X horas, slots antes de X NO se devuelven | Ejecutar SP sin parámetros, verificar exclusión de horas vencidas |
| **Unitario (SP)** | Hoy a las X horas, slots desde X en adelante SÍ se devuelven | Verificar inclusión del slot en hora actual |
| **Unitario (SP)** | Fecha futura, todos los slots se devuelven | Ejecutar con `@Fecha = tomorrow`, verificar que hay slots en todas las horas |
| **Unitario (SP)** | Fecha del mes pasado, resultado vacío | Regresión: debe seguir vacío |
| **Integración (API)** | Endpoint sin fecha, horas vencidas excluidas | Llamar API, verificar payload |
| **Integración (API)** | Endpoint con fecha futura, todas las horas incluidas | Llamar API con ?fecha=<future>, verificar payload |

## Open Questions

Ninguna. Decisiones resueltas:
- `>` (estricto): si la hora ya inició, se considera no disponible → se excluye el slot de la hora actual
- `TIME(0)`: las horas son exactas sin fracciones, precisión correcta
