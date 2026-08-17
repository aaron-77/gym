# Spec: GenerarClaseProgramadaAsync — Seed seguro vía slot disponible

## 1. Resumen

Refactorizar el helper de tests `ClasesProgramadasHelper.GenerarClaseProgramadaAsync` para que deje de armar el DTO adivinando datos con consultas sueltas e inconsistentes (fecha de hoy, primera hora laboral sin verificar disponibilidad, cupo hardcodeado, entrenador desalineado de la fecha del DTO). El método debe delegar el armado del dataset en `SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync`, que ya resuelve por construcción un slot libre, entrenador, clase activa y cupo real.

Como consecuencia directa, eliminar el workaround de fecha/hora en el Arrange de `ObtenerClasesProgramadasPorIdApiTests`, que solo existía porque el seed era inseguro.

## 2. Contexto

- **Capa:** Tests (GymWebApp.Tests) — helpers compartidos y un test de integración caller
- **Cambio:** 100% código de tests. NO se modifican SPs, esquema, BD ni producción.

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Helper | `ClasesProgramadasHelper.GenerarClaseProgramadaAsync` | Método a refactorizar: arma `DTODatosClaseProgramada` para seeds de tests | 12 |
| Helper | `SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync` | Orquesta slot libre + entrenador + clase + cupo real (y cliente, no usado acá) | 53 (openspec `seed-fresh-inscripcion`) |
| Helper | `HorariosHelper.ObtenerUnHorarioDisponible` | Slot disponible; ya usado internamente por el helper de slot (FiltroFecha.Mayor + FiltroHora.SinFiltro) | 06 / 50 |
| Helper | `ClasesProgramadasHelper.RegistrarClaseProgramadaML` | Registro de clase + horario en el test de integración caller | 12 |
| Test | `ObtenerClasesProgramadasPorIdApiTests` | Caller con workaround de fin de jornada a eliminar | 14 |
| Test | `E2EHappyPathsTests.Empleado_InscribirClienteAClase` | Caller E2E que solo invoca Generar + Registrar; no se modifica salvo que deje de compilar | e2e |
| DTO | `DTODatosClaseProgramada` | Contrato de salida del método a refactorizar | 12 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `obtenerSlotDisponibleParaClaseProgramadaAsync` | Helper de tests | Debe existir y estar operativo (ya implementado en el change 53) |
| `sp_obtenerHorariosDisponibles` / `sp_obtenerEntrenadoresDisponibles` | BD | Sin modificar; fuente de verdad de disponibilidad vía el helper de slot |
| Firma pública de `GenerarClaseProgramadaAsync` | Contrato | Se mantiene: recibe connection string y retorna `DTODatosClaseProgramada` |

## 3. Problema actual (deuda a cerrar en este spec)

`GenerarClaseProgramadaAsync` arma el DTO así hoy:

| Campo | Origen actual | Problema |
|-------|---------------|----------|
| `fkClase` | Primera clase activa | Aceptable, pero sin cupo real de la clase |
| `fkHoraLaboral` | Primera fila de `horasLaborales` | No verifica si el slot está libre |
| `fkEntrenador` | SP con mañana + hora de la primera laboral | Fecha/hora desalineada respecto de `fechaDeLaClase` del DTO |
| `fechaDeLaClase` | Fecha de hoy | Puede chocar con slots ocupados o fin de jornada |
| `cupoMaximo` | Valor fijo 20 | Ignora el cupo real de la clase |
| `fkEstadoClaseProgramada` | 1 (Disponible) | Correcto; se conserva |
| `idUsuarioQueReserva` | null | Correcto para pre-reserva sin cliente; se conserva |

Ese seed inseguro obligó a un parche en `ObtenerClasesProgramadasPorIdApiTests`: si la hora actual está cerca o pasada del máximo laboral, sobrescribe a mano `fechaDeLaClase` y `fkHoraLaboral` con un slot futuro. Ese workaround es síntoma del helper roto, no lógica de negocio del test.

## 4. Cambios a realizar

