# Spec: Tests Unitarios de Validación para cambiarPassword

## IMPORTANTE: Comportamiento de [ApiController] en Tests Unitarios

El atributo `[ApiController]` valida automáticamente el modelo en **requests HTTP reales**, pero **NO** en tests unitarios.

## UserPassEdit (7 tests de DataAnnotations)

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 1 | WhenEmailIsNull_ReturnsBadRequest | request.Email = null + ModelState.AddModelError | Se llama a CambiarPassword | Retorna BadRequestObjectResult |
| 2 | WhenEmailIsEmpty_ReturnsBadRequest | request.Email = "" + ModelState.AddModelError | Se llama a CambiarPassword | Retorna BadRequestObjectResult |
| 3 | WhenEmailIsInvalidFormat_ReturnsBadRequest | request.Email = "invalid-email" + ModelState.AddModelError | Se llama a CambiarPassword | Retorna BadRequestObjectResult |
| 4 | WhenNewPasswordIsNull_ReturnsBadRequest | request.NewPassword = null + ModelState.AddModelError | Se llama a CambiarPassword | Retorna BadRequestObjectResult |
| 5 | WhenNewPasswordIsEmpty_ReturnsBadRequest | request.NewPassword = "" + ModelState.AddModelError | Se llama a CambiarPassword | Retorna BadRequestObjectResult |
| 6 | WhenConfirmPasswordIsNull_ReturnsBadRequest | request.ConfirmPassword = null + ModelState.AddModelError | Se llama a CambiarPassword | Retorna BadRequestObjectResult |
| 7 | WhenConfirmPasswordDoesNotMatch_ReturnsBadRequest | request.NewPassword = "Password123" AND request.ConfirmPassword = "Different123" + ModelState.AddModelError | Se llama a CambiarPassword | Retorna BadRequestObjectResult |

## Validación de Usuario Existente (1 test)

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 8 | WhenEmailDoesNotExistInDatabase_ReturnsBadRequest | request.Email = "noexiste@test.com" (no existe en BD) | Se llama a CambiarPassword | Retorna BadRequestObjectResult con error indicando que el correo no existe |

**Nota**: Esta validación debe implementarse como un método separado en la capa BL (UsersManager) que verifique la existencia del usuario antes de cambiar la contraseña.