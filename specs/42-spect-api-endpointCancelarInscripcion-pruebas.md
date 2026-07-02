# Spec: API - Endpoint Cancelar Inscripción - Pruebas de Integración

## 1. Resumen

Crear pruebas de integración para el endpoint POST `api/inscripciones/cancelar`,
validando happy path y edge cases.

## 2. Contexto

- **Endpoint a probar:** POST `api/inscripciones/cancelar`
- **Ubicación tests:** `GymWebApp.Tests/Integration/Features/Inscripciones/`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Endpoint | `InscripcionesController` | Controlador a probar | 41 |
| Servicio | `ServiceCancelarInscripcion` | Servicio que ejecuta la cancelación | 37 |

### 2.2 Dependencias de testing

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `TestContainerHelper` | Helper | Inicializar y resetear BD |
| `WebApplicationFactory` | Factory | API en memoria |

## 3. Pruebas a implementar

### 3.1 Happy Path

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 1 | Cancelar inscripción válida | Inscripción con fecha futura | 200 + respuesta sin data |

### 3.2 Edge Cases

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 2 | Request body NULL | Enviar request vacío | 400 |
| 3 | ID inválido (0 o negativo) | Pasar ID <= 0 | 400 |
| 4 | Inscripción inexistente | ID válido pero inscripción no existe | 404 |
| 5 | Sin autenticación | Request sin token JWT | 401 |
| 6 | Rol cliente | Token con rol cliente (no empleado) | 403 |
| 7 | Usuario no existe | Token con ID de usuario inexistente | 404 |

## 4. Patrones de testing

- **AAA Pattern:** Arrange, Act, Assert
- **IClassFixture:** Compartir instancia del test entre pruebas
- **FluentAssertions:** Aserciones legibles
- **TestContainerHelper:** Para inicializar y resetear BD
- **WebApplicationFactory:** API en memoria para tests de integración

## 5. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Features/Inscripciones/InscripcionesControllerCancelarTests.cs` | Tests de integración |

## 6. Criterios de aceptación

- [ ] 7 pruebas implementadas (happy path + edge cases)
- [ ] Cada prueba tiene comentarios explicativos
- [ ] Se usa AAA Pattern
- [ ] Se usan aserciones con FluentAssertions
- [ ] Se prueba autenticación y autorización
- [ ] Se resetea la BD antes de cada prueba
