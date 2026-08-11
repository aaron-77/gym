# Delta for 54-spect-slotDisponibleParaClaseProgramada-test

## Purpose

Pruebas de integración para el helper `SlotDisponibleParaClaseProgramadaHelper` y los 3 consumidores refactorizados. Todos los escenarios son tests de INTEGRACIÓN con BD real vía Testcontainers + Respawn (NO unit tests): el helper consulta stored procedures y tablas reales, y los seeds insertan registros en BD. Se aplica la regla estricta de GymWebApp.Tests/AGENTS.md: SOLO se implementan los escenarios documentados en este spec; NO se permiten tests derivados.

## 2. Contexto

- **Capa:** GymWebApp.Tests — tests de integración (`Integration/Features/Inscripciones/`) y helper nuevo (`Integration/Helpers/`)
- **Base previa:** los tests existentes de las features de inscripciones siguen este patrón y NO cambian

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Helper a probar | `SlotDisponibleParaClaseProgramadaHelper` | Objeto bajo test | 53 |
| Seeds refactorizados | `InscripcionEndpointHelper.SeedFreshInscripcionAsync`, `InscripcionTestHelper.SeedSingleInscripcionConHoraFuturaAsync`, `InscripcionTestHelper.CreateValidDestinationClassForReagendarAsync` | Consumidores del helper | 53 |
| Test base | `GymWebApp.Tests/Integration/Features/Inscripciones/` | Archivos con patrón de integración existente: `InscripcionesControllerTests.cs`, `InscripcionesReagendarTests.cs`, `ServiceReagendarInscripcionTests.cs`, `ServiceConsultarInscripcionesDeClienteIntegrationTests.cs` | 34/38/40/44 |
| E2E base | `GymWebApp.Tests/E2E/Features/` | `InscripcionesCancelarE2ETests.cs`, `InscripcionesReagendarE2ETests.cs` (usan los seeds; contratos intactos) | - |
| Infraestructura | `TestContainerHelper`, `RespawnHelper`, `DatabaseHelper`, factories Bogus existentes | BD real en Docker + limpieza entre tests + aserciones directas | - |

### 2.2 Dependencias de testing

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `Testcontainers` + `TestContainerHelper` | Infraestructura | SQL Server real en Docker |
| `Respawn` (+ `RespawnHelper`) | Limpieza | Reset entre tests (no limpia AspNetUsers/Clases/horas) |
| Backup de pruebas | Datos | Requiere horas laborales, ≥1 Empleado Activo y ≥1 cliente con rol 'cliente' |

## 3. Escenarios de test aprobados

Todos los escenarios son tests de INTEGRACIÓN (BD real). Ubicación sugerida: `GymWebApp.Tests/Integration/Features/Inscripciones/` (patrón de archivos existente) o, si corresponde, junto a los helpers.

### 3.1 Helper devuelve DTO completo y consistente

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 1 | `obtenerSlotDisponibleParaClaseProgramadaAsync` devuelve DTO con slot/entrenador/clase/cliente consistentes | BD con horas laborales, ≥1 Empleado Activo, clase activa y cliente con rol 'cliente' disponibles | DTO no nulo; entrenador es un usuario activo del SP; clase tiene `fkEstadoClase = 1`; cliente tiene rol 'cliente' y 0 inscripciones vigentes en el slot |

#### Scenario: Slot libre completo

- GIVEN existen horas laborales, un Empleado Activo, una clase con `fkEstadoClase = 1` y un cliente con rol 'cliente'
- WHEN se invoca el helper sin parámetros opcionales
- THEN retorna un DTO no nulo
- AND el `EntrenadorId` corresponde a un usuario activo
- AND el `ClienteId` corresponde a un usuario con rol 'cliente'
- AND el `Cupo` es el real de la clase

### 3.2 Helper retorna null sin horarios disponibles

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 2 | Helper devuelve null cuando no hay horarios | Sin horas laborales disponibles (o todas ocupadas) | null sin armar el resto del dataset |

#### Scenario: Sin slot no hay dataset

- GIVEN no existen slots disponibles
- WHEN se invoca el helper
- THEN retorna null
- AND no se evalúan entrenador, clase ni cliente

### 3.3 Helper usa la clase indicada por fkClase

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 3 | Helper respeta `fkClase` explícito | Se pasa `fkClase` de una clase activa conocida | DTO con `ClaseId` igual al pasado (no clase aleatoria) |

#### Scenario: fkClase prevalece

- GIVEN una clase activa conocida con id X
- WHEN se invoca el helper con `fkClase = X`
- THEN el DTO contiene `ClaseId = X`

### 3.4 Helper con fecha respeta el filtro Mayor (solo slots posteriores)

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 4 | Helper con `fecha` usa solo slots posteriores | Se pasa una fecha base | `FechaDisponible` del DTO es posterior a la fecha base |

#### Scenario: Fecha base respetada

- GIVEN fecha base conocida `F`
- WHEN se invoca el helper con `fecha = F`
- THEN `FechaDisponible > F` (resuelto por el filtro Mayor interno, sin descarte manual)

### 3.5 Cliente libre con rol 'cliente'

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 5 | `obtenerClienteDisponibleParaSlotAsync` devuelve cliente con rol 'cliente' libre en el slot | BD con clientes con rol 'cliente' sin inscripciones vigentes en el (fecha, horario) | Retorna un `ClienteId` cuyo usuario tiene rol 'cliente' y 0 inscripciones vigentes en el slot |

