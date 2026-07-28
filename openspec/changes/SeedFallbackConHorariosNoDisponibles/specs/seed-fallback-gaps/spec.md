# Spec: seed-fallback-gaps

## Description

Mecanismo de resiliencia para tests de integración: cuando los métodos seed
no encuentran horarios disponibles, un método de fallback identifica fechas
alternativas analizando gaps en el set de fechas no disponibles, las verifica
contra el SP, y retorna una fecha para reintentar.

## Dependencias

- Proposal: `openspec/changes/SeedFallbackConHorariosNoDisponibles/proposal.md`

## Scenarios

### Escenario: FindAvailableDateGapAsync encuentra gaps cuando hay fechas libres

**Cuando** se ejecuta `FindAvailableDateGapAsync` con un HashSet de fechas ocupadas
que NO cubre todo el rango solicitado

**Entonces** retorna un `DateOnly` que NO está en el HashSet de ocupadas

**Y** la fecha retornada está dentro del rango [hoy, hoy + rangoDias]

**Y** la fecha retornada NO supera el 31 de diciembre del año actual

### Escenario: FindAvailableDateGapAsync retorna null cuando todo el rango está ocupado

**Cuando** se ejecuta `FindAvailableDateGapAsync` con un HashSet que cubre
TODAS las fechas en [hoy, hoy + rangoDias]

**Entonces** retorna `null`

### Escenario: SeedFallbackAsync orquesta búsqueda y verificación exitosa

**Cuando** se ejecuta `SeedFallbackAsync`

**Entonces** consulta `ObtenerHorariosNoDisponibles` para el año recibido

**Y** pasa el resultado a `FindAvailableDateGapAsync` con el rango solicitado

**Y** limita el rango efectivo para no superar el 31 de diciembre del año actual
(`min(rangoDias, diasRestantesHastaFinDeAnio)`)

**Y** si encontró una fecha gap, verifica contra `ObtenerHorariosDisponibles`
que el SP retorne resultados para esa fecha

**Y** retorna la fecha gap verificada

### Escenario: SeedFallbackAsync retorna null sin verificar si no hay gaps

**Cuando** se ejecuta `SeedFallbackAsync`

**Y** `FindAvailableDateGapAsync` retorna `null` (todo el rango ocupado)

**Entonces** retorna `null` sin llamar a `ObtenerHorariosDisponibles`

### Escenario: SeedFallbackAsync retorna null si la verificación falla

**Cuando** se ejecuta `SeedFallbackAsync`

**Y** `FindAvailableDateGapAsync` encontró una fecha gap

**Y** `ObtenerHorariosDisponibles` retorna lista vacía para esa fecha

**Entonces** retorna `null`

### Escenario: Tests usan SeedFallbackAsync cuando seed retorna null

**Cuando** un test llama a un método seed

**Y** el seed retorna `null` (no hay horarios disponibles)

**Entonces** el test llama a `SeedFallbackAsync` para obtener una fecha alternativa

**Y** pasa la fecha retornada como `fechaReferencia` al mismo método seed

**Y** el reintento usa la fecha alternativa para encontrar slots disponibles

## Acciones que debe realizar

### FindAvailableDateGapAsync

1. Recibir `HashSet<DateOnly> fechasOcupadas` y `int rangoDias`
2. Calcular fecha límite: `hoy + rangoDias`, sin superar 31-dic del año actual
3. Recopilar fechas en [hoy, fechaLimite] que NO estén en `fechasOcupadas`
4. Si hay fechas disponibles, seleccionar una aleatoria y retornarla
5. Si no hay fechas disponibles, retornar `null`

### SeedFallbackAsync

1. Recibir `connectionString`, `anio`, `rangoDias`
2. Calcular días restantes hasta fin de año
3. Limitar rango efectivo: `min(rangoDias, diasRestantesHastaFinDeAnio)`
4. Si rango efectivo <= 0, retornar `null`
5. Consultar `ObtenerHorariosNoDisponibles(connectionString, anio)`
6. Pasar resultado a `FindAvailableDateGapAsync(fechasOcupadas, rangoEfectivo)`
7. Si retorna `null`, retornar `null`
8. Verificar: `ObtenerHorariosDisponibles(connectionString, fechaGap)` no debe ser vacío
9. Si hay resultados, retornar `fechaGap`
10. Si no hay resultados, retornar `null`