# Design: Filtro hora único (filtro-hora-mayor-unico)

## Dependencias

- Spec: `specs/50-spect-filtroHoraUnico.md`
- Proposal: `openspec/changes/filtro-hora-mayor-unico/proposal.md`

## Enfoque técnico

Refactor de infraestructura de tests (GymWebApp.Tests) + limpieza de contrato en `BL.Utils.Enums`. Se deja un único filtro de hora válido (`FiltroHora.Mayor`) con referencia ceil a la próxima hora completa y un guard de fin de jornada, ambos en el choke point `HorariosHelper.ObtenerHorariosDisponiblesFiltrados` para que todos los seeds hereden ~1h de margen. Cero cambios en producción (SP, validadores, servicios): el SP ya excluye horas vencidas de hoy con precisión de segundos (`sp_obtenerHorariosDisponibles.sql:37`); el truncado a hora vive solo en el helper C#.

## Decisiones de arquitectura

### D1: Guard ↔ `FiltroFecha.Igual` — opción (c): la referencia efectiva se redefine

| Opción | Comportamiento | Veredicto |
|--------|----------------|-----------|
| (a) Guard solo con Mayor/MayorIgual | `Igual` sin guard → null después de la jornada → `SeedFallbackAsync` | Rechazada: ronda extra a BD + retry; el criterio de aceptación del spec no se cumple para callers `Igual` |
| (b) Shift del @Fecha del SP pero `Igual` sigue comparando contra "hoy" original | Vacío garantizado por construcción | Rechazada: fabrica el fallo que debe evitar |
| (c) Shift de la ÚNICA referencia (`fechaRef`), usada tanto para el SP como para el filtro | `Igual` matchea la fecha efectiva (mañana) → query NO vacía | **Elegida** |

**Rationale**: `FiltroFecha.Igual` en este helper YA compara contra `fechaRef` normalizado (línea 58), no contra `GETDATE()`. `NormalizarFechaReferencia` (último día del mes → primer día del mes siguiente) ya desplaza la referencia; el guard es la misma clase de normalización para el fin de jornada. Desplazar `fechaRef` produce una query válida para TODAS las combinaciones de `FiltroFecha`. Coherente con el escenario del spec: "última hora laboral 21:00, hora actual 22:10 → referencia = primer slot del día siguiente". Efectos:
- `SeedSingleInscripcionConHoraFuturaAsync` (`Igual`+`Mayor`, caller activo, usado en `ServiceConsultarInscripcionesDeClienteIntegrationTests` con fallback) siembra mañana en vez de devolver null.
- `RegistrarClaseProgramadaActual` (`Igual`+`Mayor`, sin callers activos hoy) registraría para el próximo día laboral real — coherente con su nombre ("Actual" refiere a la fecha, no a la hora puntual).

### D2: Orden de composición — ceil primero, guard después

1. `fechaRef = NormalizarFechaReferencia(fecha?.Date ?? DateTime.Today)`
2. `horaRef`: fecha explícita → `new TimeSpan(fecha.Hour, 0, 0)` (sin ceil, preserva 00:00); fecha null → ceil de `DateTime.Now` (`Minute > 0 || Second > 0` → `TimeSpan(Hour + 1, 0, 0)`, si no `TimeSpan(Hour, 0, 0)`)
3. Guard: `(minHora, maxHora) = GetRangoHoraInicioAsync()`; si `horaRef > maxHora` → `fechaRef = NormalizarFechaReferencia(fechaRef.AddDays(1))` y `horaRef = minHora`
4. `ObtenerHorariosDisponibles(connectionString, fechaRef)` → filtro `FiltroFecha` contra `fechaRef` → filtro hora `horaInicio > horaRef`

El guard corre SOLO cuando hay filtro de hora (`filtroHora != SinFiltro`, único restante: `Mayor`). Con `SinFiltro` no hay referencia horaria que desplazar y `Igual`+`SinFiltro` (InscripcionTestHelper:659) preserva semántica "hoy". El shift se vuelve a pasar por `NormalizarFechaReferencia` (paso 3) para que el SP regenere el mes completo si la fecha cae en el último día del mes.

