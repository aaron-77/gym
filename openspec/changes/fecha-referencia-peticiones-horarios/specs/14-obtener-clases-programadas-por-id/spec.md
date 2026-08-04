# Delta for 14-obtener-clases-programadas-por-id

## Purpose

El endpoint `obtenerClasesProgramadasPorId` acepta un query param opcional `fecha` que actúa como fecha de referencia de la consulta. El frontend lo envía con la fecha del browser; si no se envía, se usa la fecha actual como fallback. Las validaciones existentes de `idClase` NO cambian.

## ADDED Requirements

### Requirement: El endpoint acepta una fecha de referencia opcional

The endpoint MUST accept an optional `fecha` query param (formato `yyyy-MM-dd`, tipo fecha) en adición a `idClase`. Cuando se recibe, el controller DEBE propagarla al `ClasesManager`, y el manager DEBE usarla como fecha de referencia de la consulta. Cuando no se recibe, la fecha de referencia DEBE ser la fecha actual (`DateTime.Today`). El param `fecha` es opcional: su ausencia NO debe romper los callers actuales.

#### Scenario: GET con idClase y fecha de referencia

- DADO un usuario autenticado con rol empleado
- Y un `idClase` válido que existe
- CUANDO se hace un GET a `/api/Clases/obtenerClasesProgramadasPorId?idClase=<valido>&fecha=<YYYY-MM-DD>`
- ENTONCES el status DEBE ser `200 OK`
- Y `success` DEBE ser `true`
- Y el `payload` DEBE contener las clases programadas de esa clase evaluadas con la fecha recibida como referencia

#### Scenario: GET con idClase sin fecha (compatibilidad hacia atrás)

- DADO un usuario autenticado con rol empleado
- Y un `idClase` válido que existe
- CUANDO se hace un GET a `/api/Clases/obtenerClasesProgramadasPorId?idClase=<valido>` sin `fecha`
- ENTONCES el status DEBE ser `200 OK`
- Y `success` DEBE ser `true`
- Y la fecha de referencia DEBE ser la fecha actual (fallback)

#### Scenario: Fecha con formato inválido

- DADO un usuario autenticado con rol empleado
- CUANDO se hace un GET con `fecha` en un formato que no se puede parsear como fecha
- ENTONCES la petición DEBE ser rechazada con una respuesta de bad request

#### Scenario: ClasesManager construye la petición al API con ambos params

- DADO un `idClase` con valor
- Y una `fecha` de referencia recibida
- CUANDO el `ClasesManager.ObtenerClasesProgramadasPorId` invoca al API
- ENTONCES la URL DEBE incluir tanto `idClase` como `fecha`
- Y cuando `fecha` es nula, la URL DEBE incluir solo `idClase` (comportamiento actual preservado)

## MODIFIED Requirements

### 1.1 GET /api/Clases/obtenerClasesProgramadasPorId

Un usuario autenticado con rol empleado solicita las clases programadas de una clase existente, opcionalmente con una `fecha` de referencia. El resultado esperado se mantiene: status 200 OK, `success: true`, payload con lista de elementos con `idClaseProgramada > 0`.
(Previously: el endpoint solo aceptaba `idClase` y la consulta se evaluaba contra la fecha actual del servidor)

#### Scenario: Happy path con y sin fecha de referencia

- DADO un usuario autenticado con rol empleado
- Y una clase existente
- CUANDO se hace un GET con `idClase` válido, con o sin `fecha`
- ENTONCES el status DEBE ser `200 OK`
- Y `success` DEBE ser `true`
- Y el `payload` DEBE contener una lista con al menos un elemento, cada uno con `idClaseProgramada > 0`
