# Spec: Frontend - Spinner y deshabilitación de botones de acción (sección empleados)

## 1. Resumen

Se crea un helper reutilizable de estado de carga en `httpClient.js` que deshabilita el botón de acción principal de una página, muestra un spinner sin texto visible mientras dura la petición de registro, y restituye el botón a su estado original al terminar. El helper reemplaza las siete implementaciones ad-hoc existentes en los handlers JS de la sección empleados —cinco de ellas con la restauración rota— y se agrega a los tres handlers que actualmente no tienen ninguna protección.

Al final de la spec, los nueve botones de acción principal de las páginas con layout `_LayoutSeccionAdministracion` comparten un único mecanismo: clic → deshabilitado + spinner → petición → botón original restituido y habilitado.

## 2. Contexto

- **Capa:** GymFrontend (Views + JS)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Layout | `_LayoutSeccionAdministracion` | Layout de la sección empleados; carga `httpClient.js` para todas las páginas que lo usan | `Views/Shared/_LayoutSeccionAdministracion.cshtml` |
| Helper JS | `httpClient.js` | Cliente HTTP compartido que ya importan los siete handlers afectados; host elegido para el nuevo helper | `wwwroot/js/httpClient.js` |
| JS | `registroMedidaLogic.mjs` | Handler con restauración rota | `wwwroot/js/registroMedidaLogic.mjs` |
| JS | `registroCitas.js` | Dos handlers: uno con restauración rota, otro correcto (referencia) | `wwwroot/js/registroCitas.js` |
| JS | `gestionRutinas.js` | Dos handlers, ambos con restauración rota | `wwwroot/js/gestionRutinas.js` |
| JS | `EdicionCitas.js` | Handler con restauración rota | `wwwroot/js/EdicionCitas.js` |
| JS | `inscriptorDeClases.js` | Handler sin ninguna protección | `wwwroot/js/inscriptorDeClases.js` |
| JS | `agendarioDeHorarios.js` | Handler sin ninguna protección + dos bugs en manejo de errores | `wwwroot/js/agendarioDeHorarios.js` |
| JS | `cancelarReagendarInscripcion.js` | Handler sin ninguna protección, botón con label dinámico | `wwwroot/js/cancelarReagendarInscripcion.js` |
| UI | Bootstrap 5.3 | Provee las clases del spinner y el estado disabled de los botones | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `spinner-border-sm` | CSS de Bootstrap 5.3 | Clase del spinner inyectado dentro del botón |
| `.btn:disabled` | CSS de Bootstrap 5.3 | Estado visual del botón deshabilitado (aplica opacidad) |
| `messageManager.mjs` | Módulo JS propio | Mensajes de éxito/error que rodean el ciclo de carga en los handlers |
| `WeakMap` | API de JavaScript | Estructura que guarda el estado original de cada botón durante la carga |

## 3. Helper de estado de carga a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymFrontend/wwwroot/js/httpClient.js` | Se agregan las cinco funciones del helper antes del bloque de exposición global, y se suman al bloque de exports al final del archivo |

No se crea ningún archivo nuevo. No se agrega ningún script tag en ninguna vista: el layout ya carga `httpClient.js` para toda la sección y los siete handlers que existen ya importan de ese archivo.

### 3.2 Contrato

Cinco funciones públicas, todas exportadas:

| Función | Entrada | Salida | Propósito |
|---------|---------|--------|-----------|
| `resolveButton` | elemento, selector CSS, id o null | elemento del botón o null | Normalizar el acceso al botón. Si no se resuelve, el resto del helper es no-op |
| `setButtonLoading` | lo mismo que `resolveButton` | botón ya en estado de carga, o null | Desactivar el botón e inyectar el spinner |
| `restoreButton` | lo mismo, más un label explícito opcional | nada | Restituir texto, ancho y estado habilitado |
| `withButtonLoading` | botón + función asíncrona | resultado de la función | Ejecutar una acción con la secuencia cargar/restaurar envuelta en garantía de restauración |
| `setButtonLabel` | botón + HTML nuevo | nada | Escribir el label del botón respetando si está en carga |

**Estado compartido:** un único WeakMap de módulo, con un registro por botón, con cuatro campos:

