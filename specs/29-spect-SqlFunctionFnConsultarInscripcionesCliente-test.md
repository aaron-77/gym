# Spec: fn_obtenerInscripcionesDelCliente - Script de Pruebas

## 1. Resumen

Crear scripts de prueba para validar la función `fn_obtenerInscripcionesDelCliente`, cubriendo happy path y edge cases básicos.

## 2. Contexto

- **Tipo:** Scripts de prueba SQL
- **Función a probar:** `dbo.fn_obtenerInscripcionesDelCliente`
- **Ubicación de pruebas:** `bd/scripts de pruebas de procedimientos almacenados/`

## 3. Pruebas a implementar

### 3.1 Happy Path

| # | Prueba | Descripción | Resultado esperado |
|---|--------|-------------|-------------------|
| 1 | Cliente con inscripciones futuras | Consultar inscripciones de un cliente que tiene clases programadas futuras | Retorna todas las inscripciones vigentes con fecha/hora futura |

### 3.2 Edge Cases

| # | Prueba | Descripción | Resultado esperado |
|---|--------|-------------|-------------------|
| 2 | Cliente sin inscripciones | Consultar un cliente que no tiene inscripciones | Resultado vacío (0 filas) |
| 3 | Parámetro NULL | Pasar NULL como parámetro @idUsuario | Resultado vacío (0 filas) |
| 4 | Solo inscripciones pasadas | Cliente con inscripciones a clases que ya pasaron | Resultado vacío (0 filas) |
| 5 | Filtro de hora del día actual | Verificar que no se retornen clases de hoy con hora pasada | Solo clases de hoy con horaInicio > hora actual |
| 6 | Estructura de retorno | Verificar que la función retorna todos los campos requeridos | 8 columnas con nombres correctos |
| 7 | Orden de resultados | Verificar que los resultados vienen ordenados por fecha y hora | Ordenado por fechaDeLaClase, horaInicio |
| 8 | LEFT JOIN con entrenador | Verificar que se maneja correctamente la ausencia de entrenador | nombreEntrenador puede ser NULL |

## 4. Estructura del script

### 4.1 Sección de configuración

```sql
PRINT '====================================================';
PRINT 'PRUEBAS fn_obtenerInscripcionesDelCliente';
PRINT 'Fecha actual: ' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '====================================================';
```

### 4.2 Variables de prueba

Cada prueba debe declarar una variable `@idCliente` con el GUID del cliente a probar.

### 4.3 Validación de resultados

Usar `IF EXISTS` / `IF NOT EXISTS` para validar si la prueba pasó o falló:

```sql
IF NOT EXISTS (SELECT 1 FROM dbo.fn_obtenerInscripcionesDelCliente(@idCliente))
BEGIN
    PRINT '✓ PASS: [Descripción del pass]';
END
ELSE
BEGIN
    PRINT '✗ FAIL: [Descripción del fail]';
END
```

## 5. Pruebas detalladas

### Prueba 1: Happy Path

```sql
DECLARE @idClienteHappyPath NVARCHAR(450) = 'REEMPLAZAR_CON_GUID_REAL';

-- Resumen
SELECT 
    'Prueba 1: Happy Path' AS prueba,
    COUNT(*) AS totalInscripciones,
    MIN(fechaDeLaClase) AS primeraClase,
    MAX(fechaDeLaClase) AS ultimaClase
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteHappyPath);

-- Detalle
SELECT 
    idInscripcion, nombreClase, fechaDeLaClase,
    CONVERT(VARCHAR, horaInicio, 108) AS horaInicio,
    CONVERT(VARCHAR, horaFin, 108) AS horaFin,
    estadoInscripcion, nombreEntrenador
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteHappyPath)
ORDER BY fechaDeLaClase, horaInicio;
```

### Prueba 2: Cliente sin inscripciones

```sql
DECLARE @idClienteSinInscripciones NVARCHAR(450) = 'GUID_INEXISTENTE';

SELECT COUNT(*) AS totalInscripciones
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteSinInscripciones);

-- Validar: debe retornar 0 filas
```

### Prueba 3: Parámetro NULL

```sql
SELECT COUNT(*) AS totalInscripciones
FROM dbo.fn_obtenerInscripcionesDelCliente(NULL);

-- Validar: debe retornar 0 filas
```

### Prueba 4: Solo inscripciones pasadas

```sql
DECLARE @idClienteSoloPasadas NVARCHAR(450) = 'REEMPLAZAR_CON_GUID_CLIENTE_SOLO_PASADAS';

SELECT COUNT(*) AS totalInscripciones
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteSoloPasadas);

-- Validar: debe retornar 0 filas
```

