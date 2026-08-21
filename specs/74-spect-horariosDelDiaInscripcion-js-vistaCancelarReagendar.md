# Spec 74: horariosDelDiaInscripcion.js — Vista de Horarios para Cancelar/Reagendar Inscripciones

## Contexto

El archivo `GymFrontend/wwwroot/js/horariosDelDia.js` exporta la clase `ScheduleViewer` para la vista de horarios. La vista de cancelar/reagendar (`cancelarReagendarInscripcion.js`) importa `ScheduleViewer` de ese archivo y lo usa para mostrar los horarios disponibles.

Cuando el usuario hace click en un horario, `handleScheduleClick` llama a `registrarPreReservaDeHorario()` que hace POST a `/Horarios/preReservarHorario` (el endpoint del frontend MVC que usa el manager BL para pre-reservar un horario de clase regular).

Para la funcionalidad de cancelar/reagendar inscripciones, se necesita un flujo similar pero con dos diferencias:
1. El endpoint de pre-reserva es `/Horarios/preReservarHorarioInscripcion`
2. El body incluye `idClaseProgramada` (campo adicional en `DTOPreReservaDeHorarioInscripcion`)

## Recursos utilizados

- specs/72-spect-managerPreReservaHorarioInscripcion.md (dto y endpoint del manager)
- specs/73-spect-testsPreReservaHorarioInscripcionManager.md (dto y tests)

## Arquitectura de la solución

### Configuración — appsettings.json

Agregar la nueva key `preReservaHorarioInscripcion` en la sección `EndPoints`:

```json
"EndPoints": {
    "preReservaHorarioInscripcion": "/Horarios/preReservarHorarioInscripcion",
    ...
}
```

El TagHelper `AppConfigTagHelper` lee la sección `EndPoints` de `IConfiguration` y la serializa a `window.AppConfig`. Al agregar la key en `appsettings.json`, queda automáticamente disponible en `window.AppConfig.EndPoints.preReservaHorarioInscripcion`.

Solo se modifica `appsettings.json` base — los archivos `appsettings.*.json` específicos por entorno heredan por merge jerárquico de .NET Configuration.

### Nuevo archivo — horariosDelDiaInscripcion.js

Archivo nuevo en `GymFrontend/wwwroot/js/horariosDelDiaInscripcion.js`.

Es un clon 99% estructural de `horariosDelDia.js` (489 líneas). Las diferencias funcionales son exactamente 3:

#### 3 diferencias funcionales respecto a horariosDelDia.js

| # | Aspecto | Original (horariosDelDia.js) | Nuevo (horariosDelDiaInscripcion.js) |
|---|---------|------------------------------|--------------------------------------|
| 1 | **Endpoint path** | Hardcodeado `'/Horarios/preReservarHorario'` | Leído de `window.AppConfig.EndPoints.preReservaHorarioInscripcion` con fallback |
| 2 | **idClaseProgramada en body** | No se envía | Se captura de `element.dataset.idClaseProgramada` y se agrega al body |
| 3 | **handleScheduleClick** | Solo guarda `data-idhora` | También guarda `dataset.idClaseProgramada` antes de llamar a la pre-reserva |

#### Detalle técnico — Constructor

Agregar `this.selectedIdClaseProgramada = null` al constructor.

#### Detalle técnico — handleScheduleClick

En `handleScheduleClick`, después de obtener el elemento clickeado:

```javascript
const scheduleId = element.getAttribute("data-idhora");
this.selectedIdClaseProgramada = element.dataset.idClaseProgramada;  // NUEVO
this.updateHiddenInput(scheduleId);
const idPreReserva = await this.registrarPreReservaDeHorario();
```

El elemento clickeado ya tiene `dataset.idClaseProgramada` — se setea en `createScheduleElement` (línea 127 del archivo original). No se necesita un hidden input nuevo porque `idClaseProgramada` varía por horario individual, no es común a todos.

#### Detalle técnico — registrarPreReservaDeHorario

El método `registrarPreReservaDeHorario()` (mismo nombre, mismo flujo) cambia en dos puntos:

**a) Lectura del endpoint desde config:**

```javascript
const endpointPath = window.AppConfig?.EndPoints?.preReservaHorarioInscripcion
                     || '/Horarios/preReservarHorarioInscripcion';
```

**b) Body con idClaseProgramada:**

```javascript
const body = {
    idUsuarioQueReserva,    // '' — el controller pisa desde JWT
    fechaTentativa,
    idHoraLaboral,
    idClase,
    idEntrenador,
    idClaseProgramada: parseInt(this.selectedIdClaseProgramada)  // NUEVO
};

const response = await realizarPeticionAPI(endpointPath, body);
```

El resto del método (validaciones de campos requeridos, manejo de errores, retorno de `payload`) permanece idéntico.

### Modificación de cancelarReagendarInscripcion.js

Cambiar una sola línea — el import:

```javascript
// Antes:
import { ScheduleViewer } from './horariosDelDia.js';
// Después:
import { ScheduleViewer } from './horariosDelDiaInscripcion.js';
```

El nombre de la clase (`ScheduleViewer`) se mantiene igual. No hay cambios en cómo se usa el componente en el código que lo consume.

## Criterios de aceptación

1. El endpoint de pre-reserva se lee de `window.AppConfig.EndPoints.preReservaHorarioInscripcion` (con fallback al path hardcodeado)
2. El body del POST incluye `idClaseProgramada` parseado a int desde `this.selectedIdClaseProgramada`
3. `handleScheduleClick` captura `dataset.idClaseProgramada` del elemento clickeado y lo almacena en `this.selectedIdClaseProgramada`
4. El import en `cancelarReagendarInscripcion.js` apunta a `horariosDelDiaInscripcion.js`
5. La clase `ScheduleViewer` exportada tiene el mismo nombre y контракт público que el original
6. El nuevo archivo no modifica `httpClient.js` — usa `realizarPeticionAPI` existente

## Flujo de la petición

```
Usuario clickea horario
  → handleScheduleClick(element)
    → element.dataset.idClaseProgramada = "42"
    → this.selectedIdClaseProgramada = "42"
  → registrarPreReservaDeHorario()
    → endpointPath = window.AppConfig.EndPoints.preReservaHorarioInscripcion
                    = "/Horarios/preReservarHorarioInscripcion"
    → realizarPeticionAPI(endpointPath, body)
      → URL = getNginxBaseUrl() + "/Horarios/preReservarHorarioInscripcion"
      → Nginx: / → frontend:5062
      → HorariosController.registrarPreReservaDeHorarioInscripcion
        → cookie AuthToken → JWT → claim → pisa idUsuarioQueReserva
        → _horariosManager.preReservarHorarioInscripcion(preReserva)
          → BL: POST api/Horarios/preReservarHorarioInscripcion
```

## Notas de implementación

- El nombre de la clase se mantiene como `ScheduleViewer` (no `ScheduleViewerInscripcion`) para minimizar el impacto en `cancelarReagendarInscripcion.js` (solo cambia el import path)
- El fallback en la lectura de config garantiza que si `AppConfig` no está disponible, el sistema usa el path correcto
- `realizarPeticionAPI` ya prepend la base URL de Nginx via `getNginxBaseUrl()`, por lo que solo se almacena el path relativo en config
- El método `registrarPreReservaDeHorario` no cambia de nombre; solo cambia qué endpoint y body usa internamente
