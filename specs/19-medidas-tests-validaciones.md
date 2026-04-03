# Spec 19: Tests de Validación para Medidas (Measurements)

## Overview

Este documento especifica los tests unitarios y de integración para los endpoints del controlador `MedidasController` en la API de FitnessGym. Los tests cubren validaciones de parámetros de entrada (GUIDs, valores enumerados) y verificaciones de integridad de datos (no duplicados).

## Tests Unitarios (21 tests)

### 2.1 Validaciones de GUID para getParametrosDeMedicion

| # | Test Name | Tipo |
|---|-----------|------|
| 1 | GetParametrosDeMedicion_WhenIdUsuarioIsNull_ReturnsBadRequest | Unit |
| 2 | GetParametrosDeMedicion_WhenIdUsuarioIsEmpty_ReturnsBadRequest | Unit |
| 3 | GetParametrosDeMedicion_WhenIdUsuarioIsInvalidGuid_ReturnsBadRequest | Unit |
| 4 | GetParametrosDeMedicion_WhenIdUsuarioIsValidGuid_ReturnsOk | Unit |

#### Test 1: GetParametrosDeMedicion_WhenIdUsuarioIsNull_ReturnsBadRequest

- **GIVEN**: idUsuario es null
- **WHEN**: Se llama a getParametrosDeMedicion
- **THEN**: Retorna BadRequest con error de validación de GUID
- **Tipo de test**: Unit

#### Test 2: GetParametrosDeMedicion_WhenIdUsuarioIsEmpty_ReturnsBadRequest

- **GIVEN**: idUsuario es string vacío
- **WHEN**: Se llama a getParametrosDeMedicion
- **THEN**: Retorna BadRequest con error de validación de GUID
- **Tipo de test**: Unit

#### Test 3: GetParametrosDeMedicion_WhenIdUsuarioIsInvalidGuid_ReturnsBadRequest

- **GIVEN**: idUsuario es un GUID inválido (formato no válido)
- **WHEN**: Se llama a getParametrosDeMedicion
- **THEN**: Retorna BadRequest con error de validación de GUID
- **Tipo de test**: Unit

#### Test 4: GetParametrosDeMedicion_WhenIdUsuarioIsValidGuid_ReturnsOk

- **GIVEN**: idUsuario es un GUID válido
- **WHEN**: Se llama a getParametrosDeMedicion
- **THEN**: Retorna Ok (la consulta se ejecuta)
- **Tipo de test**: Unit

---

### 2.2 Validaciones de GUID para getProgresoDelCliente

| # | Test Name | Tipo |
|---|-----------|------|
| 5 | GetProgresoDelCliente_WhenIdUsuarioIsNull_ReturnsBadRequest | Unit |
| 6 | GetProgresoDelCliente_WhenIdUsuarioIsEmpty_ReturnsBadRequest | Unit |
| 7 | GetProgresoDelCliente_WhenIdUsuarioIsInvalidGuid_ReturnsBadRequest | Unit |
| 8 | GetProgresoDelCliente_WhenIdUsuarioIsValidGuid_ReturnsOk | Unit |

#### Test 5: GetProgresoDelCliente_WhenIdUsuarioIsNull_ReturnsBadRequest

- **GIVEN**: idUsuario es null
- **WHEN**: Se llama a getProgresoDelCliente
- **THEN**: Retorna BadRequest con error de validación de GUID
- **Tipo de test**: Unit

#### Test 6: GetProgresoDelCliente_WhenIdUsuarioIsEmpty_ReturnsBadRequest

- **GIVEN**: idUsuario es string vacío
- **WHEN**: Se llama a getProgresoDelCliente
- **THEN**: Retorna BadRequest con error de validación de GUID
- **Tipo de test**: Unit

#### Test 7: GetProgresoDelCliente_WhenIdUsuarioIsInvalidGuid_ReturnsBadRequest

- **GIVEN**: idUsuario es un GUID inválido
- **WHEN**: Se llama a getProgresoDelCliente
- **THEN**: Retorna BadRequest con error de validación de GUID
- **Tipo de test**: Unit

