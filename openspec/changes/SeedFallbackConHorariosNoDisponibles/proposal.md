# Proposal: SeedFallbackConHorariosNoDisponibles

## Intent

Los métodos seed en helpers de tests lanzan `InvalidOperationException` cuando
`sp_obtenerHorariosDisponibles` no retorna fechas (ej: feriado, fin de semana,
todas las horas del día ya pasaron). Esto hace que tests de integración fallen
intermitentemente según el momento del día o fecha.

Necesitamos un mecanismo de resiliencia: cuando no hay slots disponibles,
el test debe poder consultar las fechas NO disponibles, detectar gaps entre
ellas, elegir una fecha alternativa, y reintentar el seed con esa fecha.

## Scope

### In Scope
- `ObtenerUnHorarioDisponible` en `HorariosHelper`: cambio a nullable return
- Métodos seed en `InscripcionTestHelper`: propagar nullable en vez de throw
- Nuevo método `FindAvailableDateGapAsync` en `InscripcionTestHelper`: lógica de gaps
- Tests que usan seeds: agregar verificación + fallback
- `ClasesProgramadasHelper.RegistrarClaseProgramadaActual`: manejar nullable

### Out of Scope
- Cambiar la lógica de `sp_obtenerHorariosDisponibles`
- Modificar seeds que NO usan `ObtenerUnHorarioDisponible` (BulkSeedFreshInscripcionAsync, InscripcionEndpointHelper)
- Crear tests nuevos — solo modificar existentes

## Capabilities

### New Capabilities
- `seed-fallback-gaps`: Mecanismo para encontrar fechas disponibles alternativas
  cuando el SP no retorna resultados, basado en gaps del set de no-disponibles

### Modified Capabilities
- None (cambios a nivel de helpers/test infrastructure, no specs funcionales)

## Approach

1. **`HorariosHelper.ObtenerHorariosDisponiblesFiltrados`**:
   - Cambiar `var hoy = DateTime.Today` por `var fechaReferencia = fecha?.Date ?? DateTime.Today`
   - Cuando se pasa `fechaReferencia`, el filtro compara contra ESA fecha, no contra hoy
   - Sin `fecha` (default null), el comportamiento es idéntico al actual

2. **`HorariosHelper.ObtenerUnHorarioDisponible`**:
   - Firma actual: `Task<(DateOnly, int)>` → cambiar a `Task<(DateOnly, int)?>`
   - En vez de throw `InvalidOperationException`, retornar `null`

3. **Métodos seed en `InscripcionTestHelper`** (7 métodos):
   - Cambiar retorno de `(string, int)` a `(string, int)?`
   - No lanzar excepción, retornar `null`
   - Afecta: `SeedSingleInscripcionConHoraFuturaAsync`, `SeedSingleInscripcionConFechaYHoraPosterioresAsync`, `SeedSingleInscripcionConFechaMayorIgualSinFiltroHoraAsync`, `SeedSingleInscripcionConFechaIgualSinFiltroHoraAsync`, `SeedSingleInscripcionWithClientAsync`, `CreateValidDestinationClassForReagendarAsync`, `SeedFreshInscripcionAsync` / `SeedFreshInscripcionAndReturnIdAsync`
   - `SeedSingleInscripcionConFechaPosteriorAsync`: cambiar throw por retorno `null`

4. **Nuevo método `FindAvailableDateGapAsync`** en `InscripcionTestHelper`:
   - Firma: `Task<DateOnly?>(HashSet<DateOnly> fechasOcupadas, int rangoDias = 365)`
   - LOGICA PURA EN MEMORIA: itera desde hoy hasta hoy+rangoDias
   - Por cada fecha, verifica si NO está en `fechasOcupadas` (HashSet, O(1))
   - Selecciona una aleatoria de los gaps disponibles
   - Retorna `null` solo si TODO el rango está ocupado

5. **Nuevo método `SeedFallbackAsync`** en `InscripcionTestHelper`:
   - Firma: `Task<DateOnly?>(string connectionString, int anio, int rangoDias = 365)`
   - Llama `ObtenerHorariosNoDisponibles(connectionString, anio)` para el año actual
   - Limita el rango para NO cruzar de año: `min(rangoDias, diasRestantesHastaFinDeAnio)`
   - Pasa el HashSet a `FindAvailableDateGapAsync`
   - Si encontró fecha gap, llama `ObtenerHorariosDisponibles(connectionString, fechaGap)` para verificar
   - Retorna la fecha gap para que el test la use como `fechaReferencia`

6. **Tests afectados** (4 archivos):
   - Verificar si seed retorna null
   - Si null → llamar a `SeedFallbackAsync`
   - Usar fecha retornada como `fechaReferencia` en el reintento al mismo seed
   - El filtro `Igual` ahora funciona porque usa `fechaReferencia`, no `DateTime.Today`

7. **`ClasesProgramadasHelper.RegistrarClaseProgramadaActual`**: manejar nullable

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `HorariosHelper.cs` | Modified | `ObtenerUnHorarioDisponible` → nullable return |
| `InscripcionTestHelper.cs` | Modified | 7 seed methods + nuevo método de fallback |
| `ClasesProgramadasHelper.cs` | Modified | `RegistrarClaseProgramadaActual` maneja null |
| `ServiceConsultarInscripcionesDeClienteIntegrationTests.cs` | Modified | Check null + fallback |
| `ServiceReagendarInscripcionTests.cs` | Modified | Check null + fallback |
| `ServiceCancelarInscripcionTests.cs` | Modified | Check null + fallback |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| `SeedFreshInscripcionAndReturnIdAsync` delega en `SeedFreshInscripcionAsync` que delega en `SeedSingleInscripcionConHoraFuturaAsync` — cascada de nullable | Low | Cambiar solo el método base, los delegados propagan |
| Tests que deconstruyen tupla existente sin nullable no compilan | Medium | El compilador ataja todos los casos |
| FindAvailableDateGapAsync retorna null si TODO está ocupado | Low | El test puede fallar con mensaje claro |

## Rollback Plan

Revert commits individualmente por archivo. Los cambios son atómicos por helper:

1. `HorariosHelper.cs` → cambio de firma
2. `InscripcionTestHelper.cs` → seeds + fallback
3. `ClasesProgramadasHelper.cs` → nullable
4. Tests → adaptación

## Dependencies

- Ninguna externa. Solo cambios en helpers de tests.

## Success Criteria

- [ ] `ObtenerUnHorarioDisponible` retorna `null` cuando no hay slots (no lanza excepción)
- [ ] Todos los seeds propagan el `null` correctamente
- [ ] `FindAvailableDateGapAsync` encuentra gaps y retorna fecha válida
- [ ] Tests con fallback reintentan exitosamente
- [ ] `dotnet test --filter "FullyQualifiedName~Integration"` pasa