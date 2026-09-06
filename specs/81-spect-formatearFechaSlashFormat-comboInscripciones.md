# Spec 81: formatearFechaSlashFormat — Formato de fecha y texto del combo de inscripciones

## 1. Resumen

Se agrega la función utilitaria `formatearFechaSlashFormat` al módulo de utilidades de fecha del frontend (`dateUtils.mjs`) y se modifica la función `onClienteChange` de la vista de cancelar/reagendar inscripciones para usarla al construir el texto de cada opción del combo de inscripciones.

El texto visible de cada inscripción pasa a incluir la hora de inicio de la clase y a mostrar la fecha con formato diagonal (`YYYY/MM/DD`), sin la hora que trae el valor crudo de la API.

## 2. Contexto

- **Capa:** GymFrontend (JavaScript del lado del cliente)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| DTO | DTOInscripcionDelCliente | Propiedades de cada inscripción: idInscripcion, nombreClase, fechaDeLaClase, horaInicio, idClaseProgramada, fkClase | 30 |
| Archivo JS | cancelarReagendarInscripcion.js | Vista de cancelar/reagendar inscripciones (combo de inscripciones del cliente) | 49 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| dateUtils.mjs | Módulo JS existente | Ya exporta `convertirADateLocal`, `pad` y `formatLocalDateTimeForQuery` |
| httpClient.js | Módulo JS existente | Provee `realizarPeticionAPI` y el endpoint de inscripciones del cliente |

## 3. Sistema de formato de fecha a implementar

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| GymFrontend/wwwroot/js/dateUtils.mjs | Se agrega la función exportada `formatearFechaSlashFormat` |
| GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js | Se importa la nueva función y se usa en el mapFn de `fillComboBox` dentro de `onClienteChange` |

### 3.2 Contrato

La función `formatearFechaSlashFormat` recibe un único parámetro que puede ser un objeto `Date` o un string de fecha (formato ISO 8601 u otro parseable por el constructor de `Date`). Devuelve siempre un string:

- Fecha válida: el resultado es `YYYY/MM/DD` con mes y día con cero a la izquierda.
- Fecha vacía (null, undefined o string vacío): string vacío.
- Fecha inválida (string no parseable o `Date` inválida): string vacío.

En los dos casos de error, debe registrar un mensaje descriptivo en consola con `console.error`, indicando el problema y el valor que recibió.

### 3.3 Comportamiento esperado

| Entrada | Salida | Consola |
|---------|--------|---------|
| `new Date(2024, 0, 15)` | `2024/01/15` | Sin mensajes |
| `"2024-01-15T10:00:00"` | `2024/01/15` | Sin mensajes |
| `null` | String vacío | Error: fecha vacía o null |
| `undefined` | String vacío | Error: fecha vacía o null |
| `""` | String vacío | Error: fecha vacía o null |
| `"fecha-no-valida"` | String vacío | Error: fecha inválida no parseable |
| `new Date("invalida")` | String vacío | Error: fecha inválida no parseable |

### 3.4 Acciones que debe realizar la función

1. Evaluar si el parámetro recibido es vacío; si lo es, registrar el error descriptivo y devolver string vacío.
2. Determinar si el parámetro es un objeto `Date` o un string; si es string, convertirlo a `Date` para su procesamiento.
3. Validar que la fecha resultante sea válida (no un NaN de tiempo); si no lo es, registrar el error descriptivo y devolver string vacío.
4. Construir el texto con el año completo, el mes y el día con cero a la izquierda, separados por diagonales.

### 3.5 Modificación de onClienteChange

En `onClienteChange` de `cancelarReagendarInscripcion.js`, el mapFn que se pasa a `fillComboBox` construye el texto de cada opción concatenando, en este orden:

1. El nombre de la clase (`ins.nombreClase`).
2. La fecha de la clase formateada con `formatearFechaSlashFormat` aplicada sobre `ins.fechaDeLaClase`.
3. La hora de inicio de la clase (`ins.horaInicio`).

El `value` y el `dataset` de cada opción permanecen iguales (idInscripcion, idClaseProgramada, fkClase y fechaDeLaClase).

### 3.6 Patrones a aplicar

- **Sobrecarga por tipo en JavaScript:** la función maneja tanto `Date` como string con un único parámetro, usando detección de tipo en tiempo de ejecución.
- **Manejo defensivo con trazabilidad:** los casos de error devuelven string vacío (sin romper la concatenación en el template literal) y dejan evidencia en consola con el valor recibido.
- **Utilidad compartida:** el formato queda centralizado en `dateUtils.mjs` para reutilizarse en futuras vistas que necesiten el mismo formato.

## 4. Archivos a modificar

| Archivo | Descripción |
|---------|-------------|
| GymFrontend/wwwroot/js/dateUtils.mjs | Agregar función `formatearFechaSlashFormat` |
| GymFrontend/wwwroot/js/cancelarReagendarInscripcion.js | Importar la función y usarla en el texto del combo de inscripciones |

## 5. Criterios de aceptación

- [ ] `formatearFechaSlashFormat` acepta objetos `Date` y strings, y devuelve `YYYY/MM/DD` con cero a la izquierda en mes y día.
- [ ] Con fecha vacía (null, undefined o string vacío) devuelve string vacío y registra error descriptivo en consola.
- [ ] Con fecha inválida (string no parseable o Date inválida) devuelve string vacío y registra error descriptivo en consola.
- [ ] El texto del combo de inscripciones muestra nombre de clase, fecha con formato diagonal y hora de inicio de la clase.
- [ ] El `value` y el `dataset` de las opciones del combo no cambian respecto al comportamiento anterior.
- [ ] `cancelarReagendarInscripcion.js` importa la función desde `dateUtils.mjs`.
- [ ] La función queda exportada correctamente para ser reutilizada por otros módulos.