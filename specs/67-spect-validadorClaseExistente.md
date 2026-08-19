# Spec: IValidadorClaseExistente - Validador de existencia de clase

## 1. Resumen

Validador que verifica la existencia de una clase en la base de datos dado su ID. Sigue el mismo patrón que `IValidadorUsuarioExistente`: interfaz con método `ValidarAsync` que retorna una tupla `(bool Existe, Clase? Clase)`, e implementación en `API/Services/Validaciones/` porque requiere acceso a `FitnessCenterDbContext`.

## 2. Contexto

- **Capa:** API Services Validaciones

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Entity | Clase | Entidad de EF Core que representa una clase | — |
| DbContext | FitnessCenterDbContext | Contexto de EF Core para consultar la base de datos | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| FitnessCenterDbContext | DataAccess | Contexto de EF Core con DbSet `Clases` |
| Microsoft.EntityFrameworkCore | NuGet | Para `FindAsync` |

## 3. IValidadorClaseExistente a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `API/Services/Validaciones/IValidadorClaseExistente.cs` | Interfaz del validador |
| `API/Services/Validaciones/ValidadorClaseExistente.cs` | Implementación del validador |

### 3.2 Contrato

```csharp
public interface IValidadorClaseExistente
{
    Task<(bool Existe, Clase? Clase)> ValidarAsync(int idClase);
}
```

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | Buscar clase por `idClase` usando `FindAsync` | Repository/DbContext | Retorna `(false, null)` si no existe |

### 3.4 Acciones que debe realizar

1. Recibir `idClase` (int) como parámetro
2. Buscar la clase en `_context.Clases` usando `FindAsync(idClase)`
3. Retornar tupla `(clase is not null, clase)`

### 3.5 Patrones a aplicar

- **Consistencia con ValidadorUsuarioExistente:** Misma firma de retorno `Task<(bool Existe, T? Entidad)> ValidarAsync(param)`.
- **Inyección de dependencias:** Recibir `FitnessCenterDbContext` por constructor.
- **Async/await:** Retornar `Task<(bool, Clase?)>` y usar `await` para `FindAsync`.

### 3.6 Inyección de dependencias

Registrar en `Program.cs`:
```csharp
builder.Services.AddScoped<IValidadorClaseExistente, ValidadorClaseExistente>();
```

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `API/Services/Validaciones/IValidadorClaseExistente.cs` | Interfaz del validador |
| `API/Services/Validaciones/ValidadorClaseExistente.cs` | Implementación con `FindAsync` |

## 5. Criterios de aceptación

- [ ] La interfaz define `Task<(bool Existe, Clase? Clase)> ValidarAsync(int idClase)`
- [ ] La implementación usa `FindAsync` sobre `_context.Clases`
- [ ] Retorna `(true, clase)` cuando la clase existe
- [ ] Retorna `(false, null)` cuando la clase no existe
- [ ] Está registrado como `Scoped` en DI
