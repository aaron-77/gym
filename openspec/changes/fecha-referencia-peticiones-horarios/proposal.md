# Proposal: fecha-referencia-peticiones-horarios

## Intent

El flujo de reagendar/horarios depende de "hoy" desde 3 relojes distintos que pueden discrepar: `GETDATE()` (SPs), `DateTime.Now` (BL) y `new Date()` (browser). El usuario YA corrigió el SP en BD para recibir la fecha de referencia como parámetro. Falta: que el JS mande esa fecha en las peticiones de horarios y que el backend correspondiente la acepte. Un solo reloj manda: el browser, sincronizado con el server (Playwright set clock en E2E).

## Scope

### In Scope
- `agendarioDeHorarios.js`: `obtenerHorariosNuevos(fecha = null)` → default `new Date()` formateado sv-SE (`yyyy-MM-dd`) y mandarlo SIEMPRE como query param `fecha` en `/Horarios/obtenerHorariosDisponibles` y `/Horarios/obtenerPreReservas`. Revisar callers: `inicializarAgendador()`, `handleChangeMonthOrYear()`.
- `cancelarReagendarInscripcion.js`: `fetchClasesProgramadas()` manda `fecha` de referencia a `/clases/obtenerClasesProgramadasPorId`.
- `ClasesController.cs`: `ObtenerClasesProgramadasPorId` acepta `[FromQuery] DateOnly? fecha = null` (opcional) además de `idClase`.
- `ClasesManager` (BL): usa la fecha recibida como referencia (fallback `DateTime.Today`).
- Verificación: E2E `Reagendar_InscripcionValida_RetornaExito` + unit de ClasesManager si cambia firma.

### Out of Scope
- `ValidadorFechasInscripcionesYClasesProgramadas` (BL) sigue con `DateTime.Now` — fuente de verdad en producción.
- NO se agrega endpoint nuevo de fecha del server (Decisión A).
- NO se modifica el E2E (set clock condicional ya existe; solo verificación final).
- NO se toca el SP en BD (ya corregido por el usuario).
- NO se agrega fecha al endpoint de preReservarHorario (solo GETs de consulta).

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `specs/05-horarios-pre-reservas.md`: `obtenerPreReservas` recibe SIEMPRE `fecha` del browser como fecha de referencia (el endpoint ya acepta `[FromQuery] string? fecha = null`; compatibilidad hacia atrás cuando no se manda).
- `specs/06-horarios-disponibles.md`: `obtenerHorariosDisponibles`/`obtenerPreReservas` reciben SIEMPRE `fecha` del browser; el filtro de horas vencidas (Req. 13) se evalúa contra esa fecha de referencia, no contra GETDATE().
- `specs/14-obtener-clases-programadas-por-id.md`: endpoint acepta `fecha` opcional como fecha de referencia.
- `specs/49-spect-ui-cancelarReagendarInscripcion.md`: `fetchClasesProgramadas` envía fecha de referencia.

## Approach

- Helper JS: fecha de referencia = `new Date().toLocaleDateString('sv-SE')` (formato `yyyy-MM-dd`).
- `obtenerHorariosNuevos(fecha = <helper>)` → pasa `fecha` a ambos GETs; `fetchClasesProgramadas` hace lo mismo.
- `ClasesController` recibe `fecha` opcional y la propaga al `ClasesManager`; éste usa `fecha ?? DateTime.Today` como referencia.
- Precedente del patrón: `ObtenerEntrenadoresDisponibles(DateTime fechaReferencia)` en UsersManager/CitasController y `sp_obtenerEntrenadoresDisponibles @fechaReferencia`.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `GymFrontend/wwwroot/js/agendarioDeHorarios.js` | Modified | obtenerHorariosNuevos + callers mandan `fecha` |
| `GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js` | Modified | fetchClasesProgramadas manda `fecha` |
| `GymFrontend/Controllers/ClasesController.cs` | Modified | param opcional `fecha` |
| `BL/.../ClasesManager.cs` | Modified | usa fecha recibida |
| `specs/05`, `specs/06`, `specs/14`, `specs/49` | Modified | requisitos actualizados |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Formato de fecha mal parseado por el server | Low | sv-SE genera `yyyy-MM-dd`; `DateOnly?` lo parsea; cubierto por E2E |
| Caller olvidado llama sin fecha | Med | default en JS cubre; revisar TODOS los callers en alcance |
| Diferencia de zona horaria browser vs server | Low | Aceptada: browser es el reloj de referencia (Decisión A) |

## Rollback Plan

Revertir los commits de JS/controller/manager: los endpoints quedan con `fecha` opcional → sin el param vuelven a usar `GETDATE()`/`DateTime.Today`. El SP en BD conserva el parámetro pero con default a fecha actual. Sin migraciones ni datos que revertir.

## Dependencies

- SP en BD ya corregido por el usuario (usa la fecha recibida).
- E2E existente `Reagendar_InscripcionValida_RetornaExito` con set clock condicional.

## Success Criteria

- [ ] El agendador manda `fecha` del browser en TODAS las llamadas a `obtenerHorariosDisponibles`/`obtenerPreReservas`
- [ ] `fetchClasesProgramadas` manda `fecha`
- [ ] `obtenerClasesProgramadasPorId` acepta `fecha` opcional sin romper callers actuales (unit verde)
- [ ] E2E `Reagendar_InscripcionValida_RetornaExito` pasa
- [ ] Specs 05, 06, 14 y 49 reflejan el nuevo requisito
