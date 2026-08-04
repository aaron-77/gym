# Verify Report — fecha-referencia-peticiones-horarios

## Status

**FAIL** — El gate de build (4.1) pasa; el gate E2E (4.2) NO pasa, pero la causa raíz es **infraestructural (imágenes Docker desactualizadas) y NO es atribuible a este cambio**. Las specs 05/06/14/49 y el design se cumplen según revisión estática.

## Executive Summary

El cambio `fecha-referencia-peticiones-horarios` agrega la fecha de referencia del browser (`obtenerFechaReferencia()` en `httpClient.js`) como query param `fecha` en las peticiones de horarios/clases programadas del frontend, y propaga `DateOnly? fecha` desde el controller frontend hasta `BL/ClasesManager.ObtenerClasesProgramadasPorId`.

**Gate 4.1 — Build: PASS.** `dotnet build FinessGymSol.sln` compila con 0 errores (solo warnings preexistentes ajenos: NU1504 BCrypt duplicado en BL.csproj, NU1902 MailKit/MimeKit).

**Gate 4.2 — E2E `Reagendar_InscripcionValida_RetornaExito`: FAIL — causa ajena al cambio.** El test falla con timeout esperando `button.calendar-cell:not([disabled])` (0 elementos). Se demostró que el E2E corre contra las imágenes Docker `fitnessgymfrontend:latest` (construida 2026-07-30 14:17) y `fitnessgymapi:latest` (2026-07-30 18:23), que **no incluyen el código actual del repo**: todos los archivos de este cambio se modificaron el 2026-07-31 15:05 (posteriores al build de la imagen), y el JS del otro cambio (`e2e-reagendar-inscripcion-frontend`) es del 2026-07-30 18:26 (también posterior).

Evidencia verificada dentro de la imagen del frontend:
- `/app/wwwroot/js/cancelarReagendarInscripcion.js` (imagen) usa `idClaseProgramada` y NO tiene `fkClase` ni `fecha:` → es la versión anterior al otro cambio.
- `/app/wwwroot/js/httpClient.js` (imagen) NO contiene `obtenerFechaReferencia` → este cambio no está en la imagen.
- La imagen tiene 0 archivos `.cshtml` (vistas compiladas dentro del DLL) → corre la versión de frontend del 30/07 14:17.

El browser, al ejecutar el JS viejo contra la vista vieja, crashea en el armado del calendario (`onReagendarToggle` → `new Calendar('calendar')` sin el `#calendar`/partial esperado) → el calendario nunca renderiza → 0 botones → timeout en línea 247. El E2E no es un gate válido para evaluar este cambio hasta reconstruir las imágenes.

**Verificación estática specs/design: PASS** con hallazgos menores (no bloqueantes) detallados abajo.

## Artifacts

- `openspec/changes/fecha-referencia-peticiones-horarios/verify-report.md` (este archivo)
- Engram observation: topic `sdd/fecha-referencia-peticiones-horarios/verify-report` (project gym, scope project)

## Gates

| Gate | Resultado | Evidencia |
|------|-----------|-----------|
| 4.1 Build | ✅ PASS | `dotnet build FinessGymSol.sln` → 0 errores. Warnings preexistentes: NU1504 (BCrypt.Net-Next duplicado en BL.csproj), NU1902 (MailKit 4.12.1, MimeKit 4.12.0), MSB3277 (EF Core SqlServer 8.0.11 vs 8.0.29 en tests) |
| 4.2 E2E `Reagendar_InscripcionValida_RetornaExito` | ❌ FAIL (ajeno) | Timeout 30000ms en línea 247 `waiting for Locator("button.calendar-cell:not([disabled])")` — 0 elementos. Causa: imágenes Docker desactualizadas (ver Executive Summary) |

## Verificación por Spec

### Spec 05 — horarios-pre-reservas ✅ PASS

- `GymFrontend/wwwroot/js/agendarioDeHorarios.js`: `import { obtenerFechaReferencia }` (línea 6); `obtenerHorariosNuevos(fecha = obtenerFechaReferencia())`; `const params = { fecha }` se envía SIEMPRE (se eliminó el `if (fecha)` condicional).
- Callers cubiertos sin modificar: `inicializarAgendador()` (~360), `handleChangeMonthOrYear(fechaParam)` (~322, ya pasa string formateado — el helper lo devuelve tal cual), `recargarDatosDespuesReconexion()` (~821).
- Enviar `fecha` sin hora → la API filtra horarios del día (comportamiento esperado del spec).
- No se modifica `inscriptorDeClases.js` (compatibilidad hacia atrás del cambio de mes) — alineado con el alcance.

### Spec 06 — horarios-disponibles ✅ PASS

