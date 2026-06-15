# Ejemplos de Tests Unitarios con ModelState.AddModelError()

## Concepto

Cuando testamos controladores ASP.NET Core con `[ApiController]`, la validación automática de DataAnnotations **solo funciona en requests HTTP reales**. En tests unitarios, debemos simular los errores de validación usando `ModelState.AddModelError()`.

## Ejemplo 1: DTO con Custom Validation Attribute

### DTO
```csharp
public class ConsultarRutinasRequest
{
    [RequiredGuid(ErrorMessage = "El ID de usuario es requerido")]
    public string UsuarioID { get; set; }
}
```

### Test
```csharp
[Fact]
public async Task WhenUsuarioIDIsNull_ReturnsBadRequest()
{
    // Arrange
    var request = new ConsultarRutinasRequest { UsuarioID = null };
    _sut.ModelState.AddModelError("UsuarioID", "El ID de usuario es requerido");

    // Act
    var result = await _sut.obtenerRutinasDeUusario(request);

    // Assert
    result.Should().BeOfType<BadRequestObjectResult>();
}
```

## Ejemplo 2: DTO con DataAnnotations estándar

### DTO
```csharp
public class Rutina
{
    [Required(ErrorMessage = "Ingresa el cliente")]
    public string UsuarioID { get; set; }
    
    [Required(ErrorMessage = "Ingresa el entrenador")]
    public string EntrenadorID { get; set; }
}
```

### Test
```csharp
[Fact]
public async Task WhenUsuarioIDIsNull_ReturnsBadRequest()
{
    // Arrange
    var rutina = RutinaFactory.CrearRutinaInvalida(usuarioId: null);
    _sut.ModelState.AddModelError("UsuarioID", "Ingresa el cliente");

    // Act
    var result = await _sut.RegistrarRutina(rutina);

    // Assert
    result.Should().BeOfType<BadRequestObjectResult>();
}
```

## Ejemplo 3: Validación de rangos numéricos

### DTO
```csharp
public class AsignacionDeEjercicio
{
    [Range(1, int.MaxValue, ErrorMessage = "Selecciona una rutina")]
    public int RutinaId { get; set; }
    
    [Range(1, int.MaxValue, ErrorMessage = "Ingresa los sets")]
    public int Sets { get; set; }
}
```

### Test
```csharp
[Fact]
public async Task WhenRutinaIdIsZero_ReturnsBadRequest()
{
    // Arrange
    var asignacion = RutinaFactory.CrearAsignacionInvalida(rutinaId: 0);
    _sut.ModelState.AddModelError("RutinaId", "Selecciona una rutina");

    // Act
    var result = await _sut.asignarEjercicioARutina(asignacion);

    // Assert
    result.Should().BeOfType<BadRequestObjectResult>();
}
```

## Resumen

| Escenario | Método de test |
|-----------|---------------|
| Tests de integración | `[ApiController]` valida automáticamente |
| Tests unitarios | Usar `_sut.ModelState.AddModelError()` |