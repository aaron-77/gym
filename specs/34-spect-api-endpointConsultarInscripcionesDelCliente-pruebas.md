# Spec: API - Endpoint Consultar Inscripciones del Cliente - Pruebas de Integración

## 1. Resumen

Crear pruebas de integración para el endpoint GET `api/inscripciones/obtenerInscripcionesDelCliente/{idUsuario}`,
validando happy path y edge cases.

## 2. Contexto

- **Endpoint a probar:** GET `api/inscripciones/obtenerInscripcionesDelCliente/{idUsuario}`
- **Ubicación tests:** `GymWebApp.Tests/Integration/Features/Inscripciones/`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Endpoint | `InscripcionesController` | Controlador a probar | 33-spect-api-endpointConsultarInscripcionesDelCliente |
| Servicio | `ServiceConsultarInscripcionesDeCliente` | Servicio que ejecuta la consulta | 31 |
| DTO | `DTOInscripcionDelCliente` | Modelo de datos de respuesta | 30 |

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
| 1 | Cliente con inscripciones futuras | Empleado consulta cliente con clases programadas | 200 + lista |

### 3.2 Edge Cases

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 2 | Cliente sin inscripciones | Empleado consulta cliente sin inscripciones | 200 + lista vacía |
| 3 | GUID inválido (ej: "abc123") | Pasar string que no tiene formato GUID | 400 |
| 4 | GUID vacío | Pasar string vacío como ID | 400 |
| 5 | GUID inexistente | GUID válido pero cliente no existe | 404 |
| 6 | Sin autenticación | Request sin token JWT | 401 |
| 7 | Rol cliente | Token con rol cliente (no empleado) | 403 |

## 4. Patrones de testing

- **AAA Pattern:** Arrange, Act, Assert
- **IClassFixture:** Compartir instancia del test entre pruebas
- **FluentAssertions:** Aserciones legibles
- **TestContainerHelper:** Para inicializar y resetear BD
- **WebApplicationFactory:** API en memoria para tests de integración

## 5. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Features/Inscripciones/InscripcionesControllerTests.cs` | Tests de integración |

## 6. Criterios de aceptación

- [ ] 7 pruebas implementadas (happy path + edge cases)
- [ ] Cada prueba tiene comentarios explicativos
- [ ] Se usa AAA Pattern
- [ ] Se usan aserciones con FluentAssertions
- [ ] Se prueba autenticación y autorización
- [ ] Se resetea la BD antes de cada prueba
