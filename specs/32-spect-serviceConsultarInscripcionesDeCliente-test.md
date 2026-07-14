# Spec: InscripcionesService.ConsultarInscripcionesDeClienteAsync - Pruebas de Integración

## 1. Resumen

Crear pruebas de integración para el método `ConsultarInscripcionesDeClienteAsync` de
`InscripcionesService`, validando happy path y edge cases.

## 2. Contexto

- **Método a probar:** `InscripcionesService.ConsultarInscripcionesDeClienteAsync`
- **Servicio unificado:** `InscripcionesService` (implementa `IInscripcionesService`)
- **Ubicación tests:** `GymWebApp.Tests/Integration/Features/Inscripciones/`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Servicio | `InscripcionesService` | Servicio unificado de inscripciones | 31 |
| DTO | `DTOInscripcionDelCliente` | Modelo de datos para recibir resultados | 30 |

### 2.2 Dependencias de testing

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `TestContainerHelper` | Helper | Inicializar y resetear BD |
| `IntegrationTestBase` | Base | Clase base con WebApplicationFactory |

## 3. Pruebas a implementar

| # | Prueba | Tipo | Descripción | Resultado |
|---|--------|------|-------------|-----------|
| 1 | Cliente con inscripciones futuras | Happy Path | Consultar cliente con clases programadas futuras | 200 + lista con inscripciones |
| 2 | Cliente sin inscripciones | Edge Case | Consultar cliente sin inscripciones vigentes | 200 + lista vacía |
| 3 | GUID inválido (ej: "abc123") | Edge Case | Pasar string que no tiene formato GUID | 400 |
| 4 | GUID vacío | Edge Case | Pasar string vacío como ID | 400 |
| 5 | GUID inexistente | Edge Case | GUID con formato válido pero usuario no existe en BD | 404 |
| 6 | Parámetro NULL | Edge Case | Pasar NULL como parámetro | 400 |
| 7 | Cliente con solo inscripciones canceladas | Edge Case | Cliente que tuvo inscripciones pero todas canceladas | 200 + lista vacía |

## 4. Patrones de testing

- **AAA Pattern:** Arrange, Act, Assert
- **IClassFixture:** `IntegrationTestBase` ya implementa `IClassFixture<CitasApiWebApplicationFactory<Program>>`
- **FluentAssertions:** Aserciones legibles con `.Should().Be()`, `.Should().HaveCount()`, `.Should().BeNullOrEmpty()`
- **TestContainerHelper:** Para inicializar y resetear la BD antes de cada prueba
- **CreateService():** Método helper que resuelve dependencias reales desde DI

## 5. Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Features/Inscripciones/ServiceConsultarInscripcionesDeClienteIntegrationTests.cs` | Tests de integración (ya creado) |

## 6. Criterios de aceptación

- [x] 7 pruebas implementadas (happy path + edge cases)
- [x] Cada prueba tiene comentarios explicativos
- [x] Se usa AAA Pattern
- [x] Se usan aserciones con FluentAssertions
- [x] Se valida la estructura de respuesta DTOResponse
- [x] Se usa `IntegrationTestBase` con `IClassFixture` para compartir instancia
- [x] Se resetea la BD antes de cada prueba via `TestContainerHelper.ResetDatabaseAsync()`
