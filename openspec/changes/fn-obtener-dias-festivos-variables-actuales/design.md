# Design: `fn_obtenerDiasFestivosVariablesActuales`

## 1. Resumen técnico

Función table-valued de SQL Server que obtiene los días festivos variables activos y calcula sus fechas para un año dado, delegando el cálculo a la función existente `fn_obtenerFechasDeDiasFestivosVariables`.

## 2. Arquitectura

```
[Caller] 
    → fn_obtenerDiasFestivosVariablesActuales(@anio)
        → Consulta diasFestivosVariables (activos)
        → Carga @datos DatosDiaFestivoVariable
        → fn_obtenerFechasDeDiasFestivosVariables(@anio, @datos)
        → Retorna @fechas TABLE (fechaExacta DATE)
```

## 3. Decisión técnica: multi-statement TVF vs inline TVF

Se usa **multi-statement TVF** (con `BEGIN...END` y `@fechas TABLE`) porque:
1. Necesitamos declarar una variable de tipo `DatosDiaFestivoVariable` y poblarla con INSERT
2. Luego llamar a otra función TVF con esa variable
3. Esto no se puede hacer en una sola sentencia SELECT (inline)

## 4. Decisión técnica: filtro por estado activo

Se usa `INNER JOIN` con `estadosDeActividadLaboral` filtrando por `nombre = 'activo'` en vez de un subquery porque:
- Es más legible y explícito
- La tabla es pequeña, no hay diferencia de performance
- Evita depender de IDs mágicos hardcodeados

## 5. Firmas y contratos

### Función nueva

```sql
CREATE FUNCTION dbo.fn_obtenerDiasFestivosVariablesActuales (
    @anio INT
)
RETURNS @fechas TABLE (fechaExacta DATE)
AS
BEGIN
    DECLARE @datos DatosDiaFestivoVariable;

    INSERT INTO @datos (diaDeFechaVariable, semanaDeFechaVariable, mesDeFechaVariable, idTipoDeRecurrencia)
    SELECT dfv.deQueDia, dfv.deQueSemana, dfv.deQueMes, dfv.fkTipoDeRecurrenciaDelFestivo
    FROM dbo.diasFestivosVariables dfv
    INNER JOIN dbo.estadosDeActividadLaboral eal
        ON dfv.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
    WHERE eal.nombre = 'activo';

    INSERT INTO @fechas (fechaExacta)
    SELECT fechaExacta
    FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(@anio, @datos);

    RETURN;
END;
```

### Dependencias existentes

```sql
-- Tipo tabla
CREATE TYPE [dbo].[DatosDiaFestivoVariable] AS TABLE(
    [diaDeFechaVariable] [int] NOT NULL,
    [semanaDeFechaVariable] [int] NULL,
    [mesDeFechaVariable] [int] NULL,
    [idTipoDeRecurrencia] [int] NULL
)

-- Función existente (no se modifica)
CREATE FUNCTION dbo.fn_obtenerFechasDeDiasFestivosVariables (
    @anio INT,
    @datosDeDiasFestivosVariables DatosDiaFestivoVariable READONLY
)
RETURNS @fechas TABLE (fechaExacta DATE)
```

## 6. Mapeo de columnas

| Tabla `diasFestivosVariables` | Tipo `DatosDiaFestivoVariable` |
|-------------------------------|-------------------------------|
| `deQueDia` (NOT NULL) | `diaDeFechaVariable` (NOT NULL) |
| `deQueSemana` (NULL) | `semanaDeFechaVariable` (NULL) |
| `deQueMes` (NULL) | `mesDeFechaVariable` (NULL) |
| `fkTipoDeRecurrenciaDelFestivo` (NOT NULL) | `idTipoDeRecurrencia` (NULL) |

## 7. Flujo de datos

1. **Entrada:** `@anio INT`
2. **Lectura:** `diasFestivosVariables` filtrados por estado activo
3. **Transformación:** Mapeo de columnas al tipo `DatosDiaFestivoVariable`
4. **Cálculo:** Delegación a `fn_obtenerFechasDeDiasFestivosVariables`
5. **Salida:** `TABLE (fechaExacta DATE)`

## 8. Casos borde

| Caso | Comportamiento esperado |
|------|------------------------|
| No hay festivos activos | Retorna tabla vacía |
| `@anio` es NULL | Error de validación de SQL Server (parámetro INT no nullable) |
| La función interna no retorna fechas | Retorna tabla vacía |
| Todos los festivos están inactivos | Retorna tabla vacía |

## 9. Archivo de salida

| Archivo | Ruta |
|---------|------|
| Función | `bd/scripsOrdenadosParaMigrarBd/9funciones/sqlServer/fn_obtenerDiasFestivosVariablesActuales.sql` |
