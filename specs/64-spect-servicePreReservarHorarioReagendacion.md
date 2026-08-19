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
| Método base | RegistrarPreReservaDeHorario | Método existente con patrón similar | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| FitnessCenterDbContext | DataAccess | Contexto de EF Core para ejecutar SQL raw |
| Microsoft.Data.SqlClient | NuGet | Para construir `SqlParameter` |
| BL.Utils.ResponseManager | BL | Para construir respuestas `DTOResponse<T>` |

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

### 3.5 Acciones que debe realizar

1. Convertir `preReserva.fechaTentativa` de `DateOnly` a `DateTime` usando `TimeOnly.MinValue` (el SP recibe `date`, pero `SqlParameter` no acepta `DateOnly` directamente)
2. Construir el arreglo de `SqlParameter` con todos los parámetros del SP:
   - `@idUsuarioQueReserva`
   - `@fechaTentativa` (el SP lo recibe como `date`)
   - `@idHoraLaboral`
   - `@idClase`
   - `@idEntrenador`
   - `@idClaseProgramada`
   - `@idPrereservaOut` (output)
3. Manejar valores nulos usando `DBNull.Value`
4. Ejecutar `sp_preReservarHorarioInscripcion` mediante `ExecuteSqlRawAsync`
5. Extraer el valor del parámetro de salida
6. Retornar una respuesta exitosa de tipo `DTOResponse<int>` con el ID de la pre-reserva creada
7. En caso de excepción, loggear el error y retornar una respuesta de error interno del servidor de tipo `DTOResponse<int>`

### 3.6 Patrones a aplicar

- **Consistencia con método existente:** Seguir el mismo patrón de `RegistrarPreReservaDeHorario` en cuanto a construcción de parámetros, ejecución del SP y logging.
- **Respuesta estandarizada:** Usar `ResponseManager` para construir respuestas `DTOResponse<T>` en lugar de relanzar excepciones.
- **Logging:** Usar `Console.WriteLine` para el mensaje de error, igual que el método base.
- **Async/await:** Retornar `Task<DTOResponse<int>>` y usar `await` para la ejecución del SP.

### 3.7 Manejo de errores

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
- [ ] Ejecuta `sp_preReservarHorarioInscripcion` con todos sus parámetros
- [ ] Incluye `@idClaseProgramada` en los parámetros
- [ ] Maneja valores nulos con `DBNull.Value`
- [ ] Extrae correctamente el valor del parámetro output `@idPrereservaOut`
- [ ] En caso de éxito retorna `DTOResponse<int>` con `success = true`, `httpCode = 200` y el ID en `payload`
- [ ] En caso de error retorna `DTOResponse<int>` con `success = false`, `httpCode = 500` y el mensaje de error
- [ ] Loggea errores siguiendo el mismo patrón que `RegistrarPreReservaDeHorario`
- [ ] No relanza la excepción