### D3: Query MIN/MAX en HorariosHelper (no reutilizar `GetMaxHoraInicioAsync`)

| Atributo | Decisión |
|----------|----------|
| Ubicación | `HorariosHelper` — método privado estático `GetRangoHoraInicioAsync(connectionString)` |
| SQL | `SELECT MIN(horaInicio) AS MinHora, MAX(horaInicio) AS MaxHora FROM horasLaborales` (1 round-trip) |
| Alternativa rechazada | Llamar `InscripcionTestHelper.GetMaxHoraInicioAsync` (línea 1034) + query MIN aparte: 2 round-trips y acoplamiento Helpers→Helpers |

`GetMaxHoraInicioAsync` NO se modifica: lo usan tests directos (`ServiceReagendarInscripcionTests:186`, `InscripcionesReagendarTests:38`, `ObtenerClasesProgramadasPorIdApiTests:37`) y el E2E (`InscripcionesReagendarE2ETests:178`). Columnas verificadas contra `bd/esquemaBdsDeReferenciaParaIa/FitnessGymSchemaActual.sql` (`horasLaborales.horaInicio time NOT NULL`, línea 254).

## Flujo de datos

```
Test seed ─► ObtenerUnHorarioDisponible(connStr, filtroFecha, filtroHora, fecha?)
                  │
                  ▼
      ObtenerHorariosDisponiblesFiltrados
    ┌─────────────┼────────────────────────────────────────┐
    │ 1. fechaRef = NormalizarFechaReferencia(fecha?.Date ?? Today)
    │ 2. Si filtroHora == Mayor:
    │      horaRef = fecha.HasValue ? TimeSpan(fecha.Hour,0,0)
    │                                : Ceil(DateTime.Now)      ← ceil
    │      (minHora, maxHora) = GetRangoHoraInicioAsync()      ← guard
    │      si horaRef > maxHora:
    │          fechaRef = NormalizarFechaReferencia(fechaRef.AddDays(1))
    │          horaRef  = minHora
    │ 3. SP(fechaRef) ──► slots del mes (SP ya excluye horas vencidas de hoy)
    │ 4. FiltroFecha contra fechaRef (switch existente, sin cambios)
    │ 5. FiltroHora: horaInicio > horaRef
    └─────────────┴────────────────────────────────────────┘
                  │
                  ▼
      Seed inserta clase programada (fechaDisponible, idHora)
```

## Cambios por archivo

| Archivo | Acción | Detalle |
|---------|--------|---------|
| `BL/Utils/Enums/FiltroHorarioEnums.cs` | Modificar | Líneas 22-27: eliminar `Igual` y `MayorIgual` de `FiltroHora` (quedan `Mayor` y `SinFiltro`); línea 18: actualizar XML doc (referencia ceil + guard). Renumeración de valores segura: uso solo en memoria en tests |
| `GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs` | Modificar | Línea 74: reemplazar floor por ceil; líneas 76-91: switch colapsa a filtro `Mayor` con `horaRef`; línea 51: `fechaRef` final (posiblemente desplazada) al SP; + método privado `GetRangoHoraInicioAsync`; XML docs 34-41 actualizados |
| `GymWebApp.Tests/SharedHelpers/ClasesProgramadasHelper.cs` | Modificar | Línea 317: `FiltroHora.Igual` → `FiltroHora.Mayor` (SIN rename); XML doc 293-299 actualizado |

Sin cambios: `DatabaseHelper`, `InscripcionTestHelper` (incl. `GetMaxHoraInicioAsync`), `sp_obtenerHorariosDisponibles.sql`, `ValidadorFechasInscripcionesYClasesProgramadas.cs`, `InscripcionesReagendarE2ETests.cs` (guard propio de reloj, líneas 177-202, queda intacto).

## Sketch del guard (patrón no obvio)

