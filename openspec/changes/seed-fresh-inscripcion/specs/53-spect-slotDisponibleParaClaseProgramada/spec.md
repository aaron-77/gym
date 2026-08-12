# Delta for 53-spect-slotDisponibleParaClaseProgramada

## Purpose

Los seeds de inscripciones de los tests adivinan datos (entrenador, clase, cliente, estado, cupo), produciendo combinaciones (fecha, hora, entrenador) inconsistentes. Se crea un helper independiente `SlotDisponibleParaClaseProgramadaHelper` que arma por construcción todo el dataset de una inscripción (slot + entrenador + clase + cliente libre) usando los stored procedures de disponibilidad, y se refactorizan los 3 métodos que crean inscripciones/clases programadas para consumirlo. Los contratos de retorno de los 3 métodos NO cambian.

## 2. Contexto

- **Capa:** GymWebApp.Tests — helpers de integración (`Integration/Helpers/`)
- **Cambio:** 100% código de tests; NO se modifican SPs, esquema ni BD.

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Propuesta | `openspec/changes/seed-fresh-inscripcion/proposal.md` | Intent, decisiones cerradas y alcance del change | - |
| SP | `dbo.sp_obtenerHorariosDisponibles` | Slot libre: EXCEPT de slots ocupados (clases programadas, pre-reservas, feriados) garantiza que nadie está inscrito en el slot elegido | 06 |
| SP | `dbo.sp_obtenerEntrenadoresDisponibles` | Entrenadores activos para una fecha de referencia; retorna UsuarioID, Nombre, Apellido | 07 |
| Vista | `dbo.v_idEstadoVigenteInscripcionAClase` | Ámbito de estado 'vigente' para el filtro de inscripciones del cliente | - |
| Vista | `dbo.v_idEstadoDisponibleClasesProgramadas` | Ámbito de estado 'disponible' para el estado de la clase programada | - |
| Helper | `HorariosHelper.ObtenerUnHorarioDisponible` | Elegir un slot disponible: `Mayor` + `SinFiltro`; filtra `fecha > fechaBase` internamente | 50/51 |
| Referencia | `PreReservaDeHorarioHelper` | Patrón de composición slot → entrenador (NO se modifica) | - |
| Archivos | `InscripcionEndpointHelper.cs`, `InscripcionTestHelper.cs` | Métodos refactorizados a consumidores del helper | 34/38/40/44 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Change `fecha-referencia-datetime` | En flight | Overlap en `HorariosHelper` (guard clause 2); coordinar orden de apply — nuestros callers pasan null/00:00, guard 2 fuera del path |
| `HorariosHelper.ObtenerUnHorarioDisponible` | Helper | Sin modificar (9 callers) |
| SPs `sp_obtenerHorariosDisponibles` + `sp_obtenerEntrenadoresDisponibles` | BD | Sin modificar; fuente de verdad de disponibilidad |

## ADDED Requirements

### Requirement: Requisito 1 — Nuevo helper `SlotDisponibleParaClaseProgramadaHelper`

SHALL existir un helper nuevo en `GymWebApp.Tests/Integration/Helpers/SlotDisponibleParaClaseProgramadaHelper.cs` con un método público `obtenerSlotDisponibleParaClaseProgramadaAsync(string connectionString, DateOnly? fecha = null, int? fkClase = null)` que SHALL retornar `SlotDisponibleParaClaseProgramadaDto?`: el dataset completo de una inscripción cuando hay un slot disponible, o `null` cuando no hay horarios disponibles.

#### Scenario: Retorna DTO con datos consistentes

- GIVEN la BD tiene horas laborales, ≥1 Empleado Activo, ≥1 clase con `fkEstadoClase = 1` y ≥1 cliente con rol 'cliente'
- WHEN se invoca el helper sin parámetros opcionales
- THEN el resultado es un DTO no nulo

#### Scenario: Retorna null sin horarios

- GIVEN no existen slots disponibles (no hay horas laborales o todas ocupadas)
- WHEN se invoca el helper
- THEN el resultado es null

### Requirement: Requisito 2 — DTO `SlotDisponibleParaClaseProgramadaDto`

