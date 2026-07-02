# Spec: ServiceCancelarInscripcion

## 1. Resumen

Crear un servicio para cancelar inscripciones que valide que la inscripción exista,
que sea de una fecha futura o del día actual con hora posterior, y ejecute el
procedimiento almacenado de cancelación.

## 2. Contexto

- **Capa:** API Services

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Procedimiento | `dbo.sp_procesoCompletoCancelacionDeInscripcionAClase` | Procedimiento de cancelación | - |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `FitnessCenterDbContext` | DataAccess | Contexto de EF Core para acceder a la BD |
| `ILogger` | Logging | Logear errores y eventos |

## 3. Servicio a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `API/Services/IServiceCancelarInscripcion.cs` | Interfaz |
| `API/Services/ServiceCancelarInscripcion.cs` | Implementación |

### 3.2 Contrato

El servicio debe exponer un método asíncrono que reciba `int idInscripcion` y devuelva `Task<DTOResponse<bool>>`.

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | ID es mayor a 0 | Guard clause | 400 |
| 2 | Inscripción existe en BD | `FindAsync` | 404 |
| 3 | Fecha de la clase >= fecha actual | Comparación de fechas | 400 |
| 4 | Si es fecha actual, hora > hora actual | Comparación de horas | 400 |
| 5 | Ejecutar procedimiento almacenado | `ExecuteSqlInterpolatedAsync` | 500 |

### 3.4 Acciones que debe realizar

1. Validar que `idInscripcion` sea mayor a 0
2. Buscar la inscripción en la BD usando `FindAsync`
3. Si la inscripción no existe, retornar error 404
4. Obtener la fecha y hora de la clase programada
5. Validar que la fecha de la clase sea mayor o igual a la fecha actual
6. Si es la misma fecha, validar que la hora de inicio sea mayor a la hora actual
7. Si la validación de fecha/hora falla, retornar error 400
8. Ejecutar el procedimiento almacenado `sp_procesoCompletoCancelacionDeInscripcionAClase`
9. Si el procedimiento retorna `true`, retornar respuesta de éxito
10. Si el procedimiento retorna `false` o falla, retornar error

### 3.5 Patrones a aplicar

- **Guard clauses:** Validaciones tempranas al inicio del método
- **ResponseManager:** Usar `ResponseManager.BuildResponse<T>()` para construir respuestas
- **ErrorModel:** Crear lista de `ErrorModel` con propiedad y mensaje descriptivo
- **Logging:** Usar `ILogger` con `LogError` en catch, incluir `idInscripcion` en el log
- **Async/Await:** Todo el método debe ser async
- **Try/Catch:** Envolver la lógica principal en try/catch

### 3.6 Inyección de dependencias

Registrar en `Program.cs`:
```csharp
services.AddScoped<IServiceCancelarInscripcion, ServiceCancelarInscripcion>();
```

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `API/Services/IServiceCancelarInscripcion.cs` | Interfaz del servicio |
| `API/Services/ServiceCancelarInscripcion.cs` | Implementación del servicio |
| `API/Program.cs` | Modificar para registrar DI |

## 5. Criterios de aceptación

- [ ] Servicio con interfaz e implementación
- [ ] Validación de ID > 0
- [ ] Validación de existencia de inscripción
- [ ] Validación de fecha >= fecha actual
- [ ] Validación de hora > hora actual si es fecha de hoy
- [ ] Ejecución de procedimiento almacenado
- [ ] Respuesta `true` si exitoso, `false` si falla
- [ ] DI registrada en Program.cs
- [ ] Manejo de errores con ResponseManager
- [ ] Logging de errores con ILogger
