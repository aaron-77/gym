# Spec: ServiceConsultarInscripcionesDeCliente - Creación de Servicio

## 1. Resumen

Crear un servicio para consultar las inscripciones de un cliente que valide el ID del usuario,
verifique que exista en la BD, ejecute la función SQL `fn_obtenerInscripcionesDelCliente` y
devuelva el resultado.

## 2. Contexto

- **Capa:** API Services

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Función de BD | `dbo.fn_obtenerInscripcionesDelCliente` | Consulta inscripciones vigentes del cliente con clases futuras | 28 |
| DTO | `DTOInscripcionDelCliente` | Modelo de datos para recibir resultados de la función | 30 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `FitnessCenterDbContext` | DataAccess | Contexto de EF Core para acceder a la BD |
| `UserManager<ApplicationUser>` | Identity | Validar existencia de usuario |
| `ILogger` | Logging | Logear errores y eventos

## 3. Servicio a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `API/Services/IServiceConsultarInscripcionesDeCliente.cs` | Interfaz |
| `API/Services/ServiceConsultarInscripcionesDeCliente.cs` | Implementación |

### 3.2 Contrato

El servicio debe exponer un método asíncrono que reciba `string idUsuario` y devuelva `Task<DTOResponse<List<DTOInscripcionDelCliente>>>`.

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | ID no es NULL, vacío o whitespace | Guard clause | 400 |
| 2 | ID tiene formato GUID válido | `Guid.TryParse` | 400 |
| 3 | Usuario existe en BD | `UserManager.FindByIdAsync` | 404 |
| 4 | Ejecutar función SQL | `FromSqlInterpolated` | 500 |

### 3.4 Acciones que debe realizar

1. Validar que el parámetro `idUsuario` no sea NULL, vacío o whitespace
2. Validar que `idUsuario` tenga formato GUID válido usando `Guid.TryParse`
3. Buscar el usuario en la BD usando `UserManager.FindByIdAsync`
4. Si el usuario no existe, retornar error 404
5. Ejecutar la función SQL `fn_obtenerInscripcionesDelCliente` usando `FromSqlInterpolated`
6. Retornar la lista de inscripciones en la respuesta

### 3.5 Patrones a aplicar

- **Guard clauses:** Validaciones tempranas al inicio del método, return inmediato con error
- **ResponseManager:** Usar `ResponseManager.BuildResponse<T>()` para construir respuestas
- **ErrorModel:** Crear lista de `ErrorModel` con propiedad y mensaje descriptivo
- **Logging:** Usar `ILogger` con `LogError` en catch, incluir `idUsuario` en el log
- **Async/Await:** Todo el método debe ser async, usar `await` para operaciones de BD
- **Dependency Injection:** Inyectar `FitnessCenterDbContext`, `UserManager<ApplicationUser>`, `ILogger`
- **Try/Catch:** Envolver la lógica principal en try/catch, logear errores y retornar respuesta de error

### 3.5 Inyección de dependencias

Registrar en `Program.cs`:
```csharp
services.AddScoped<IServiceConsultarInscripcionesDeCliente, ServiceConsultarInscripcionesDeCliente>();
```

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `API/Services/IServiceConsultarInscripcionesDeCliente.cs` | Interfaz del servicio |
| `API/Services/ServiceConsultarInscripcionesDeCliente.cs` | Implementación del servicio |
| `API/Program.cs` | Modificar para registrar DI |

## 5. Criterios de aceptación

- [ ] Servicio con interfaz e implementación
- [ ] Validación de GUID con `Guid.TryParse`
- [ ] Validación de existencia de usuario con `FindByIdAsync`
- [ ] Ejecución de función SQL con `FromSqlInterpolated`
- [ ] DI registrada en Program.cs
- [ ] Manejo de errores con ResponseManager
- [ ] Logging de errores con ILogger
