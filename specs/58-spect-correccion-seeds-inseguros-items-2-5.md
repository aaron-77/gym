# spect-58: Corregir seeds inseguros en tests de integración (items 2-5)

## Meta

- **Tipo**: Corrección de tests de integración
- **Scope**: `GymWebApp.Tests/Integration/Features/Clases/`, `GymWebApp.Tests/Integration/Features/Inscripciones/`
- **Depende de**: spect-57 (seeds seguros)
- **Estado**: Propuesto

---

## Motivación

Los tests de integración de los items 2-5 realizan seeds de datos haciendo `INSERT` directo en las tablas `clasesProgramadas`, `horariosDeClasesProgramadas` e `inscripcionesDeClases`, eligiendo entrenador, clase y horario con `ORDER BY NEWID()` sin consultar los stored procedures de disponibilidad (`sp_obtenerHorariosDisponibles`, `sp_obtenerEntrenadoresDisponibles`).

Esto genera dos problemas:

1. **Conflicto con el índice único** `IX_entrenadorfechahora` en `clasesProgramadas (fkEntrenador, fechaDeLaClase, fkHorarioLaboral)` — el seed puede insertar un trainer en un slot que ya tiene clase, causando error de clave duplicada.
2. **Datos inconsistentes** — se elige aleatoriamente un entrenador sin verificar que esté activo y disponible para la fecha/hora seleccionada.

La solución es reemplazar los INSERTs directos por los helpers seguros ya existentes (`SlotDisponibleParaClaseProgramadaHelper`, `HorariosHelper`, `InscripcionTestHelper`) que consultan los SPs de disponibilidad antes de hacer cualquier escritura.

---

## Elementos a corregir

### Item 2: `ReagendarInscripcionAClaseApiTests.cs`

**Archivo**: `GymWebApp.Tests/Integration/Features/Clases/ReagendarInscripcionAClaseApiTests.cs`

**Test afectado**: `ReagendarInscripcionAClase_WithValidData_ReturnsOk`

**Problema**: Líneas 70 y 95 — INSERT directo en `clasesProgramadas` con:
- `fkEntrenador` hardcodeado de email `uno@gmail.com`
- Sin verificar disponibilidad del entrenador para las fechas `fechaClaseAnterior` (hoy+7) y `fechaClaseNueva` (hoy+14)
- Sin insertar en `horariosDeClasesProgramadas`

**Corrección**:
- Reemplazar los INSERTs directos por `SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync`
- Usar el DTO devuelto para insertar clase + horario de forma consistente
- El test debe seguir verificando el flujo de reagendación, no el seed

---

### Item 3: `InscribirAClaseApiTests.cs`

**Archivo**: `GymWebApp.Tests/Integration/Features/Clases/InscribirAClaseApiTests.cs`

**Tests afectados** (3):

| Test | Líneas | Problema |
|------|--------|----------|
| `InscribirAClase_WithValidData_RegistersInscription_ReturnsOk` | 56 | INSERT directo con entrenador hardcodeado `uno@gmail.com` |
| `InscribirAClase_WithNoAvailableSpots_ReturnsBadRequest` | 159 | INSERT directo con `cupoMaximo = 0`, mismo problema de entrenador |
| `InscribirAClase_WithNonExistentClient_ReturnsError` | 251 | INSERT directo, mismo problema de entrenador |

**Corrección para los 3 tests**:
- Reemplazar INSERT directo por `SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync`
- Para el test de "cupo lleno" (`cupoMaximo = 0`): usar el slot seguro pero sobreescribir `Cupo` con valor `0` antes de insertar, manteniendo la consistencia de entrenador/horario

---

### Item 4: `CancelarClasesProgramadasTests.cs`

**Archivo**: `GymWebApp.Tests/Integration/Features/Clases/CancelarClasesProgramadasTests.cs`

**Test afectado**: `CancelarClasesProgramadas_WithValidData_ReturnsOkAndCreatesReagendacion`

**Problema**: Líneas 56 y 81 — INSERT directo en `clasesProgramadas` y `horariosDeClasesProgramadas`:
- `fkEntrenador` obtenido de usuario hardcodeado `uno@gmail.com`
- `fkHoraLaboral` elegido con `ORDER BY NEWID()` sin verificar disponibilidad

**Corrección**:
- Usar `SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync` para obtener dataset consistente
- Reemplazar INSERT directo de clase + horario por el flujo seguro

---

### Item 5: `ServiceReagendarInscripcionTests.cs`

**Archivo**: `GymWebApp.Tests/Integration/Features/Inscripciones/ServiceReagendarInscripcionTests.cs`

**Tests afectados** (2):

| Test | Líneas (INSERT) | Problema |
|------|-----------------|----------|
| `ReagendarInscripcionAsync_InscripcionValidaFutura_ReturnsOk` | 98, 117 | INSERT directo clase + horario; entrenador usa SP pero fecha elegida manualmente |
| `ReagendarInscripcionAsync_TipoClaseDestinoDiferente_ReturnsBadRequest` | 354 | INSERT directo clase sin horario; no verifica disponibilidad de entrenador |

**Nota**: `ReagendarInscripcionAsync_FechaDestinoMenorOIgual_ReturnsBadRequest` se mantiene como está — no requiere corrección de seed.

**Corrección**:
- Para `ReagendarInscripcionAsync_InscripcionValidaFutura_ReturnsOk`: usar `SlotDisponibleParaClaseProgramadaHelper` para el destino, manteniendo la lógica de fecha posterior a la original
- Para `ReagendarInscripcionAsync_TipoClaseDestinoDiferente_ReturnsBadRequest`: usar `sp_obtenerEntrenadoresDisponibles` para elegir entrenador válido antes del INSERT directo (el test no necesita horario porque la validación de `fkClase` ocurre primero)

---

## Métodos seguros a utilizar

| Helper | Método | Uso |
|--------|--------|-----|
| `SlotDisponibleParaClaseProgramadaHelper` | `obtenerSlotDisponibleParaClaseProgramadaAsync` | Dataset completo (fecha + hora + entrenador + clase + cliente) |
| `HorariosHelper` | `ObtenerUnHorarioDisponible` | Solo slot (fecha + hora) |
| `InscripcionTestHelper` | `SeedSingleInscripcionConHoraFuturaAsync` | Inscripción completa con dataset consistente |

---

## Criterios de aceptación

1. Todos los INSERTs directos reemplazados por llamadas a helpers seguros o uso de `sp_obtenerEntrenadoresDisponibles`
2. Ningún test inserta en `clasesProgramadas` con `fkEntrenador` elegido con `ORDER BY NEWID()` o hardcodeado sin verificar disponibilidad
3. Los tests mantienen su propósito original (verificar el endpoint/servicio, no el seed)
4. Los tests de "cupo lleno" siguen funcionando con `cupoMaximo = 0` pero usando dataset consistente para entrenador/horario
5. El índice `IX_entrenadorfechahora` no genera errores de clave duplicada en los tests

---

## Recursos utilizados

- spect-57 (seeds seguros)
- `GymWebApp.Tests/Integration/Helpers/SlotDisponibleParaClaseProgramadaHelper.cs`
- `GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs`
- `GymWebApp.Tests/Integration/Helpers/InscripcionTestHelper.cs`
- `bd/esquemaBdsDeReferenciaParaIa/FitnessGymSchemaActual.sql` (índice `IX_entrenadorfechahora`)
