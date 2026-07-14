# Spec: InscripcionesService.ReagendarInscripcionAsync - Pruebas de Integración

## 1. Resumen

Crear pruebas de integración para el método `ReagendarInscripcionAsync` de
`InscripcionesService`, validando happy path y edge cases.

## 2. Contexto

- **Método a probar:** `InscripcionesService.ReagendarInscripcionAsync`
- **Servicio unificado:** `InscripcionesService` (implementa `IInscripcionesService`)
- **Ubicación tests:** `GymWebApp.Tests/Integration/Features/Inscripciones/`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Servicio | `InscripcionesService` | Servicio unificado de inscripciones | 39 |

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
| 1 | Reagendar inscripción válida futura | Inscripción con fecha futura y clase programada destino existente | 200 + true |

### 3.2 Edge Cases

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 2 | ID inscripción inválido (0 o negativo) | Pasar idInscripcion <= 0 | 400 |
| 3 | ID clase programada inválido (0 o negativo) | Pasar idClaseProgramada <= 0 | 400 |
| 4 | ID cliente vacío | Pasar string vacío | 400 |
| 5 | Inscripción inexistente | ID válido pero inscripción no existe en BD | 404 |
| 6 | Inscripción con fecha pasada | Inscripción de clase que ya pasó | 400 |
| 7 | Inscripción de hoy con hora pasada | Inscripción de hoy con horaInicio < hora actual | 400 |
| 8 | Clase programada destino inexistente | ID válido pero clase destino no existe | 404 |

## 4. Patrones de testing

- **AAA Pattern:** Arrange, Act, Assert
- **IntegrationTestBase:** Heredar de la clase base que implementa `IClassFixture<CitasApiWebApplicationFactory<Program>>`
- **FluentAssertions:** Aserciones legibles
- **TestContainerHelper:** Para inicializar y resetear BD
- **CreateService():** Método helper que resuelve dependencias reales desde DI
- **InscripcionTestHelper:** Para seeding de inscripciones con datos controlados
- **DatabaseHelper:** Para modificar datos existentes en edge cases

## 5. Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Features/Inscripciones/ServiceReagendarInscripcionTests.cs` | Tests de integración (a crear) |

## 6. Criterios de aceptación

- [ ] 8 pruebas implementadas (happy path + edge cases)
- [ ] Cada prueba tiene comentarios explicativos
- [ ] Se usa AAA Pattern
- [ ] Se usan aserciones con FluentAssertions
- [ ] Se resetea la BD antes de cada prueba via `TestContainerHelper.ResetDatabaseAsync()`
