# Spec: Frontend - Tests E2E Cancelar Inscripción

## 1. Resumen

Crear tests E2E para el endpoint frontend POST de cancelación de inscripciones,
validando happy path y edge cases básicos del proxy endpoint.

## 2. Contexto

- **Capa:** Tests (E2E)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Endpoint | `POST /inscripciones/cancelar` | Endpoint frontend a testear | 45 |

## 3. Tests a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/E2ETests/InscripcionesCancelarE2ETests.cs` | Tests E2E |

### 3.2 Happy path

| # | Test | Descripción |
|---|------|-------------|
| 1 | `Cancelar_InscripcionValida_RetornaOk` | Cancelar inscripción válida retorna éxito |

### 3.3 Edge cases

| # | Test | Descripción |
|---|------|-------------|
| 2 | `Cancelar_IdInscripcionCero_RetornaBadRequest` | ID inscripción 0 retorna error |
| 3 | `Cancelar_SinAutenticacion_RetornaRedirectToLogin` | Sin cookie JWT redirige a login |
| 4 | `Cancelar_UsuarioSinRolEmpleado_RetornaForbidden` | Usuario sin rol empleado retorna error |
| 5 | `Cancelar_InscripcionNoExiste_RetornaNotFound` | Inscripción que no existe retorna error |

### 3.4 Patrones a aplicar

- **xUnit:** Framework de testing
- **FluentAssertions:** Aserciones legibles
- **Playwright:** Para tests E2E con navegador
- **Arrange/Act/Assert:** Estructura de cada test
- **Test data builder:** Crear datos de prueba válidos
- **Cookie authentication:** Configurar cookie JWT para requests autenticadas

## 4. Criterios de aceptación

- [ ] Test happy path: cancelar inscripción válida retorna éxito
- [ ] Test edge case: idInscripcion 0 retorna bad request
- [ ] Test edge case: sin autenticación redirige a login
- [ ] Test edge case: usuario sin rol empleado retorna forbidden
- [ ] Test edge case: inscripción no existe retorna not found
- [ ] Tests siguen patrón AAA
- [ ] Tests usan FluentAssertions
