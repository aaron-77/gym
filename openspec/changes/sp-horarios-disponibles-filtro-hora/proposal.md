# Proposal: Filtrar horas pasadas en sp_obtenerHorariosDisponibles

## Intent

El SP `sp_obtenerHorariosDisponibles` filtra fechas pasadas (`WHERE f.Fecha >= CAST(GETDATE() AS DATE)`) pero NO filtra horas vencidas del día de hoy. Si son las 15:30, se muestran slots de 06:00, 07:00, etc. — horas que ya transcurrieron. Esto causa que usuarios vean y seleccionen slots imposibles, requiriendo un workaround en memoria (`HorariosHelper.cs` con `FiltroHora.MayorIgual`) que debería estar en la BD.

## Scope

### In Scope
- Modificar `sp_obtenerHorariosDisponibles` agregando condición de hora en CTE `AllSlots`
- Actualizar spec `specs/06-horarios-disponibles.md` para reflejar el nuevo filtro

### Deferred (post-change)
- Remover workaround redundante en `HorariosHelper.cs` (`FiltroHora.MayorIgual`) — fuera de alcance por ahora, no rompe nada

### Out of Scope
- Cambios en lógica de negocio (BL Managers)
- Cambios en pre-reservas o SignalR hub
- Cambios en frontend o API controllers
- Cambios en otros SPs

## Capabilities

### New Capabilities
None — es una corrección, no nueva funcionalidad.

### Modified Capabilities
- `specs/06-horarios-disponibles.md`: se actualizan requerimientos para reflejar que horarios vencidos del día actual NO se incluyen en los resultados

## Approach

Agregar en el CTE `AllSlots` del SP la condición:

```sql
AND (f.Fecha > @hoy OR hl.horaInicio > @horaActual)
```

Usando `DECLARE @hoy DATE = CAST(GETDATE() AS DATE)` y `@horaActual TIME = CAST(GETDATE() AS TIME)` declarados al inicio.

Esto elimina la necesidad del filtro en memoria en `HorariosHelper.cs`.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `bd/StoredProcedures/sp_obtenerHorariosDisponibles.sql` | Modified | Condición `AND (f.Fecha > @hoy OR hl.horaInicio > @horaActual)` en CTE AllSlots |
| `specs/06-horarios-disponibles.md` | Modified | Reflejar que past hours no se devuelven |
| `openspec/changes/sp-horarios-disponibles-filtro-hora/` | New | SDD artifacts |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Ningún caller depende de horarios vencidos | None | Verificado en exploración: todos los callers usan horarios como "disponibles ahora" |
| Diferencia de tiempo entre `@hoy`/`@horaActual` y el `GETDATE()` en WHERE | Low | Se calculan al inicio del SP con el mismo GETDATE(); diferencia inapreciable |

## Rollback Plan

Revertir el cambio en el SP al commit anterior. Remover actualización de spec. Restaurar workaround en HorariosHelper.cs.

## Dependencies

Ninguna.

## Success Criteria

- [ ] SP no retorna slots con hora vencida para la fecha actual
- [ ] SP retorna todos los slots correctamente para fechas futuras
- [ ] SP retorna slots futuros del día actual correctamente
- [ ] Tests del SP verifican los 3 escenarios anteriores
- [ ] Spec 06 actualizado reflejando el filtro
