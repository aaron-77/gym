# Spec 76: Pre-reserva en flujo de inscripción a clases

## 1. Resumen

Modificar el flujo de inscripción a clases (`inscriptorDeClases.js` + `inscriptorDeClasesScheduler.js`) para que al seleccionar un horario se registre primero una pre-reserva de horario, igual que el flujo existente en `cancelarReagendarInscripcion.js`. El `idPreReserva` se envía como parte del body de la inscripción al endpoint API.

## 2. Contexto

- **Capa:** Frontend JavaScript (GymFrontend wwwroot)
- **Flujo de referencia:** `cancelarReagendarInscripcion.js` + `horariosDelDiaInscripcion.js` (ya implementa pre-reserva al seleccionar horario)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Endpoint frontend | `/Horarios/preReservarHorarioInscripcion` | Registra pre-reserva de horario | 71 |
| Partial view | `_HorariosDelDia.cshtml` | Contenedor del schedule viewer | — |
| Partial view | `_Calendario.cshtml` | Contenedor del calendario | — |
| Servicio JS | `httpClient.js` | `realizarPeticionAPI` | — |
| Servicio JS | `messageManager.mjs` | `showComplexDialog`, `iconTypes` | — |
| Endpoint API | `POST /api/clases/inscribirAClase` | Registra inscripción | 75 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|------------|------|-------------|
| `ScheduleViewerInscripciones` | JS Class | Componente de horarios en inscripción |
| `DTOPreReservaDeHorarioInscripcion` | DTO | Modelo del body de pre-reserva |
| `localStorage` | Browser API | Almacenar `idPreReserva` temporalmente |

---

## 3. Cambios en `inscriptorDeClasesScheduler.js`

### 3.1 Flujo modificado de `handleScheduleClick`

**ANTES:** Solo actualizaba inputs y disparaba evento.

**DESPUÉS:** Ídem + confirmación + pre-reserva.

```
1. showComplexDialog("¿Deseas reservar ese horario?...", iconTypes.warning)
   └─ Si NO confirma → return temprano
2. Extraer idClaseProgramada del dataset del elemento clickeado
3. updateHiddenInput(scheduleId)
4. registrarPreReservaDeHorario() → endpoint del frontend
   └─ Si falla → showMessage error → return temprano
5. saveToLocalStorage("idPreReserva", idPreReserva)
6. clearSelection()
7. selectSchedule(element, scheduleId)
8. dispatchSelectionEvent(scheduleId)
9. scrollToSelectedLabel()
```

### 3.2 Flujo modificado de `registrarPreReservaDeHorario`

**ANTES:** Endpoint `/Horarios/preReservarHorario`, sin `idClaseProgramada`, sin `idClase`, sin `idEntrenador`, `idUsuarioQueReserva = 16` (hardcodeado).

**DESPUÉS:**

```
1. Obtener inputs del DOM:
   - inputFkHoraLaboral (fkHorarioLaboral)
   - fechaDeLaClase (fechaTentativa)
   - inputClase (idClase)
   - inputEntrenador (idEntrenador)
2. Validar con reportValidity() → false si inválido
3. Armar body:
   {
     idUsuarioQueReserva: '',     // vacío → el backend extrae del JWT cookie
     fechaTentativa: inputFecha.value,         // YYYY-MM-DD
     idHoraLaboral: parseInt(inputFkHoraLaboral.value),
     idClase: parseInt(inputClase.value),
     idEntrenador: inputEntrenador.value,       // nvarchar
     idClaseProgramada: parseInt(selectedIdClaseProgramada)
   }
4. POST a endpointPath = window.AppConfig?.EndPoints?.preReservaHorarioInscripcion || '/Horarios/preReservarHorarioInscripcion'
5. Si response.success → retornar response.payload (idPreReserva)
   Si falla → mostrar error → retornar 0
```

### 3.3 Inputs requeridos en el formulario

El formulario `InscripcionAClases.cshtml` ya tiene:
- `idProgramacionClase` (hidden, existente)
- `fkHoraLaboral` (hidden, existente via `_HorariosDelDia`)
- `fechaDeLaClase` (hidden, existente via `_Calendario`)

**AGREGAR en `InscripcionAClases.cshtml`:**

```html
<input type="hidden" id="inputClase" value="" />
<input type="hidden" id="inputEntrenador" value="" />
```

Estos campos deben ser llenados por `inscriptorDeClases.js` cuando se carga una clase y se selecciona un horario.

