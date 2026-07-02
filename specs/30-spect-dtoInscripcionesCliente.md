# Spec: Creación de DTO para Inscripciones del Cliente

## 1. Resumen

Crear un DTO para recibir los resultados de la función `fn_obtenerInscripcionesDelCliente` y
registrarlo como propiedad DbSet en el FitnessCenterDbContext.

## 2. Contexto

- **Función de BD:** `dbo.fn_obtenerInscripcionesDelCliente`
- **Capa:** DataAccess (DbContext) + DTO

## 3. DTO a crear

### 3.1 Archivo: `DTO/Dtos/DTOInscripcionDelCliente.cs`

```csharp
using System;

namespace DTO.Dtos
{
    public class DTOInscripcionDelCliente
    {
        public int idInscripcion { get; set; }
        public DateTime fechaDeInscripcion { get; set; }
        public int idClaseProgramada { get; set; }
        public string nombreClase { get; set; }
        public DateTime fechaDeLaClase { get; set; }
        public TimeSpan horaInicio { get; set; }
        public TimeSpan horaFin { get; set; }
        public string nombreEntrenador { get; set; }
    }
}
```

### 3.2 Propiedades

| Propiedad | Tipo | Descripción |
|-----------|------|-------------|
| `idInscripcion` | `int` | ID único de la inscripción |
| `fechaDeInscripcion` | `DateTime` | Fecha y hora de la inscripción |
| `idClaseProgramada` | `int` | ID de la clase programada |
| `nombreClase` | `string` | Nombre de la clase |
| `fechaDeLaClase` | `DateTime` | Fecha de la clase programada |
| `horaInicio` | `TimeSpan` | Hora de inicio de la clase |
| `horaFin` | `TimeSpan` | Hora de fin de la clase |
| `nombreEntrenador` | `string` | Nombre completo del entrenador |

## 4. Registro en DbContext

**Archivo:** `DataAccess/EntityFramework/FitnessCenterDbContext.cs`

Agregar en la sección "PROPIEDADES AGREGADAS MANUALMENTE" (después de la línea 153):

```csharp
public virtual DbSet<DTO.Dtos.DTOInscripcionDelCliente> InscripcionesDelClienteSP { get; set; }
```

## 5. Archivos a modificar/crear

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `DTO/Dtos/DTOInscripcionDelCliente.cs` | Crear | DTO con las 8 propiedades |
| `DataAccess/EntityFramework/FitnessCenterDbContext.cs` | Modificar | Agregar DbSet |

## 6. Criterios de aceptación

- [ ] DTO creado con las 8 propiedades que coinciden con el retorno de la función
- [ ] DbSet registrado en el contexto con nombre `InscripcionesDelClienteSP`
- [ ] Convenciones de naming del proyecto (camelCase en propiedades del DTO)
- [ ] Namespace correcto: `DTO.Dtos`
