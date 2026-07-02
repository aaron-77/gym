# Spec: ServiceReagendarInscripcion - Pruebas de Integración

## 1. Resumen

Crear pruebas de integración para el servicio `ServiceReagendarInscripcion`,
validando happy path y edge cases.

## 2. Contexto

- **Servicio a probar:** `ServiceReagendarInscripcion`
- **Ubicación tests:** `GymWebApp.Tests/Integration/Features/Inscripciones/`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Servicio | `ServiceReagendarInscripcion` | Servicio a probar | 39 |

### 2.2 Dependencias de testing

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `TestContainerHelper` | Helper | Inicializar y resetear BD |

## 3. Pruebas a implementar

### 3.1 Happy Path

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 1 | Reagendar inscripción válida | Inscripción con fecha futura y clase programada existente | 200 + true |

### 3.2 Edge Cases

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 2 | ID inscripción inválido (0 o negativo) | Pasar ID <= 0 | 400 |
| 3 | ID clase programada inválido (0 o negativo) | Pasar ID <= 0 | 400 |
| 4 | ID cliente vacío | Pasar string vacío | 400 |
| 5 | Inscripción inexistente | ID válido pero inscripción no existe | 404 |
| 6 | Inscripción con fecha pasada | Inscripción de clase que ya pasó | 400 |
| 7 | Inscripción de hoy con hora pasada | Inscripción de hoy con horaInicio < hora actual | 400 |
| 8 | Clase programada inexistente | ID válido pero clase no existe | 404 |

## 4. Patrones de testing

- **AAA Pattern:** Arrange, Act, Assert
- **IClassFixture:** Compartir instancia del test entre pruebas
- **FluentAssertions:** Aserciones legibles
- **TestContainerHelper:** Para inicializar y resetear BD

## 5. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Features/Inscripciones/ServiceReagendarInscripcionTests.cs` | Tests de integración |

## 6. Criterios de aceptación

- [ ] 8 pruebas implementadas (happy path + edge cases)
- [ ] Cada prueba tiene comentarios explicativos
- [ ] Se usa AAA Pattern
- [ ] Se usan aserciones con FluentAssertions
- [ ] Se resetea la BD antes de cada prueba
