# Spec: CancelarInscripcionAsync (InscripcionesService)

## 1. Resumen

Método unificado para cancelar inscripciones que valida que la inscripción exista,
que sea de una fecha futura o del día actual con hora posterior, y ejecuta el
procedimiento almacenado de cancelación. Implementado como parte de `InscripcionesService`.

## 2. Contexto

- **Capa:** API Services
- **Servicio unificado:** `InscripcionesService` — implementa `IInscripcionesService`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Procedimiento | `dbo.sp_procesoCompletoCancelacionDeInscripcionAClase` | Procedimiento de cancelación | - |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `FitnessCenterDbContext` | DataAccess | Contexto de EF Core para acceder a la BD |
| `IValidadorFechaCancelacionInscripcion` | BL | Validar fecha y hora de cancelación |
| `IDataAccessExecutor` | DataAccess | Ejecutar procedimientos almacenados |
| `ILogger<InscripcionesService>` | Logging | Logear errores y eventos |

## 3. Método en el servicio unificado

### 3.1 Contrato

```csharp
Task<DTOResponse<bool>> CancelarInscripcionAsync(int idInscripcion);
```

### 3.2 Archivos

| Archivo | Descripción |
|---------|-------------|
| `API/Services/IInscripcionesService.cs` | Interfaz unificada (contiene este método) |
| `API/Services/InscripcionesService.cs` | Implementación unificada |

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | ID es mayor a 0 | Guard clause | 400 |
| 2 | Inscripción existe en BD (con Include de clase programada + horarios) | `FirstOrDefaultAsync` | 404 |
| 3 | Fecha de la clase >= fecha actual | `IValidadorFechaCancelacionInscripcion.Validar` | 400 |
| 4 | Si es fecha actual, hora > hora actual | `IValidadorFechaCancelacionInscripcion.Validar` | 400 |
| 5 | Ejecutar procedimiento almacenado | `IDataAccessExecutor.ExecuteAsync` | 500 |

### 3.4 Acciones que debe realizar

1. Validar que `idInscripcion` sea mayor a 0 (guard clause)
2. Buscar la inscripción en la BD incluyendo `FkProgramacionClaseNavigation`, sus `HorariosDeClasesProgramadas` y el `FkHorarioLaboralNavigation`
3. Si la inscripción no existe, retornar error 404
4. Obtener `fechaDeLaClase` y `horaInicio` de la clase programada
5. Validar fecha y hora usando `IValidadorFechaCancelacionInscripcion.Validar(fechaClase, horaInicio)`
6. Si la validación falla, retornar error 400 con el mensaje del validador
7. Ejecutar `dbo.sp_procesoCompletoCancelacionDeInscripcionAClase` via `IDataAccessExecutor.ExecuteAsync`
8. Retornar `true` en el payload

### 3.5 Inyección de dependencias

Registrado en `Program.cs`:
```csharp
builder.Services.AddScoped<IInscripcionesService, InscripcionesService>();
```

Además requiere:

```csharp
builder.Services.AddScoped<IValidadorFechaCancelacionInscripcion, ValidadorFechaCancelacionInscripcion>();
builder.Services.AddScoped<IValidadorUsuarioExistente, ValidadorUsuarioExistente>();
builder.Services.AddScoped<IDataAccessExecutor, DataAccessExecutor>();
```

## 4. Criterios de aceptación

- [x] Método `CancelarInscripcionAsync` en `IInscripcionesService` e `InscripcionesService`
- [x] Validación de ID > 0 con guard clause
- [x] Validación de existencia de inscripción con EF Include chain
- [x] Validación de fecha >= fecha actual con `IValidadorFechaCancelacionInscripcion`
- [x] Validación de hora > hora actual si es fecha de hoy
- [x] Ejecución de procedimiento almacenado con `IDataAccessExecutor.ExecuteAsync`
- [x] DI registrada como `IInscripcionesService → InscripcionesService`
- [x] Manejo de errores con `ResponseManager`
- [x] Logging de errores con `ILogger`