- Mismo patrón de spec 05: el GET de horarios disponibles incluye `fecha` de referencia del browser SIEMPRE, para que el backend no dependa de su propia hora local.

### Spec 14 — obtener-clases-programadas-por-id ✅ PASS

- `GymFrontend/Controllers/ClasesController.cs` línea 153: `ObtenerClasesProgramadasPorId([FromQuery] int? idClase = null, [FromQuery] DateOnly? fecha = null)` — acepta y propaga `fecha`; valida ModelState defensivamente (400 con `DTOResponse`); delega en el manager.
- `BL/ClasesManager.cs`: firma `ObtenerClasesProgramadasPorId(int? idClase = null, DateOnly? fecha = null)`; agrega `fecha=yyyy-MM-dd` a la URL de la API solo si `fecha.HasValue`, con separador `?`/`&` correcto según exista `idClase`.
- El endpoint de la API (`API/Controllers/ClasesController.cs:836-839`) NO declara `fecha` → el param extra es ignorado por `[ApiController]` → retrocompatible, sin cambios de API necesarios (alineado con design).
- La TVF `fn_obtenerClasesProgramadasPorIdClase` no filtra por fecha (fuera de alcance) → el filtrado queda a cargo del SP de horarios; consistente con el design.

### Spec 49 — spect-ui-cancelarReagendarInscripcion ✅ PASS

- `GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js`: `import { ..., obtenerFechaReferencia }` (línea 1); `fetchClasesProgramadas()` envía `{ idClase: fkClase, fecha: obtenerFechaReferencia() }` (línea 120) → el calendario recibe las clases programadas del día de referencia del browser.
- Cubre los 3 callers internos: check Reagendar (onReagendarToggle), comboInscripcion (onInscripcionChange), SignalR (onSignalRClasesProgramadas).
- El diff de este archivo respecto del repo incluye también cambios del OTRO cambio (`fkClase`, `fechaDeLaClase`, hidden inputs `#inputClase`/`#inputEntrenador`) — preexistentes, no validados como defecto nuestro.

## Verificación por Design

| Decisión | Estado |
|----------|--------|
| D1 — fecha de referencia = reloj del browser vía query param `fecha` | ✅ Implementado en los 3 puntos de consumo (specs 05/06/49) |
| D2 — helper `obtenerFechaReferencia` en `httpClient.js` (sv-SE → yyyy-MM-dd, acepta Date o string) | ✅ Implementado; exportado como ES module + expuesto en `window.obtenerFechaReferencia` |
| D3 — sin cambios en `GymFrontend/Program.cs` (400 ProblemDetails del framework vía `[ApiController]` aceptado) | ✅ Sin cambios en Program.cs |
| D4 — sin tests unitarios (decisión del usuario) | ✅ No se crearon tests |

## Next Recommended

1. **Reconstruir las imágenes Docker del E2E** con el código actual del repo antes de dar por válido el gate 4.2:
   - `fitnessgymfrontend:latest` (build actual del frontend, incluye JS nuevos + vista 47/49)
   - `fitnessgymapi:latest`
   - No hay Dockerfile en el repo → el build es externo (pendiente de coordinar).
2. Re-correr `dotnet test GymWebApp.Tests/GymWebApp.Tests.csproj --filter "FullyQualifiedName~Reagendar_InscripcionValida_RetornaExito"` con imágenes actualizadas.
3. Considerar un paso CI de build de imágenes antes de la suite E2E para evitar este desfase.

## Risks

- **CRITICAL (infra, ajeno al cambio)**: el gate E2E no es confiable hasta reconstruir las imágenes Docker. El E2E `InscripcionesReagendarE2ETests.cs` es untracked y pertenece al otro cambio; su fallo actual NO puede atribuirse a este cambio.
- **WARNING (preexistente)**: NU1504 (PackageReference BCrypt.Net-Next duplicado en BL.csproj) y NU1902 (MailKit/MimeKit vulnerabilidad moderada) — ajenos a este cambio.
- **WARNING (del otro cambio, observado)**: la lógica de disponibilidad del calendario (`calendario.js` líneas 300-305) compara `fechaGenerada` (00:00) contra `calendarCurrentDate` (con hora actual) → si `disponibleDates` está vacío, el día de HOY queda deshabilitado y solo quedan días futuros de la grilla. No bloquea este cambio, pero conviene corregirlo en el dueño de ese flujo.
- **INFO**: `fetchClasesProgramadas` usa `response.payload || response` — tolera ambos formatos; robusto.

## Skill Resolution

- `sdd-verify`: aplicado — gates ejecutados (build OK, E2E repro con causa raíz demostrada), specs/design verificados, hallazgos con severidad, reporte persistido.
- No se modificó ningún archivo de código ni de test durante la verificación. No se corrieron comandos git.