| Campo | Descripción |
|-------|-------------|
| `original` | El contenido del botón capturado al iniciar la carga, con todo su texto e íconos |
| `originalWidth` | El ancho inline original del botón, normalmente vacío |
| `pendingLabel` | Un label solicitado mientras el botón estaba en carga, o null si nadie pidió uno |
| `loading` | Bandera que indica si el botón está actualmente en estado de carga |

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Comportamiento en error |
|------|-----------|--------|------------------------|
| 1 | El target resuelve a un elemento | Búsqueda por elemento, selector o id | Devuelve null y el resto de pasos no se ejecuta (no-op) |
| 2 | El botón no está ya en carga | Chequeo de idempotencia sobre `loading` | Sale sin modificar nada (doble click no hace doble swap) |
| 3 | El botón no tiene registro previo | Chequeo de existencia en el WeakMap | Si tiene registro sin carga, se reutiliza sin sobreescribir el original |
| 4 | El registro existe y `loading` es true en la restauración | Chequeo previo a tocar el DOM | Sale sin modificar nada (nunca se lucha con un handler que no usó el helper) |

Ninguna de las cinco funciones lanza excepciones. Todas fallan hacia el no-op.

### 3.4 Acciones que debe realizar

**`setButtonLoading` — algoritmo de activación, en este orden exacto:**

1. **Resolver** el botón con `resolveButton`. Si devuelve null, cortar.
2. **Verificar idempotencia**: si el registro ya está en estado de carga, cortar.
3. **Registrar** en el WeakMap el contenido original del botón y su ancho inline original, si todavía no existe un registro. Nunca sobreescribir un registro existente con el contenido actual, para no capturar un spinner como si fuera el texto real.
4. **Medir** el ancho actual del botón. Se hace antes de deshabilitar porque el estado disabled puede alterar el ancho intrínseco en algunos navegadores.
5. **Fijar** ese ancho como ancho inline. Se hace antes de reemplazar el contenido, porque de lo contrario se mediría el ancho ya colapsado. Evita que el botón encoge de ~92px a ~40px y se mueva dentro del flexbox mientras carga.
6. **Deshabilitar** el botón. Esto bloquea nuevos clicks y, en los botones de tipo submit, también bloquea el envío implícito del formulario con Enter.
7. **Reemplazar** el contenido del botón por el spinner de Bootstrap, sin ningún texto visible. Marcar el atributo aria de ocupado.
8. **Marcar** el registro como en estado de carga y devolver el botón.

Los pasos 4 a 8 se ejecutan síncronos, sin esperas intermedias: un solo repaso de layout por parte del navegador, sin parpadeo.

**`restoreButton` — algoritmo de restitución, en este orden exacto:**

1. **Resolver** el botón. Si devuelve null, cortar.
2. **Verificar** que hubo una carga registrada. Si no existe o no está marcada como carga, cortar sin tocar nada.
3. **Determinar el texto de salida**: si hay un label pendiente, ese; si el llamador pasó un label explícito, ese; si no, el contenido original registrado.
4. **Escribir** ese contenido en el botón.
5. **Restaurar** el ancho inline al valor original, normalmente vacío, lo que devuelve el ancho a su valor natural.
6. **Habilitar** el botón y quitar el atributo aria de ocupado.
7. **Borrar** el registro del WeakMap, para que el botón quede como recién usado.

El orden contenido → ancho → habilitación es deliberado: el botón nunca es clicable mientras todavía muestra el spinner.

**`withButtonLoading` — acciones:**

1. Activar la carga con `setButtonLoading`.
2. Ejecutar la función recibida dentro de un bloque try.
3. Restaurar en un bloque finally, que se ejecuta siempre, incluso si la acción lanza excepción.

**`setButtonLabel` — acciones:**

1. Resolver el botón.
2. Si está en estado de carga, guardar el HTML como label pendiente en el registro **sin tocar el DOM**, de modo que el spinner siga visible.
3. Si no está en carga, escribir el contenido directamente.

### 3.5 Patrones a aplicar

- **Restauración garantizada por estructura:** la restauración vive dentro de `withButtonLoading` en un bloque finally, por lo que el llamador no puede olvidarla ni escribirla mal. Es la corrección estructural de los cinco restores actuales.
- **Estado fuera del DOM:** el estado original se guarda en un WeakMap, no en atributos data ni en variables del handler. Sobrevive al reseteo del formulario, no se serializa al DOM y se limpia solo.
- **No-op defensivo:** cualquier imposibilidad de resolver o de validar el estado termina en silencio, nunca en excepción. El helper no puede romper el flujo del handler que lo usa.
- **Idempotencia:** una segunda activación sobre un botón ya cargado no hace nada. Cubre el doble click rápido y los envíos programáticos repetidos.
- **Medición antes de mutación:** el ancho se mide y se fija antes de mutar el contenido, para capturar el valor real y evitar un reflow intermedio visible.
- **Label diferido:** un cambio de label durante la carga se acumula como pendiente en lugar de escribirse, para no destruir el spinner y para que la restitución muestre el estado real de la aplicación y no un snapshot viejo.

