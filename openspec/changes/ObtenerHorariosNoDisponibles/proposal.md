# Proposal: `ObtenerHorariosNoDisponibles`

## Intent

Evitar que tests de integración fallen al elegir fechas para horarios disponibles porque caen en días festivos, feriados variables, fechas con clases ya programadas o pre-reservas activas. Al conocer de antemano qué fechas están bloqueadas, los tests pueden elegir fechas seguras sin riesgo de error.

## Scope

### In Scope
- Nuevo método público `ObtenerHorariosNoDisponibles(string connectionString)` en `InscripcionTestHelper`
- Consulta SQL unificada de 4 fuentes de fechas bloqueadas
- Retorno como `HashSet<DateOnly>` para uso eficiente en tests
- Uso de `DatabaseHelper.ExecuteQueryAsync` (mismo patrón que métodos existentes)

### Out of Scope
- No modifica métodos existentes
- No crea nuevos helpers
- No cambia la BD ni SPs existentes
- No afecta el comportamiento de `sp_obtenerHorariosDisponibles`

## Approach

Un único método que ejecuta una query SQL con `UNION` de 4 fuentes:

| Fuente | Tabla/Función | Columna fecha |
|--------|---------------|---------------|
| Festivos fijos | `diasFestivosYDescansos` WHERE estado = 'no se labora' | `fechaFestivaODescanso` |
| Festivos variables | `fn_obtenerDiasFestivosVariablesActuales(@anio)` (ya existe en BD) | `fechaExacta` |
| Clases programadas | `clasesProgramadas` (fechas distintas) | `fechaDeLaClase` |
| Pre-reservas | `preReservasDeHorario` (fechas distintas) | `fechaDeLaClase` |

Para festivos variables se usa la función existente `fn_obtenerDiasFestivosVariablesActuales(YEAR(GETDATE()))` que ya resuelve los patrones a fechas concretas. Se consultan año actual y siguiente para cubrir todo el rango útil.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `GymWebApp.Tests/Integration/Helpers/InscripcionTestHelper.cs` | Modified | Nuevo método público agregado |
| `openspec/changes/ObtenerHorariosNoDisponibles/` | New | Artifacts SDD |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Función `fn_obtenerDiasFestivosVariablesActuales` no existe en BD de test | Low | Ya existe en el esquema; es consulta de solo lectura |
| UNION devuelva fechas duplicadas | None | `HashSet<DateOnly>` maneja duplicados; `UNION` en SQL ya los elimina |
| Performance con muchas fechas | Low | Solo son consultas SELECT, sin escrituras, sobre tablas indexadas |

## Rollback Plan

Eliminar el método de `InscripcionTestHelper.cs`. No hay otras dependencias.

## Dependencies

- Función BD `fn_obtenerDiasFestivosVariablesActuales` debe existir en la BD de test
- `DatabaseHelper.ExecuteQueryAsync` para consultas SQL

## Success Criteria

- [ ] Método compila y retorna `HashSet<DateOnly>` con fechas de las 4 fuentes
- [ ] Tests existentes pasan sin cambios
- [ ] Las fechas devueltas incluyen días festivos conocidos, fines de semana con estado 'no se labora', fechas con clases programadas y pre-reservas
