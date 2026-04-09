# Spec: Tests Unitarios de Validación para verificarCodigoOTP

## IMPORTANTE: Validaciones de Usuario Existente en DTO

Las validaciones de existencia de correo/celular deben implementarse como **Custom Validation Attributes** en el DTO OTPCodeVerification.

## OTPCodeVerification (3 tests)

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 1 | WhenCodigoIsNull_ReturnsBadRequest | request.codigo = null + ModelState.AddModelError | Se llama a verificarCodigoOTP | Retorna BadRequestObjectResult |
| 2 | WhenCelularDoesNotExist_Returns400BadRequest | request.cel = "+549999999999" (no existe en BD) + ModelState.AddModelError | Se llama a verificarCodigoOTP | Retorna BadRequestObjectResult con error indicando que el celular no existe |
| 3 | WhenCorreoDoesNotExist_Returns400BadRequest | request.correo = "noexiste@test.com" (no existe en BD) + ModelState.AddModelError | Se llama a verificarCodigoOTP | Retorna BadRequestObjectResult con error indicando que el correo no existe |

**Nota**: Crear custom validation attribute que verifique existencia en AspNetUsers.