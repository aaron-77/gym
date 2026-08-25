# Spec: preReservarHorarioInscripcion - Tests de Integración

## 1. Resumen

Tests de integración para el método `preReservarHorarioInscripcion` de `HorariosService`. Los tests validan el flujo completo de creación de pre-reservas para inscripciones y reagendaciones: happy path, rechazo por pre-reserva duplicada y rechazo por falta de cupo. El método retorna una respuesta estandarizada `DTOResponse<int>`. Se usa seed seguro mediante helpers existentes.

## 2. Contexto

- **Capa:** GymWebApp.Tests (Integración)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Service | `preReservarHorarioInscripcion` | Método a probar | 64 |
| Helper | `SlotDisponibleParaClaseProgramadaHelper` | Obtiene slot, entrenador, clase y cliente seguros | — |
| Helper | `ClasesProgramadasHelper.RegistrarClaseProgramadaML` | Inserta clase programada + horario | — |
| Helper | `DatabaseHelper` | Inserta inscripción de prueba y obtiene segundo cliente | — |
| Helper | `ResponseManager` | Utilidad de BL para construir respuestas estandarizadas | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| IntegrationTestBase | Clase base | Base para tests de integración con WebApplicationFactory |
| TestContainerHelper | Helper | Base de datos de pruebas en Docker |
| FitnessCenterDbContext | DataAccess | Contexto para instanciar `HorariosService` |

## 3. Tests a crear

### 3.1 Archivo

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Features/Horarios/PreReservarHorarioReagendacionServiceTests.cs` | Clase con los 3 tests de integración |

### 3.2 Setup común

Antes de cada test:

1. Obtener un slot seguro con `SlotDisponibleParaClaseProgramadaHelper.obtenerSlotDisponibleParaClaseProgramadaAsync` usando una fecha futura
2. Construir un `DTODatosClaseProgramada` con:
   - `fkClase` = `slot.ClaseId`
   - `fkEntrenador` = `slot.EntrenadorId`
   - `fkHoraLaboral` = `slot.IdHoraLaboral`
   - `fechaDeLaClase` = `slot.FechaDisponible`
   - `cupoMaximo` = `1`
   - `fkEstadoClaseProgramada` = `1`
   - `idUsuarioQueReserva` = `null`
   - `idPreservaDeHorario` = `null`
3. Llamar `ClasesProgramadasHelper.RegistrarClaseProgramadaML` para insertar la clase programada y su horario
4. Capturar el `idClaseProgramada` generado

### 3.3 Test 1 — Happy Path

**Nombre:** `PreReservarHorarioReagendacion_DatosValidos_CreaPreReserva`

**Pasos:**
1. Ejecutar el setup común
2. Construir `DTOPreReservaDeHorarioInscripcion` con:
   - `idUsuarioQueReserva` = `slot.ClienteId`
   - `fechaTentativa` = `slot.FechaDisponible`
   - `idHoraLaboral` = `slot.IdHoraLaboral`
   - `idClase` = `slot.ClaseId`
   - `idEntrenador` = `slot.EntrenadorId`
   - `idClaseProgramada` = `idClaseProgramada`
3. Obtener una instancia de `FitnessCenterDbContext` desde `Factory.Services`
4. Instanciar `HorariosService`
5. Llamar `service.preReservarHorarioInscripcion(dto)`

**Resultado esperado:**
- Retorna un `DTOResponse<int>`
- `success` debe ser `true`
- `httpCode` debe ser `200`
- `payload` debe ser mayor a `0`

### 3.4 Test 2 — Pre-reserva duplicada

**Nombre:** `PreReservarHorarioReagendacion_PreReservaDuplicada_RetornaError`

**Pasos:**
1. Ejecutar el setup común
2. Llamar `service.preReservarHorarioInscripcion(dto)` con `slot.ClienteId`
3. Llamar `service.preReservarHorarioInscripcion(dto)` nuevamente con el mismo cliente

**Resultado esperado:**
- La segunda llamada retorna un `DTOResponse<int>`
- `success` debe ser `false`
- `httpCode` debe ser `500`
- La lista de errores debe contener un mensaje sobre pre-reserva vigente duplicada

### 3.5 Test 3 — Sin cupo

**Nombre:** `PreReservarHorarioReagendacion_SinCupo_RetornaError`

**Pasos:**
1. Ejecutar el setup común
2. Insertar una inscripción vigente en `inscripcionesDeClases` para `slot.ClienteId` y `idClaseProgramada`
3. Obtener un segundo cliente distinto usando `DatabaseHelper`
4. Construir el DTO con el segundo cliente
5. Llamar `service.preReservarHorarioInscripcion(dto)`

**Resultado esperado:**
- Retorna un `DTOResponse<int>`
- `success` debe ser `false`
- `httpCode` debe ser `500`
- La lista de errores debe contener un mensaje sobre falta de cupo disponible

## 4. Cleanup

Al final de cada test eliminar, en orden:

1. Pre-reservas creadas en `preReservasDeHorario`
2. Inscripción de prueba creada en `inscripcionesDeClases` (solo Test 3)
3. Registro en `horariosDeClasesProgramadas`
4. Registro en `clasesProgramadas`

## 5. Criterios de aceptación

- [ ] La clase de test hereda de `IntegrationTestBase` y usa `[Collection("IntegrationTests")]`
- [ ] Los 3 tests usan seed seguro mediante `SlotDisponibleParaClaseProgramadaHelper`
- [ ] La clase programada de prueba se crea con `cupoMaximo = 1`
- [ ] El Test 1 verifica que `success` es `true`, `httpCode` es `200` y `payload` es mayor a cero
- [ ] El Test 2 verifica que `success` es `false`, `httpCode` es `500` y el mensaje de error menciona pre-reserva duplicada
- [ ] El Test 3 verifica que `success` es `false`, `httpCode` es `500` y el mensaje de error menciona falta de cupo
- [ ] Cada test limpia sus datos de prueba al finalizar