```csharp
// ObtenerHorariosDisponiblesFiltrados — reemplaza líneas 50-91
var fechaRef = NormalizarFechaReferencia(fecha?.Date ?? DateTime.Today);
TimeSpan? horaRef = null;

if (filtroHora != FiltroHora.SinFiltro) // único filtro restante: Mayor
{
    horaRef = fecha.HasValue
        ? new TimeSpan(fecha.Value.Hour, 0, 0)      // fecha explícita → sin ceil
        : CeilHoraActual(DateTime.Now);             // ceil solo con hora actual

    var (minHora, maxHora) = await GetRangoHoraInicioAsync(connectionString);
    if (horaRef > maxHora)                          // guard fin de jornada
    {
        fechaRef = NormalizarFechaReferencia(fechaRef.AddDays(1));
        horaRef = minHora;                          // primer slot del día siguiente
    }
}

var horarios = await ObtenerHorariosDisponibles(connectionString, fechaRef);
// FiltroFecha vs fechaRef: switch existente (líneas 54-69), sin cambios
// FiltroHora:
if (horaRef is not null)
    horarios = horarios.Where(r => r["horaInicio"] != null
                                && (TimeSpan)r["horaInicio"] > horaRef.Value).ToList();

static TimeSpan CeilHoraActual(DateTime ahora) =>
    ahora.Minute > 0 || ahora.Second > 0
        ? new TimeSpan(ahora.Hour + 1, 0, 0)
        : new TimeSpan(ahora.Hour, 0, 0);
```

## Casos borde

| Caso | Comportamiento |
|------|----------------|
| 16:35 → ref 17:00 | Solo slots con horaInicio > 17:00 (spec) |
| 16:00:00 exacto → ref 16:00 | Sin ceil (spec); el filtro `>` + SP (precisión segundos) dejan solo slots futuros |
| 23:35 → ceil 24:00 | `24:00 > maxHora` → guard → día siguiente, horaRef = minHora |
| Último día del mes + guard | `NormalizarFechaReferencia` post-shift → SP regenera el mes completo |
| `horaRef == maxHora` exacto | Sin shift; `>` excluye el último slot de hoy → posible null → `SeedFallbackAsync` (seguro) |
| Fecha explícita futura (`DateOnly`→00:00) | horaRef = 00:00 → sin ceil ni guard (comportamiento preservado) |
| `FiltroFecha.Igual` + guard | fechaRef efectiva = mañana → query NO vacía (D1) |
| `SinFiltro` | Sin horaRef → sin guard → `Igual`+`SinFiltro` mantiene "hoy" |
| `FiltroFecha.Mayor` + guard | fechaRef = mañana → devuelve días posteriores a mañana (válido, no vacío) |

## Estrategia de testing

| Capa | Qué | Cómo |
|------|-----|------|
| Integración | Escenarios del spec: 16:35→ref>17:00; 16:00 exacto; fecha explícita→00:00; fin de jornada (22:10 con max 21:00 → slots del día siguiente); dentro de jornada | Testcontainers + BD real (patrón xunit-integration), assert sobre referencias y no-vacío. Los tests concretos se definen en sdd-tasks (regla: solo tests del spec 50) |
| Compile-time | Enum sin `Igual`/`MayorIgual`; caller migrado a `Mayor` | El build falla si queda cualquier uso |
| E2E | `Reagendar_InscripcionValida_RetornaExito` (spec 10) | Corridas repetidas — el flake es el objetivo del cambio |
| Regresión | Tests existentes con `Mayor`/`SinFiltro` (InscripcionTestHelper:401, 599, 1071; E2E:187) | Suite completa verde |

## Migración / Rollout

No se requiere migración (cambio solo en tests + enum sin persistencia). Rollback: revertir los commits del cambio — restaurar enum, switch y floor; el método no se renombra, así que todos los callers vuelven a compilar.

## Preguntas abiertas

- [ ] `RegistrarClaseProgramadaActual` consulta entrenadores con `DateTime.Now` (línea 338): si el guard desplaza la clase a mañana, el entrenador se elige por disponibilidad de HOY. El método no tiene callers activos → se documenta como limitación conocida, no se corrige. ¿Confirmar?
- [ ] ¿Se considera redundante el guard E2E del reloj (InscripcionesReagendarE2ETests:177-202) una vez aplicado el fix? (fuera de alcance — se evalúa luego, según proposal)