#### Test 8: GetProgresoDelCliente_WhenIdUsuarioIsValidGuid_ReturnsOk

- **GIVEN**: idUsuario es un GUID válido
- **WHEN**: Se llama a getProgresoDelCliente
- **THEN**: Retorna Ok (la consulta se ejecuta)
- **Tipo de test**: Unit

---

### 2.3 Validaciones de GUID para getAñosActivo (obtenerAñosConActividadDelCliente)

| # | Test Name | Tipo |
|---|-----------|------|
| 9 | GetAñosActivo_WhenIdClienteIsNull_ReturnsBadRequest | Unit |
| 10 | GetAñosActivo_WhenIdClienteIsEmpty_ReturnsBadRequest | Unit |
| 11 | GetAñosActivo_WhenIdClienteIsInvalidGuid_ReturnsBadRequest | Unit |
| 12 | GetAñosActivo_WhenIdClienteIsValidGuid_ReturnsOk | Unit |

#### Test 9: GetAñosActivo_WhenIdClienteIsNull_ReturnsBadRequest

- **GIVEN**: idCliente es null
- **WHEN**: Se llama a getAñosActivo
- **THEN**: Retorna BadRequest con error de validación de GUID
- **Tipo de test**: Unit

#### Test 10: GetAñosActivo_WhenIdClienteIsEmpty_ReturnsBadRequest

- **GIVEN**: idCliente es string vacío
- **WHEN**: Se llama a getAñosActivo
- **THEN**: Retorna BadRequest con error de validación de GUID
- **Tipo de test**: Unit

#### Test 11: GetAñosActivo_WhenIdClienteIsInvalidGuid_ReturnsBadRequest

- **GIVEN**: idCliente es un GUID inválido
- **WHEN**: Se llama a getAñosActivo
- **THEN**: Retorna BadRequest con error de validación de GUID
- **Tipo de test**: Unit

#### Test 12: GetAñosActivo_WhenIdClienteIsValidGuid_ReturnsOk

- **GIVEN**: idCliente es un GUID válido
- **WHEN**: Se llama a getAñosActivo
- **THEN**: Retorna Ok (la consulta se ejecuta)
- **Tipo de test**: Unit

---

### 2.4 Validaciones para ObtenerEjerciciosYParametros

| # | Test Name | Tipo |
|---|-----------|------|
| 13 | ObtenerEjerciciosYParametros_WhenIdClienteIsNull_ReturnsBadRequest | Unit |
| 14 | ObtenerEjerciciosYParametros_WhenIdClienteIsEmpty_ReturnsBadRequest | Unit |
| 15 | ObtenerEjerciciosYParametros_WhenIdClienteIsValidGuid_ReturnsOk | Unit |

#### Test 13: ObtenerEjerciciosYParametros_WhenIdClienteIsNull_ReturnsBadRequest

- **GIVEN**: idCliente es null
- **WHEN**: Se llama a ObtenerDetallesDeProgreso
- **THEN**: Retorna BadRequest por validación de GUID
- **Tipo de test**: Unit

#### Test 14: ObtenerEjerciciosYParametros_WhenIdClienteIsEmpty_ReturnsBadRequest

- **GIVEN**: idCliente es string vacío
- **WHEN**: Se llama a ObtenerDetallesDeProgreso
- **THEN**: Retorna BadRequest por validación de GUID
- **Tipo de test**: Unit

#### Test 15: ObtenerEjerciciosYParametros_WhenIdClienteIsValidGuid_ReturnsOk

- **GIVEN**: idCliente es un GUID válido
- **WHEN**: Se llama a ObtenerDetallesDeProgreso
- **THEN**: Retorna Ok (la consulta se ejecuta)
- **Tipo de test**: Unit

---

### 2.5 Validaciones múltiples para ObtenerDetallesDeProgresoApi

