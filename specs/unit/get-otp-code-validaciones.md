# Spec: Tests Unitarios de Validación para getOTPCode

## IMPORTANTE: Validaciones de Usuario Existente en DTO

Las validaciones de existencia de correo/celular deben implementarse como **Custom Validation Attributes** en el DTO CanalDeEnvioOTP.

## CanalDeEnvioOTP (3 tests)

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 1 | WhenCorreoDoesNotExist_Returns400BadRequest | request.correo = "noexiste@test.com" (no existe en BD) + ModelState.AddModelError | Se llama a obtenerCodigoOTP | Retorna BadRequestObjectResult con error indicando que el correo no existe |
| 2 | WhenCelularDoesNotExist_Returns400BadRequest | request.cel = "+549999999999" (no existe en BD) + ModelState.AddModelError | Se llama a obtenerCodigoOTP | Retorna BadRequestObjectResult con error indicando que el celular no existe |
| 3 | WhenBothCorreoAndCelularAreNull_Returns400BadRequest | request.correo = null AND request.cel = null + ModelState.AddModelError | Se llama a obtenerCodigoOTP | Retorna BadRequestObjectResult con error indicando que debe proporcionar al menos un canal |

**Nota**: Crear custom validation attribute que verifique existencia en AspNetUsers (para correo) y aspnet_Users (para PhoneNumber).