# Spec: ServiceConsultarInscripcionesDeCliente - Pruebas de Integración

## 1. Resumen

Crear pruebas de integración para el servicio `ServiceConsultarInscripcionesDeCliente`,
validando happy path y edge cases.

## 2. Contexto

- **Servicio a probar:** `ServiceConsultarInscripcionesDeCliente`
- **Ubicación tests:** `GymWebApp.Tests/Integration/Features/Inscripciones/`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Servicio | `ServiceConsultarInscripcionesDeCliente` | Servicio a probar | 31 |
| DTO | `DTOInscripcionDelCliente` | Modelo de datos para recibir resultados | 30 |

### 2.2 Dependencias de testing

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `TestContainerHelper` | Helper | Inicializar y resetear BD |
| `ResponseManager` | Utils | Validar estructura de respuesta |

## 3. Pruebas a implementar

| # | Prueba | Tipo | Descripción | Resultado |
|---|--------|------|-------------|-----------|
| 1 | Cliente con inscripciones futuras | Happy Path | Consultar cliente con clases programadas futuras | 200 + lista con inscripciones |
| 2 | Cliente sin inscripciones | Edge Case | Consultar cliente sin inscripciones vigentes | 200 + lista vacía |
| 3 | GUID inválido (ej: "abc123") | Edge Case | Pasar string que no tiene formato GUID | 400 |
| 4 | GUID vacío | Edge Case | Pasar string vacío como ID | 400 |
| 5 | GUID inexistente | Edge Case | GUID con formato válido pero usuario no existe en BD | 404 |
| 6 | Parámetro NULL | Edge Case | Pasar NULL como parámetro | 400 |

## 4. Patrones de testing

- **AAA Pattern:** Arrange, Act, Assert
- **IClassFixture:** Compartir instancia del test entre pruebas
- **FluentAssertions:** Aserciones legibles con `.Should().Be()`, `.Should().HaveCount()`, `.Should().BeNullOrEmpty()`
- **TestContainerHelper:** Para inicializar y resetear la BD antes de cada prueba
- **ResponseManager:** Validar estructura de respuesta con `DTOResponse<T>`

## 5. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Features/Inscripciones/ServiceConsultarInscripcionesDeClienteTests.cs` | Tests de integración |

## 6. Criterios de aceptación

- [ ] 6 pruebas implementadas (happy path + edge cases)
- [ ] Cada prueba tiene comentarios explicativos
- [ ] Se usa AAA Pattern
- [ ] Se usan aserciones con FluentAssertions
- [ ] Se valida la estructura de respuesta DTOResponse
- [ ] Se usa IClassFixture para compartir instancia
- [ ] Se resetea la BD antes de cada prueba