| # | Test Name | Tipo |
|---|-----------|------|
| 16 | ObtenerDetallesDeProgresoApi_WhenIdClienteIsNull_ReturnsBadRequest | Unit |
| 17 | ObtenerDetallesDeProgresoApi_WhenIdClienteIsInvalidGuid_ReturnsBadRequest | Unit |
| 18 | ObtenerDetallesDeProgresoApi_WhenIdParametroIsNegative_ReturnsBadRequest | Unit |
| 19 | ObtenerDetallesDeProgresoApi_WhenEspaciadoTemporalIsInvalid_ReturnsBadRequest | Unit |
| 20 | ObtenerDetallesDeProgresoApi_WhenTipoDeBusquedaIsInvalid_ReturnsBadRequest | Unit |
| 21 | ObtenerDetallesDeProgresoApi_WhenAllValid_ReturnsOk | Unit |

#### Test 16: ObtenerDetallesDeProgresoApi_WhenIdClienteIsNull_ReturnsBadRequest

- **GIVEN**: idCliente es null
- **WHEN**: Se llama a ObtenerDetallesDeProgresoApi
- **THEN**: Retorna BadRequest con error de validación de GUID
- **Tipo de test**: Unit

#### Test 17: ObtenerDetallesDeProgresoApi_WhenIdClienteIsInvalidGuid_ReturnsBadRequest

- **GIVEN**: idCliente es un GUID inválido
- **WHEN**: Se llama a ObtenerDetallesDeProgresoApi
- **THEN**: Retorna BadRequest con error de validación de GUID
- **Tipo de test**: Unit

#### Test 18: ObtenerDetallesDeProgresoApi_WhenIdParametroIsNegative_ReturnsBadRequest

- **GIVEN**: idParametro es negativo
- **WHEN**: Se llama a ObtenerDetallesDeProgresoApi
- **THEN**: Retorna BadRequest con error de validación
- **Tipo de test**: Unit

#### Test 19: ObtenerDetallesDeProgresoApi_WhenEspaciadoTemporalIsInvalid_ReturnsBadRequest

- **GIVEN**: espaciadoTemporal tiene valor inválido
- **WHEN**: Se llama a ObtenerDetallesDeProgresoApi
- **THEN**: Retorna BadRequest con error de validación
- **Valores válidos**: "individual", "promedio"
- **Tipo de test**: Unit

#### Test 20: ObtenerDetallesDeProgresoApi_WhenTipoDeBusquedaIsInvalid_ReturnsBadRequest

- **GIVEN**: tipoDeBusqueda tiene valor inválido
- **WHEN**: Se llama a ObtenerDetallesDeProgresoApi
- **THEN**: Retorna BadRequest con error de validación
- **Valores válidos**: "MES", "AÑO"
- **Tipo de test**: Unit

#### Test 21: ObtenerDetallesDeProgresoApi_WhenAllValid_ReturnsOk

- **GIVEN**: Todos los parámetros son válidos
- **WHEN**: Se llama a ObtenerDetallesDeProgresoApi
- **THEN**: Retorna Ok
- **Tipo de test**: Unit

---

## Tests de Integración - Verificación de Duplicados (4 tests)

### 3.1 GetParametrosDeMedicion_ReturnsNoDuplicateParameterIds

- **GIVEN**: Un empleado autenticado
- **WHEN**: Se llama a getParametrosDeMedicion
- **THEN**: Los IDs de parámetros no deben estar duplicados y los nombres deben ser únicos
- **Validaciones**:
  - parametroMedicionId no debe repetirse
  - nombre no debe repetirse
- **Tipo de test**: Integration

### 3.2 GetProgresoDeUsuario_ReturnsNoDuplicateParametroIds

- **GIVEN**: Un cliente autenticado
- **WHEN**: Se llama a progresoDeUsuario
- **THEN**: Los items de progreso no deben tener parametroId ni nombreParametro duplicados
- **Validaciones**:
  - medida.fkParametro no debe repetirse
  - medida.nombreParametro no debe repetirse
- **Tipo de test**: Integration

### 3.3 ObtenerAñosConActividadDelCliente_ReturnsNoDuplicateYears