SHALL existir un DTO con las columnas: `FechaDisponible` (DateOnly), `IdHoraLaboral` (int), `EntrenadorId` (string), `NombreEntrenador` (string), `ClaseId` (int), `Cupo` (int), `ClienteId` (string). SHALL NOT incluir campo de hora: la hora no se usa en ninguna decisión (SP de entrenadores se invoca solo con la fecha).

#### Scenario: DTO expone las 7 columnas

- GIVEN un resultado no nulo del helper
- WHEN se inspeccionan sus propiedades
- THEN están presentes las 7 columnas y ninguna representa la hora del slot

### Requirement: Requisito 3 — Orquestación interna en orden slot → entrenador → clase → cliente

La orquestación interna del helper SHALL seguir este orden: (1) slot, (2) entrenador, (3) clase, (4) cliente. El slot SHALL elegirse reusando `HorariosHelper.ObtenerUnHorarioDisponible(conn, FiltroFecha.Mayor, FiltroHora.SinFiltro, fecha?)`; si retorna null, el helper SHALL retornar null. SHALL NOT filtrarse manualmente: el filtro `Mayor` ya maneja `fecha > fechaBase` internamente.

#### Scenario: Slot del día siguiente al base

- GIVEN `fecha = 2026-08-11`
- WHEN el helper elige el slot
- THEN la `FechaDisponible` del DTO es posterior a 2026-08-11 (resuelta por el filtro Mayor interno)

#### Scenario: Sin slots, null

- GIVEN `ObtenerUnHorarioDisponible` retorna null
- WHEN se resuelve la orquestación
- THEN el helper retorna null sin ejecutar los pasos restantes

### Requirement: Requisito 4 — Entrenador: solo fecha del slot, disponible == activo

El entrenador SHALL resolverse ejecutando internamente `sp_obtenerEntrenadoresDisponibles` con `@fechaReferencia = slot.FechaDisponible` (SOLO la fecha; hora 00:00 → el SP devuelve todos los activos). "Disponible" == "activo": decisión consciente — si el slot está libre no hay clase programada ahí, por lo tanto todos los entrenadores activos están libres. El DTO SHALL guardar `EntrenadorId` (UsuarioID del SP) y `NombreEntrenador` (compuesto de Nombre + Apellido del SP).

#### Scenario: SP invocado con la fecha del slot

- GIVEN un slot con `FechaDisponible` conocida
- WHEN se resuelve el entrenador
- THEN el SP se invoca con la fecha del slot y el DTO guarda `EntrenadorId` y `NombreEntrenador` del resultado

### Requirement: Requisito 5 — Clase: parámetro fkClase o TOP 1 con fkEstadoClase = 1

La clase SHALL resolverse así: si se recibió el parámetro `fkClase`, se usa esa clase; si no, se consulta la primera clase con `fkEstadoClase = 1` (estado 'Activa'). El DTO SHALL guardar `ClaseId` y `Cupo` real de la clase.

#### Scenario: fkClase explícito

- GIVEN `fkClase = 5`
- WHEN se resuelve la clase
- THEN el DTO usa la clase 5, no una clase aleatoria

#### Scenario: fkClase omitido

- GIVEN no se pasa `fkClase`
- WHEN se resuelve la clase
- THEN se usa la primera clase con `fkEstadoClase = 1` y su `Cupo` real

### Requirement: Requisito 6 — Cliente: una sola consulta desde inscripciones, sin rol, solo vigentes

El helper SHALL invocar internamente el método público `obtenerClienteDisponibleParaSlotAsync(slot.FechaDisponible, slot.IdHoraLaboral)` de la misma clase. Este método SHALL hacer UNA sola consulta SELECT desde `inscripcionesDeClases` (JOIN `clasesProgramadas` + JOIN `horariosDeClasesProgramadas`), SHALL tener un filtro que excluya las inscripciones cuyo `(fechaDeLaClase, fkHorarioLaboral)` coincida con la (fecha, idHoraLaboral) pasadas al método (el cliente buscado es el que NO tiene inscripciones en clases programadas de la fecha y hora de referencia), y SHALL devolver `fkCliente` del primer cliente que cumpla la condición. SHALL filtrar SOLO inscripciones VIGENTES (vía `v_idEstadoVigenteInscripcionAClase`): las canceladas no bloquean. SHALL NOT filtrar por rol 'cliente' (todas las inscripciones son de clientes por construcción, no puede haber una inscripción de un no-cliente). Para el filtro de exclusión, el método SHALL usar `NOT EXISTS` sobre el conjunto de clientes ocupados en la (fecha, hora) de referencia (equivalentemente a `NOT IN`, pero sin el problema de NULLs: `fkCliente` es nullable en el esquema — verificado en `FitnessGymSchemaActual.sql` línea 870). Si ningún cliente cumple, SHALL lanzar la excepción con el texto literal: `El cliente con id {idCliente} ya está inscrito a una clase en ese horario` (guard defensivo inalcanzable: el EXCEPT de slots ocupados del SP de horarios garantiza que el slot elegido no tiene inscripciones).

