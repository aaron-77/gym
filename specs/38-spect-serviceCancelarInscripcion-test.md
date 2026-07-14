# Spec: InscripcionesService.CancelarInscripcionAsync - Pruebas de Integración

## 1. Resumen

Crear pruebas de integración para el método `CancelarInscripcionAsync` de
`InscripcionesService`, validando happy path y edge cases.

## 2. Contexto

- **Método a probar:** `InscripcionesService.CancelarInscripcionAsync`
- **Servicio unificado:** `InscripcionesService` (implementa `IInscripcionesService`)
- **Ubicación tests:** `GymWebApp.Tests/Integration/Features/Inscripciones/`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Servicio | `InscripcionesService` | Servicio unificado de inscripciones | 37 |

### 2.2 Dependencias de testing

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `TestContainerHelper` | Helper | Inicializar y resetear BD |
| `IntegrationTestBase` | Base | Clase base con WebApplicationFactory |
| `InscripcionTestHelper` | Helper | Seeding de datos de inscripciones |
| `DatabaseHelper` | Helper | Consultas y comandos SQL directos |

## 3. Pruebas a implementar

### 3.1 Happy Path

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 1 | Cancelar inscripción válida futura | Inscripción con fecha futura (generada vía SP) | 200 + true |

### 3.2 Edge Cases

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 2 | ID inválido (0) | Pasar idInscripcion = 0 | 400 |
| 3 | ID inválido (negativo) | Pasar idInscripcion = -1 | 400 |
| 4 | Inscripción inexistente | ID válido (>0) pero inscripción no existe en BD | 404 |
| 5 | Inscripción con fecha pasada | Inscripción de clase con fecha anterior a hoy | 400 |
| 6 | Inscripción de hoy con hora pasada | Inscripción de hoy con horaInicio < hora actual | 400 |

> **Nota:** El test "Parámetro NULL → 400" del spec original no aplica porque `CancelarInscripcionAsync(int idInscripcion)` recibe un `int` (value type no nullable). Se reemplaza por el test 3 (idInscripcion negativo) que cubre el resto del guard clause `idInscripcion <= 0`.

## 4. Patrones de testing

- **AAA Pattern:** Arrange, Act, Assert
- **IntegrationTestBase:** Heredar de la clase base que implementa `IClassFixture<CitasApiWebApplicationFactory<Program>>`
- **FluentAssertions:** Aserciones legibles
- **TestContainerHelper:** Para inicializar y resetear BD
- **CreateService():** Método helper que resuelve dependencias reales desde DI
- **InscripcionTestHelper:** Para seeding de inscripciones con datos controlados
- **DatabaseHelper:** Para modificar datos existentes (fechas, estados) en edge cases

## 5. Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Features/Inscripciones/ServiceCancelarInscripcionTests.cs` | Tests de integración (a crear) |

## 6. Criterios de aceptación

- [ ] 6 pruebas implementadas (happy path + edge cases)
- [ ] Cada prueba tiene comentarios explicativos
- [ ] Se usa AAA Pattern
- [ ] Se usan aserciones con FluentAssertions
- [ ] Se resetea la BD antes de cada prueba via `TestContainerHelper.ResetDatabaseAsync()`
- [ ] Se usa `InscripcionTestHelper.SeedFreshInscripcionAsync()` para happy path
- [ ] Se usa `DatabaseHelper.ExecuteNonQueryAsync` para manipular datos en edge cases
