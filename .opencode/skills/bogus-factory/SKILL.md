---
name: bogus-factory
description: >
  Crear factories con Bogus para generar datos de prueba.
  Trigger: Cuando cualquier prueba necesite crear objetos/datos de prueba (unit, integración, E2E).
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## When to Use

- Cuando cualquier prueba necesite crear objetos/datos de prueba
- Tests unitarios que requieren entidades
- Tests de integración que necesitan datos en la base de datos
- Tests E2E que requieren usuarios, registros, etc.
- Datos pueden ser válidos o inválidos según lo que requiera la prueba

## Naming

| Tipo | Pattern | Ejemplo |
|------|---------|---------|
| Factory | `{EntityName}Factory.cs` | `UsuarioFactory.cs` |

## Ejemplo de Factory

Ver [assets/factory-template.cs](assets/factory-template.cs)

## Ejemplo de Uso

```csharp
// Crear entidad individual
var entidad = EntidadFactory.Crear();

// Crear con propiedades específicas
var entidad = EntidadFactory.Crear(e => e.RuleFor(x => x.Propiedad, "valor"));

// Crear múltiples entidades
var entidades = EntidadFactory.CrearVarios(5);
```