#### Scenario: Cliente elegible

- GIVEN un usuario con rol 'cliente' sin inscripciones vigentes en el (fecha, horario)
- WHEN se invoca `obtenerClienteDisponibleParaSlotAsync(fecha, idHoraLaboral)`
- THEN retorna ese `ClienteId`

### 3.6 Cliente con inscripción cancelada sí es elegible

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 6 | `obtenerClienteDisponibleParaSlotAsync` NO cuenta inscripciones canceladas | Se siembra una inscripción en el slot y se cancela (estado no vigente); el cliente sigue siendo elegible | Retorna `ClienteId` del cliente a pesar de la inscripción cancelada |

#### Scenario: Cancelada no bloquea el slot

- GIVEN un cliente con una inscripción en el slot que fue cancelada (estado no vigente vía `v_idEstadoVigenteInscripcionAClase`)
- WHEN se invoca `obtenerClienteDisponibleParaSlotAsync(fecha, idHoraLaboral)`
- THEN el cliente es elegible y retorna su `ClienteId`

### 3.7 EndpointHelper inserta los 3 registros y retorna clienteId

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 7 | `SeedFreshInscripcionAsync` inserta clase programada + horarios + inscripción y retorna `clienteId` | BD con slot, entrenador activo, clase activa y cliente libre | Retorna `string clienteId` no nulo; existen 1 clase programada (estado disponible), sus horarios y 1 inscripción en BD, todos consistentes con el slot |

#### Scenario: Seed completo del EndpointHelper

- GIVEN slot, entrenador activo, clase activa y cliente libre
- WHEN se invoca `SeedFreshInscripcionAsync`
- THEN retorna un `clienteId` no nulo
- AND existe exactamente 1 clase programada con estado disponible (vista `v_idEstadoDisponibleClasesProgramadas`)
- AND existe 1 inscripción asociada con estado vigente y el `ClienteId` retornado

### 3.8 TestHelper devuelve tupla con entrenador consistente

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 8 | `SeedSingleInscripcionConHoraFuturaAsync` retorna `(ClienteId, IdInscripcion)` con entrenador consistente con el slot | BD con disponibilidad completa | Tupla no nula; `IdInscripcion > 0`; el entrenador usado en la clase programada es el mismo que devuelve el SP para la fecha del slot (sin `DateTime.Now`) |

#### Scenario: Tupla completa del TestHelper

- GIVEN slot disponible, entrenador activo, clase activa y cliente libre
- WHEN se invoca `SeedSingleInscripcionConHoraFuturaAsync`
- THEN retorna una tupla con `ClienteId` y `IdInscripcion > 0`
- AND el entrenador de la clase programada coincide con el entrenador del slot (consistente por construcción)

### 3.9 CreateValidDestinationClassForReagendarAsync crea destino posterior

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 9 | `CreateValidDestinationClassForReagendarAsync` crea clase destino posterior a la fecha original | Se parte de una inscripción con fecha original conocida | Retorna `int?` no nulo; la clase programada destino tiene fecha posterior a la original y usa la clase original |

#### Scenario: Destino posterior garantizado

- GIVEN una fecha original y una clase original conocidas
- WHEN se invoca `CreateValidDestinationClassForReagendarAsync(fkClaseOriginal, fechaOriginal)`
- THEN retorna un id no nulo de la clase programada destino
- AND la fecha de la clase destino es posterior a `fechaOriginal`
- AND el destino mantiene el cliente original

## 4. Criterios de aceptación (tests)

- [ ] Escenario 1: DTO completo y consistente (entrenador activo, clase activa, cliente rol 'cliente', cupo real)
- [ ] Escenario 2: null sin horarios
- [ ] Escenario 3: `fkClase` respetado (no clase aleatoria)
- [ ] Escenario 4: `FechaDisponible > fecha base` con filtro Mayor interno
- [ ] Escenario 5: cliente con rol 'cliente' libre en el slot
- [ ] Escenario 6: inscripción cancelada no bloquea al cliente (filtro solo vigentes)
- [ ] Escenario 7: EndpointHelper inserta los 3 registros y retorna `clienteId`
- [ ] Escenario 8: TestHelper retorna tupla con entrenador consistente con el slot
- [ ] Escenario 9: clase destino posterior a la fecha original, sin `DateTime.Now`
- [ ] NO se implementan tests derivados fuera de este spec

## Notas

- Siguen fuera de alcance los tests derivados NO documentados aquí: por ejemplo, la guard de cliente ocupado (inalcanzable por construcción), la excepción del guard del helper, o variantes de combinaciones de parámetros no listadas.
- No se cubren los demás `DateTime.Now` pendientes (`InscripcionTestHelper` 534, 710, 974 + `ServiceReagendarInscripcionTests:109`): son un change futuro, no parte de los escenarios de este spec.
- Los escenarios 5 y 6 prueban el método público interno `obtenerClienteDisponibleParaSlotAsync` (público pero orquestado dentro del helper).
- Los tests E2E existentes (`Cancelar`/`Reagendar`) no requieren nuevos escenarios: validan que los contratos de retorno se mantienen.