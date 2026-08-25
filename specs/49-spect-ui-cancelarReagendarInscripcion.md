# Spec: Frontend - UI Cancelar/Reagendar Inscripción

## 1. Resumen

Crear la vista "CancelarReagendarInscripcion" con su JavaScript asociado, que permite seleccionar un cliente,
ver sus inscripciones vigentes en un combo, y cancelar o reagendar una inscripción,
utilizando el mismo patrón de `RegistroDeClasesProgramadas.cshtml` (componentes `Calendar` + `ScheduleViewer` + `agendarioDeHorarios.js`)
para consultar las clases programadas disponibles al reagendar.

## 2. Contexto

- **Capa:** GymFrontend Views + JS

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Archivo/Spec |
|---------|--------|-------------|-------------|
| Controller | GET `/inscripciones/cancelarReagendar` | Sirve la vista con lista de clientes | spec 48 |
| Vista | `_Calendario.cshtml` | Partial del calendario | `Views/Shared/_Calendario.cshtml` |
| Vista | `_HorariosDelDia.cshtml` | Partial del scheduler de horarios | `Views/Shared/_HorariosDelDia.cshtml` |
| JS | `Calendar` | Clase del calendario | `wwwroot/js/calendario.js` |
| JS | `ScheduleViewer` | Clase del visualizador de horarios | `wwwroot/js/horariosDelDia.js` |
| JS | `agendarioDeHorarios.js` | Orquestador calendario + scheduler + SignalR | `wwwroot/js/agendarioDeHorarios.js` |
| JS | `httpClient.js` | Cliente HTTP con `realizarPeticionAPI` | `wwwroot/js/httpClient.js` |
| Frontend Endpoint | `POST /inscripciones/cancelar` | Proxy frontend cancelación | spec 45 |
| Frontend Endpoint | `POST /inscripciones/reagendar` | Proxy frontend reagendación | spec 47 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `signalR` | Librería JS | Conexión en tiempo real para clases programadas |

## 3. Vista a crear

### 3.1 Archivos

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `GymFrontend/Views/Inscripciones/CancelarReagendarInscripcion.cshtml` | Crear | Vista principal |
| `GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js` | Crear | JS específico (módulo ES6) |
| `GymFrontend/wwwroot/css/cancelarReagendarInscripcion.css` | Crear | Estilos específicos |

### 3.2 Estructura de la UI

La vista se organiza en un formulario con las siguientes secciones, en orden de arriba a abajo:

**ComboCliente:** Selector de clientes. Las opciones se llenan en Razor desde los datos que pasa el controller (spec 48). El value de cada opción es el ID del cliente (GUID).

**ComboInscripcion:** Selector de inscripciones. Se llena dinámicamente desde JavaScript al seleccionar un cliente. Cada opción muestra el nombre de la clase y la fecha de la clase programada separados por un guión. El value de la opción es el idInscripcion. Cada opción tiene un data attribute `idClaseProgramada` que almacena el ID de la clase programada de esa inscripción, y un data attribute `fechaDeLaClase` con la fecha de la clase de esa inscripción (usada como fecha de referencia al consultar las clases programadas disponibles para reagendar).

**Checkbox "Reagendar":** Control que muestra u oculta el calendario y scheduler. Al marcarlo, se consultan las clases programadas disponibles para la clase de la inscripción seleccionada.

**Calendario:** Partial `_Calendario.cshtml`. Oculto inicialmente. Se muestra solo cuando el check "Reagendar" está marcado.

**Scheduler (visor de horarios):** Partial `_HorariosDelDia.cshtml`. Oculto inicialmente. Se muestra solo cuando el check "Reagendar" está marcado.

**Botón ejecutar:** Botón cuyo texto cambia según el estado del check. Si no está marcado, muestra "Cancelar". Si está marcado, muestra "Reagendar".

**Botón limpiar:** Botón que resetea todos los campos de la UI a su estado inicial.

### 3.3 Valores desde combobox

| Dato | De dónde se obtiene |
|------|-------------------|
| `idCliente` | Del value del comboCliente |
| `idInscripcion` | Del value del comboInscripcion |
| `idClaseProgramada` | Del data attribute `idClaseProgramada` de la opción seleccionada en comboInscripcion |
| `fechaDeLaClase` | Del data attribute `fechaDeLaClase` de la opción seleccionada en comboInscripcion |

No se usan inputs ocultos para estos valores.

