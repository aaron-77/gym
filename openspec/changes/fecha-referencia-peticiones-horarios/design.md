# Design: fecha-referencia-peticiones-horarios

## Technical Approach

Un solo reloj manda: el browser (sincronizado con el server vía Playwright set clock en E2E). El JS formatea la fecha de referencia con `toLocaleDateString('sv-SE')` (`yyyy-MM-dd`) y la envía SIEMPRE como query param `fecha` en las peticiones de horarios (`obtenerHorariosDisponibles`, `obtenerPreReservas`) y de clases programadas (`obtenerClasesProgramadasPorId`). El backend frontend (ClasesController) la acepta como `DateOnly?` opcional y la propaga al ClasesManager, que la reenvía al API. Se reutiliza el patrón `fechaReferencia` ya establecido (`ObtenerEntrenadoresDisponibles(DateTime fechaReferencia)` en UsersManager/CitasController, `sp_obtenerEntrenadoresDisponibles @fechaReferencia`, `HorariosHelper.ObtenerHorariosDisponiblesFiltrados`). No se toca SP en BD, API, E2E, ni el validador BL.

## Architecture Decisions

### D1 — Reloj de referencia: browser via query param `fecha`

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Browser `fecha` param | SPs ya corregidos; set clock E2E sincroniza; precedente `fechaReferencia` existente | **✓** |
| Endpoint nuevo /fecha-server | Nuevo contrato; ya rechazado (Decisión A) | ✗ |
| TimeProvider en .NET | Cambio de arquitectura; validador BL fuera de alcance | ✗ |

### D2 — Helper JS compartido en httpClient.js

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Exportar `obtenerFechaReferencia(fecha = new Date())` en httpClient.js | Extrae el patrón `toLocaleDateString('sv-SE')` ya repetido (agendarioDeHorarios.js:246,317 y otros 6 archivos); ambos módulos ya importan de ahí; formato único garantizado (spec 49 "mismo helper/formato") | **✓** |
| Inline `new Date().toLocaleDateString('sv-SE')` en cada archivo | Duplicación; riesgo de divergencia de formato | ✗ |

### D3 — Tipo del param en frontend ClasesController

| Option | Tradeoff | Decision |
|--------|----------|----------|
| `[FromQuery] DateOnly? fecha = null` | Binding rechaza formato inválido → 400; la propuesta lo fija; semántica date-only | **✓** |
| `string` + TryParse manual (patrón CitasController) | Más boilerplate; parseo manual propenso a throw | ✗ |
| `DateTime?` | Semántica fecha+hora; acá solo importa la fecha | ✗ |

Nota: el binding inválido de `DateOnly?` (fecha malformada) cortocircuita ANTES del action con el 400 automático de `[ApiController]` (ProblemDetails del framework). Se ACEPTA tal cual: el status 400 cumple la spec 14; el formato de respuesta no se controla. NO se agrega config extra (ni `InvalidModelStateResponseFactory`, ni `SuppressModelStateInvalidFilter`, ni nada en `GymFrontend/Program.cs`). El chequeo explícito `ModelState.IsValid` se mantiene como patrón del repo (mismo estilo que `API/Controllers/ClasesController.cs:842-860`) para cubrir validaciones del action de forma defensiva, sin factory propia.

### D4 — Sin tests unit nuevos en este cambio

| Option | Tradeoff | Decision |
|--------|----------|----------|
| NO agregar tests unit de `ClasesManager` ni del controller frontend | Cambio de plumbing (contrato URL/query param); el E2E existente `Reagendar_InscripcionValida_RetornaExito` + compatibilidad hacia atrás (fecha opcional) ya cubren el flujo | **✓** |
| Tests unit de `ClasesManager` (construcción de URL) | Firma del manager cambia, pero el usuario decidió NO agregarlos en este cambio | ✗ |

Comportamiento del fallback del manager (sin tests, pero documentado): cuando `fecha` es nula, el manager OMITE el param de la URL → el server aplica su fecha actual por defecto (spec 14: URL solo con `idClase`). `inscriptorDeClases.js` NO envía `fecha` y queda cubierto por la compatibilidad hacia atrás del endpoint (param opcional).