### 4.1 Archivos

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `GymWebApp.Tests/SharedHelpers/ClasesProgramadasHelper.cs` | Modificar | Refactor de `GenerarClaseProgramadaAsync` para consumir el helper de slot |
| `GymWebApp.Tests/Integration/Features/Clases/ObtenerClasesProgramadasPorIdApiTests.cs` | Modificar | Eliminar el workaround de fin de jornada / override de fecha-hora; Arrange queda en Generar → Registrar |

### 4.2 Contrato de `GenerarClaseProgramadaAsync`

- **Firma:** sin cambios. Sigue recibiendo el connection string y retornando `Task<DTODatosClaseProgramada>`.
- **Semántica nueva:** el DTO retornado debe representar un dataset **consistente por construcción** (slot libre + entrenador alineado a la fecha del slot + clase activa + cupo real), no datos adivinados.
- **Null del helper de slot:** si `obtenerSlotDisponibleParaClaseProgramadaAsync` retorna null, el método debe fallar con una excepción de operación inválida y mensaje claro indicando que no hay horarios disponibles (mismo estilo que otros registradores del helper). No retornar un DTO vacío ni con ceros.

### 4.3 Mapeo slot → DTO

| Campo de `DTODatosClaseProgramada` | Origen |
|------------------------------------|--------|
| `fkClase` | Identificador de clase del slot |
| `fkEntrenador` | Identificador de entrenador del slot |
| `fkHoraLaboral` | Identificador de hora laboral del slot |
| `fechaDeLaClase` | Fecha disponible del slot |
| `cupoMaximo` | Cupo real de la clase del slot |
| `fkEstadoClaseProgramada` | Estado disponible (valor 1), sin cambiar la convención actual |
| `idUsuarioQueReserva` | Sin usuario (null), pre-reserva sin cliente |
| `idPreservaDeHorario` | Sin pre-reserva explícita (null), salvo que el contrato actual del DTO en este método ya lo deje implícito |

El campo de cliente del DTO de slot **no se usa** en este método: `GenerarClaseProgramadaAsync` solo arma datos de clase programada, no de inscripción.

### 4.4 Acciones que debe realizar `GenerarClaseProgramadaAsync`

1. Invocar `obtenerSlotDisponibleParaClaseProgramadaAsync` con el connection string recibido (sin forzar fecha ni clase: defaults del helper de slot).
2. Si el resultado es nulo, lanzar excepción de operación inválida con mensaje que indique ausencia de horarios disponibles.
3. Mapear el DTO de slot al `DTODatosClaseProgramada` según la tabla de la sección 4.3.
4. Retornar el DTO listo para que el caller lo registre (`RegistrarClaseProgramadaAsync`, `RegistrarClaseProgramadaML`, u otro).
5. Eliminar las consultas directas sueltas a clases, horas laborales y entrenadores que hoy viven dentro del método.
6. Conservar el manejo de error existente del método (log de consola + rethrow) o el patrón equivalente del archivo, sin tragar excepciones.

### 4.5 Cleanup del caller de integración (punto 5 del plan)

En `ObtenerClasesProgramadasPorIdApiTests`, el Arrange que seedea la clase programada debe quedar así en intención:

1. Autenticar si el test lo requiere (sin cambios de auth).
2. Generar el DTO con `GenerarClaseProgramadaAsync`.
3. Registrar con `RegistrarClaseProgramadaML` (u el registrador que ya use el test).
4. Continuar con la obtención del id de clase y las aserciones del escenario del spec 14.

Debe **eliminarse**:

- La consulta a la hora laboral máxima usada solo para decidir el parche.
- El condicional por reloj (`TimeOfDay` vs máximo laboral).
- La llamada directa a `ObtenerUnHorarioDisponible` dentro de ese Arrange.
- La sobrescritura manual de `fechaDeLaClase` y `fkHoraLaboral` sobre el DTO generado.

Justificación: con el seed seguro, la fecha y la hora ya vienen de un slot futuro disponible; el parche es redundante y confunde la intención del test.

### 4.6 Caller E2E

