# Tasks: SeedFallbackConHorariosNoDisponibles

## Dependencias

- Spec: `openspec/changes/SeedFallbackConHorariosNoDisponibles/specs/seed-fallback-gaps/spec.md`
- Design: `openspec/changes/SeedFallbackConHorariosNoDisponibles/design.md`

## Review Workload Forecast

- Archivos modificados: 6
- Archivos nuevos: 0
- Líneas estimadas: ~200-300
- 400-line budget risk: **Low**
- Chained PRs recommended: **No**

## Task Checklist

### 1. Modificar HorariosHelper.cs

- [ ] **1.1** En `ObtenerHorariosDisponiblesFiltrados`: cambiar `var hoy = DateTime.Today` por `var fechaRef = fecha?.Date ?? DateTime.Today` en el switch de filtro de fecha
- [ ] **1.2** En `ObtenerUnHorarioDisponible`: cambiar retorno de `(DateOnly FechaDisponible, int IdHora)` a `(DateOnly FechaDisponible, int IdHora)?`
- [ ] **1.3** En `ObtenerUnHorarioDisponible`: reemplazar `throw InvalidOperationException` por `return null`

### 2. Modificar InscripcionTestHelper.cs — Seeds a nullable

- [ ] **2.1** `SeedSingleInscripcionConHoraFuturaAsync`: cambiar retorno a `(string, int)?`, propagar null desde `ObtenerUnHorarioDisponible`
- [ ] **2.2** `SeedSingleInscripcionConFechaPosteriorAsync`: cambiar retorno a `(string, int)?`, reemplazar throw por `return null`
- [ ] **2.3** `SeedSingleInscripcionConFechaYHoraPosterioresAsync`: cambiar retorno a `(string, int)?`, propagar null
- [ ] **2.4** `SeedSingleInscripcionConFechaMayorIgualSinFiltroHoraAsync`: cambiar retorno a `(string, int)?`, propagar null
- [ ] **2.5** `SeedSingleInscripcionConFechaIgualSinFiltroHoraAsync`: cambiar retorno a `(string, int)?`, propagar null
- [ ] **2.6** `SeedSingleInscripcionWithClientAsync`: cambiar retorno a `(string, int)?`, propagar null
- [ ] **2.7** `CreateValidDestinationClassForReagendarAsync`: cambiar retorno a `int?`, propagar null
- [ ] **2.8** `SeedFreshInscripcionAsync`: cambia porque delega en `SeedSingleInscripcionConHoraFuturaAsync` → retornar `(string, int)?`
- [ ] **2.9** `SeedFreshInscripcionAndReturnIdAsync`: cambia porque delega en `SeedFreshInscripcionAsync` → retornar `(string, int)?`

### 3. Agregar FindAvailableDateGapAsync en InscripcionTestHelper.cs

- [ ] **3.1** Implementar método `FindAvailableDateGapAsync(HashSet<DateOnly> fechasOcupadas, int rangoDias = 365)`
  - Calcular límite superior sin cruzar año
  - Iterar desde hoy hasta límite recolectando fechas no ocupadas
  - Seleccionar aleatoria de las disponibles
  - Retornar null si no hay gaps

### 4. Agregar SeedFallbackAsync en InscripcionTestHelper.cs

- [ ] **4.1** Implementar método `SeedFallbackAsync(string connectionString, int anio, int rangoDias = 365)`
  - Calcular rango efectivo limitado a fin de año
  - Llamar `ObtenerHorariosNoDisponibles(connectionString, anio)`
  - Llamar `FindAvailableDateGapAsync(fechas, rangoEfectivo)`
  - Si hay gap, verificar con `ObtenerHorariosDisponibles(connectionString, gapDate)`
  - Retornar gap verificado o null

### 5. Modificar ClasesProgramadasHelper.cs

- [ ] **5.1** `RegistrarClaseProgramadaActual`: manejar el nullable de `ObtenerUnHorarioDisponible` (propagar con throw con mensaje claro o retornar nullable — según conveniencia del helper)

### 6. Modificar tests

- [ ] **6.1** `ServiceConsultarInscripcionesDeClienteIntegrationTests.cs`:
  - L51: agregar null-check + fallback + reintento
  - L155: agregar null-check + fallback + reintento
- [ ] **6.2** `ServiceReagendarInscripcionTests.cs`:
  - L37: null-check + fallback + reintento
  - L168, 220: `CreateValidDestinationClassForReagendarAsync` → null-check
  - L236, 253: `SeedFreshInscripcionAndReturnIdAsync` → null-check + fallback
  - L312: null-check + fallback + reintento
- [ ] **6.3** `ServiceCancelarInscripcionTests.cs`:
  - L36: null-check + fallback + reintento

## Orden de Implementación

1. **Task 1** (HorariosHelper) — prerequisito de todo lo demás
2. **Task 5** (ClasesProgramadasHelper) — usa HorariosHelper, independiente de seeds
3. **Task 2** (seeds a nullable) — prerequisito de tests
4. **Tasks 3+4** (nuevos métodos) — prerequisito de fallback en tests
5. **Task 6** (tests con fallback) — final