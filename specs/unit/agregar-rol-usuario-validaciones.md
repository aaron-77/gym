# Spec: Tests Unitarios de Validación para AgregarRolUsuario

## IMPORTANTE: Comportamiento de [ApiController] en Tests Unitarios

El atributo `[ApiController]` valida automáticamente el modelo en **requests HTTP reales**, pero **NO** en tests unitarios que llaman el método del controller directamente.

## DTOAgregarRol (4 tests de DataAnnotations)

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 1 | WhenUserIdIsNull_ReturnsBadRequest | request.UserId = null + ModelState.AddModelError | Se llama a AgregarRolUsuario | Retorna BadRequestObjectResult |
| 2 | WhenUserIdIsEmpty_ReturnsBadRequest | request.UserId = "" + ModelState.AddModelError | Se llama a AgregarRolUsuario | Retorna BadRequestObjectResult |
| 3 | WhenRoleIsNull_ReturnsBadRequest | request.Role = null + ModelState.AddModelError | Se llama a AgregarRolUsuario | Retorna BadRequestObjectResult |
| 4 | WhenRoleIsEmpty_ReturnsBadRequest | request.Role = "" + ModelState.AddModelError | Se llama a AgregarRolUsuario | Retorna BadRequestObjectResult |

## Validación de Usuario Existente (1 test)

| # | Test Name | GIVEN | WHEN | THEN |
|---|-----------|-------|------|------|
| 5 | WhenUserIdDoesNotExist_ReturnsBadRequest | request.UserId = "non-existent-id" | Se llama a AgregarRolUsuario | Retorna BadRequestObjectResult con error indicando que el usuario no existe |

**Nota**: Esta validación debe implementarse como un método separado en la capa BL (UsersManager) que valide la existencia del usuario antes de agregar el rol.