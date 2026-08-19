# Spec: FechaMinimaValidaAttribute - Atributo de validación personalizado

## 1. Resumen

Atributo de validación `ValidationAttribute` que verifica que el año de un `DateOnly` sea mayor o igual a un valor mínimo especificado. Se aplica a `fechaTentativa` en `DTOPreReservaDeHorarioInscripcion` para rechazar fechas anteriores a 1890.

## 2. Contexto

- **Capa:** DTO (CustomValidations)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| DTO | `DTOPreReservaDeHorarioInscripcion` | DTO que usa el atributo | 63 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| System.ComponentModel.DataAnnotations | .NET | Base `ValidationAttribute` |

## 3. FechaMinimaValidaAttribute a crear

### 3.1 Archivo

| Archivo | Descripción |
|---------|-------------|
| `DTO/CustomValidations/FechaMinimaValidaAttribute.cs` | Atributo de validación |

### 3.2 Contrato

```csharp
[AttributeUsage(AttributeTargets.Property | AttributeTargets.Field, AllowMultiple = false)]
public class FechaMinimaValidaAttribute : ValidationAttribute
{
    public int AnioMinimo { get; }

    public FechaMinimaValidaAttribute(int anioMinimo = 1890);
}
```

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | Si el valor es `null` (para `DateOnly?`) | Early return | `ValidationResult.Success` |
| 2 | Si `fecha.Year < _anioMinimo` | Validación de rango | `ValidationResult` con mensaje |

### 3.4 Acciones que debe realizar

1. Recibir `anioMinimo` en el constructor (default `1890`)
2. En `IsValid(object value, ValidationContext validationContext)`:
   - Si `value is null`, retornar `ValidationResult.Success`
   - Si `value is DateOnly fecha`:
     - Si `fecha.Year < _anioMinimo`, retornar `ValidationResult` con mensaje de error
     - Caso contrario, retornar `ValidationResult.Success`

### 3.5 Mensaje de error

El mensaje por defecto es: `"La fecha tentativa debe tener un año válido ({anioMinimo} o posterior)."` donde `anioMinimo` es el valor configurado.

## 4. Aplicación en DTO

Agregar a `DTOPreReservaDeHorarioInscripcion.fechaTentativa`:

```csharp
[Required(ErrorMessage = "La fecha tentativa es requerida")]
[DataType(DataType.Date, ErrorMessage = "La fecha tentativa no tiene un formato válido")]
[FechaMinimaValida(1890, ErrorMessage = "La fecha tentativa debe tener un año válido (1890 o posterior)")]
public DateOnly fechaTentativa { get; set; }
```

## 5. Criterios de aceptación

- [ ] El atributo hereda de `ValidationAttribute`
- [ ] El constructor recibe `anioMinimo` con default `1890`
- [ ] Si `DateOnly.Year >= anioMinimo` retorna `ValidationResult.Success`
- [ ] Si `DateOnly.Year < anioMinimo` retorna `ValidationResult` con mensaje de error
- [ ] Si el valor es `null` retorna `ValidationResult.Success`
- [ ] Está aplicado en `DTOPreReservaDeHorarioInscripcion.fechaTentativa`
- [ ] El mensaje de error incluye el año mínimo configurado
