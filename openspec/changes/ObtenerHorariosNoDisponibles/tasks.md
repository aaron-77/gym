# Tasks: `ObtenerHorariosNoDisponibles`

## Review Workload Forecast

- **Estimated changed lines**: ~40 (1 file, method + doc comment)
- **400-line budget risk**: Low
- **Chained PRs recommended**: No
- **Decision needed before apply**: No

## Task List

### Phase 1: Implementation

- [ ] **1.1** Agregar método `ObtenerHorariosNoDisponibles` en `InscripcionTestHelper.cs`:
  - Firma: `public static async Task<HashSet<DateOnly>> ObtenerHorariosNoDisponibles(string connectionString, int anio)`
  - Query SQL con UNION ALL de 4 fuentes + SELECT DISTINCT externo
  - Parámetro `@Anio` para `fn_obtenerDiasFestivosVariablesActuales`
  - Usar `DatabaseHelper.ExecuteQueryAsync` para ejecutar
  - Retornar `HashSet<DateOnly>` con fechas únicas
  - Incluir XML doc comment completo

### Phase 2: Build Verification

- [ ] **2.1** Compilar el proyecto de tests para verificar que no hay errores sintácticos ni de referencias
- [ ] **2.2** Ejecutar tests existentes para asegurar que no se rompió nada

## Dependencies

- Ninguna external. Solo depende de `DatabaseHelper.ExecuteQueryAsync` (ya existe) y `fn_obtenerDiasFestivosVariablesActuales` (ya existe en BD).