#### Scenario: Cliente sin inscripción vigente en el slot

- GIVEN existe un cliente con inscripciones vigentes que no incluyen la (fecha, horario) del slot
- WHEN se invoca `obtenerClienteDisponibleParaSlotAsync(fecha, idHoraLaboral)`
- THEN retorna ese `fkCliente`

#### Scenario: Cliente con inscripción cancelada sí es elegible

- GIVEN un cliente con una inscripción NO vigente (cancelada) en el slot
- WHEN se evalúa su disponibilidad
- THEN la inscripción cancelada no cuenta y el cliente es elegible

#### Scenario: Cliente ya inscrito en el slot no aparece

- GIVEN un cliente con una inscripción vigente exactamente en la (fecha, horario) del slot
- WHEN se evalúa su disponibilidad
- THEN ese cliente NO se devuelve (excluido por el filtro de la consulta)

#### Scenario: Guard defensivo sin clientes libres

- GIVEN ningún cliente tiene 0 inscripciones vigentes fuera de la (fecha, horario) del slot
- WHEN se invoca el método
- THEN lanza una excepción cuyo mensaje contiene el texto literal de guard

### Requirement: Requisito 7 — Refactor `InscripcionEndpointHelper.SeedFreshInscripcionAsync`

El método SHALL refactorizarse para consumir el helper (step 4 de la orquestación). SHALL eliminar el bloque de verificación de cliente propio (líneas 19-51): el cliente proviene de `DTO.ClienteId`. SHALL eliminar el `SELECT TOP 1` de `AspNetUsers` para el entrenador (62-66) ya que el entrenador proviene del DTO. El estado de la clase programada SHALL resolverse vía `v_idEstadoDisponibleClasesProgramadas` (no primer row). El cupo SHALL ser el real de `Clases.Cupo` (no hardcodeado). El contrato de retorno `string clienteId` SHALL permanecer intacto.

#### Scenario: Seed con helper inserta los 3 registros

- GIVEN hay slot, entrenador activo, clase activa y cliente libre
- WHEN se invoca `SeedFreshInscripcionAsync`
- THEN se insertan la clase programada, sus horarios y la inscripción
- AND retorna el `clienteId` del DTO

#### Scenario: Sin horarios retorna null

- GIVEN no hay slots disponibles
- WHEN se invoca `SeedFreshInscripcionAsync`
- THEN retorna null sin insertar nada

### Requirement: Requisito 8 — Refactor `InscripcionTestHelper.SeedSingleInscripcionConHoraFuturaAsync`

El método SHALL refactorizarse para consumir el helper: corrige el bug de `DateTime.Now` pasado al SP de entrenadores (431-434) y elimina el cliente aleatorio. Slot, entrenador, clase y cliente SHALL provenir del DTO. El contrato de retorno `(string ClienteId, int IdInscripcion)?` SHALL permanecer intacto: `IdInscripcion` sigue saliendo del INSERT de la inscripción; null cuando no hay horarios.

#### Scenario: Retorna tupla con idInscripcion

- GIVEN slot disponible, entrenador activo, clase activa y cliente libre
- WHEN se invoca el método
- THEN retorna `(ClienteId, IdInscripcion)` con el `IdInscripcion` del INSERT y el `ClienteId` del DTO

#### Scenario: El entrenador es consistente con el slot

- GIVEN estado previo consistente
- WHEN se invoca el método
- THEN el `EntrenadorId` usado en la clase programada es el mismo del slot (sin `DateTime.Now`)

### Requirement: Requisito 9 — Refactor `CreateValidDestinationClassForReagendarAsync`

