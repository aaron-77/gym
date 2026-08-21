# Spec: Método BL preReservarHorarioInscripcion en HorariosManager - Implementación

## 1. Resumen

Nuevo método en `BL/HorariosManager.cs` que POSTea un `DTOPreReservaDeHorarioInscripcion` al endpoint backend `api/Horarios/preReservarHorarioInscripcion` y deserializa la respuesta a `DTOResponse<object?>`. Es un clon del método `PreReservarHorario` existente en el mismo archivo, con dos diferencias clave: (1) el path destino es `preReservarHorarioInscripcion` y (2) el tipo de deserialización es `DTOResponse<object?>` en lugar de `DTOResponse<int>`. Esta segunda diferencia es deliberada y necesaria para sobrevivir los 400 de validación de modelo del API.

## 2. Contexto

- **Capa:** BL

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| DTO | `DTOPreReservaDeHorarioInscripcion` | Payload de entrada con validaciones | 63 |
| Endpoint backend | `registrarPreReservaDeInscripcion` | API destino del POST | 66 |
| Método base | `PreReservarHorario` (mismo archivo) | Plantilla de patrón a clonar | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `IHttpCustomClient` | HTTP | Cliente inyectado; método `post(path, HttpContent)` |
| `System.Net.Http.Json.JsonContent` | Serialización | Para construir el body de la petición |
| `System.Text.Json.JsonSerializer` | Deserialización | Para parsear la respuesta del API |

## 3. Método a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `BL/HorariosManager.cs` | Agregar método al manager existente |

### 3.2 Contrato

- **Nombre:** `preReservarHorarioInscripcion`
- **Modificador:** `public async`
- **Parámetro:** `DTOPreReservaDeHorarioInscripcion preReserva`
- **Retorno:** `Task<DTOResponse<object?>>`

### 3.3 Por qué `DTOResponse<object?>` y no `DTOResponse<int>`

| Aspecto | Detalle |
|---------|---------|
| Comportamiento del API en éxito | Retorna `DTOResponse<int>` con `payload` = ID de la pre-reserva creada |
| Comportamiento del API en 400 de validación de modelo | `InvalidModelStateResponseFactory` retorna `DTOResponse<object>` con `payload = null` (los `[Required]`, `[Range]`, `[StringLength]` y `FechaMinimaValida` fallan) |
| Comportamiento de `HttpCustomClient.post` | Devuelve el body como string para CUALQUIER status code (no lanza en non-2xx, a diferencia de `get`) |
| Deserialización con `DTOResponse<int>` | `payload:null` lanza `JsonException` ("could not be converted to System.Int32. Path: $.payload") porque `int` no admite null |
| Deserialización con `DTOResponse<object?>` | `payload:null` deserializa correctamente a `null`; `payload:123` deserializa a `JsonElement` |

> Decisión: usar `DTOResponse<object?>` para que el método sobreviva tanto a éxitos como a 400 de validación sin lanzar. El frontend recibe el `payload` como `JsonElement` en éxito y como `null` en validación fallida. Esta es la MISMA solución aplicada en los tests del endpoint backend (`PreReservarHorarioInscripcionControllerTests.cs`), que leen `DTOResponse<object?>` en los sad paths.

### 3.4 Acciones que debe realizar

1. Construir el body serializando `preReserva` con `JsonContent.Create(preReserva)`
2. Llamar `_httpClient.post("api/Horarios/preReservarHorarioInscripcion", jsonCon)` y obtener el string de respuesta
3. Deserializar la respuesta con `JsonSerializer.Deserialize<DTOResponse<object?>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true })`
4. Si el resultado deserializado es null, retornar un `DTOResponse<object?>` sintético con `success = false` y `message = "Error de deserialización o respuesta vacía."`
5. Si la deserialización es exitosa, retornar el `DTOResponse<object?>` resultante (passthrough)
6. En el bloque `catch (Exception ex)`: logear a `Console.WriteLine` con el nombre del método (`preReservarHorarioInscripcion`), la línea (vía `StackTrace`), la causa (`ex.GetType().Name - ex.Message`) y el stack trace; retornar `DTOResponse<object?>` sintético con `success = false` y `message = "Error al pre-reservar horario inscripción."`

### 3.5 Patrones a aplicar

- **Manager POST pattern:** Clon del método `PreReservarHorario` (líneas 69-87 del mismo archivo): `JsonContent.Create` → `_httpClient.post` → `Deserialize` con `PropertyNameCaseInsensitive = true` → `?? sintético`.
- **Null-coalescing fallback:** `Deserialize(...) ?? new DTOResponse<object?> { success = false, ... }` cubre el caso de respuesta vacía/null.
- **Catch-all con log estructurado:** Mismo formato de log que el resto del manager (método, línea, causa, stack trace).

### 3.6 Inyección de dependencias

Sin cambios. El constructor `HorariosManager(IHttpCustomClient httpClient)` ya existe y asigna `_httpClient`. El nuevo método usa ese campo. El registro DI en Program.cs (`AddHttpClient<IHttpCustomClient, HttpCustomClient>(...).AddHttpMessageHandler<AuthHeaderHandler>()` + `AddScoped<HorariosManager>()`) ya está presente.

## 4. Archivos a modificar

| Archivo | Descripción |
|---------|-------------|
| `BL/HorariosManager.cs` | Agregar método `preReservarHorarioInscripcion` |

## 5. Criterios de aceptación

- [ ] El método se llama `preReservarHorarioInscripcion`, es `public async`, recibe `DTOPreReservaDeHorarioInscripcion` y retorna `Task<DTOResponse<object?>>`
- [ ] POSTea a `api/Horarios/preReservarHorarioInscripcion` (path relativo, mismo formato que `PreReservarHorario`)
- [ ] Serializa el body con `JsonContent.Create(preReserva)`
- [ ] Deserializa con `JsonSerializer.Deserialize<DTOResponse<object?>>` y `PropertyNameCaseInsensitive = true`
- [ ] El fallback `??` retorna un `DTOResponse<object?>` con `success = false` cuando la deserialización es null
- [ ] El `catch` logea a `Console` con método, línea, causa y stack trace
- [ ] El `catch` retorna `DTOResponse<object?>` con `success = false` y message descriptivo
- [ ] El método NO lanza `JsonException` cuando el API responde 400 con `payload:null`