### 3.4 Scripts incluidos en la vista

Los scripts se incluyen en el mismo orden que en `RegistroDeClasesProgramadas.cshtml`:
1. SignalR (CDN de Microsoft)
2. `messageManager.mjs`
3. `httpClient.js`
4. `calendario.js`
5. `horariosDelDia.js`
6. `agendarioDeHorarios.js`
7. `cancelarReagendarInscripcion.js`

### 3.5 Estilos CSS

Se incluyen los mismos estilos que `RegistroDeClasesProgramadas`:
- `calendarioStyles.css`
- `horariosDelDia.css`
- Archivo adicional específico: `cancelarReagendarInscripcion.css`

## 4. Comportamiento JavaScript

### 4.1 Archivo JS

Crear `cancelarReagendarInscripcion.js` como módulo ES6 (`type="module"`), reutilizando los mismos componentes y lógica que `RegistroDeClasesProgramadas`:

| Componente | Origen | Uso |
|------------|--------|-----|
| `Calendar` | `calendario.js` | Instanciar calendario para seleccionar fecha de la nueva clase programada |
| `ScheduleViewer` | `horariosDelDia.js` | Instanciar scheduler para ver horarios disponibles |
| `agendarioDeHorarios.js` | `agendarioDeHorarios.js` | Reutilizar SignalR, obtención de clases programadas, lógica de horarios |
| `realizarPeticionAPI` | `httpClient.js` | Llamadas HTTP |
| `showMessage` | `messageManager.mjs` | Mensajes al usuario |

### 4.2 Flujo principal

**Al cargar la vista:**
- El comboCliente ya está lleno desde Razor (no lo toca JS)
- Se inicializa la conexión SignalR reusando el patrón de `agendarioDeHorarios.js`
- Se renderiza el calendario y scheduler ocultos inicialmente
- Se bindean los eventos de UI (change, click)

**Al seleccionar un cliente:**
- Se obtiene el idCliente del value del comboCliente
- Se hace una petición GET a la API `/inscripciones/cliente?idCliente={idCliente}`
- Se reciben las inscripciones del cliente (cada una incluye: idInscripcion, nombreClase, fechaDeLaClase, idClaseProgramada)
- Se llena el comboInscripcion: cada opción tiene como value el idInscripcion, como texto visible "nombreClase — fechaDeLaClase", y un data attribute idClaseProgramada con el ID de la clase programada

**Al seleccionar una inscripción:**
- Se obtiene el idInscripcion del value del comboInscripcion
- Se obtiene el idClaseProgramada del data attribute de la opción seleccionada
- Se obtiene la fechaDeLaClase del data attribute de la opción seleccionada
- Si el check "Reagendar" está marcado, se consultan las clases programadas para ese idClaseProgramada, enviando como `fecha` la fechaDeLaClase de la inscripción seleccionada (no la fecha de hoy), de modo que el backend solo devuelva clases con fecha mayor o igual a la de la inscripción que se quiere reagendar

**Al marcar/desmarcar el check "Reagendar":**
- Si se marca: se muestra el calendario y scheduler, se consultan las clases programadas para la clase programada de la inscripción seleccionada enviando como `fecha` la fechaDeLaClase de dicha inscripción (reusando funciones de `agendarioDeHorarios.js`), se inicializa el calendario con `Calendar`, se inicializa el scheduler con `ScheduleViewer`, y el texto del botón ejecutar cambia a "Reagendar"
- Si se desmarca: se oculta el calendario y scheduler, y el texto del botón ejecutar vuelve a "Cancelar"

**Al seleccionar una fecha en el calendario:**
- Se obtienen las clases programadas para la fecha seleccionada y la clase programada de la inscripción
- Se actualiza el scheduler con los horarios disponibles usando ScheduleViewer.loadSchedules()

**Al hacer click en el botón ejecutar:**

Opción CANCELAR (check no marcado):
- Se obtiene el idInscripcion del value del comboInscripcion
- Se hace un POST a nginx hacia `/inscripciones/cancelar` con body `{ idInscripcion }`
- El frontend proxy (spec 45) agrega el userId y reenvía al API

