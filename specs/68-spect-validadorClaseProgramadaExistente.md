# Spec: IValidadorClaseProgramadaExistente - Validador de existencia de clase programada

## 1. Resumen

Validador que verifica la existencia de una clase programada en la base de datos dado su ID. Sigue el mismo patrón que `IValidadorUsuarioExistente` e `IValidadorClaseExistente`: interfaz con método `ValidarAsync` que retorna una tupla `(bool Existe, ClasesProgramada? ClaseProgramada)`, e implementación en `API/Services/Validaciones/` porque requiere acceso a `FitnessCenterDbContext`.

## 2. Contexto

- **Capa:** API Services Validaciones

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Entity | ClasesProgramada | Entidad de EF Core que representa una clase programada | — |
| DbContext | FitnessCenterDbContext | Contexto de EF Core para consultar la base de datos | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| FitnessCenterDbContext | DataAccess | Contexto de EF Core con DbSet `ClasesProgramadas` |
| Microsoft.EntityFrameworkCore | NuGet | Para `FindAsync` |

## 3. IValidadorClaseProgramadaExistente a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `API/Services/Validaciones/IValidadorClaseProgramadaExistente.cs` | Interfaz del validador |
| `API/Services/Validaciones/ValidadorClaseProgramadaExistente.cs` | Implementación del validador |

### 3.2 Contrato

```csharp
public interface IValidadorClaseProgramadaExistente
{
    Task<(bool Existe, ClasesProgramada? ClaseProgramada)> ValidarAsync(int idClaseProgramada);
}
```

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | Buscar clase programada por `idClaseProgramada` usando `FindAsync` | Repository/DbContext | Retorna `(false, null)` si no existe |

### 3.4 Acciones que debe realizar

1. Recibir `idClaseProgramada` (int) como parámetro
2. Buscar la clase programada en `_context.ClasesProgramadas` usando `FindAsync(idClaseProgramada)`
3. Retornar tupla `(claseProgramada is not null, claseProgramada)`

### 3.5 Patrones a aplicar

- **Consistencia con ValidadorUsuarioExistente:** Misma firma de retorno `Task<(bool Existe, T? Entidad)> ValidarAsync(param)`.
- **Inyección de dependencias:** Recibir `FitnessCenterDbContext` por constructor.
- **Async/await:** Retornar `Task<(bool, ClasesProgramada?)>` y usar `await` para `FindAsync`.

### 3.6 Inyección de dependencias

Registrar en `Program.cs`:
```csharp
builder.Services.AddScoped<IValidadorClaseProgramadaExistente, ValidadorClaseProgramadaExistente>();
```

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `API/Services/Validaciones/IValidadorClaseProgramadaExistente.cs` | Interfaz del validador |
| `API/Services/Validaciones/ValidadorClaseProgramadaExistente.cs` | Implementación con `FindAsync` |

## 5. Criterios de aceptación

- [ ] La interfaz define `Task<(bool Existe, ClasesProgramada? ClaseProgramada)> ValidarAsync(int idClaseProgramada)`
- [ ] La implementación usa `FindAsync` sobre `_context.ClasesProgramadas`
- [ ] Retorna `(true, claseProgramada)` cuando la clase programada existe
- [ ] Retorna `(false, null)` cuando la clase programada no existe
- [ ] Está registrado como `Scoped` en DI
