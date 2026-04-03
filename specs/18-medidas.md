# Spec 18: Tests de Integración para Medidas (Measurements)

## Overview

Este documento especifica los tests de integración para los endpoints del controlador `MedidasController` en la API de FitnessGym.

## Endpoints bajo prueba

| # | Endpoint | Método | Roles autorizados |
|---|----------|--------|-------------------|
| 1 | `/api/RegistrarMedida` | POST | empleado |
| 2 | `/api/getParametrosDeMedicion` | GET | empleado, cliente |
| 3 | `/api/progresoDeUsuario` | GET | cliente |
| 4 | `/api/obtenerAñosConActividadDelCliente` | GET | empleado, cliente |
| 5 | `/api/obtenerEjerciciosYParametros` | GET | empleado, cliente |
| 6 | `/api/obtenerDetallesDeProgreso` | GET | empleado, cliente |

## Datos de Seed (Base de datos)

La base de datos de testing contiene los siguientes datos inicializados:

- **parametrosDeMedicion**: peso (id=1), imc (id=2), altura (id=3), fuerza (id=4)
- **unidadesDeMedida**: kg (id=1), kg/m² (id=2), m (id=3)
- **medidas**: Tabla en `TablesToIgnore` - no se limpia entre tests

## Casos de Prueba

### Happy Paths (7 tests)

#### 1. RegistrarMedida_WithValidData_Returns200AndInsertsToDb

- **GIVEN**: Un cliente autenticado como empleado con datos válidos de medida
- **WHEN**: Se envía una solicitud POST a `/api/RegistrarMedida` con un DTOMedida válido
- **THEN**: Retorna 200 OK con mensaje de éxito Y la medida se inserta en la base de datos

```json
Request:
{
  "fkUsuario": "<cliente-id>",
  "fkParametro": 1,
  "unidadDeMedidaId": 1,
  "valor": 75.5
}
```

**Assert**: Verificar en BD que el registro existe con los valores enviados.

#### 2. GetParametrosDeMedicion_WithValidUser_Returns200WithData

- **GIVEN**: Un cliente autenticado (empleado o cliente)
- **WHEN**: Se envía una solicitud GET a `/api/getParametrosDeMedicion?idUsuario=<id>`
- **THEN**: Retorna 200 OK con una lista de parámetros de medición

#### 3. GetProgresoDeUsuario_WithValidClient_Returns200

- **GIVEN**: Un cliente autenticado con rol "cliente"
- **WHEN**: Se envía una solicitud GET a `/api/progresoDeUsuario?idUsuario=<id>`
- **THEN**: Retorna 200 OK con datos de progreso (últimas medidas y metas)

#### 4. GetAñosConActividad_WithValidClient_Returns200

- **GIVEN**: Un cliente autenticado (empleado o cliente)
- **WHEN**: Se envía una solicitud GET a `/api/obtenerAñosConActividadDelCliente?idCliente=<id>`
- **THEN**: Retorna 200 OK con lista de años con actividad

#### 5. GetEjerciciosYParametros_WithValidClient_Returns200

- **GIVEN**: Un cliente autenticado (empleado o cliente)
- **WHEN**: Se envía una solicitud GET a `/api/obtenerEjerciciosYParametros?idCliente=<id>`
- **THEN**: Retorna 200 OK con lista de ejercicios y parámetros del cliente

#### 6. GetDetallesDeProgreso_WithValidParams_Returns200

- **GIVEN**: Un cliente autenticado (empleado o cliente) con parámetros válidos
- **WHEN**: Se envía una solicitud GET a `/api/obtenerDetallesDeProgreso?idCliente=<id>&idParametro=1`
- **THEN**: Retorna 200 OK con medidas y metas del cliente

### Sad Paths - Sin Autenticación (6 tests)

#### 7. RegistrarMedida_WithoutAuth_Returns401

- **GIVEN**: Sin token de autenticación
- **WHEN**: Se envía POST a `/api/RegistrarMedida`
- **THEN**: Retorna 401 Unauthorized

#### 8. GetParametrosDeMedicion_WithoutAuth_Returns401

- **GIVEN**: Sin token de autenticación
- **WHEN**: Se envía GET a `/api/getParametrosDeMedicion`
- **THEN**: Retorna 401 Unauthorized

#### 9. GetProgresoDeUsuario_WithoutAuth_Returns401

- **GIVEN**: Sin token de autenticación
- **WHEN**: Se envía GET a `/api/progresoDeUsuario`
- **THEN**: Retorna 401 Unauthorized

#### 10. GetAñosConActividad_WithoutAuth_Returns401

- **GIVEN**: Sin token de autenticación
- **WHEN**: Se envía GET a `/api/obtenerAñosConActividadDelCliente`
- **THEN**: Retorna 401 Unauthorized

#### 11. GetEjerciciosYParametros_WithoutAuth_Returns401

- **GIVEN**: Sin token de autenticación
- **WHEN**: Se envía GET a `/api/obtenerEjerciciosYParametros`
- **THEN**: Retorna 401 Unauthorized

#### 12. GetDetallesDeProgreso_WithoutAuth_Returns401

- **GIVEN**: Sin token de autenticación
- **WHEN**: Se envía GET a `/api/obtenerDetallesDeProgreso`
- **THEN**: Retorna 401 Unauthorized

### Sad Paths - Forbidden (1 test)

#### 13. RegistrarMedida_AsCliente_Returns403

- **GIVEN**: Cliente autenticado con rol "cliente" (no autorizado para este endpoint)
- **WHEN**: Se envía POST a `/api/RegistrarMedida`
- **THEN**: Retorna 403 Forbidden

## Estructura de Archivos

```
GymWebApp.Tests/
├── Integration/
│   ├── Features/
│   │   └── Medidas/
│   │       └── MedidasApiTests.cs
│   └── Factories/
│       └── MedidaFactory.cs
```

## Dependencias Requeridas

- **TestContainerHelper**: Inicialización de SQL Server en contenedor
- **DatabaseHelper**: Consultas directas a BD para validaciones
- **CitasApiWebApplicationFactory**: Factory para testing con autenticación
- **DTOMedida**: DTO del endpoint RegistrarMedida
- **FluentAssertions**: Aserciones fluidas
- **xUnit**: Framework de testing

## Notas de Implementación

1. Usar `[Collection("MedidasApiIntegrationTests")]` para agrupar tests
2. Heredar de `IClassFixture<CitasApiWebApplicationFactory<Program>>`
3. Inicializar `TestContainerHelper` y resetear BD en constructor
4. Usar `SetAuthHeaderAsync()` / `ClearAuthHeader()` para control de auth
5. Verificar inserts a BD con `DatabaseHelper.ExecuteQuerySingleAsync()`
6. Usar IDs del seed data: fkParametro=1, unidadDeMedidaId=1