## 4. Archivos a modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `GymFrontend/wwwroot/js/httpClient.js` | Modificar | Agregar las cinco funciones del helper y sumarlas al bloque de exports |
| `GymFrontend/wwwroot/js/registroMedidaLogic.mjs` | Modificar | Corregir la restauración y migrarla al helper |
| `GymFrontend/wwwroot/js/registroCitas.js` | Modificar | Corregir la restauración del handler de registrar cita y migrar ambos handlers al helper |
| `GymFrontend/wwwroot/js/gestionRutinas.js` | Modificar | Corregir la restauración de ambos handlers y migrarlos al helper |
| `GymFrontend/wwwroot/js/EdicionCitas.js` | Modificar | Corregir la restauración y migrarla al helper |
| `GymFrontend/wwwroot/js/inscriptorDeClases.js` | Modificar | Agregar el ciclo de carga donde no existe, más un bloque de restauración |
| `GymFrontend/wwwroot/js/agendarioDeHorarios.js` | Modificar | Agregar el ciclo de carga, resolver el botón por id, y corregir dos bugs de manejo de errores |
| `GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js` | Modificar | Agregar el ciclo de carga al punto de entrada único y rutear las tres escrituras de label por la función de label diferido |

### 4.1 Corrección de restauraciones rotas

Las cinco correcciones aplican el mismo cambio: sacar la captura del botón y de su contenido original fuera del bloque de reemplazo, invocar la activación del helper al inicio, y sustituir la restauración manual por la del helper. Se elimina todo texto hardcodeado de restitución.

| # | Archivo y handler | Texto hardcodeado actual | Comportamiento observable del bug |
|---|-------------------|--------------------------|-----------------------------------|
| 1 | `registroMedidaLogic.mjs` — `enviarFormularioMedida` | Un literal que no corresponde al texto real del botón | El primer registro renombra visiblemente el botón de su texto original a otro, y el cambio persiste. Además la restauración no tiene protección ante un botón inexistente |
| 2 | `registroCitas.js` — `enviarFormularioRegistrarCita` | Literal idéntico al de la vista | Hoy coincide por casualidad; se rompe si el texto de la vista cambia o se le agrega un ícono |
| 3 | `registroCitas.js` — `enviarFormularioDuracionCitas` | Ninguno, usa el contenido original | Ya correcto; solo se unifica sobre el helper para que quede un solo patrón |
| 4 | `gestionRutinas.js` — `enviarFormularioRutina` | Literal idéntico al de la vista | Igual que el 2 |
| 5 | `gestionRutinas.js` — `enviarFormularioAsignacionEjercicio` | Literal idéntico al de la vista | Captura el contenido original pero no lo usa; la restauración consulta el DOM de nuevo en una variable que tapa la anterior |
| 6 | `EdicionCitas.js` — `enviarFormularioModificarCita` | Literal idéntico al de la vista | Igual que el 2 |

**Por qué el literal es incorrecto aunque coincida con la vista:** la vista de duración de citas renderiza dos botones distintos según el modo, elegidos en el servidor con la misma condición, y ambos salen del mismo selector. El texto es `Guardar` al editar y `Registrar` al crear. Un literal es incorrecto la mitad de las veces; el contenido original es la única fuente válida.

### 4.2 Altas en handlers sin protección

| # | Archivo y handler | Cómo se resuelve el botón | Detalle |
|---|-------------------|---------------------------|---------|
| 1 | `inscriptorDeClases.js` — `inscribirAClase` | Selector dentro del form | El botón está dentro del form y no compite con otro submit en la página. Se captura antes del bloque de reemplazo. Se agrega el bloque de restauración que hoy no existe |
| 2 | `agendarioDeHorarios.js` — `registrarClaseProgramada` | Búsqueda por identificador directo | El botón vive fuera del form, asociado por el atributo de asociación de formularios de HTML5, por lo que el selector dentro del form devuelve null y una asignación sobre su contenido lanzaría una excepción de objeto nulo |
| 3 | `cancelarReagendarInscripcion.js` — `onEjecutarClick` | Constante de módulo existente | Botón de tipo botón, no de envío, con entrada única de clic. Se activa después de la validación inicial y antes de la rama que elige entre cancelar y reagendar. La restauración recibe el label derivado del estado real del checkbox en ese momento, no el texto capturado al hacer clic |