Opción REAGENDAR (check marcado):
- Se valida que haya un horario seleccionado en el scheduler
- Se obtiene el idInscripcion del comboInscripcion
- Se obtiene el idCliente del comboCliente
- Se obtiene la idClaseProgramada de la inscripción seleccionada (desde el data attribute)
- Se obtiene la nueva idClaseProgramada del horario seleccionado en el scheduler
- Se hace un POST a nginx hacia `/inscripciones/reagendar` con body `{ idInscripcion, idClaseProgramada, idCliente }`
- El frontend proxy (spec 47) agrega el userId y reenvía al API

En ambos casos:
- Se muestra un mensaje de éxito o error reusando `showMessage` de `messageManager.mjs`
- Si la operación es exitosa, se limpian los campos

**Al hacer click en el botón limpiar:**
- Se resetea el comboCliente a su valor por defecto
- Se limpia el comboInscripcion (solo queda la opción por defecto)
- Se desmarca el check "Reagendar"
- Se oculta el calendario y scheduler
- El botón ejecutar vuelve a mostrar "Cancelar"

**SignalR (reusando el patrón de `agendarioDeHorarios.js`):**
- Se conecta al hub `/reservacionesHub`
- Se escuchan los eventos: `actualizarClasesProgramadas` y `actualizarCuposDeClases`
- Al recibir una actualización, si hay una clase seleccionada que coincida con la actualización, se actualiza el calendario y el scheduler

### 4.3 Peticiones HTTP (desde JavaScript)

| Acción | Método | Ruta (nginx) | Descripción |
|--------|--------|-------------|-------------|
| Obtener inscripciones del cliente | GET | `/inscripciones/cliente?idCliente=X` | Se pasa idCliente como query param |
| Obtener clases programadas | GET | `/clases/obtenerClasesProgramadasPorId?idClase=X` | Se pasa idClaseProgramada como query param y `fecha` con la fechaDeLaClase de la inscripción seleccionada, para que el backend devuelva solo clases con fecha mayor o igual a la de la inscripción que se quiere reagendar |
| Cancelar inscripción | POST | `/inscripciones/cancelar` | Body: `{ idInscripcion }` |
| Reagendar inscripción | POST | `/inscripciones/reagendar` | Body: `{ idInscripcion, idClaseProgramada, idCliente }` |

## 5. Archivos a crear

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `GymFrontend/Views/Inscripciones/CancelarReagendarInscripcion.cshtml` | Crear | Vista principal |
| `GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js` | Crear | JS específico que importa Calendar, ScheduleViewer y agendarioDeHorarios |
| `GymFrontend/wwwroot/css/cancelarReagendarInscripcion.css` | Crear | Estilos específicos |

## 6. Criterios de aceptación

- [ ] comboCliente se llena en Razor desde los datos del controller
- [ ] Al seleccionar cliente, JS consulta inscripciones vía API y llena comboInscripcion
- [ ] comboInscripcion muestra: "nombreClase — fechaDeLaClase" con value=idInscripcion y data attributes idClaseProgramada y fechaDeLaClase
- [ ] No hay inputs ocultos para idInscripcion ni idCliente — se obtienen de los combobox
- [ ] Checkbox "Reagendar" muestra/oculta calendario y scheduler
- [ ] Calendario reutiliza `Calendar` de `calendario.js` (mismo que RegistroDeClasesProgramadas)
- [ ] Scheduler reutiliza `ScheduleViewer` de `horariosDelDia.js` (mismo que RegistroDeClasesProgramadas)
- [ ] Al marcar reagendar, se consultan clases programadas para la clase programada de la inscripción (solo se muestran las que tienen cupo disponible)
- [ ] Al seleccionar fecha en calendario, se actualiza el scheduler con horarios disponibles de clases con cupo
- [ ] Botón ejecutar cambia texto: "Cancelar" o "Reagendar" según el check
- [ ] Botón limpiar resetea todos los campos
- [ ] Petición cancelación POST a nginx → frontend proxy (spec 45) → API
- [ ] Petición reagendación POST a nginx → frontend proxy (spec 47) → API
- [ ] SignalR activo para actualizaciones en tiempo real (mismo patrón que agendarioDeHorarios.js)
- [ ] Reutiliza los mismos JS que RegistroDeClasesProgramadas (calendario.js, horariosDelDia.js, agendarioDeHorarios.js)
- [ ] El query param `fecha` enviado a `obtenerClasesProgramadasPorId` es la fechaDeLaClase de la inscripción seleccionada (no la fecha de hoy), de modo que solo se devuelven clases con fecha mayor o igual a la de la inscripción que se quiere reagendar
