# ?? NOTAS DE IMPLEMENTACIÓN PARA EQUIPO .NET

**Fecha:** 2025-12-04  
**Dirigido a:** Desarrolladores del equipo .NET (C#, Razor Pages)  
**Impacto:** Cambios en servicios de clases y horarios

---

## ?? CAMBIOS EN LA BASE DE DATOS

### ¿QUÉ CAMBIÓ?

La fecha y el entrenador de una clase programada ahora se guardan en **`clasesProgramadas`** en lugar de **`horariosDeClasesProgramadas`**.

```
ANTES:
clasesProgramadas ? horariosDeClasesProgramadas (con fecha y entrenador)

DESPUÉS:
clasesProgramadas (con fecha y entrenador) ? horariosDeClasesProgramadas
```

### ¿DÓNDE?

| Tabla | Campo | Cambio |
|-------|-------|--------|
| `clasesProgramadas` | `fechaDeLaClase` | ? AHORA AQUÍ |
| `clasesProgramadas` | `fkEntrenador` | ? AHORA AQUÍ |
| `horariosDeClasesProgramadas` | `fechaDeLaClase` | ? REMOVIDO |
| `horariosDeClasesProgramadas` | `fkEntrenador` | ? REMOVIDO |
| `preReservasDeHorario` | `idClase` | ? NUEVO |
| `preReservasDeHorario` | `fechaDeLaClase` | ? NUEVO |
| `preReservasDeHorario` | `idEntrenador` | ? NUEVO |

---

## ?? CAMBIOS EN PROCEDIMIENTOS ALMACENADOS

### 1. `sp_registrarClaseProgramada` (CRÍTICO)

**Cambio de parámetro de tabla:**
```sql
-- La estructura DatosClaseProgramada DEBE incluir:
CREATE TYPE DatosClaseProgramada AS TABLE(
    fkClase [int] NULL,
    fkEntrenador [nvarchar](450) NULL,       -- ? AHORA AQUÍ
    cupoMaximo [int] NULL,
    fkEstadoClaseProgramada [int] NULL,
    fechaDeLaClase [date] NULL,              -- ? AHORA AQUÍ
    idUsuarioQueReserva [nvarchar](450) NULL,
    fkHoraLaboral [nvarchar](max) NULL,
    idPreservaDeHorario [int] NULL
)
```

**Nueva lógica en el procedimiento:**
```sql
-- El procedimiento ahora:
1. Inserta fechaDeLaClase en clasesProgramadas
2. Inserta fkEntrenador en clasesProgramadas
3. NO inserta estos campos en horariosDeClasesProgramadas
```

**Impacto en C#:**
```csharp
// En ClasesService.cs o donde guardes clases:

// ANTES:
var cmd = new SqlCommand("sp_registrarClaseProgramada");
cmd.Parameters.AddWithValue("@fkClase", claseId);
cmd.Parameters.AddWithValue("@fkEntrenador", entrenadortId);

// DESPUÉS (sin cambios en la llamada, pero el SP hace diferente):
// La lógica es la misma desde C#, pero el SP almacena en clasesProgramadas
var cmd = new SqlCommand("sp_registrarClaseProgramada");
cmd.Parameters.AddWithValue("@fkClase", claseId);
cmd.Parameters.AddWithValue("@fkEntrenador", entrenadortId);  // ? Continúa igual
cmd.Parameters.AddWithValue("@fechaDeLaClase", fechaClase);   // ? NUEVO PARÁMETRO
```

---

### 2. `sp_registrarHorarioDeClaseProgramada` (CAMBIO)

**Cambio de firma:**
```sql
-- ANTES:
sp_registrarHorarioDeClaseProgramada 
    @fkClaseProgramada INT,
    @fkHorarioLaboral INT,
    @fechaDeLaClase DATE,      -- ? REMOVIDO
    @fkEntrenador NVARCHAR(450) -- ? REMOVIDO

-- DESPUÉS:
sp_registrarHorarioDeClaseProgramada 
    @fkClaseProgramada INT,
    @fkHorarioLaboral INT,
    @fkEntrenador NVARCHAR(450) -- Solo para mantener compatibilidad, no se usa
```

**Impacto en C#:**
```csharp
// En HorariosService.cs o donde llames este procedimiento:

// ANTES:
cmd.Parameters.AddWithValue("@fechaDeLaClase", fecha);
cmd.Parameters.AddWithValue("@fkEntrenador", entrenadorId);

// DESPUÉS: REMOVE THESE LINES (ya no se necesitan)
// cmd.Parameters.AddWithValue("@fechaDeLaClase", fecha);  // ? QUITAR
// cmd.Parameters.AddWithValue("@fkEntrenador", entrenadorId); // ? QUITAR
```

---

### 3. `sp_preReservarHorario` (CRÍTICO)

**Cambio de parámetros:**
```sql
-- ANTES:
sp_preReservarHorario
    @idUsuarioQueReserva nvarchar(450),
    @fechaTentativa date,
    @idHoraLaboral int,
    @idPrereservaOut int OUTPUT

-- DESPUÉS:
sp_preReservarHorario
    @idUsuarioQueReserva nvarchar(450),
    @fechaTentativa date,
    @idHoraLaboral int,
    @idClase int = NULL,           -- ? NUEVO
    @idEntrenador nvarchar(450) = NULL,  -- ? NUEVO
    @idPrereservaOut int OUTPUT
```

**Impacto en C#:**
```csharp
// En HorariosService.cs:

// ANTES:
using (SqlCommand cmd = new SqlCommand("sp_preReservarHorario", connection))
{
    cmd.Parameters.AddWithValue("@idUsuarioQueReserva", usuarioId);
    cmd.Parameters.AddWithValue("@fechaTentativa", fecha);
    cmd.Parameters.AddWithValue("@idHoraLaboral", horaId);
    
    SqlParameter outParam = new SqlParameter("@idPrereservaOut", SqlDbType.Int)
    {
        Direction = ParameterDirection.Output
    };
    cmd.Parameters.Add(outParam);
    
    cmd.ExecuteNonQuery();
}

// DESPUÉS: AGREGAR ESTOS PARÁMETROS
using (SqlCommand cmd = new SqlCommand("sp_preReservarHorario", connection))
{
    cmd.Parameters.AddWithValue("@idUsuarioQueReserva", usuarioId);
    cmd.Parameters.AddWithValue("@fechaTentativa", fecha);
    cmd.Parameters.AddWithValue("@idHoraLaboral", horaId);
    cmd.Parameters.AddWithValue("@idClase", claseId ?? (object)DBNull.Value);        // ? NUEVO
    cmd.Parameters.AddWithValue("@idEntrenador", entrenadorsId ?? (object)DBNull.Value); // ? NUEVO
    
    SqlParameter outParam = new SqlParameter("@idPrereservaOut", SqlDbType.Int)
    {
        Direction = ParameterDirection.Output
    };
    cmd.Parameters.Add(outParam);
    
    cmd.ExecuteNonQuery();
}
```

---

## ?? CAMBIOS EN FUNCIONES

### `fn_obtenerClasesProgramadasPorIdClase`

**Cambio en JOIN:**
```sql
-- ANTES:
JOIN horariosDeClasesProgramadas hcp 
    ON cp.idProgramacionClase = hcp.fkClaseProgramada
WHERE hcp.fechaDeLaClase = ...  -- ?

-- DESPUÉS:
JOIN horariosDeClasesProgramadas hcp 
    ON cp.idProgramacionClase = hcp.fkClaseProgramada
WHERE cp.fechaDeLaClase = ...   -- ?
```

**Impacto en C#:**

Si usas `ORM` (Entity Framework), probablemente no hay impacto porque las queries se redefinen en el mapeo.

Si usas `Dapper` o `SqlCommand` directos, verifica que:
```csharp
// Si llamas esta función desde C#:
var resultado = cmd.ExecuteReader();
// Los campos deben venir de cp., no de hcp.
```

---

## ?? BÚSQUEDA Y REEMPLAZO EN CÓDIGO

### En `ClasesService.cs` o similar:

Buscar y revisar:
```csharp
// ANTES (buscar):
"horariosDeClasesProgramadas"
"hcp.fechaDeLaClase"
"hcp.fkEntrenador"

// DESPUÉS (debe ser):
"clasesProgramadas"
"cp.fechaDeLaClase"
"cp.fkEntrenador"
```

### En `HorariosService.cs` o similar:

Buscar y revisar:
```csharp
// ANTES (revisar):
sp_registrarHorarioDeClaseProgramada

// DESPUÉS (remover parámetros):
@fechaDeLaClase  // ? QUITAR
@fkEntrenador    // ? QUITAR (o mantener vacío)
```

---

## ?? TESTING RECOMENDADO

### 1. Test de Registro de Clase
```csharp
[Test]
public void TestRegistrarClaseProgramada_DebeInsertarFechaEnClasesProgramadas()
{
    // Arrange
    var claseId = 1;
    var entrenadorsId = "user-123";
    var fecha = new DateTime(2025, 12, 15);
    
    // Act
    var resultado = servicioClases.RegistrarClaseProgramada(
        claseId, entrenadorsId, fecha);
    
    // Assert
    Assert.IsNotNull(resultado);
    
    // Verificar en BD que clasesProgramadas.fechaDeLaClase = fecha
    // Verificar en BD que clasesProgramadas.fkEntrenador = entrenadorsId
}
```

### 2. Test de Pre-Reserva
```csharp
[Test]
public void TestPreReservarHorario_DebeInsertarNuevasColunas()
{
    // Arrange
    var usuarioId = "user-456";
    var fecha = new DateTime(2025, 12, 15);
    var horaId = 5;
    var claseId = 1;
    var entrenadorsId = "user-123";
    
    // Act
    var preReservaId = servicioHorarios.PreReservarHorario(
        usuarioId, fecha, horaId, claseId, entrenadorsId);
    
    // Assert
    Assert.IsGreater(preReservaId, 0);
    
    // Verificar en BD:
    // preReservasDeHorario.idClase = 1
    // preReservasDeHorario.fechaDeLaClase = fecha
    // preReservasDeHorario.idEntrenador = entrenadorsId
}
```

### 3. Test de Disponibilidad
```csharp
[Test]
public void TestObtenerHorariosDisponibles_UseClasesProgramadasFecha()
{
    // Act
    var horariosDisponibles = servicioHorarios.ObtenerHorariosDisponibles(
        new DateTime(2025, 12, 15));
    
    // Assert - verifica que la consulta usa cp.fechaDeLaClase
    Assert.IsNotNull(horariosDisponibles);
    // Los horarios no deben incluir los ya reservados
}
```

---

## ?? CHECKLIST DE ACTUALIZACIÓN .NET

- [ ] Revisar `ClasesService.cs` o equivalente
  - [ ] Verificar que se envía `fechaDeLaClase` a `sp_registrarClaseProgramada`
  - [ ] Verificar que se envía `fkEntrenador` a `sp_registrarClaseProgramada`
  
- [ ] Revisar `HorariosService.cs` o equivalente
  - [ ] Remover parámetros `@fechaDeLaClase` de `sp_registrarHorarioDeClaseProgramada`
  - [ ] Remover parámetros `@fkEntrenador` de `sp_registrarHorarioDeClaseProgramada`
  - [ ] Agregar parámetros `@idClase` y `@idEntrenador` a `sp_preReservarHorario`
  
- [ ] Revisar consultas LINQ/SQL
  - [ ] Cambiar referencias de `hcp.fechaDeLaClase` a `cp.fechaDeLaClase`
  - [ ] Cambiar referencias de `hcp.fkEntrenador` a `cp.fkEntrenador`
  
- [ ] Ejecutar tests unitarios
  - [ ] Test de registro de clase
  - [ ] Test de pre-reserva
  - [ ] Test de disponibilidad
  
- [ ] Ejecutar tests de integración (si existen)
  
- [ ] Revisar logs para errores de parámetros faltantes

---

## ?? ERRORES COMUNES A EVITAR

### Error 1: Parámetro faltante
```
Msg 8130: The parameterized query '(...@idClase...) expects the parameter @idClase which was not supplied.'
```
**Solución:** Agregar `cmd.Parameters.AddWithValue("@idClase", claseId);`

### Error 2: Campo no encontrado
```
Msg 207: Invalid column name 'fechaDeLaClase'.
```
**Solución:** Si es en `horariosDeClasesProgramadas`, cambiar a `clasesProgramadas.fechaDeLaClase`

### Error 3: Índice único violado
```
Msg 2627: Violation of UNIQUE KEY constraint 'UX_preReservasDeHorario_Unique'
```
**Solución:** Ya existe una pre-reserva para esa combinación (clase, fecha, hora, entrenador)

---

## ?? PRÓXIMOS PASOS

1. **Ejecutar scripts SQL** en BD de staging
2. **Actualizar código .NET** con cambios anteriores
3. **Ejecutar tests unitarios**
4. **Ejecutar tests de integración**
5. **Hacer code review**
6. **Deploy a producción**

---

## ?? PREGUNTAS FRECUENTES

**P: ¿Debo cambiar DTOs?**  
R: No necesariamente. Los DTOs que usas probablemente ya tienen `fechaDeLaClase` y `fkEntrenador`. Solo verifica que se mapean correctamente.

**P: ¿Qué pasa con datos existentes?**  
R: Los datos en `horariosDeClasesProgramadas` no se pierden. Los nuevos campos en `preReservasDeHorario` son opcionales por ahora.

**P: ¿Hay datos que migrar?**  
R: No. La migración es solo de estructura. Los registros existentes permanecen como están.

**P: ¿Esto afecta a Entity Framework?**  
R: Posiblemente. Si usas `DbContext`, verifica el mapeo de `clasesProgramadas` y `horariosDeClasesProgramadas`.

---

**Versión:** 1.0  
**Fecha:** 2025-12-04

