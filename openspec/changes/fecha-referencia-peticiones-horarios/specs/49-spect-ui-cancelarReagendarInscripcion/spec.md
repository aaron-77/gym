# Delta for 49-spect-ui-cancelarReagendarInscripcion

## Purpose

`fetchClasesProgramadas` envía la fecha de referencia del browser (formato `yyyy-MM-dd`) como query param `fecha` en la petición GET a `/clases/obtenerClasesProgramadasPorId`, junto con `idClase`. Con esto la consulta de clases programadas se evalúa contra el mismo reloj que el resto del flujo de reagendar.

## ADDED Requirements

### Requirement: fetchClasesProgramadas envía la fecha de referencia

`fetchClasesProgramadas` MUST include el query param `fecha` con la fecha actual del browser formateada `yyyy-MM-dd` (mismo helper/formato que `agendarioDeHorarios.js`) en la petición a `/clases/obtenerClasesProgramadasPorId`, además del `idClase` existente. TODOS los flujos que la invocan DEBEN enviar la fecha.

#### Scenario: Al marcar el check "Reagendar" con inscripción seleccionada

- DADO el check "Reagendar" marcado
- Y una inscripción seleccionada en el comboInscripcion
- CUANDO se ejecuta `fetchClasesProgramadas`
- ENTONCES la petición a `/clases/obtenerClasesProgramadasPorId` DEBE incluir `idClase` y `fecha` (hoy, `yyyy-MM-dd`)
- Y el scheduler se actualiza con las clases programadas recibidas

#### Scenario: Al seleccionar una inscripción con el check ya marcado

- DADO el check "Reagendar" marcado
- CUANDO el usuario selecciona una inscripción en el comboInscripcion
- ENTONCES la petición DEBE incluir `idClase` y `fecha` (hoy, `yyyy-MM-dd`)

#### Scenario: Actualización por SignalR de clases programadas

- DADO el calendario inicializado
- CUANDO se recibe una actualización `actualizarClasesProgramadas` que dispara `fetchClasesProgramadas`
- ENTONCES la petición DEBE incluir `idClase` y `fecha` (hoy, `yyyy-MM-dd`)

## MODIFIED Requirements

### 4.3 Peticiones HTTP (desde JavaScript) — Obtener clases programadas

La petición de obtención de clases programadas incluye ahora la fecha de referencia del browser como query param, además del id de clase.
(Previously: la petición solo enviaba `idClase` como query param)

#### Scenario: Petición con idClase y fecha de referencia

- DADO una inscripción seleccionada con `fkClase` válido
- CUANDO se consultan las clases programadas para reagendar
- ENTONCES la ruta es `/clases/obtenerClasesProgramadasPorId` con query params `idClase` y `fecha` (hoy, `yyyy-MM-dd`)
- Y el resto del flujo de reagendar permanece sin cambios
