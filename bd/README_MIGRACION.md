# GUÍA DE MIGRACIÓN: clasesProgramadas y preReservasDeHorario

## ?? RESUMEN DE CAMBIOS

Esta migración reestructura cómo se almacenan `fechaDeLaClase` y `fkEntrenador`:

### ANTES (Estructura anterior):
```
horariosDeClasesProgramadas
  ??? fechaDeLaClase (AQUÍ)
  ??? fkEntrenador (AQUÍ)
  ??? fkEstadoHorarioClase
```

### DESPUÉS (Nueva estructura):
```
clasesProgramadas
  ??? fechaDeLaClase (AHORA AQUÍ)
  ??? fkEntrenador (AHORA AQUÍ)
  ??? horariosDeClasesProgramadas (sin estos campos)

preReservasDeHorario
  ??? idClase (NUEVO)
  ??? fechaDeLaClase (NUEVO)
  ??? idEntrenador (NUEVO)
  ??? Índice UNIQUE para evitar conflictos
```

---

## ?? ORDEN DE EJECUCIÓN (CRÍTICO)

### PASO 1: Agregar columnas a preReservasDeHorario
```
Archivo: bd/01_ALTER_preReservasDeHorario_AddColumns.sql
```
**Acciones:**
- Agrega columnas: `idClase`, `fechaDeLaClase`, `idEntrenador`
- Agrega Foreign Keys
- Crea índice UNIQUE
- Crea índice para búsquedas rápidas

**?? IMPORTANTE:** Ejecutar PRIMERO

---

### PASO 2: Actualizar FUNCIONES
```
Archivo: bd/02_UPDATE_Funciones_Migration.sql
```
**Funciones actualizadas:**
- ? `yaExisteClaseProgramada` - Usa `cp.fechaDeLaClase`
- ? `yaExistePreRegistroDeClase` - Simplificada
- ? `fn_obtenerClasesProgramadaPorIdProgramacionClase` - Usa `cp.fechaDeLaClase`
- ? `fn_obtenerClasesProgramadasPorIdClase` - Usa `cp.fechaDeLaClase`
- ? `ObtenerClasesProgramadas` - Usa `cp.fechaDeLaClase`

---

### PASO 3: Actualizar PROCEDIMIENTOS (Parte 1)
```
Archivo: bd/03_UPDATE_Procedimientos_Migration_Part1.sql
```
**Procedimientos actualizados:**
- ? `buscarClaseProgramadas` - Usa `cp.fechaDeLaClase`
- ? `sp_cancelarClasesProgramadas` - Usa `cp.fechaDeLaClase`
- ? `sp_obtenerEntrenadoresDisponibles` - Usa `cp.fechaDeLaClase`
- ? `sp_obtenerHorariosDisponibles` - Usa `cp.fechaDeLaClase`

---

### PASO 4: Actualizar PROCEDIMIENTOS CRÍTICOS (Parte 2)
```
Archivo: bd/04_UPDATE_Procedimientos_Migration_Part2_Critical.sql
```
**Procedimientos CRÍTICOS:**
- ? `sp_registrarClaseProgramada` - **Inserta `fechaDeLaClase` en `clasesProgramadas`**
- ? `sp_registrarHorarioDeClaseProgramada` - **Simplificado, NO inserta `fechaDeLaClase` ni `fkEntrenador`**
- ? `sp_preReservarHorario` - **Inserta `idClase`, `fechaDeLaClase`, `idEntrenador` en `preReservasDeHorario`**

---

### PASO 5: Validación Post-Migración
```
Archivo: bd/05_Validacion_PostMigracion.sql
```
**Valida:**
- ? Presencia de nuevas columnas
- ? Índices creados correctamente
- ? Foreign Keys establecidas
- ? Funciones ejecutables
- ? Conteo de registros

---

## ?? CAMBIOS ESPECÍFICOS POR COMPONENTE

### 1. Tabla `preReservasDeHorario`
| Campo | Tipo | Nuevo | Propósito |
|-------|------|-------|----------|
| `idClase` | int | ? | Referencia a la clase reservada |
| `fechaDeLaClase` | date | ? | Fecha de la clase reservada |
| `idEntrenador` | nvarchar(450) | ? | Entrenador asignado |
| `Índice UX` | UNIQUE | ? | Evita duplicados |

