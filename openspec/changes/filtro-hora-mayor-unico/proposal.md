# Proposal: Filtro hora único (filtro-hora-mayor-unico)

## Intent

El E2E `Reagendar_InscripcionValida_RetornaExito` falla intermitente con "no se puede reagendar una clase que ya empezó". Causa raíz: los seeds eligen slots con margen de 1-2 min (ej. 19:58 → slot 20:00) porque `HorariosHelper.ObtenerHorariosDisponiblesFiltrados` usa referencia de hora con precisión de HORA (floor `TimeSpan(Hour,0,0)`), mientras el validador de negocio compara con precisión completa (`horaInicio <= DateTime.Now`). El SP ya excluye horas pasadas con precisión de segundos (línea 37) — el truncado vive solo en el helper C#. Fix: un único filtro de hora (`Mayor`) con referencia ceil + guard de fin de jornada → margen garantizado de ~1h.

## Scope

### In Scope

1. **Limpiar enum `FiltroHora`** (`BL/Utils/Enums/FiltroHorarioEnums.cs:20-30`): eliminar `Igual` y `MayorIgual` (solo quedan `Mayor` y `SinFiltro`); quitar casos del switch en `HorariosHelper.cs` (líneas 78-81 y 86-89); migrar el único caller de `Igual` (`ClasesProgramadasHelper.cs:317` `RegistrarClaseProgramadaActual`) a `Mayor` SIN renombrar el método — "Actual" refiere a la fecha actual (hoy), no a la hora puntual, así que el nombre sigue siendo correcto al migrar a `Mayor`. Verificado: `Igual` y `MayorIgual` no tienen más callers en el repo.
2. **Ceil a próxima hora completa** en `HorariosHelper.cs:74`: si minutos/segundos > 0, la referencia pasa a la siguiente hora completa (16:35 → 17:00). Garantiza ~1h de margen para `FiltroHora.Mayor`.
3. **Guard de fin de jornada**: consultar MIN/MAX(`horaInicio`) de `horasLaborales` (patrón ya existente en `InscripcionTestHelper.GetMaxHoraInicioAsync`, línea 1034); si la referencia > última hora laboral → referencia = primera hora laboral del día siguiente.

### Out of Scope

- `BL/Validaciones/ValidadorFechasInscripcionesYClasesProgramadas.cs` — CORRECTO, no se toca.
- Lógica de negocio de producción (API/BL services).
- `sp_obtenerHorariosDisponibles.sql` — ya excluye horas pasadas de hoy (línea 37).
- NO forzar fechas futuras en tests que ejercitan la fecha actual intencionalmente.
- NO remover el fallback E2E existente (`InscripcionesReagendarE2ETests.cs:177-202`; puede volverse redundante — se evalúa luego).
- Enum `FiltroFecha` — fuera de alcance.

## Capabilities

### New Capabilities

None — refactor de infraestructura de tests + limpieza de enum; no introduce funcionalidad nueva.

### Modified Capabilities

None — los specs de endpoints (`06-horarios-disponibles.md` Req. 13, `10-reagendar-inscripcion.md`) describen comportamiento de producción, que NO cambia.

## Approach

1. Borrar valores del enum → enforcement en compile-time (ningún caller puede volver a usar `Igual`/`MayorIgual`); el switch queda con `Mayor` + default.
2. Reemplazar `new TimeSpan(fecha?.Hour ?? DateTime.Now.Hour, 0, 0)` por cálculo ceil: referencia = hora actual + 1h si hay minutos/segundos, sin ceil cuando minutos == 0 (mantiene referencia explícita de `fecha` intacta para fechas futuras).
3. Guard consultando `MAX(horaInicio)` (y `MIN` para el primer slot del día siguiente) vía connectionString ya disponible en el helper; aplica al shift de la referencia de hora/fecha.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `BL/Utils/Enums/FiltroHorarioEnums.cs` | Modified | Eliminar `Igual`/`MayorIgual`; actualizar XML doc de referencia horaria |
| `GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs` | Modified | Switch sin `Igual`/`MayorIgual`; ceil línea 74; guard de fin de jornada |
| `GymWebApp.Tests/SharedHelpers/ClasesProgramadasHelper.cs` | Modified | Línea 317 → `FiltroHora.Mayor`; SIN rename (el nombre "Actual" refiere a la fecha, no a la hora) |

Verificación (sin cambios): `InscripcionTestHelper.cs:401, 599, 1071` ya usan `FiltroHora.Mayor`; `SinFiltro` en E2E e integración queda intacto.

## Decision Points

- **RESUELTO — Sin rename**: `RegistrarClaseProgramadaActual` mantiene su nombre. "Actual" refiere a la FECHA actual (hoy), no a la hora puntual; al migrar a `Mayor` registra "hoy, próxima hora futura", coherente con el nombre.
- **Interacción guard ↔ `FiltroFecha.Igual`**: al saltar al día siguiente, el filtro de fecha "hoy" puede devolver vacío — resolución queda para diseño.

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Ceil rompe callers con `fecha` explícita (hora 0) | Low | Con minutos == 0 no hay ceil; revisar callers en diseño |
| Guard ↔ `FiltroFecha.Igual` devuelve vacío | Med | Callers con `SeedFallbackAsync` ya manejan null; decidir en diseño |
| Tests que ejercitan "clase actual de hoy" cambian de slot elegido | Med | Revisar cada caller migrado en diseño (solo 1) |
| Límite exacto de hora (17:00:00) | Low | Plan: ceil solo si minutos/segundos > 0 |

## Rollback Plan

Revertir los commits del cambio: restaurar enum (`Igual`/`MayorIgual`), switch y floor en `HorariosHelper`, nombre original del método. Sin migraciones ni datos que revertir; todos los callers vuelven a compilar.

## Dependencies

- E2E existente con set clock condicional (no se modifica).
- Patrón de query de horas laborales ya presente (`GetMaxHoraInicioAsync`).

## Success Criteria

- [ ] Enum `FiltroHora` expone solo `Mayor` y `SinFiltro` (compile-time)
- [ ] Switch de `HorariosHelper` sin casos `Igual`/`MayorIgual`
- [ ] `RegistrarClaseProgramadaActual` usa `Mayor` (sin rename)
- [ ] Slot elegido con `Mayor` tiene ≥ ~1h de margen respecto a la hora actual
- [ ] Con hora actual > última hora laboral, el seed apunta al día siguiente (no vacío)
- [ ] E2E `Reagendar_InscripcionValida_RetornaExito` pasa en corridas repetidas
- [ ] Validador de negocio sin cambios; tests existentes con `Mayor`/`SinFiltro` siguen verdes
