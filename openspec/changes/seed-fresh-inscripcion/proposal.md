# Proposal: seed-fresh-inscripcion — Seed de inscripciones con datos consistentes por construcción

## Summary

Los seeds de inscripciones de tests adivinan datos (entrenador/clase/cliente/estado/cupo), produciendo combinaciones (fecha, hora, entrenador) inconsistentes. Se crea un helper independiente `SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync` que arma TODO el dataset de una inscripción (slot + entrenador + clase + cliente libre) vía los SPs de disponibilidad, y se refactorizan los 3 métodos que crean inscripciones/clases programadas para usarlo.

## Intent

Eliminar datos adivinados e inconsistentes en los seeds de inscripciones. Garantizar por construcción que slot, entrenador, clase y cliente son consistentes: slot real disponible del SP de horarios, entrenador activo del SP de entrenadores, clase con `fkEstadoClase = 1`, cliente SIN inscripción vigente en ese (fecha, horario) — obtenido de la propia tabla de inscripciones en una sola consulta, sin filtro por rol.

## Scope

### In Scope
- Nuevo helper `SlotDisponibleParaClaseProgramadaHelper` (+ DTO `SlotDisponibleParaClaseProgramadaDto`).
- Refactor de `InscripcionEndpointHelper.SeedFreshInscripcionAsync` (17-132).
- Refactor de `InscripcionTestHelper.SeedSingleInscripcionConHoraFuturaAsync` (394-487).
- Refactor de `InscripcionTestHelper.CreateValidDestinationClassForReagendarAsync` (1059-1136).
- Delta specs (numeración spect-53+) para el contrato del helper y los seeds.

### Out of Scope
- `HorariosHelper` intacto (9 callers), `PreReservaDeHorarioHelper` intacto (otra entidad; su composición es el patrón de referencia), `ClasesProgramadasHelper.Registrar*` intactos (sin callers).
- Otros `DateTime.Now`: `InscripcionTestHelper` 534, 710, 974 + `ServiceReagendarInscripcionTests:109` → change futuro.
- SPs, esquema y BD: NO se modifican.

## Problem

| Método | Bug |
|--------|-----|
| `InscripcionEndpointHelper.SeedFreshInscripcionAsync` (17-132) | Entrenador = `SELECT TOP 1 Id FROM AspNetUsers` sin rol/estado/disponibilidad (62-66). Bloque de verificación de cliente (19-51) con fallback que RETORNA sin seedear (quirk). Estado programada = primer row sin filtro 'disponible' (68-71). Cupo hardcodeado 20 (98). |
| `InscripcionTestHelper.SeedSingleInscripcionConHoraFuturaAsync` (394-487) | `sp_obtenerEntrenadoresDisponibles @fechaReferencia = DateTime.Now` (431-434) → hora incorrecta para el slot futuro. Clase random sin filtro `fkEstadoClase = 1` (423-425). Cliente random (410-417). |
| `CreateValidDestinationClassForReagendarAsync` (1059-1136) | `DateTime.Now` al SP de entrenadores (1097-1100). Filtrado manual `fecha > fechaOriginal` (1080-1083) reemplazable por filtro Mayor interno. |

## Approach

### Nuevo helper `SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync`
Orquestación interna en este orden:

1. **Slot**: `HorariosHelper.ObtenerUnHorarioDisponible(conn, FiltroFecha.Mayor, FiltroHora.SinFiltro, fecha?)` → `null` si no hay horarios → retorna `null`. Sin filtrado manual (Mayor ya filtra `fecha > fechaBase` internamente).
2. **Entrenador**: interno `EXEC sp_obtenerEntrenadoresDisponibles @fechaReferencia = slot.FechaDisponible` — SOLO la fecha (hora 00:00 → SP devuelve todos los activos; "disponible" == "activo", decisión consciente; `horaInicio` no se necesita). SP devuelve UsuarioID + Nombre + Apellido → DTO guarda `EntrenadorId` + `NombreEntrenador`.
3. **Clase**: si `fkClase` param dado → se usa; si no → `SELECT TOP 1 ClaseID, Cupo FROM Clases WHERE fkEstadoClase = 1`.
4. **Cliente**: llamada INTERNA a `obtenerClienteDisponibleParaSlotAsync(slot.FechaDisponible, slot.IdHoraLaboral)` (método público de la misma clase, orquestado internamente): UNA sola consulta SELECT desde `inscripcionesDeClases` (JOIN `clasesProgramadas` + `horariosDeClasesProgramadas`), filtrando SOLO inscripciones VIGENTES (`v_idEstadoVigenteInscripcionAClase`), con `NOT EXISTS` que excluye inscripciones del (fecha, horario) pasados al método (comparando contra `clasesProgramadas.fechaDeLaClase` + `horariosDeClasesProgramadas.fkHorarioLaboral`, NO `inscripcionesDeClases.fechaDeInscripcion`). Devolver `fkCliente` del primer cliente que cumpla; sin filtro por rol 'cliente' (todas las inscripciones son de clientes por construcción). Si ninguno cumple → throw `"El cliente con id {idCliente} ya está inscrito a una clase en ese horario"` (guard defensivo INALCANZABLE: `sp_obtenerHorariosDisponibles` hace EXCEPT de OccupiedSlots, 96-118).
5. **DTO** `SlotDisponibleParaClaseProgramadaDto`: `FechaDisponible`, `IdHoraLaboral`, `EntrenadorId`, `NombreEntrenador`, `ClaseId`, `Cupo`, `ClienteId`. Sin campo hora.

