# Spec: ConsultarInscripcionesDeCliente (InscripcionesService)

## 1. Resumen

Servicio unificado para consultar las inscripciones de un cliente que valida el ID del usuario,
verifica que exista en la BD, ejecuta la función SQL `fn_obtenerInscripcionesDelCliente` y
devuelve el resultado. Implementado como parte de `InscripcionesService`.

## 2. Contexto

- **Capa:** API Services
- **Servicio unificado:** `InscripcionesService` — implementa `IInscripcionesService`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Función de BD | `dbo.fn_obtenerInscripcionesDelCliente` | Consulta inscripciones vigentes del cliente con clases futuras | 28 |
| DTO | `DTOInscripcionDelCliente` | Modelo de datos para recibir resultados de la función | 30 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `FitnessCenterDbContext` | DataAccess | Contexto de EF Core para acceder a la BD |
| `IValidadorUsuarioExistente` | API Services | Validar que el usuario exista en BD |
| `IDataAccessExecutor` | DataAccess | Ejecutar consultas SQL y procedimientos |
| `ILogger<InscripcionesService>` | Logging | Logear errores y eventos |

## 3. Método en el servicio unificado

### 3.1 Contrato

```csharp
Task<DTOResponse<List<DTOInscripcionDelCliente>>> ConsultarInscripcionesDeClienteAsync(string idUsuario);
```

### 3.2 Archivos

| Archivo | Descripción |
|---------|-------------|
| `API/Services/IInscripcionesService.cs` | Interfaz unificada (contiene este método) |
| `API/Services/InscripcionesService.cs` | Implementación unificada |

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | ID no es NULL, vacío o whitespace | `ValidadorStringId.Validar` | 400 |
| 2 | ID tiene formato GUID válido | `ValidadorStringId.Validar` (valida GUID) | 400 |
| 3 | Usuario existe en BD | `IValidadorUsuarioExistente` (vía UserManager) | 404 |
| 4 | Ejecutar función SQL | `IDataAccessExecutor.QueryAsync` | 500 |

### 3.4 Acciones que debe realizar

1. Validar formato del ID usando `ValidadorStringId.Validar(idUsuario, "ID de usuario")`
2. Si el formato es inválido, retornar error 400
3. Validar que el usuario exista en BD usando `IValidadorUsuarioExistente.ValidarAsync(idUsuario)`
4. Si el usuario no existe, retornar error 404
5. Ejecutar la función SQL `fn_obtenerInscripcionesDelCliente` usando `IDataAccessExecutor.QueryAsync`
6. Retornar la lista de inscripciones en la respuesta

### 3.5 Inyección de dependencias

Registrado en `Program.cs`:
```csharp
builder.Services.AddScoped<IInscripcionesService, InscripcionesService>();
```

## 4. Archivos del servicio unificado

| Archivo | Descripción |
|---------|-------------|
| `API/Services/IInscripcionesService.cs` | Interfaz unificada (todos los métodos de inscripciones) |
| `API/Services/InscripcionesService.cs` | Implementación unificada |

## 5. Criterios de aceptación

- [x] Método `ConsultarInscripcionesDeClienteAsync` en `IInscripcionesService` e `InscripcionesService`
- [x] Validación de formato de ID con `ValidadorStringId`
- [x] Validación de existencia de usuario con `IValidadorUsuarioExistente`
- [x] Ejecución de función SQL con `IDataAccessExecutor.QueryAsync`
- [x] DI registrada como `IInscripcionesService → InscripcionesService`
- [x] Manejo de errores con `ResponseManager`
- [x] Logging de errores con `ILogger`
