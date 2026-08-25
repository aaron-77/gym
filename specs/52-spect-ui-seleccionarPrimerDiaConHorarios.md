# Spec: Frontend - Seleccionar primer día con horarios al iniciar calendario de reagendar

## 1. Resumen

Modificar el JavaScript de la vista "CancelarReagendarInscripcion" para que, al consultar las clases programadas disponibles al reagendar, se seleccione automáticamente el primer día que tenga horarios cargados y se muestren sus horarios en el scheduler al iniciar el calendario. Actualmente el calendario inicia con el día de HOY seleccionado, lo que deja el scheduler vacío o con horarios de un día sin clases cuando el primer día disponible está en el futuro.

## 2. Contexto

- **Capa:** GymFrontend JS

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Archivo/Spec |
|---------|--------|-------------|-------------|
| JS | `cancelarReagendarInscripcion.js` | Archivo a modificar: orquestador del flujo cancelar/reagendar | `wwwroot/js/cancelarReagendarInscripcion.js` |
| JS | `Calendar` | Clase del calendario; la propiedad `selectedDate` define el mes renderizado y el día marcado | `wwwroot/js/calendario.js` |
| JS | `ScheduleViewer` | Clase del visualizador de horarios; carga horarios con `loadSchedules` | `wwwroot/js/horariosDelDia.js` |
| Vista | `CancelarReagendarInscripcion.cshtml` | Vista que renderiza `#contenedorCalendario` (oculto con `d-none` hasta tildar "Reagendar") | `Views/Inscripciones/CancelarReagendarInscripcion.cshtml` |
| Spec UI | Cancelar/Reagendar Inscripción | Spec de la página donde vive este comportamiento | spec 49 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `horarios` | Estado JS | Objeto de 3 niveles `horarios[anio][mes][dia]` que se construye en `fetchClasesProgramadas` con las clases programadas devueltas por la API |
| `obtenerClasesProgramadasPorId` | Endpoint | Devuelve SOLO clases programadas con fecha mayor o igual a la fecha de la inscripción seleccionada (enviada como `fecha` de referencia) — verificado en `fn_obtenerClasesProgramadasPorIdClase` |

## 3. Cambios a realizar