### Consumidores (3, mismo helper)

| Método | Cambio |
|--------|--------|
| `InscripcionEndpointHelper.SeedFreshInscripcionAsync` | DELETE bloque 19-51 (cliente viene de `DTO.ClienteId`). DELETE `SELECT TOP 1 AspNetUsers` (62-66). Estado vía `v_idEstadoDisponibleClasesProgramadas`. Cupo real `Clases.Cupo`. Contrato `string clienteId` intacto. |
| `InscripcionTestHelper.SeedSingleInscripcionConHoraFuturaAsync` | Usa helper → corrige DateTime.Now (431-434) y cliente random. DTO provee slot/entrenador/clase/cliente. Contrato `(string ClienteId, int IdInscripcion)?` intacto (idInscripcion del INSERT OUTPUT). |
| `CreateValidDestinationClassForReagendarAsync` | Helper con `fkClase = fkClaseOriginal` + `fecha = fechaOriginal` (Mayor interno asegura destino > fechaOriginal). NO usa cliente helper (mismo cliente, cambia clase). Corrige DateTime.Now (1099). |

## Capabilities

### New Capabilities
- `seed-inscripcion`: garantía por construcción de slot/entrenador/clase/cliente consistente para seeds de inscripción (nuevo helper + contrato de los 3 consumidores). Delta spec spect-53+.

### Modified Capabilities
- `seeding-e2e` (`specs/e2e-infraestructura.md`, estrategia de seeding): los seeds pasan de adivinar datos a ensamblar vía helper seguro; contratos de retorno se mantienen (documentado en specs de tests 34/38/40/44 que referencian los seeds).

## Decision Log

1. Fecha SOLO al SP de entrenadores (00:00 → todos los activos); `horaInicio` no se necesita.
2. "Disponible" == "activo": decisión consciente (slot libre ⇒ nadie da clase ahí ⇒ todos los activos libres).
3. Sin filtro por rol 'cliente' (UNA consulta desde `inscripcionesDeClases` con NOT EXISTS): todas las inscripciones son de clientes por construcción, no puede haber una inscripción de un no-cliente. `fkCliente` es nullable (verificado en `FitnessGymSchemaActual.sql` línea 870) → se usa NOT EXISTS (no NOT IN) para evitar el problema de NULLs.
4. Solo inscripciones VIGENTES vía `v_idEstadoVigenteInscripcionAClase`; comparación contra clase programada (`fechaDeLaClase` + `fkHorarioLaboral`), no `fechaDeInscripcion`.
5. Excepción de cliente ocupado = guard defensivo inalcanzable (EXCEPT del SP de horarios lo garantiza).
6. Reuso de `ObtenerUnHorarioDisponible` (Mayor filtra interno; sin descarte manual).
7. Ambos seeds usan el helper pese a contratos distintos.
8. Contratos preservados: `string clienteId` y `(string ClienteId, int IdInscripcion)?` (null si sin horarios).

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Overlap con change en flight `fecha-referencia-datetime` (activa guard 2 en `HorariosHelper`; specs 50/51 sin commit) | Med | Coordinar orden de apply; nuestros callers usan `FiltroHora.SinFiltro` → guard 2 fuera del path |
| Working tree sucio (guard clauses de HorariosHelper + specs 50/51 sin commit) | Med | Verificar `git status` antes de apply (vía git-workflow-manager) |
| `IX_entrenadorfechahora` no está en schema de referencia (solo comentario C# 494) | Low | Verificar existencia ad-hoc en BD de pruebas antes de depender |
| Respawn no limpia AspNetUsers/Clases/horas → seeds acumulan clasesProgramadas; saturación de primer entrenador | Med | `ObtenerUnHorarioDisponible` elige slot random (mitiga saturación) |
| EndpointHelper ahora REQUIERE ≥1 Empleado Activo (antes funcionaba con cualquier usuario) | Med | Verificar en tareas que el backup tenga empleados activos |

## Rollback Plan

Cambio 100% código de tests (sin esquema/SP/BD): revertir con git-workflow-manager. Contratos intactos ⇒ callers no requieren cambios. Si un E2E falla, restaurar los 3 métodos a su versión previa.

## Dependencies

- `sp_obtenerHorariosDisponibles` y `sp_obtenerEntrenadoresDisponibles` (sin modificar, fuente de verdad de disponibilidad).
- `HorariosHelper.ObtenerUnHorarioDisponible` (sin modificar).
- Backup con ≥1 Empleado Activo y ≥1 cliente (los clientes son quienes tienen inscripciones; el helper los obtiene de `inscripcionesDeClases`, no de AspNetUsers).

## Success Criteria

- [ ] Helper arma slot/entrenador/clase/cliente consistentes por construcción (sin adivinar).
- [ ] Ningún `DateTime.Now` al SP de entrenadores en los 3 métodos refactorizados.
- [ ] EndpointHelper sin `SELECT` a AspNetUsers para entrenador; usa `Clases.Cupo` real y estado por vista.
- [ ] Clase siempre con `fkEstadoClase = 1` en los 3 métodos.
- [ ] Cliente sin inscripción vigente en el (fecha, horario) elegido (obtenido desde `inscripcionesDeClases`, sin filtro de rol).
- [ ] Contratos intactos: suites E2E/Integración existentes (Cancelar, Reagendar, Consultar) pasan sin cambios en callers.