### 2. Función `yaExisteClaseProgramada`
**Cambio principal:**
```sql
-- ANTES:
WHERE hcp.fechaDeLaClase = @fecha

-- DESPUÉS:
WHERE cp.fechaDeLaClase = @fecha
```

### 3. Función `yaExistePreRegistroDeClase`
**Cambio principal:**
```sql
-- ANTES (JOIN complejo):
LEFT JOIN preReservasDeHorario pr ON
    hl.idHora = pr.fkHoraLaboral

-- DESPUÉS (Simplificado):
WHERE pr.fechaDeLaClase = @fechaReservada
  AND pr.fkHoraLaboral IN (...)
```

### 4. Procedimiento `sp_registrarClaseProgramada`
**Cambio CRÍTICO:**
```sql
-- NUEVA LÍNEA:
INSERT INTO clasesProgramadas (
    fkClase,
    fkEntrenador,
    cupoMaximo,
    fkEstadoClaseProgramada,
    fechaDeLaClase  -- ? AQUÍ, NO EN horariosDeClasesProgramadas
)
```

### 5. Procedimiento `sp_preReservarHorario`
**Cambio CRÍTICO:**
```sql
-- NUEVOS PARÁMETROS:
@idClase int = NULL,
@idEntrenador nvarchar(450) = NULL

-- NUEVAS COLUMNAS EN INSERT:
INSERT INTO preReservasDeHorario (
    ...
    idClase,           -- ? NUEVO
    fechaDeLaClase,    -- ? NUEVO
    idEntrenador       -- ? NUEVO
)
```

---

## ?? PRECAUCIONES IMPORTANTES

1. **Hacer backup antes de ejecutar** 
   - Estos scripts MODIFICAN estructuras existentes
   
2. **Ejecutar en orden** 
   - No saltarse pasos
   - Cada paso depende del anterior

3. **Validar después de cada paso**
   - Ejecutar `05_Validacion_PostMigracion.sql` al final
   - Revisar que no hay errores

4. **Datos existentes**
   - Si hay datos en `horariosDeClasesProgramadas`, necesitarán migración manual
   - Los procedimientos han sido diseñados para ir llenando correctamente los nuevos campos

---

## ?? VERIFICACIÓN FINAL

Después de ejecutar todos los scripts, ejecutar:

```sql
-- Verificar que funciones funcionan
SELECT dbo.fn_obtenerClasesProgramadasPorIdClase(1)

-- Verificar que procedimientos son ejecutables
EXEC sp_obtenerHorariosDisponibles @Fecha = '2025-12-15'

-- Contar registros
SELECT COUNT(*) FROM preReservasDeHorario WHERE idClase IS NOT NULL
```

---

## ?? NOTAS TÉCNICAS

- **Índice UNIQUE en preReservasDeHorario:** Previene múltiples pre-reservas para la misma clase, fecha, hora y entrenador
- **Foreign Keys:** Mantienen integridad referencial
- **Funciones actualiz adas:** Ahora apuntan a `clasesProgramadas.fechaDeLaClase`
- **Procedimientos:** Siguen la nueva lógica de almacenamiento

---

## ? ESTADO DE LA MIGRACIÓN

- [x] Estructura de tabla `preReservasDeHorario` actualizada
- [x] Funciones migracion completadas (5 funciones)
- [x] Procedimientos migración completados (4 procedimientos generales)
- [x] Procedimientos CRÍTICOS actualizados (3 procedimientos)
- [x] Validación post-migración disponible
- [x] Documentación completa

---

## ?? EN CASO DE ERROR

Si algo falla:

1. Revisar el mensaje de error exacto
2. Ejecutar `05_Validacion_PostMigracion.sql` para diagnosticar
3. Verificar que los scripts anteriores se ejecutaron correctamente
4. Si es necesario, hacer ROLLBACK de cambios

---

**Fecha de creación:** 2025-12-04
**Versión de BD:** FitnessCenterDB
**Objetivo:** Centralizar gestión de fecha y entrenador en nivel de clase programada
