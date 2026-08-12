# Tasks: seed-fresh-inscripcion — Seed de inscripciones consistentes por construcción

> DECISIÓN DE SCOPE (2026-08-11, usuaria): **NO se escriben tests nuevos** (spec 54 eliminado).
> El helper nuevo y los 3 refactors quedan cubiertos solo por las suites EXISTENTES que ya ejercitan los
> métodos (E2E Cancelar/Reagendar + Integration Inscripciones/ServiceConsultar/ServiceReagendar).
> Fuera de alcance: crear cualquier archivo de tests nuevo.
>
> FIX CLIENTE APLICADO (2026-08-11, usuaria): `obtenerClienteDisponibleParaSlotAsync` usa UNA sola
> consulta desde `inscripcionesDeClases` con NOT EXISTS (sin rol 'cliente'), descrito en spec 53 Req 6
> y task 1.3. Los 4 archivos del change YA están implementados en el working tree (1.1-1.3, 2.1-2.3) —
> falta solo la verificación (3.1) y el commit.

## Phase 0: Pre-apply Hygiene
- [x] 0.1 Vía git-workflow-manager: `git status` limpio antes de apply (mode-change cleanup ya resuelto; guard clauses fecha-referencia-datetime YA merged a dev → overlap resuelto; re-verificar en apply). (~0)

## Phase 1: GREEN — Helper (sin tests nuevos)
- [x] 1.1 Crear skeleton `GymWebApp.Tests/Integration/Helpers/SlotDisponibleParaClaseProgramadaHelper.cs`: DTO `SlotDisponibleParaClaseProgramadaDto` (7 cols: FechaDisponible DateOnly, IdHoraLaboral int, EntrenadorId string, NombreEntrenador string, ClaseId int, Cupo int, ClienteId string; SIN hora) + métodos `obtenerSlotDisponibleParaClaseProgramadaAsync(string, DateOnly? = null, int? = null)` → null y `obtenerClienteDisponibleParaSlotAsync(DateOnly, int)` → throw (guard). Namespace GymWebApp.Tests.Integration.Helpers; DTO interno al test project — NO crear archivo en DTO/. (~60)
- [x] 1.2 Implementar orquestación en orden: slot `HorariosHelper.ObtenerUnHorarioDisponible(conn, FiltroFecha.Mayor, FiltroHora.SinFiltro, fecha)` → null ⇒ null; entrenador `EXEC sp_obtenerEntrenadoresDisponibles @fechaReferencia = slot.FechaDisponible` (date 00:00 → todos activos; disponible == activo) → EntrenadorId + NombreEntrenador (Nombre + Apellido); clase: fkClase param o `SELECT TOP 1 ClaseID, Cupo FROM Clases WHERE fkEstadoClase = 1`; cliente → 1.3; armar DTO. (~120)
- [x] 1.3 Implementar `obtenerClienteDisponibleParaSlotAsync(fecha, idHoraLaboral)`: UNA sola consulta SELECT desde `inscripcionesDeClases` (JOIN `clasesProgramadas` + `horariosDeClasesProgramadas`); solo inscripciones VIGENTES (v_idEstadoVigenteInscripcionAClase); NOT EXISTS excluyendo inscripciones del (fecha, horario) pasados (NO role filter: todas las inscripciones son de clientes); TOP 1 fkCliente libre en el slot; si ninguno cumple throw literal "El cliente con id {idCliente} ya está inscrito a una clase en ese horario" (guard inalcanzable). (~80)

## Phase 2: GREEN — Consumidores (sin tests nuevos)
- [x] 2.1 Refactor `InscripcionEndpointHelper.SeedFreshInscripcionAsync` (17-132): DELETE bloque cliente 19-51 + SELECT AspNetUsers 62-66; consumir helper → null sin slots (NO throw); estado vía v_idEstadoDisponibleClasesProgramadas; cupo real Clases.Cupo; INSERTs con DTO; contrato string clienteId intacto. (~55)
- [x] 2.2 Refactor `InscripcionTestHelper.SeedSingleInscripcionConHoraFuturaAsync` (394-487): consumir helper; eliminar DateTime.Now (431-434) y cliente random (410-417); contrato (string ClienteId, int IdInscripcion)? intacto (idInscripcion del INSERT OUTPUT). (~50)
- [x] 2.3 Refactor `InscripcionTestHelper.CreateValidDestinationClassForReagendarAsync` (1059-1136): helper con fkClase=fkClaseOriginal + fecha=fechaOriginal (Mayor interno asegura destino > fechaOriginal); eliminar filtrado manual 1080-1083 y DateTime.Now (1099); NO usar cliente helper; retorno int? intacto. (~45)

## Phase 3: Verificación (regresión = suites existentes) + NO-GO
- [ ] 3.1 Correr suites existentes que ejercitan los 3 métodos: `dotnet test --filter "FullyQualifiedName~Inscripciones"` (InscripcionesControllerTests, InscripcionesReagendarTests, ServiceReagendarInscripcionTests, ServiceConsultarInscripcionesDeClienteIntegrationTests) + E2E `InscripcionesCancelarE2ETests` + `InscripcionesReagendarE2ETests` (contratos intactos, sin cambios en callers). (~0)
- [ ] 3.2 Validar NO-GO: sin cambios en HorariosHelper, PreReservaDeHorarioHelper, ClasesProgramadasHelper.Registrar*, SPs/esquema/BD, ni DateTime.Now 534/710/974 + ServiceReagendar:109; sin archivos de tests nuevos (decisión usuaria). (~0)

## NO-GO (prohibido tocar)
HorariosHelper; PreReservaDeHorarioHelper; ClasesProgramadasHelper.Registrar*; SPs (sp_obtenerHorariosDisponibles, sp_obtenerEntrenadoresDisponibles) / esquema / BD; otros DateTime.Now (TestHelper 534/710/974, ServiceReagendarInscripcionTests:109); archivos de fecha-referencia-datetime (ya merged, no re-abrir); **NO crear tests nuevos de ningún tipo** (spec 54 eliminado por decisión de la usuaria — cobertura vía suites existentes).

## Review Workload Forecast
- Líneas estimadas: **~410 total** (0.x: 0; 1.1: 60; 1.2: 120; 1.3: 80; 2.1: 55; 2.2: 50; 2.3: 45; 3.x: 0). Excede 400 por margen chico → **Budget risk: MEDIUM** (antes HIGH con tests).
- **Chained PRs: opcional** — el cambio quedó en un solo archivo nuevo (helper) + 3 refactors de 2 archivos existentes, sin tests nuevos. Un solo PR de ~410 es revisable; split solo si se quiere aislar el helper.
- **Decision needed before apply: NO** — PR único con size:exception aprobado por la usuaria; sin verificación de backup (retirada del scope por decisión de la usuaria).
