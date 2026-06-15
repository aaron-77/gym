# Spec: Tests Unitarios de Validación para Rutinas

## IMPORTANTE: Comportamiento de [ApiController] en Tests Unitarios

El atributo `[ApiController]` valida automáticamente el modelo en **requests HTTP reales**, pero **NO** en tests unitarios que llaman el método del controller directamente.

Por lo tanto:
- **En requests HTTP reales**: `[ApiController]` retorna BadRequest si la validación falla
- **En tests unitarios**: El controller debe retornar Ok (la validación no ocurre automáticamente)

Para simular el comportamiento de validación en tests unitarios, SE DEBE usar `ModelState.AddModelError()`.

## RegistrarRutina (4 tests)

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 1 | WhenUsuarioIDIsNull_ReturnsBadRequest | rutina.UsuarioID = null + ModelState.AddModelError | Se llama a RegistrarRutina | Retorna BadRequestObjectResult |
| 2 | WhenEntrenadorIDIsNull_ReturnsBadRequest | rutina.EntrenadorID = null + ModelState.AddModelError | Se llama a RegistrarRutina | Retorna BadRequestObjectResult |
| 3 | WhenFechaCreacionIsDefault_ReturnsBadRequest | rutina.FechaCreacion = default + ModelState.AddModelError | Se llama a RegistrarRutina | Retorna BadRequestObjectResult |
| 4 | WhenObservacionesIsNull_ReturnsBadRequest | rutina.Observaciones = null + ModelState.AddModelError | Se llama a RegistrarRutina | Retorna BadRequestObjectResult |

## AsignarEjercicio (7 tests)

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 1 | WhenUsuarioIDIsNull_ReturnsBadRequest | asignacion.UsuarioID = null + ModelState.AddModelError | Se llama a asignarEjercicioARutina | Retorna BadRequestObjectResult |
| 2 | WhenRutinaIdIsZero_ReturnsBadRequest | asignacion.RutinaId = 0 + ModelState.AddModelError | Se llama a asignarEjercicioARutina | Retorna BadRequestObjectResult |
| 3 | WhenRutinaIdIsNegative_ReturnsBadRequest | asignacion.RutinaId = -1 + ModelState.AddModelError | Se llama a asignarEjercicioARutina | Retorna BadRequestObjectResult |
| 4 | WhenEjercicioIDIsZero_ReturnsBadRequest | asignacion.EjercicioID = 0 + ModelState.AddModelError | Se llama a asignarEjercicioARutina | Retorna BadRequestObjectResult |
| 5 | WhenSetsIsZero_ReturnsBadRequest | asignacion.Sets = 0 + ModelState.AddModelError | Se llama a asignarEjercicioARutina | Retorna BadRequestObjectResult |
| 6 | WhenSetsIsNegative_ReturnsBadRequest | asignacion.Sets = -1 + ModelState.AddModelError | Se llama a asignarEjercicioARutina | Retorna BadRequestObjectResult |
| 7 | WhenRepeticionesIsNegative_ReturnsBadRequest | asignacion.Repeticiones = -1 + ModelState.AddModelError | Se llama a asignarEjercicioARutina | Retorna BadRequestObjectResult |

**Nota**: El atributo `[Range(0, int.MaxValue)]` en Repeticiones permite valores negativos porque el rango starts at 0. Esto es un bug en la validación - debería ser `[Range(1, int.MaxValue)]`.

## ConsultarRutinas (4 tests)

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 1 | WhenUsuarioIDIsNull_ReturnsOk | UsuarioID = null | Se llama a obtenerRutinasDeUusario | Retorna OkObjectResult (parámetro opcional) |
| 2 | WhenUsuarioIDIsEmpty_ReturnsOk | UsuarioID = "" | Se llama a obtenerRutinasDeUusario | Retorna OkObjectResult (parámetro opcional) |
| 3 | WhenUsuarioIDIsValidGuid_ReturnsOk | UsuarioID = "guid-válido" | Se llama a obtenerRutinasDeUusario | Retorna OkObjectResult |