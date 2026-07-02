# Spec: Frontend - Endpoint Cancelar/Reagendar - Pruebas de Integración

## 1. Resumen

Crear pruebas de integración para el endpoint GET `/inscripciones/cancelarReagendar`,
validando happy path y edge cases.

## 2. Contexto

- **Endpoint a probar:** GET `/inscripciones/cancelarReagendar`
- **Ubicación tests:** `GymWebApp.Tests/Integration/Features/Inscripciones/`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Endpoint | `InscripcionesController` | Controlador frontend a probar | 35 |

### 2.2 Dependencias de testing

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `WebApplicationFactory` | Factory | Frontend en memoria |

## 3. Pruebas a implementar

### 3.1 Happy Path

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 1 | Empleado accede a la vista | Empleado autenticado accede a cancelar/reagendar | 200 + vista con clientes |

### 3.2 Edge Cases

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 2 | Sin autenticación | Request sin token JWT | Redirect a login |
| 3 | Rol cliente | Token con rol cliente (no empleado) | 403 o redirect |
| 4 | Error de API | API no responde o retorna error | Vista con mensaje de error |

## 4. Patrones de testing

- **AAA Pattern:** Arrange, Act, Assert
- **IClassFixture:** Compartir instancia del test entre pruebas
- **FluentAssertions:** Aserciones legibles
- **WebApplicationFactory:** Frontend en memoria para tests

## 5. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Features/Inscripciones/InscripcionesFrontendControllerTests.cs` | Tests de integración |

## 6. Criterios de aceptación

- [ ] 4 pruebas implementadas (happy path + edge cases)
- [ ] Cada prueba tiene comentarios explicativos
- [ ] Se usa AAA Pattern
- [ ] Se usan aserciones con FluentAssertions
- [ ] Se prueba autenticación y autorización
- [ ] Se prueba manejo de errores de API
