# Tasks: Filtrar horas pasadas en sp_obtenerHorariosDisponibles

## Phase 1: Database — Modificar SP

- [x] 1.1 Agregar `DECLARE @hoy DATE` y `DECLARE @horaActual TIME(0)` al inicio del SP (después de `SET NOCOUNT ON`)
- [x] 1.2 Reemplazar `CAST(GETDATE() AS DATE)` en `SET @Fecha = ISNULL(...)` por `@hoy`
- [x] 1.3 Agregar `AND (f.Fecha > @hoy OR hl.horaInicio > @horaActual)` en WHERE del CTE `AllSlots`
- [ ] 1.4 Ejecutar el SP contra BD real para verificar sintaxis correcta (EN PROCESO)

## Phase 2: Specs — Verificar documentación

- [x] 2.1 Confirmar que `specs/06-horarios-disponibles.md` contiene los escenarios de filtro horario (ya hecho según planning)

## Phase 3: Testing — Validación funcional

- [ ] 3.1 Ejecutar SP sin parámetros a hora conocida, verificar que NO devuelve slots con horaInicio vencida
- [ ] 3.2 Ejecutar SP con `@Fecha = tomorrow`, verificar que devuelve todos los slots del día futuro
- [ ] 3.3 Ejecutar SP con fecha del mes anterior, verificar resultado vacío (regresión)

## Phase 4: Versionado

- [ ] 4.1 Commit con mensaje convencional: `feat: add hour filter to sp_obtenerHorariosDisponibles`