### 4.3 Correcciones en el manejo de errores de `agendarioDeHorarios.js`

Ambas correcciones se aplican en la misma función que recibe el spinner nuevo.

| Ubicación | Bug | Comportamiento actual | Corrección |
|-----------|-----|-----------------------|------------|
| Rama de fallo de la respuesta | Usa el ícono de éxito para comunicar un registro fallido | El usuario ve un aviso verde de éxito cuando la operación falló | Usar el ícono de error y un mensaje por defecto por si la respuesta no trae uno |
| Bloque de captura de excepción | Referencia una variable declarada dentro del bloque de reemplazo, que no existe fuera de él | Círculo de fallo silencioso: no se muestra ningún aviso, el registro de consola del paso siguiente tampoco se ejecuta, y la propia excepción escapa como promesa rechazada sin procesar | Mostrar el mensaje de la excepción real con el ícono de error, con un mensaje por defecto |

### 4.4 Rutear las escrituras de label del botón dinámico

`cancelarReagendarInscripcion.js` escribe el texto del botón en tres lugares distintos en tiempo de ejecución: dos ramas del manejador del checkbox de reagendar, y la función que resetea la interfaz. Son escrituras directas de texto que, si ocurren mientras el botón está en carga, reemplazan el spinner por texto plano y el usuario ve un botón deshabilitado sin indicación de progreso. Las tres pasan a escribir por la función de label diferido.

## 5. Alcance fuera de esta spec

| Ítem | Motivo por el que queda fuera |
|------|------------------------------|
| `RegistroDeClases.cshtml` | El formulario no tiene acción ni método, no tiene manejador de envío, y el controller del frontend no tiene ruta de recepción para esa operación. Es una funcionalidad que no persiste nada, no un tema de spinner |
| Carpeta `appp/` | Código muerto, no servido ni referenciado. Ignorada por decisión explícita |
| Valor de id de usuario literal en el manejador de `agendarioDeHorarios.js` | Bug de datos aparte, no relacionado con el estado de carga |
| Detalle de error construido y no mostrado en `inscriptorDeClases.js` | Bug de UX aparte |
| Identificadores de DOM duplicados entre la vista de gestión de rutinas y la de asignación de ejercicios | Refactor aparte |

## 6. Criterios de aceptación

- [ ] `httpClient.js` exporta las cinco funciones del helper y son importables desde los módulos que las necesitan
- [ ] El helper no lanza excepciones bajo ninguna condición; todo fallo es no-op
- [ ] Durante la carga el botón queda deshabilitado y muestra solo el spinner, sin ningún texto visible
- [ ] El ancho del botón se mantiene idéntico al original durante toda la carga, sin salto visible
- [ ] Al terminar la operación, con éxito o con error, el botón muestra exactamente el texto e íconos originales y vuelve a habilitarse
- [ ] La restauración se ejecuta también cuando la petición lanza excepción
- [ ] Un doble clic rápido dispara una sola petición
- [ ] Ningún handler de los nueve contiene texto hardcodeado de restitución
- [ ] Las cinco restauraciones rotas fueron migradas al helper y ya no consultan el DOM de nuevo en el bloque de restauración
- [ ] Los tres handlers que no tenían protección ahora activan la carga antes de su petición y restauran después, incluyendo el caso en que la validación interna corta el flujo
- [ ] El botón fuera del form en `agendarioDeHorarios.js` se resuelve por identificador y no por selector dentro del form
- [ ] El botón dinámico de cancelar/reagendar conserva el spinner si el checkbox cambia durante la carga, y al restituir muestra el label correspondiente al estado real del checkbox
- [ ] Las tres escrituras de label de ese botón pasan por la función de label diferido
- [ ] La rama de fallo de `agendarioDeHorarios.js` muestra el ícono de error, no el de éxito
- [ ] El bloque de captura de excepción de `agendarioDeHorarios.js` ya no referencia la variable fuera de su alcance, y el registro de consola se ejecuta en errores
- [ ] No se agrega ningún script tag en ninguna vista, no se crea ningún archivo nuevo, y no se modifica ninguna vista Razor
- [ ] Verificación manual en las nueve páginas: clic en el botón de registro deshabilita y muestra spinner sin texto; al terminar se restituye texto y habilitación, en éxito y en error
