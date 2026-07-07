# Spec: Frontend - Endpoint Cancelar/Reagendar - Pruebas (Integración + E2E)

## 1. Resumen

Crear pruebas para el endpoint GET `/inscripciones/cancelarReagendar`,
combinando tests E2E (flujo real con browser) y tests de integración
(WebApplicationFactory con simulación de errores de API).

## 2. Contexto

- **Endpoint a probar:** GET `/inscripciones/cancelarReagendar`
- **Ubicación tests E2E:** `GymWebApp.Tests/E2E/Features/`
- **Ubicación tests Integración:** `GymWebApp.Tests/Integration/Features/Inscripciones/`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Endpoint | `InscripcionesController` | Controlador frontend a probar | 35 |

### 2.2 Dependencias de testing

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `WebApplicationFactory` | Factory | Frontend en memoria (tests de integración) |
| `Playwright` | E2E | Browser automatizado (tests E2E) |

## 3. Pruebas a implementar

### 3.1 Happy Path

| # | Prueba | Descripción | Resultado | Tipo |
|---|--------|-------------|-----------|------|
| 1 | Empleado accede a la vista | Empleado autenticado accede a cancelar/reagendar | 200 + vista con clientes | E2E |

### 3.2 Edge Cases

| # | Prueba | Descripción | Resultado | Tipo |
|---|--------|-------------|-----------|------|
| 2 | Sin autenticación | Request sin token JWT | Redirect a login | E2E |
| 3 | Rol cliente | Token con rol cliente (no empleado) | 403 o redirect | E2E |
| 4 | Error de API | API no responde o retorna error | Vista con mensaje de error | Integración |

## 4. Patrones de testing

### E2E
- **PlaywrightTestBase:** Clase base con browser lifecycle
- **E2eContainerHelper:** Contenedores Docker (SQL Server + API + Frontend + Nginx)
- **E2ETestSettings:** Credenciales de prueba desde `appsettings.Testing.json`
- **Collection("E2E HappyPaths"):** Colección compartida

### Integración
- **AAA Pattern:** Arrange, Act, Assert
- **WebApplicationFactory:** Frontend en memoria
- **DelegatingHandler:** Interceptar llamadas HTTP al API para simular errores
- **FluentAssertions:** Aserciones legibles

## 5. Archivos a crear

| Archivo | Tipo | Descripción |
|---------|------|-------------|
| `GymWebApp.Tests/E2E/Features/CancelarReagendarE2ETests.cs` | E2E | Tests E2E con Playwright (tests 1, 2, 3) |
| `GymWebApp.Tests/Integration/Features/Inscripciones/CancelarReagendarApiErrorTests.cs` | Integración | Test de error de API con WebApplicationFactory (test 4) |

## 6. Criterios de aceptación

- [ ] 4 pruebas implementadas (3 E2E + 1 Integración)
- [ ] Cada prueba tiene comentarios explicativos
- [ ] Los tests E2E siguen el patrón establecido (PlaywrightTestBase, E2eContainerHelper)
- [ ] El test de integración usa WebApplicationFactory con DelegatingHandler para simular error de API
- [ ] Se prueba autenticación, autorización y manejo de errores de API
- [ ] Se usan aserciones con FluentAssertions en el test de integración