---

## 4. Cambios en `inscriptorDeClases.js`

### 4.1 Datos necesarios para pre-reserva

`inscriptorDeClases.js` ya llena los campos `idProgramacionClase`, `fkHoraLaboral` y `fechaDeLaClase`. Agregar el llenado de los nuevos campos:

**Cuando se selecciona una clase y se obtienen clases programadas:**

```javascript
// Dentro de agregarHorarios() o al seleccionar clase
// Los campos hidden ya existen en el markup de InscripcionAClases.cshtml
document.getElementById('inputClase').value = idClaseSeleccionada;
// idEntrenador se obtiene del primer horario devuelto
document.getElementById('inputEntrenador').value = primerHorario.fkEntrenador || '';
```

### 4.2 Modificación a `inscribirAClase()`

**ANTES:** Solo enviaba `idCliente` + `idProgramacionClase`.

**DESPUÉS:**

```
1. Leer idPreReserva del localStorage: localStorage.getItem('idPreReserva')
2. Incluirlo en el body: { ..., idPreReserva: idPreReserva || null }
3. Tras inscripción exitosa:
   a. localStorage.removeItem('idPreReserva')
   b. Mantener el resto del flujo de limpieza existente
```

### 4.3 Flujo completo de `inscribirAClase` modificado

```
event.preventDefault()
├─ validate form.checkValidity()
├─ crear FormData
│   └─ eliminar campos sobrantes (fechaDeLaClase, comboClases, fkHoraLaboral)
├─ formDataToJson
├─ AGREGAR: idPreReserva desde localStorage
├─ POST /clases/inscripcionAClase
│   ├─ SUCCESS:
│   │   ├─ showMessage success
│   │   ├─ limpiarFormularioPorCampos(..., ["idCliente", "fkHoraLaboral", "idProgramacionClase"])
│   │   ├─ scheduleViewerInstance.clearSelection()
│   │   ├─ limpiar labels (entrenador, espacios)
│   │   └─ localStorage.removeItem('idPreReserva')  ← NUEVO
│   └─ ERROR:
│       └─ showMessage error
└─ formulario.classList.remove('was-validated')
```

---

## 5. Archivos a modificar

| Archivo | Descripción |
|---------|-------------|
| `GymFrontend/wwwroot/js/inscriptorDeClasesScheduler.js` | `handleScheduleClick` + `registrarPreReservaDeHorario` |
| `GymFrontend/wwwroot/js/inscriptorDeClases.js` | `inscribirAClase` + llenado de `inputClase`/`inputEntrenador` |
| `GymFrontend/Views/Clases/InscripcionAClases.cshtml` | Agregar `inputClase` + `inputEntrenador` hidden |

---

## 6. Criterios de aceptación

- [ ] Al hacer click en un horario disponible se muestra el diálogo de confirmación
- [ ] Si se cancela el diálogo, no se ejecuta la pre-reserva ni se selecciona el horario
- [ ] Si se confirma, se registra la pre-reserva vía `POST /Horarios/preReservarHorarioInscripcion`
- [ ] El `idPreReserva` devuelto se almacena en `localStorage` bajo la key `"idPreReserva"`
- [ ] Si la pre-reserva falla, se muestra mensaje de error y no se selecciona el horario
- [ ] Los campos `inputClase` y `inputEntrenador` se llenan al seleccionar clase/horario
- [ ] El body del POST a `/clases/inscripcionAClase` incluye `idPreReserva` (o `null`)
- [ ] Tras inscripción exitosa se limpia el `idPreReserva` del localStorage
- [ ] El flujo de inscripción sigue funcionando si no hay pre-reserva (compatible hacia atrás)

---

## 7. Notas técnicas

### Compatibilidad hacia atrás

Si `idPreReserva` es `null` o no está presente en el body, el endpoint de inscripción debe funcionar igual (la pre-reserva es optativa para el flujo de inscripción). El SP `sp_registrarInsrcipcionAClase` no requiere pre-reserva.

### Timing del diálogo de confirmación

`showComplexDialog` en `cancelarReagendarInscripcion.js` usa `iconTypes.warning`. En el flujo de inscripción se usa el mismo ícono.

### Lógica de los hidden inputs

Los campos `inputClase` y `inputEntrenador` son necesarios para el body de la pre-reserva. Se recomienda inicializarlos en la función `handleClaseSelected` o `agregarHorarios` cuando se obtienen las clases programadas para la clase seleccionada.