El método SHALL refactorizarse para consumir el helper con `fkClase = fkClaseOriginal` y `fecha = fechaOriginal`: el filtro `Mayor` interno asegura que la clase destino es posterior a `fechaOriginal`, reemplazando el descarte manual. SHALL NOT usar el cliente helper (mismo cliente, cambia de clase). Corrige el `DateTime.Now` del SP de entrenadores. El retorno `int?` SHALL permanecer intacto.

#### Scenario: Destino posterior a la fecha original

- GIVEN fecha original conocida y `fkClaseOriginal`
- WHEN se invoca el método
- THEN la clase destino creada es posterior a la fecha original (sin `DateTime.Now` ni descarte manual)

## 3.2 Acciones que debe realizar

### Orquestación del helper `obtenerSlotDisponibleParaClaseProgramadaAsync` (en orden):

1. Elegir el slot llamando a `HorariosHelper.ObtenerUnHorarioDisponible` con filtro de fecha `Mayor` y filtro de hora `SinFiltro`, pasando `fecha` opcional
2. Si no hay slot, retornar null (fin)
3. Ejecutar `sp_obtenerEntrenadoresDisponibles` con `@fechaReferencia = slot.FechaDisponible` (solo la fecha) y guardar `EntrenadorId` + `NombreEntrenador` del primer resultado
4. Resolver la clase: usar `fkClase` si se recibió; si no, consultar `ClaseID` y `Cupo` de la primera clase con `fkEstadoClase = 1`
5. Invocar `obtenerClienteDisponibleParaSlotAsync(slot.FechaDisponible, slot.IdHoraLaboral)` y guardar `ClienteId`
6. Armar y retornar el `SlotDisponibleParaClaseProgramadaDto` con los 7 campos

### `obtenerClienteDisponibleParaSlotAsync(fecha, idHoraLaboral)`:

1. Ejecutar UNA sola consulta SELECT desde `inscripcionesDeClases` con JOIN `clasesProgramadas` y JOIN `horariosDeClasesProgramadas`
2. Filtrar solo inscripciones VIGENTES (vía `v_idEstadoVigenteInscripcionAClase`)
3. Excluir con `NOT EXISTS` las inscripciones cuya (fecha, horario) coincida con la pasada al método (el cliente buscado es el que no tiene inscripciones vigentes en esa fecha y hora de referencia)
4. Retornar el `fkCliente` del primer cliente que cumpla la condición
5. Si ninguno cumple, lanzar excepción con el texto literal de guard

## 4. Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Helpers/SlotDisponibleParaClaseProgramadaHelper.cs` | Nuevo helper + DTO interno |
| `GymWebApp.Tests/Integration/Helpers/InscripcionEndpointHelper.cs` | Refactor de `SeedFreshInscripcionAsync` |
| `GymWebApp.Tests/Integration/Helpers/InscripcionTestHelper.cs` | Refactor de `SeedSingleInscripcionConHoraFuturaAsync` y `CreateValidDestinationClassForReagendarAsync` |

## 5. Criterios de aceptación

- [ ] Req 1: helper nuevo en `Integration/Helpers/` con firma y retorno `Dto?`/null
- [ ] Req 2: DTO con las 7 columnas, sin campo hora
- [ ] Req 3: orquestación slot→entrenador→clase→cliente; null sin slots; sin filtrado manual
- [ ] Req 4: SP de entrenadores con SOLO la fecha del slot; `EntrenadorId` + `NombreEntrenador` en el DTO
- [ ] Req 5: clase por `fkClase` o primera con `fkEstadoClase = 1`, con `Cupo` real
- [ ] Req 6: cliente con UNA consulta desde inscripciones, sin rol, solo vigentes, NOT EXISTS sobre (fecha, horario), guard con texto literal
- [ ] Req 7: `SeedFreshInscripcionAsync` sin bloque de cliente propio ni SELECT de entrenador; estado por vista; cupo real; contrato `string` intacto
- [ ] Req 8: `SeedSingleInscripcionConHoraFuturaAsync` sin `DateTime.Now`; cliente del DTO; contrato tupla intacto
- [ ] Req 9: `CreateValidDestinationClassForReagendarAsync` con `fkClase`/`fecha` originales; sin `DateTime.Now`; contrato `int?` intacto
- [ ] Ningún `DateTime.Now` al SP de entrenadores en los 3 métodos refactorizados