### Prueba 5: Filtro de hora del día actual

```sql
DECLARE @idClienteHoy NVARCHAR(450) = 'REEMPLAZAR_CON_GUID_CLIENTE_CLASES_HOY';

-- Clases de hoy que aparecen
SELECT 
    idInscripcion, nombreClase,
    CONVERT(VARCHAR, horaInicio, 108) AS horaInicio,
    CASE 
        WHEN CONVERT(TIME, GETDATE()) < horaInicio THEN '✓ VÁLIDA'
        ELSE '✗ INVÁLIDA'
    END AS estadoValidacion
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteHoy)
WHERE fechaDeLaClase = CAST(GETDATE() AS DATE);

-- Validar: no debe haber clases con hora pasada
```

### Prueba 6: Estructura de retorno

```sql
DECLARE @idClienteEstructura NVARCHAR(450) = 'REEMPLAZAR_CON_GUID_REAL';

-- Verificar que retorna las 8 columnas
SELECT 
    idInscripcion, fechaDeInscripcion,
    idClaseProgramada, nombreClase, fechaDeLaClase,
    horaInicio, horaFin, nombreEntrenador
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteEstructura);
```

### Prueba 7: Orden de resultados

```sql
DECLARE @idClienteOrden NVARCHAR(450) = 'REEMPLAZAR_CON_GUID_REAL';

-- Verificar orden
SELECT 
    idInscripcion, nombreClase, fechaDeLaClase,
    CONVERT(VARCHAR, horaInicio, 108) AS horaInicio
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteOrden)
ORDER BY fechaDeLaClase, horaInicio;
```

### Prueba 8: LEFT JOIN con entrenador

```sql
DECLARE @idClienteEntrenador NVARCHAR(450) = 'REEMPLAZAR_CON_GUID_REAL';

-- Verificar entrenador
SELECT 
    idInscripcion, nombreClase, nombreEntrenador,
    CASE 
        WHEN nombreEntrenador IS NULL THEN 'Sin entrenador'
        ELSE 'Entrenador asignado'
    END AS estadoEntrenador
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteEntrenador);
```

## 6. Configuración de datos de prueba

### 6.1 Obtener GUIDs de clientes

```sql
-- Ejecutar para obtener GUIDs de clientes con inscripciones
SELECT TOP 10 
    u.Id AS guidCliente,
    CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreCliente,
    COUNT(ic.idInscripcion) AS totalInscripciones
FROM AspNetUsers u
INNER JOIN inscripcionesDeClases ic ON u.Id = ic.fkCliente
GROUP BY u.Id, u.NombreCompleto, u.Apellido
HAVING COUNT(ic.idInscripcion) > 0;
```

### 6.2 Obtener clientes con inscripciones pasadas

```sql
-- Clientes con inscripciones a clases pasadas
SELECT DISTINCT
    u.Id AS guidCliente,
    CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreCliente
FROM AspNetUsers u
INNER JOIN inscripcionesDeClases ic ON u.Id = ic.fkCliente
INNER JOIN clasesProgramadas cp ON ic.fkProgramacionClase = cp.idProgramacionClase
WHERE cp.fechaDeLaClase < CAST(GETDATE() AS DATE)
  AND NOT EXISTS (
      SELECT 1 
      FROM inscripcionesDeClases ic2
      INNER JOIN clasesProgramadas cp2 ON ic2.fkProgramacionClase = cp2.idProgramacionClase
      WHERE ic2.fkCliente = u.Id
        AND (
            cp2.fechaDeLaClase > CAST(GETDATE() AS DATE)
            OR (cp2.fechaDeLaClase = CAST(GETDATE() AS DATE))
        )
  );
```

## 7. Archivos a crear

| Archivo | Ubicación | Descripción |
|---------|-----------|-------------|
| `prueba_fn_obtenerInscripcionesDelCliente.sql` | `bd/scripts de pruebas de procedimientos almacenados/` | Scripts de prueba completos |

## 8. Criterios de aceptación

- [ ] El script contiene las 8 pruebas especificadas
- [ ] Cada prueba tiene comentarios explicativos
- [ ] Se usan variables para los GUIDs (fácil de configurar)
- [ ] Se incluyen queries para obtener GUIDs de prueba
- [ ] Se valida el resultado de cada prueba (PASS/FAIL)
- [ ] Se imprime un resumen al inicio y al final
- [ ] Los GUIDs de ejemplo están marcados para reemplazar