- **GIVEN**: Un empleado autenticado
- **WHEN**: Se llama a obtenerAñosConActividadDelCliente
- **THEN**: Los años no deben estar duplicados
- **Validaciones**:
  - Los valores de año no deben repetirse
- **Tipo de test**: Integration

### 3.4 ObtenerEjerciciosYParametros_ReturnsNoDuplicateItems

- **GIVEN**: Un empleado autenticado
- **WHEN**: Se llama a obtenerEjerciciosYParametros
- **THEN**: No debe haber ejercicioId, parametroId, nombreEjercicio ni nombreParametro duplicados
- **Validaciones**:
  - EjercicioId no debe repetirse
  - parametroMedicionId no debe repetirse
  - NombreEjercicio no debe repetirse
  - nombreParametro no debe repetirse
- **Tipo de test**: Integration

---

## Estructura de Archivos

```
GymWebApp.Tests/
├── Unit/
│   └── Medidas/
│       ├── GetParametrosDeMedicionValidationTests.cs
│       ├── ProgresoDeUsuarioValidationTests.cs
│       ├── ObtenerAñosConActividadValidationTests.cs
│       ├── ObtenerEjerciciosYParametrosValidationTests.cs
│       └── ObtenerDetallesDeProgresoValidationTests.cs
├── Integration/
│   └── Features/
│       └── Medidas/
│           └── MedidasDuplicatesValidationTests.cs
```

---

## Validaciones del Controlador

El controlador MedidasController debe validar los siguientes parámetros de entrada:

### Validaciones de GUID
| Parámetro | Condición | Acción |
|-----------|-----------|--------|
| idUsuario / idCliente | null | Retorna 400 BadRequest |
| idUsuario / idCliente | string.Empty | Retorna 400 BadRequest |
| idUsuario / idCliente | Formato GUID inválido | Retorna 400 BadRequest |

### Validaciones Numéricas
| Parámetro | Condición | Acción |
|-----------|-----------|--------|
| idParametro | Negativo (< 0) | Retorna 400 BadRequest |

### Validaciones de Enumerados
| Parámetro | Valores válidos | Acción |
|-----------|-----------------|--------|
| espaciadoTemporal | "individual", "promedio" | Retorna 400 BadRequest si es inválido |
| tipoDeBusqueda | "MES", "AÑO" | Retorna 400 BadRequest si es inválido |

---

## Resumen de Cobertura

| Categoría | Cantidad de Tests |
|-----------|-------------------|
| Tests Unitarios - Validaciones GUID | 15 |
| Tests Unitarios - Validaciones Enumerados | 5 |
| Tests Unitarios - Happy Path | 1 |
| Tests de Integración - Duplicados | 4 |
| **Total** | **25** |

---

## Dependencias Requeridas

- **xUnit**: Framework de testing
- **FluentAssertions**: Aserciones fluidas
- **NSubstitute**: Mocks para tests unitarios
- **TestContainers**: SQL Server en contenedor para tests de integración
- **Respawn**: Limpieza de BD entre tests
- **DatabaseHelper**: Consultas directas a BD para validaciones
- **CitasApiWebApplicationFactory**: Factory para testing con autenticación

---

## Notas de Implementación

### Tests Unitarios
1. Usar NSubstitute para crear mocks de FitnessCenterDbContext, UserManager y ILogger
2. Inicializar MedidasController con los mocks en el constructor
3. Verificar que el resultado sea BadRequestObjectResult con DTOResponse apropiado
4. Verificar success=false, httpCode=400 y errors con la propiedad correcta

### Tests de Integración
1. Usar `[Collection("MedidasApiIntegrationTests")]` para agrupar tests
2. Heredar de `IClassFixture<CitasApiWebApplicationFactory<Program>>`
3. Inicializar `TestContainerHelper` y resetear BD en constructor
4. Usar `AuthenticateAsync()` para obtener token de empleado
5. Usar `AuthenticateAsClienteAsync()` para obtener token de cliente
6. Verificar unicidad con `Should().OnlyHaveUniqueItems()`
