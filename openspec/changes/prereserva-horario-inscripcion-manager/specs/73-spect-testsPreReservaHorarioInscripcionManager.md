# Spec: Tests de Integración HorariosManager.preReservarHorarioInscripcion - Tests

## 1. Resumen

Tests de integración que ejercitan el método `preReservarHorarioInscripcion` de `HorariosManager` (BL) directamente contra el API real en memoria. A diferencia de los tests del endpoint (spec 69, que posteaban por HTTP al API), estos tests construyen el manager con el cliente HTTP del factory y llaman al método BL tipado. Validan el happy path (200 con payload) y 5 sad paths por validación de modelo. Este es el primer wiring de un Manager BL contra el API en el repo, pero está construido enteramente con bloques existentes: `IntegrationTestBase` + `HttpCustomClient(Client)`.

## 2. Contexto

- **Capa:** GymWebApp.Tests (Integración — BL→API)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Manager BL | `HorariosManager.preReservarHorarioInscripcion` | Método bajo prueba | 72 |
| Endpoint backend | `registrarPreReservaDeInscripcion` | API real que se levanta in-memory | 66 |
| DTO | `DTOPreReservaDeHorarioInscripcion` | Payload tipado con validaciones | 63 |
| CustomValidation | `FechaMinimaValidaAttribute` | Valida `DateOnly.Year >= 1890` | 70 |
| Tests de referencia | `PreReservarHorarioInscripcionControllerTests` | Estructura y sad paths a replicar | 69 |
| Helper | `SlotDisponibleParaClaseProgramadaHelper` | Seed seguro de slot con cliente, entrenador, clase programada | — |
| Helper | `PreReservarHorarioApiTestHelper` | Cleanup de pre-reservas (sobrecarga para `DTOPreReservaDeHorarioInscripcion`) | — |
| Helper | `DatabaseHelper` | Queries directas a BD para obtener ids válidos | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `IntegrationTestBase` | Clase base | WebApplicationFactory + TestContainers + `Client` + `SetAuthHeaderAsync` |
| `HttpCustomClient` | BL | Wrapper sobre `HttpClient` que usa el manager; recibe `Client` del factory |
| `CitasApiWebApplicationFactory<Program>` | Factory | Levanta el API en memoria con `BaseAddress` del servidor in-memory |
| `TestContainerHelper` | Helper | Docker SQL Server |
| `SetAuthHeaderAsync` | Base | Token JWT con rol `empleado` (Bearer en `Client`) |

## 3. Tests a crear

