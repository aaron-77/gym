# Spec: preReservarHorarioInscripcion - Método en HorariosService

## 1. Resumen

Método en `HorariosService` que ejecuta el stored procedure `sp_preReservarHorarioInscripcion` para crear pre-reservas de horario destinadas al flujo de inscripciones y reagendaciones. Recibe un `DTOPreReservaDeHorarioInscripcion`, construye los parámetros SQL necesarios (incluyendo la conversión de `DateOnly` a `DateTime` para `@fechaTentativa`, ya que el SP recibe `date`) y retorna una respuesta estandarizada del tipo `DTOResponse<int>` con el ID de la pre-reserva creada o el error correspondiente.

## 2. Contexto

- **Capa:** API Services

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| DTO | DTOPreReservaDeHorarioInscripcion | Payload de entrada con validaciones DataAnnotations | 63 |
| SP | sp_preReservarHorarioInscripcion | Procedimiento almacenado a ejecutar | 62 |
| Helper | ResponseManager | Utilidad de la capa BL para construir respuestas estandarizadas | — |
| Validador | IValidadorUsuarioExistente | Verifica existencia del cliente y entrenador | — |
| Validador | IValidadorClaseExistente | Verifica existencia de la clase | 67 |
| Validador | IValidadorClaseProgramadaExistente | Verifica existencia de la clase programada | 68 |
| Método base | RegistrarPreReservaDeHorario | Método existente con patrón similar | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| FitnessCenterDbContext | DataAccess | Contexto de EF Core para ejecutar SQL raw |
| Microsoft.Data.SqlClient | NuGet | Para construir `SqlParameter` |
| BL.Utils.ResponseManager | BL | Para construir respuestas `DTOResponse<T>` |
| API.Services.Validaciones | API Services | Validadores de existencia (cliente, clase, clase programada) |

## 3. preReservarHorarioInscripcion a crear

### 3.1 Archivo

| Archivo | Descripción |
|---------|-------------|
| `API/Services/HorariosService.cs` | Método a agregar en la clase existente |

### 3.2 Firma

```csharp
public async Task<DTOResponse<int>> preReservarHorarioInscripcion(DTOPreReservaDeHorarioInscripcion preReserva)
```

### 3.3 Parámetros de entrada

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| preReserva | `DTOPreReservaDeHorarioInscripcion` | Datos de la pre-reserva a crear |

### 3.4 Retorno

- `Task<DTOResponse<int>>` — Respuesta estandarizada que contiene el ID de la pre-reserva creada en `payload` cuando es exitosa, o los detalles del error cuando falla.

### 3.5 Guard clauses (validaciones previas al SP)

Antes de ejecutar el procedimiento almacenado, el método debe validar la existencia de las entidades referenciadas en el DTO. Cada validación usa su validador correspondiente y retorna `404` si la entidad no existe.

| Paso | Entidad | Validador | Condición | Error |
|------|---------|-----------|-----------|-------|
| 1 | Cliente (`idUsuarioQueReserva`) | `IValidadorUsuarioExistente` | Siempre obligatorio | `404` — "Cliente no encontrado" |
| 2 | Entrenador (`idEntrenador`) | `IValidadorUsuarioExistente` | Solo si no es nulo ni vacío | `404` — "Entrenador no encontrado" |
| 3 | Clase (`idClase`) | `IValidadorClaseExistente` | Solo si `idClase.HasValue` | `404` — "Clase no encontrada" |
| 4 | Clase programada (`idClaseProgramada`) | `IValidadorClaseProgramadaExistente` | Siempre obligatorio | `404` — "Clase programada no encontrada" |

Todas las respuestas de error usan `ResponseManager.NotFound<int>` con `httpCode = 404` y el mensaje de error en la lista de `errors`.

### 3.6 Acciones que debe realizar

1. Validar existencia del cliente usando `IValidadorUsuarioExistente` → si no existe, retornar `404`
2. Si `idEntrenador` no es nulo ni vacío, validar existencia del entrenador → si no existe, retornar `404`
3. Si `idClase` tiene valor, validar existencia de la clase → si no existe, retornar `404`
4. Validar existencia de la clase programada → si no existe, retornar `404`
5. Convertir `preReserva.fechaTentativa` de `DateOnly` a `DateTime` usando `TimeOnly.MinValue` (el SP recibe `date`, pero `SqlParameter` no acepta `DateOnly` directamente)
6. Construir el arreglo de `SqlParameter` con todos los parámetros del SP:
   - `@idUsuarioQueReserva`
   - `@fechaTentativa` (el SP lo recibe como `date`)
   - `@idHoraLaboral`
   - `@idClase`
   - `@idEntrenador`
   - `@idClaseProgramada`
   - `@idPrereservaOut` (output)
7. Manejar valores nulos usando `DBNull.Value`
8. Ejecutar `sp_preReservarHorarioInscripcion` mediante `ExecuteSqlRawAsync`
9. Extraer el valor del parámetro de salida
10. Retornar una respuesta exitosa de tipo `DTOResponse<int>` con el ID de la pre-reserva creada
11. En caso de excepción, loggear el error y retornar una respuesta de error interno del servidor de tipo `DTOResponse<int>`

### 3.7 Patrones a aplicar

- **Consistencia con método existente:** Seguir el mismo patrón de `RegistrarPreReservaDeHorario` en cuanto a construcción de parámetros, ejecución del SP y logging.
- **Respuesta estandarizada:** Usar `ResponseManager` para construir respuestas `DTOResponse<T>` en lugar de relanzar excepciones.
- **Logging:** Usar `Console.WriteLine` para el mensaje de error, igual que el método base.
- **Async/await:** Retornar `Task<DTOResponse<int>>` y usar `await` para la ejecución del SP.
- **Guard clauses:** Validar existencia de entidades antes de ejecutar el SP, retornando `404` si alguna no existe.

### 3.8 Manejo de errores

- Capturar excepciones con `try/catch`
- Loggear mensaje incluyendo método, línea, tipo de excepción, mensaje, userId y stack trace
- Retornar una respuesta `DTOResponse<int>` con `success = false`, `httpCode = 500` y el mensaje de error en la lista de errores
- No relanzar la excepción, ya que el controller utilizará `ResponderHelper` para convertir la respuesta en el código HTTP correspondiente

## 4. Archivos a modificar

| Archivo | Descripción |
|---------|-------------|
| `API/Services/HorariosService.cs` | Agregar método `preReservarHorarioInscripcion` |

## 5. Criterios de aceptación

- [ ] El método recibe `DTOPreReservaDeHorarioInscripcion` y retorna `Task<DTOResponse<int>>`
- [ ] Valida existencia del cliente y retorna `404` si no existe
- [ ] Valida existencia del entrenador (si viene) y retorna `404` si no existe
- [ ] Valida existencia de la clase (si viene) y retorna `404` si no existe
- [ ] Valida existencia de la clase programada y retorna `404` si no existe
- [ ] Ejecuta `sp_preReservarHorarioInscripcion` con todos sus parámetros
- [ ] Incluye `@idClaseProgramada` en los parámetros
- [ ] Maneja valores nulos con `DBNull.Value`
- [ ] Extrae correctamente el valor del parámetro output `@idPrereservaOut`
- [ ] En caso de éxito retorna `DTOResponse<int>` con `success = true`, `httpCode = 200` y el ID en `payload`
- [ ] En caso de error retorna `DTOResponse<int>` con `success = false`, `httpCode = 500` y el mensaje de error
- [ ] Loggea errores siguiendo el mismo patrón que `RegistrarPreReservaDeHorario`
- [ ] No relanza la excepción
