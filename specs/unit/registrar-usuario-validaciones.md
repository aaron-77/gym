# Spec: Tests Unitarios de Validación para RegistrarUsuario

## IMPORTANTE: Comportamiento de [ApiController] en Tests Unitarios

El atributo `[ApiController]` valida automáticamente el modelo en **requests HTTP reales**, pero **NO** en tests unitarios que llaman el método del controller directamente.

Por lo tanto:
- **En requests HTTP reales**: `[ApiController]` retorna BadRequest si la validación falla
- **En tests unitarios**: El controller debe retornar BadRequest (la validación no ocurre automáticamente)

Para simular el comportamiento de validación en tests unitarios, SE DEBE usar `ModelState.AddModelError()`.

## NewUser (13 tests)

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 1 | WhenNombreIsNull_ReturnsBadRequest | usuario.Nombre = null + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |
| 2 | WhenNombreIsEmpty_ReturnsBadRequest | usuario.Nombre = "" + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |
| 3 | WhenApellidoIsNull_ReturnsBadRequest | usuario.Apellido = null + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |
| 4 | WhenApellidoIsEmpty_ReturnsBadRequest | usuario.Apellido = "" + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |
| 5 | WhenFechaDeNacimientoIsDefault_ReturnsBadRequest | usuario.FechaDeNacimiento = default + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |
| 6 | WhenDireccionIsNull_ReturnsBadRequest | usuario.Direccion = null + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |
| 7 | WhenCurpIsNull_ReturnsBadRequest | usuario.Curp = null + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |
| 8 | WhenCorreoIsNull_ReturnsBadRequest | usuario.Correo = null + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |
| 9 | WhenCorreoIsInvalidFormat_ReturnsBadRequest | usuario.Correo = "invalid-email" + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |
| 10 | WhenTelefonoIsNull_ReturnsBadRequest | usuario.Telefono = null + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |
| 11 | WhenContrasenaIsNull_ReturnsBadRequest | usuario.Contrasena = null + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |
| 12 | WhenRolIsNull_ReturnsBadRequest | usuario.Rol = null + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |
| 13 | WhenEstadoIsNull_ReturnsBadRequest | usuario.Estado = null + ModelState.AddModelError | Se llama a RegistrarUsuario | Retorna BadRequestObjectResult |