## Data Flow

```
agendarioDeHorarios.js ──fecha (sv-SE)──▶ /Horarios/obtenerHorariosDisponibles?fecha=
      │  (callers: inicializarAgendador, handleChangeMonthOrYear, recargarDatosDespuesReconexion)
      │                                   /Horarios/obtenerPreReservas?fecha=
      └─ helper obtenerFechaReferencia() (httpClient.js)

cancelarReagendarInscripcion.js ──▶ /clases/obtenerClasesProgramadasPorId?idClase=X&fecha=Y
      │  (fetchClasesProgramadas: check Reagendar, comboInscripcion, SignalR actualizarClasesProgramadas)

GymFrontend ClasesController ──▶ ClasesManager ──▶ api/clases/obtenerClasesProgramadasPorId?…&fecha=
                                                      └─ API ignora `fecha` hoy (TVF, fuera de alcance)
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `GymFrontend/wwwroot/js/httpClient.js` | Modify | Exportar helper `obtenerFechaReferencia(fecha = new Date())` → `fecha.toLocaleDateString('sv-SE')` (extrae patrón existente); default = hoy del browser; formato `yyyy-MM-dd` |
| `GymFrontend/wwwroot/js/agendarioDeHorarios.js` | Modify | `obtenerHorariosNuevos(fecha = obtenerFechaReferencia())`; `params.fecha` seteado SIEMPRE (quitar el `if (fecha)`); los 3 callers quedan cubiertos sin cambios |
| `GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js` | Modify | `fetchClasesProgramadas` agrega `fecha: obtenerFechaReferencia()` al params (cubre sus 3 callers internos) |
| `GymFrontend/Controllers/ClasesController.cs` | Modify | `ObtenerClasesProgramadasPorId` acepta `[FromQuery] DateOnly? fecha = null`; ModelState inválido → BadRequest DTOResponse 400; propaga `fecha` al manager |
| `BL/ClasesManager.cs` | Modify | Firma `ObtenerClasesProgramadasPorId(int? idClase = null, DateOnly? fecha = null)`; agrega `&fecha=yyyy-MM-dd` a la URL solo si presente |

## Interfaces / Contracts

- Helper JS: `obtenerFechaReferencia(fecha = new Date()): string` — `fecha.toLocaleDateString('sv-SE')` → `yyyy-MM-dd`; default = hoy del browser.
- Controller frontend: `ObtenerClasesProgramadasPorId([FromQuery] int? idClase = null, [FromQuery] DateOnly? fecha = null)`.
- Manager: `ObtenerClasesProgramadasPorId(int? idClase = null, DateOnly? fecha = null)` → URL `api/clases/obtenerClasesProgramadasPorId` con `?idClase=` y `&fecha=` condicionales.
- Horarios: frontend controller/manager YA aceptan `fecha` (`HorariosController.cs:34,68`); solo cambia el JS.

## Testing Strategy

| Layer | What | Approach |
|-------|------|----------|
| Unit | Ninguno — decisión del usuario: sin tests unit nuevos en este cambio (ni `ClasesManager` ni controller frontend) | — |
| Integration | API `obtenerClasesProgramadasPorId` | Sin cambios (fuera de alcance); verificar que sigue verde |
| E2E | `Reagendar_InscripcionValida_RetornaExito` | Verificación final; NO modificar (set clock condicional ya existe) |

## Migration / Rollout

No migration. Rollback: revertir los commits de JS/controller/manager; los params quedan opcionales → sin `fecha` el flujo vuelve a `GETDATE()`/default del server. El SP conserva el parámetro con default a fecha actual. Sin datos que revertir.

## Open Questions

Ninguno bloqueante. Nota: el API ignora `fecha` en `obtenerClasesProgramadasPorId` (usa la TVF `fn_obtenerClasesProgramadasPorIdClase`); el param se envía igual por spec 14 — si más adelante se quiere consumir en el API, es un cambio aparte (fuera de alcance).
