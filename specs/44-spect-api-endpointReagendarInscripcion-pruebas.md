# Spec: API - Tests Endpoint Reagendar Inscripción

## 1. Resumen

Crear tests de integración para el endpoint POST de reagendación de inscripciones,
validando happy path y edge cases básicos.

## 2. Contexto

- **Capa:** Tests (Integración)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Endpoint | `POST api/inscripciones/reagendar` | Endpoint a testear | 43 |

## 3. Tests a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/IntegrationTests/InscripcionesReagendarTests.cs` | Tests de integración |

### 3.2 Happy path

| # | Test | Descripción |
|---|------|-------------|
| 1 | `Reagendar_InscripcionValida_RetornaOk` | Reagendar una inscripción válida retorna éxito |

### 3.3 Edge cases

| # | Test | Descripción |
|---|------|-------------|
| 2 | `Reagendar_IdInscripcionCero_RetornaBadRequest` | ID inscripción 0 retorna error |
| 3 | `Reagendar_IdClaseProgramadaCero_RetornaBadRequest` | ID clase programada 0 retorna error |
| 4 | `Reagendar_IdClienteVacio_RetornaBadRequest` | ID cliente vacío retorna error |
| 5 | `Reagendar_InscripcionNoExiste_RetornaNotFound` | Inscripción que no existe retorna error |
| 6 | `Reagendar_SinAutenticacion_RetornaUnauthorized` | Sin token retorna 401 |

### 3.3 Patrones a aplicar

- **xUnit:** Framework de testing
- **FluentAssertions:** Aserciones legibles
- **WebApplicationFactory:** Para crear cliente HTTP de prueba
- **Arrange/Act/Assert:** Estructura de cada test
- **Test data builder:** Crear datos de prueba válidos

## 4. Criterios de aceptación

- [ ] Test happy path: reagendar inscripción válida retorna éxito
- [ ] Test edge case: idInscripcion 0 retorna bad request
- [ ] Test edge case: idClaseProgramada 0 retorna bad request
- [ ] Test edge case: idCliente vacío retorna bad request
- [ ] Test edge case: inscripción no existe retorna not found
- [ ] Test edge case: sin autenticación retorna unauthorized
- [ ] Tests siguen patrón AAA
- [ ] Tests usan FluentAssertions