### 3.1 Archivo

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Features/Horarios/PreReservarHorarioInscripcionManagerTests.cs` | Clase con 6 tests (happy + 5 sad) |

### 3.2 Wiring del manager

- **Clase:** `PreReservarHorarioInscripcionManagerTests` (nombre distinto al de tests del endpoint `PreReservarHorarioInscripcionControllerTests` para evitar colisión)
- **Herencia:** `IntegrationTestBase`
- **Collection:** `[Collection("IntegrationTests")]`
- **Constructor:** recibe `CitasApiWebApplicationFactory<Program>` y `TestContainerHelper`, los pasa a la base
- **Instanciación del manager:** después de `SetAuthHeaderAsync()`, construir `new HorariosManager(new HttpCustomClient(Client))`. El `Client.BaseAddress` del factory apunta al servidor in-memory, por lo que los paths relativos del manager (`api/Horarios/...`) resuelven correctamente. El header `Authorization: Bearer` ya está seteado en `Client` y fluye a través de `HttpCustomClient.post` (que usa el `HttpClient` recibido).
- **Nuevo wiring, bloques existentes:** este patrón no tiene precedente en el repo (ningún test ejercita un Manager BL), pero se compone únicamente de `IntegrationTestBase`, `HttpCustomClient` y `Client` — todos preexistentes. No requiere cambios en DI ni en el factory.

> Los tests llaman al método del manager DIRECTAMENTE (`await manager.preReservarHorarioInscripcion(dto)`), NO a través del controller frontend.

### 3.3 Setup común

Antes de cada test:
1. Autenticarse con `SetAuthHeaderAsync()` para obtener token JWT de rol `empleado`
2. Construir `new HorariosManager(new HttpCustomClient(Client))`
3. Obtener un slot válido con `SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync` usando fecha futura
4. Obtener un `idClase` válido de la tabla `Clases` mediante `DatabaseHelper.ExecuteQuerySingleAsync`
5. Obtener un `idClaseProgramada` válido de la tabla `clasesProgramadas` mediante `DatabaseHelper.ExecuteQuerySingleAsync`

Valores base usados en todos los tests:
- `idUsuarioQueReserva = {slot.ClienteId}`
- `fechaTentativa = {fecha futura, ej. 2030-06-15}`
- `idHoraLaboral = {slot.IdHoraLaboral}`
- `idClase = {idClase}`
- `idEntrenador = {slot.EntrenadorId}`
- `idClaseProgramada = {idClaseProgramada}`

### 3.4 Test 1 — Happy Path

**Nombre:** `ConTodosLosDatosCorrectos_Devuelve200`

**GIVEN:** Slot válido con cliente, entrenador, clase, clase programada y fecha futura; manager construido con `HttpCustomClient(Client)` autenticado

**WHEN:** Se llama `manager.preReservarHorarioInscripcion(dto)` con un `DTOPreReservaDeHorarioInscripcion` completo y válido

**THEN:**
- `result.success = true`
- `result.httpCode = 200`
- `result.payload` no es null (es un `JsonElement`; extraer el ID con `GetInt32()` y verificar `> 0`)

**Cleanup:** `PreReservarHorarioApiTestHelper.LimpiarPreReservasDeHorarioAsync(connectionString, dto)` (sobrecarga que recibe `DTOPreReservaDeHorarioInscripcion`).

> **Nota sobre el helper de cleanup:** se verificó que `PreReservarHorarioApiTestHelper` YA posee una sobrecarga de `LimpiarPreReservasDeHorarioAsync` que recibe `DTOPreReservaDeHorarioInscripcion` (limpia por `fkHoraLaboral`, `fechaReservada`, `idClase` e `idEntrenador`; `idClaseProgramada` no se almacena en `preReservasDeHorario` y no se usa para cleanup). NO se requiere extensión ni nuevo helper — el riesgo mencionado en el proposal queda resuelto.

### 3.5 Test 2 — Sin idUsuarioQueReserva

**Nombre:** `SinIdUsuarioQueReserva_Devuelve400`

**GIVEN:** Todos los campos válidos excepto `idUsuarioQueReserva`

**WHEN:** Se llama al manager con un `DTOPreReservaDeHorarioInscripcion` tipado donde `idUsuarioQueReserva = null` (el campo es `string?`, admite null) y el resto válido

**THEN:**
- `result.success = false`
- `result.httpCode = 400`
- `result.payload = null`
- `result.errors` contiene un elemento con `propiedad = "idUsuarioQueReserva"`

### 3.6 Test 3 — idEntrenador vacío

**Nombre:** `ConIdEntrenadorVacio_Devuelve400`

**GIVEN:** Todos los campos válidos excepto `idEntrenador`

**WHEN:** Se llama al manager con `idEntrenador = ""` (string vacío) y el resto válido

**THEN:**
- `result.success = false`
- `result.httpCode = 400`
- `result.payload = null`
- `result.errors` contiene un elemento con `propiedad = "idEntrenador"`

> **Nota:** `idEntrenador` nulo es válido (campo opcional). Para generar error se envía string vacío, que falla `[StringLength(36, MinimumLength = 36)]`.

### 3.7 Test 4 — idClase en cero

**Nombre:** `ConIdClaseCero_Devuelve400`

**GIVEN:** Todos los campos válidos excepto `idClase`

**WHEN:** Se llama al manager con `idClase = 0` (campo `int?` con valor 0) y el resto válido

**THEN:**
- `result.success = false`
- `result.httpCode = 400`
- `result.payload = null`
- `result.errors` contiene un elemento con `propiedad = "idClase"`

> **Nota:** `idClase` nulo es válido (campo opcional). Para generar error se envía 0, que falla `[Range(1, int.MaxValue)]`.

### 3.8 Test 5 — Sin idClaseProgramada

**Nombre:** `SinIdClaseProgramada_Devuelve400`

**GIVEN:** Todos los campos válidos excepto `idClaseProgramada`

**WHEN:** Se llama al manager con `idClaseProgramada = 0` (campo `int` non-nullable, default) y el resto válido

**THEN:**
- `result.success = false`
- `result.httpCode = 400`
- `result.payload = null`
- `result.errors` contiene un elemento con `propiedad = "idClaseProgramada"`

### 3.9 Test 6 — Fecha inválida (divergencia aceptada)

**Nombre:** `ConFechaInvalida_Devuelve400`

**GIVEN:** Todos los campos válidos excepto `fechaTentativa`

**WHEN:** Se llama al manager con `fechaTentativa = default(DateOnly)` (0001-01-01) y el resto válido

**THEN:**
- `result.success = false`
- `result.httpCode = 400`
- `result.payload = null`
- `result.errors` contiene un elemento con `propiedad = "fechaTentativa"`

> **Divergencia con spec 69 (Test 6 `SinFechaTentativa`):** el test del endpoint omitía el campo `fechaTentativa` del JSON (tipo anónimo sin la propiedad), de modo que el binder asignaba `default(DateOnly)` y fallaba la validación. En los tests del manager el DTO es tipado (`DTOPreReservaDeHorarioInscripcion`), donde `fechaTentativa` es un `DateOnly` (struct non-nullable) y NO puede omitirse ni ser null — su default es `0001-01-01`. Por eso el sad path se construye enviando explícitamente `default(DateOnly)`, y la validación que falla es `[FechaMinimaValida(1890)]` (año 1 < 1890), no `[Required]`. La `propiedad` del error sigue siendo `fechaTentativa`. Esta divergencia (Opción A) está aceptada y documentada: es la única forma de testear el sad path de fecha a través del DTO tipado del manager.

### 3.10 Uso del DTO tipado en sad paths

A diferencia de los tests del endpoint (spec 69), que usaban tipos anónimos para omitir campos, todos los sad paths del manager usan el `DTOPreReservaDeHorarioInscripcion` tipado porque la firma del método lo exige. Cada sad path modifica exactamente un campo; los demás permanecen válidos.

### 3.11 Aserciones comunes a los sad paths

Para todos los Tests 2-6:
- `result.success` debe ser false
- `result.httpCode` debe ser 400
- `result.payload` debe ser null (porque `InvalidModelStateResponseFactory` retorna `payload:null` en los 400 de validación)
- `result.errors` debe contener un elemento cuya `propiedad` sea el campo fallido

## 4. Cleanup

Al final de cada test (en el `finally`), en orden:
1. Pre-reservas creadas en `preReservasDeHorario` vía `PreReservarHorarioApiTestHelper.LimpiarPreReservasDeHorarioAsync` (sobrecarga `DTOPreReservaDeHorarioInscripcion`)

> El cleanup solo aplica al happy path (los sad paths no crean registros porque la validación del modelo falla antes de llegar al SP). Aun así, se recomienda envolver el happy path en `try/finally`.

## 5. Criterios de aceptación

- [ ] La clase hereda de `IntegrationTestBase` y usa `[Collection("IntegrationTests")]`
- [ ] La clase se llama `PreReservarHorarioInscripcionManagerTests` (distinta de los tests del endpoint)
- [ ] Todos los tests usan `SetAuthHeaderAsync()` para autenticación con rol `empleado`
- [ ] El manager se construye con `new HorariosManager(new HttpCustomClient(Client))` después de setear el auth header
- [ ] Los tests llaman al método del manager directamente, NO al controller frontend
- [ ] El Test 1 (happy path) verifica `success = true`, `httpCode = 200` y `payload` no null con ID `> 0`
- [ ] Los Tests 2-6 (sad paths) verifican `success = false`, `httpCode = 400`, `payload = null` y `errors` contiene la `propiedad` fallida
- [ ] El Test 6 usa `default(DateOnly)` y documenta la divergencia con el test del endpoint (spec 69)
- [ ] Todos los sad paths usan el DTO tipado `DTOPreReservaDeHorarioInscripcion`
- [ ] Cada sad path modifica exactamente un campo; los demás permanecen válidos
- [ ] El happy path limpia sus datos en el `finally` con `PreReservarHorarioApiTestHelper`
- [ ] Los tests no dependen del orden de ejecución entre sí
