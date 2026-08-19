# Spec: registrarPreReservaDeInscripcion - Tests de Integración (API)

## 1. Resumen

Tests de integración para el endpoint `POST /api/horarios/preReservarHorarioInscripcion` de `HorariosController`. Los tests validan el flujo completo de creación de pre-reservas de inscripción por HTTP: happy path y sad paths por validación de modelo. Cada sad path prueba exactamente un campo problemático; todos los demás campos se envían con valores válidos. El endpoint usa `[ApiController]` que valida automáticamente el DTO con DataAnnotations y retorna respuestas estandarizadas `DTOResponse<int>`.

## 2. Contexto

- **Capa:** GymWebApp.Tests (Integración — HTTP)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Endpoint | `registrarPreReservaDeInscripcion` | Endpoint a probar | 66 |
| Service | `HorariosService.preReservarHorarioInscripcion` | Service que ejecuta el SP | 64 |
| DTO | `DTOPreReservaDeHorarioInscripcion` | Payload con validaciones | 63 |
| Helper | `SlotDisponibleParaClaseProgramadaHelper` | Seed seguro de slot con cliente, clase programada | — |
| Helper | `PreReservarHorarioApiTestHelper` | Construye DTO y cleanup de pre-reservas | — |
| Helper | `DatabaseHelper` | Queries directas a BD | — |
| CustomValidation | `FechaMinimaValidaAttribute` | Valida que `DateOnly.Year >= 1890` | 70 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| IntegrationTestBase | Clase base | WebApplicationFactory + TestContainers |
| TestContainerHelper | Helper | Docker SQL Server |
| AuthenticateAsync | Factory | Token JWT con rol `empleado` |

## 3. Tests a crear

### 3.1 Archivo

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Features/Horarios/PreReservarHorarioInscripcionControllerTests.cs` | Clase con los 6 tests de integración |

### 3.2 Setup común

Antes de cada test:
1. Autenticarse con `SetAuthHeaderAsync()` para obtener token JWT de rol `empleado`
2. Obtener un slot válido con `SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync` usando fecha futura
3. Obtener un `idClase` válido de la tabla `Clases` mediante `DatabaseHelper.ExecuteQuerySingleAsync`

Los valores base usados en todos los tests son:
- `idUsuarioQueReserva = {clienteId}`
- `fechaTentativa = 2030-06-15`
- `idHoraLaboral = {idHoraLaboral}`
- `idClase = {idClase}`
- `idEntrenador = {entrenadorId}`
- `idClaseProgramada = {idClaseProgramada}`

### 3.3 Test 1 — Happy Path

**Nombre:** `ConTodosLosDatosCorrectos_Devuelve200`

**GIVEN:** Slot válido con cliente, entrenador, clase, clase programada y fecha futura

**WHEN:** `POST /api/horarios/preReservarHorarioInscripcion` con payload completo (todos los campos con valores válidos)

**THEN:**
- `200 OK`
- `success = true`
- `payload > 0` (ID de pre-reserva creada)

### 3.4 Test 2 — Cliente nulo

**Nombre:** `SinIdUsuarioQueReserva_Devuelve400`

**GIVEN:** Todos los campos válidos excepto `idUsuarioQueReserva`

**WHEN:** `POST /api/horarios/preReservarHorarioInscripcion` con `idUsuarioQueReserva = null` y el resto válido

**THEN:**
- `400 Bad Request`
- `success = false`

### 3.5 Test 3 — Entrenador vacío

**Nombre:** `ConIdEntrenadorVacio_Devuelve400`

**GIVEN:** Todos los campos válidos excepto `idEntrenador`

**WHEN:** `POST /api/horarios/preReservarHorarioInscripcion` con `idEntrenador = ""` y el resto válido

**THEN:**
- `400 Bad Request`
- `success = false`

**Nota:** Un `idEntrenador` nulo es válido porque el campo es opcional. Para generar un error de validación se envía string vacío, que falla `[StringLength(36, MinimumLength = 36)]`.

### 3.6 Test 4 — Clase en cero

**Nombre:** `ConIdClaseCero_Devuelve400`

**GIVEN:** Todos los campos válidos excepto `idClase`

**WHEN:** `POST /api/horarios/preReservarHorarioInscripcion` con `idClase = 0` y el resto válido

**THEN:**
- `400 Bad Request`
- `success = false`

**Nota:** Un `idClase` nulo es válido porque el campo es opcional. Para generar un error de validación se envía `0`, que falla `[Range(1, int.MaxValue)]`.

### 3.7 Test 5 — Clase programada en cero

**Nombre:** `SinIdClaseProgramada_Devuelve400`

**GIVEN:** Todos los campos válidos excepto `idClaseProgramada`

**WHEN:** `POST /api/horarios/preReservarHorarioInscripcion` con `idClaseProgramada = 0` y el resto válido

**THEN:**
- `400 Bad Request`
- `success = false`

### 3.8 Test 6 — Fecha no enviada

**Nombre:** `SinFechaTentativa_Devuelve400`

**GIVEN:** Todos los campos válidos excepto `fechaTentativa`

**WHEN:** `POST /api/horarios/preReservarHorarioInscripcion` sin el campo `fechaTentativa` y el resto válido

**THEN:**
- `400 Bad Request`
- `success = false`

**Nota:** Cuando no se envía `fechaTentativa`, el binder asigna `default(DateOnly) = 0001-01-01`. El atributo `[FechaMinimaValida(1890)]` rechaza años anteriores a 1890, generando error de validación del modelo.

## 4. Cleanup

Al final de cada test, en orden:
1. Pre-reservas creadas en `preReservasDeHorario`
2. Clase programada de prueba en `clasesProgramadas`
3. Horario en `horariosDeClasesProgramadas`

## 5. Criterios de aceptación

- [ ] La clase de test hereda de `IntegrationTestBase` y usa `[Collection("IntegrationTests")]`
- [ ] Todos los tests usan `SetAuthHeaderAsync()` para autenticación con rol `empleado`
- [ ] El Test 1 (happy path) verifica `200 OK`, `success = true` y `payload > 0`
- [ ] Los Tests 2-6 (sad paths) verifican `400 Bad Request` y `success = false`
- [ ] Cada sad path modifica exactamente un campo; todos los demás permanecen válidos
- [ ] Cada test limpia sus datos de prueba al finalizar
- [ ] Los tests no dependen del orden de ejecución entre sí