`E2EHappyPathsTests.Empleado_InscribirClienteAClase` solo llama Generar + Registrar. **No se modifica** en este cambio, salvo ajuste mecánico si deja de compilar por firma (no debería: la firma se conserva).

### 4.7 Patrones a aplicar

- **Composición, no duplicación:** un solo choke point de disponibilidad (`obtenerSlotDisponibleParaClaseProgramadaAsync`); el generador no reimplementa queries de slot/entrenador/clase.
- **Consistencia por construcción:** fecha, hora, entrenador y clase salen del mismo dataset orquestado.
- **Contrato estable:** callers existentes no cambian firma ni tipo de retorno.
- **Síntoma vs causa:** se elimina el workaround del test porque se corrige la causa en el helper.

## 5. Fuera de alcance (explícito)

Estos métodos/helpers tienen deuda similar (seed adivinando o entrenador desalineado) y **NO** se tocan en este spec. Quedan como deuda técnica pendiente de specs propios:

| Ítem | Ubicación | Motivo de exclusión |
|------|-----------|---------------------|
| `RegistrarClaseProgramadaActual` | `ClasesProgramadasHelper` | Misma familia de deuda; otro ticket |
| `RegistrarClaseProgramadaPasada` | `ClasesProgramadasHelper` | Misma familia de deuda; otro ticket |
| Otros seeds de `InscripcionTestHelper` no listados acá | `InscripcionTestHelper` | Cubiertos o pendientes en change 53 / specs propios |
| Cambios a SPs, esquema o producción | BD / API / BL | Fuera del problema |
| Specs o tests nuevos derivados | — | Este cambio es refactor de helper + cleanup de un caller; no agrega escenarios de prueba nuevos salvo que el compile/regresión lo exija |
| Renombrar `GenerarClaseProgramadaAsync` | — | Fuera de alcance |

## 6. Archivos a crear / modificar

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/SharedHelpers/ClasesProgramadasHelper.cs` | Refactor de `GenerarClaseProgramadaAsync` |
| `GymWebApp.Tests/Integration/Features/Clases/ObtenerClasesProgramadasPorIdApiTests.cs` | Eliminar workaround de slot manual en Arrange |
| `specs/57-spect-generarClaseProgramada-seedSeguro.md` | Este documento |

## 7. Criterios de aceptación

- [ ] `GenerarClaseProgramadaAsync` obtiene el dataset vía `obtenerSlotDisponibleParaClaseProgramadaAsync` (no con TOP 1 sueltos de horas/clases ni SP de entrenador con fecha desalineada)
- [ ] El DTO mapea fecha, hora laboral, entrenador, clase y cupo real desde el slot
- [ ] `fkEstadoClaseProgramada` sigue en disponible y `idUsuarioQueReserva` sigue en null
- [ ] Si no hay slot, se lanza excepción clara (no DTO con ceros / datos basura)
- [ ] Firma pública del método sin cambios
- [ ] Eliminadas del método las consultas directas inseguras que este spec reemplaza
- [ ] En `ObtenerClasesProgramadasPorIdApiTests` no queda el condicional por fin de jornada ni el override manual de fecha/hora sobre el DTO generado
- [ ] El Arrange del test de integración queda en Generar → Registrar sin parches de reloj
- [ ] Caller E2E sigue compilando sin cambios de firma
- [ ] NO se modifican `RegistrarClaseProgramadaActual`, `RegistrarClaseProgramadaPasada` ni otros seeds con la misma deuda
- [ ] Sin código de producción tocado
- [ ] Spec sin bloques de código (solo descripciones, tablas y listas)

## 8. Notas de implementación (para quien aplique)

- Reutilizar el helper de slot existente; no copiar su orquestación dentro de `ClasesProgramadasHelper`.
- El helper de slot ya usa fecha futura (`FiltroFecha.Mayor`); no reintroducir “hoy” como default del generador.
- El cleanup del test de integración es parte obligatoria de este cambio, no un follow-up opcional.
- Si al aplicar se detecta otro caller que parchea el DTO de `GenerarClaseProgramadaAsync` por la misma razón, reportarlo; no expandir alcance sin confirmación.