### 3.1 Archivos

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js` | Modificar | Agregar selección automática del primer día con horarios al consultar clases programadas; extraer helper compartido de horarios del mes |

### 3.2 Comportamiento actual (problema)

Al tildar "Reagendar" y seleccionar una inscripción, se ejecuta `fetchClasesProgramadas`, que construye el objeto `horarios` y llama a:
- `updateCalendarDisponibleDates`: calcula los horarios del mes de HOY (usa `new Date()`), los asigna a `disponibleDates` y renderiza el calendario.
- `actualizarVistaFecha`: carga en el scheduler los horarios de la fecha seleccionada actualmente.

Como el calendario se crea con `selectedDate = hoy`, el scheduler muestra los horarios de HOY. Si el primer día con clases programadas está en el futuro (día, mes o año distinto), el scheduler inicia vacío y el usuario debe navegar el calendario manualmente para encontrar el primer día útil.

Además, si el primer día con horarios cae en un mes distinto al de hoy, `updateCalendarDisponibleDates` (que usa el mes de hoy) deja `disponibleDates` vacío para el mes mostrado, y la lógica de habilitación del calendario deshabilita todos los días del mes visible.

### 3.3 Comportamiento deseado

Al ejecutarse `fetchClasesProgramadas`:
1. Se determina el primer día con horarios dentro del objeto `horarios` (la fecha mínima global, considerando que el backend devuelve fechas desde la fecha de la inscripción seleccionada enviada como `fecha` de referencia).
2. Se asigna esa fecha a `selectedDate` de la instancia del calendario.
3. Se sincroniza el input oculto `fechaDeLaClase` con esa fecha (el input no se actualiza solo: `selectedDate` es una propiedad plana sin setter/reactividad; solo lo escriben el constructor y el handler de click del día).
4. Se actualiza `disponibleDates` con los horarios del mes de `selectedDate` y se renderiza el calendario (esto navega al mes correcto y marca el día seleccionado).
5. Se cargan en el scheduler los horarios de `selectedDate` (flujo existente).

### 3.4 Acciones que debe realizar

1. Crear una función para obtener el primer día con horarios:
   - Obtener las claves (años) del objeto `horarios` convertidas a número.
   - Si no hay años, devolver nulo (no hay clases programadas).
   - Calcular el año mínimo con la función mínima sobre el arreglo de años.
   - Con ese año, obtener las claves (meses) y calcular el mes mínimo.
   - Con ese mes, obtener las claves (días) y calcular el día mínimo.
   - Devolver la fecha construida con el año, mes y día mínimos.
    - La lógica funciona porque el backend devuelve fechas desde la fecha de la inscripción seleccionada, y el mínimo global (año → mes → día) es el primer día con horarios.
2. Crear una función helper que reciba una fecha y devuelva el arreglo plano de horarios del mes de esa fecha:
   - Acceder al objeto de meses con el año de la fecha.
   - Acceder al objeto de días con el mes de la fecha.
   - Aplanar los arreglos de horarios de todos los días en un solo arreglo (el objeto está agrupado por día y el calendario consume un arreglo plano).
   - Devolver el arreglo resultante (vacío si el mes no tiene horarios).
3. Modificar `fetchClasesProgramadas`, al final de la carga:
   - Obtener el primer día con horarios.
   - Si existe y hay instancia de calendario: asignarlo a `selectedDate` y escribir el input oculto `fechaDeLaClase` con esa fecha formateada (año-mes-día).
   - Llamar al flujo existente de actualización del calendario y del scheduler (usando la fecha seleccionada).
4. Modificar `updateCalendarDisponibleDates`:
   - Usar `selectedDate` de la instancia del calendario como fecha de referencia (en lugar de la fecha de hoy) para calcular los horarios del mes.
   - Usar el helper compartido de horarios del mes.
   - Renderizar el calendario con esos horarios como disponibles.
5. Modificar el handler de cambio de mes del calendario (`onChangedDate`):
   - Usar el mismo helper compartido de horarios del mes.
   - Agregar guard de instancia de calendario (actualmente solo chequea al asignar, no al inicio).

### 3.5 Patrones a aplicar

- **Mínimo anidado:** Para obtener la primera fecha con horarios se usa la función mínima sobre las claves numéricas de cada nivel del objeto (años, luego meses, luego días). Evita recorrer los valores con bucles anidados.
- **Helper compartido (DRY):** El aplanado de horarios por mes se extrae a una única función reutilizada por `updateCalendarDisponibleDates` y por el handler de cambio de mes, eliminando la duplicación de lógica.
- **Guard de instancia:** Toda función que use la instancia del calendario verifica que exista antes de acceder, para evitar errores cuando aún no fue inicializada.

### 3.6 Consideraciones

- **No se modifica `calendario.js` ni `horariosDelDia.js`:** el cambio se resuelve seteando `selectedDate` (propiedad existente) y dejando que el render existente del calendario navegue al mes y marque el día.
- **El input `fechaDeLaClase` se sincroniza manualmente** porque la pre-reserva de horarios lee esa fecha al clickear un horario en el scheduler. Sin sincronización, la pre-reserva se registraría con la fecha equivocada.
- **No se usa click programático sobre el día del calendario** para evitar el scroll automático hacia el scheduler que ejecuta el handler de click, y para no acoplarse a que el día esté habilitado.
- **No hay cambios en el backend:** la TVF `fn_obtenerClasesProgramadasPorIdClase` ya filtra fechas desde la fecha de referencia, garantizando que el objeto `horarios` solo contenga fechas desde la fecha de la inscripción seleccionada (fecha de referencia enviada por el frontend).

## 4. Archivos a modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js` | Modificar | Agregar 2 funciones nuevas (primer día con horarios, helper de horarios del mes) y modificar `fetchClasesProgramadas`, `updateCalendarDisponibleDates` y `onChangedDate` |

## 5. Criterios de aceptación

- [ ] Al consultar clases programadas con horarios, el calendario muestra el mes del primer día con horarios y ese día queda marcado como seleccionado
- [ ] El scheduler carga los horarios del primer día con horarios al iniciar el calendario
- [ ] El input oculto `fechaDeLaClase` queda con la fecha del primer día con horarios
- [ ] Si el primer día con horarios está en un mes distinto al actual, el calendario navega a ese mes y sus días disponibles se calculan con el mes correcto
- [ ] Si no hay clases programadas, el comportamiento queda igual que antes (fecha actual como fallback)
- [ ] El aplanado de horarios por mes usa la misma función en `updateCalendarDisponibleDates` y en el handler de cambio de mes (sin duplicación)
- [ ] Al cambiar de inscripción y re-consultar, se vuelve a seleccionar el primer día con horarios de la nueva consulta
- [ ] No se modifica `calendario.js` ni `horariosDelDia.js`
