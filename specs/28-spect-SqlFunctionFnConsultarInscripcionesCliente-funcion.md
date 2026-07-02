# Spec: fn_obtenerInscripcionesDelCliente - Creación de Función

## 1. Resumen

Crear una función de SQL Server que consulte las inscripciones de un cliente específico, filtrando por estado de inscripción y devolviendo únicamente las inscripciones para clases con horario de la fecha actual en adelante. Si la clase es del día actual, la hora de la clase programada debe ser mayor a la hora actual.

## 2. Contexto

- **Tipo:** Función de tabla (Table-Valued Function)
- **Base de datos:** FitnessCenterDB
- **Esquema:** dbo
- **Nombre:** `fn_obtenerInscripcionesDelCliente`

## 3. Requisitos funcionales

### 3.1 Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@idUsuario` | `NVARCHAR(450)` | ID del usuario (GUID de AspNetUsers) |

### 3.2 Retorno

La función retorna una tabla con la siguiente estructura:

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `idInscripcion` | `INT` | ID único de la inscripción |
| `fechaDeInscripcion` | `DATETIME` | Fecha y hora de la inscripción |
| `estadoInscripcion` | `NVARCHAR(MAX)` | Nombre del estado de la inscripción |
| `idClaseProgramada` | `INT` | ID de la clase programada |
| `nombreClase` | `NVARCHAR(100)` | Nombre de la clase |
| `fechaDeLaClase` | `DATE` | Fecha de la clase programada |
| `horaInicio` | `TIME` | Hora de inicio de la clase |
| `horaFin` | `TIME` | Hora de fin de la clase |
| `cupoMaximo` | `INT` | Cupo máximo de la clase |
| `nombreEntrenador` | `NVARCHAR` | Nombre completo del entrenador |

### 3.3 Lógica de filtrado

La función debe retornar inscripciones que cumplan TODAS estas condiciones:

1. **Filtro por cliente:** `fkCliente = @idUsuario`
2. **Filtro por estado de inscripción:** Solo inscripciones con estado **'vigente'** (usando la vista `v_idEstadoVigenteInscripcionAClase`)
3. **Filtro de fecha/hora:** ALGUNO de estas condiciones:
   - **Clase futura:** `fechaDeLaClase > fecha actual`
   - **Clase del día actual con hora futura:** `fechaDeLaClase = fecha actual AND horaInicio > hora actual`

## 4. Requisitos no funcionales

### 4.1 Rendimiento

- La función debe usar `INNER JOIN` para las relaciones necesarias
- No debe realizar operaciones de escritura
- Debe ser determinística (mismos parámetros, mismos resultados en el mismo momento)

### 4.2 Compatibilidad

- Compatible con SQL Server 2016+
- Usa vistas existentes para estados (`v_idEstadoVigenteInscripcionAClase`)

## 5. Tablas involucradas

| Tabla | Alias | Relación |
|-------|-------|----------|
| `inscripcionesDeClases` | `ic` | Principal |
| `clasesProgramadas` | `cp` | FK: `ic.fkProgramacionClase = cp.idProgramacionClase` |
| `horariosDeClasesProgramadas` | `hcp` | FK: `cp.idProgramacionClase = hcp.fkClaseProgramada` |
| `horasLaborales` | `hl` | FK: `hcp.fkHorarioLaboral = hl.idHora` |
| `estadosInscripciones` | `ei` | FK: `ic.fkEstadoInscripcion = ei.idEstadoInscripcion` |
| `Clases` | `c` | FK: `cp.fkClase = c.ClaseID` |
| `AspNetUsers` | `u` | FK: `cp.fkEntrenador = u.Id` |

## 6. Vistas utilizadas

- `v_idEstadoVigenteInscripcionAClase` - Para filtrar inscripciones con estado vigente

## 7. Estrategia de implementación

### 7.1 Estructura de la función

```sql
CREATE FUNCTION dbo.fn_obtenerInscripcionesDelCliente(@idUsuario NVARCHAR(450))
RETURNS TABLE
AS
RETURN
(
    -- Consulta principal
);
```

### 7.2 Lógica de filtrado de estados

```sql
-- Solo inscripciones vigentes
AND ei.idEstadoInscripcion = (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase)
```

### 7.3 Lógica de filtrado de fechas

```sql
-- Clase futura O (clase del día actual Y hora futura)
AND (
    cp.fechaDeLaClase > CAST(GETDATE() AS DATE)
    OR 
    (
        cp.fechaDeLaClase = CAST(GETDATE() AS DATE)
        AND hl.horaInicio > CAST(GETDATE() AS TIME)
    )
)
```

## 8. Consideraciones

### 8.1 NULL handling

- Si `@idUsuario` es NULL, la función debe retornar resultado vacío
- Los JOINs con `AspNetUsers` (entrenador) deben ser `LEFT JOIN` ya que puede no tener entrenador asignado

### 8.2 Zona horaria

- La función usa `GETDATE()` que retorna la hora del servidor
- No maneja conversión de zonas horarias

### 8.3 Estados

- La función solo retorna inscripciones con estado **'vigente'**
- Se usa la vista `v_idEstadoVigenteInscripcionAClase` para obtener el ID del estado

## 9. Archivos a crear

| Archivo | Ubicación | Descripción |
|---------|-----------|-------------|
| `fn_obtenerInscripcionesDelCliente.sql` | `bd/scripsOrdenadosParaMigrarBd/9funciones/sqlServer/` | Script de creación de la función |

## 10. Criterios de aceptación

- [ ] La función retorna inscripciones del cliente especificado
- [ ] Filtra correctamente por estado de inscripción (solo 'vigente')
- [ ] Filtra correctamente clases futuras
- [ ] Filtra correctamente clases del día actual con hora futura
- [ ] No retorna clases pasadas
- [ ] No retorna inscripciones canceladas
- [ ] Retorna todos los campos especificados en el retorno
- [ ] Maneja correctamente clientes sin inscripciones
- [ ] Usa el estilo y convenciones existentes en el proyecto
