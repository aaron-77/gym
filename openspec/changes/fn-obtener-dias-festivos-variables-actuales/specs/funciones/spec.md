# Spec: fn_obtenerDiasFestivosVariablesActuales - Creación de Función

## 1. Resumen

Crear una función de SQL Server que consulte los días festivos variables activos desde la tabla `diasFestivosVariables`, los cargue en una variable de tipo `DatosDiaFestivoVariable` y ejecute la función existente `fn_obtenerFechasDeDiasFestivosVariables` para calcular todas las fechas del año recibido como parámetro.

## 2. Contexto

- **Tipo:** Función de tabla (Table-Valued Function)
- **Base de datos:** FitnessCenterDB
- **Esquema:** dbo
- **Nombre:** `fn_obtenerDiasFestivosVariablesActuales`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Tipo de tabla | `DatosDiaFestivoVariable` | Tipo tabla para pasar datos de días festivos variables | — |
| Función existente | `fn_obtenerFechasDeDiasFestivosVariables` | Calcula fechas concretas a partir de datos de días festivos variables | — |
| Función existente | `fn_obtenerNombreTipoDeRecurrencia` | Obtiene el nombre del tipo de recurrencia por ID | — |
| Tabla | `diasFestivosVariables` | Almacena los días festivos variables configurados | — |
| Tabla | `estadosDeActividadLaboral` | Almacena los estados de actividad laboral (activo/inactivo) | — |
| Tabla | `tiposDeRecurrenciaDeDiasFestivos` | Catálogo de tipos de recurrencia de días festivos | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `DatosDiaFestivoVariable` | Tipo de tabla | Debe existir previamente en la BD |
| `fn_obtenerFechasDeDiasFestivosVariables` | Función | Debe existir previamente en la BD |

## 3. Requisitos funcionales

### 3.1 Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@anio` | `INT` | Año para el cual calcular las fechas de los días festivos variables |

### 3.2 Retorno

La función retorna una tabla con la siguiente estructura:

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `fechaExacta` | `DATE` | Fecha calculada del día festivo variable |

### 3.3 Lógica de negocio

La función debe:

1. **Filtrar días festivos activos:** Consultar únicamente los registros de `diasFestivosVariables` cuyo `fkEstadoActividadLaboral` corresponda a un estado activo.
2. **Mapear columnas al tipo `DatosDiaFestivoVariable`:**
   - `deQueDia` → `diaDeFechaVariable`
   - `deQueSemana` → `semanaDeFechaVariable`
   - `deQueMes` → `mesDeFechaVariable`
   - `fkTipoDeRecurrenciaDelFestivo` → `idTipoDeRecurrencia`
3. **Ejecutar función de cálculo:** Llamar a `fn_obtenerFechasDeDiasFestivosVariables(@anio, @datos)` con el año recibido y los datos cargados.
4. **Retornar resultados:** Devolver todas las fechas generadas.

## 4. Requisitos no funcionales

### 4.1 Rendimiento

- La función no debe realizar operaciones de escritura
- Debe usar los JOINs necesarios para obtener el estado activo
- La consulta debe ser eficiente considerando que `diasFestivosVariables` es una tabla pequeña (pocos registros)

### 4.2 Compatibilidad

- Compatible con SQL Server 2016+
- Debe usar `RETURNS @fechas TABLE` siguiendo el patrón de la función existente

## 5. Tablas involucradas

| Tabla | Alias | Relación |
|-------|-------|----------|
| `diasFestivosVariables` | — | Principal (origen de datos) |
| `estadosDeActividadLaboral` | — | FK: `diasFestivosVariables.fkEstadoActividadLaboral = estadosDeActividadLaboral.idEstadoActividadLaboral` |

## 6. Estrategia de implementación

### 6.1 Estructura de la función

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

### 6.2 Flujo de ejecución

1. Declarar variable `@datos` de tipo `DatosDiaFestivoVariable`
2. Poblar `@datos` con los días festivos variables activos (JOIN con `estadosDeActividadLaboral` filtrando por nombre 'activo')
3. Ejecutar `fn_obtenerFechasDeDiasFestivosVariables(@anio, @datos)` e insertar resultados en `@fechas`
4. Retornar

## 7. Consideraciones

### 7.1 NULL handling

- Si no hay días festivos variables activos, la función retorna una tabla vacía
- `deQueSemana` y `deQueMes` pueden ser NULL (son opcionales según el tipo de recurrencia)

### 7.2 Estado activo

- Se filtra por `estadosDeActividadLaboral.nombre = 'activo'` para obtener solo los registros vigentes
- Si no existe un estado con nombre 'activo', la función retornará tabla vacía

### 7.3 Dependencia de función existente

- La función delega el cálculo de fechas a `fn_obtenerFechasDeDiasFestivosVariables`
- Cualquier cambio en esa función afecta los resultados de esta

## 8. Archivos a crear

| Archivo | Ubicación | Descripción |
|---------|-----------|-------------|
| `fn_obtenerDiasFestivosVariablesActuales.sql` | `bd/scripsOrdenadosParaMigrarBd/9funciones/sqlServer/` | Script de creación de la función |

## 9. Criterios de aceptación

- [ ] La función recibe `@anio INT` como único parámetro
- [ ] La función retorna una tabla con columna `fechaExacta DATE`
- [ ] Filtra correctamente solo días festivos variables con estado activo
- [ ] Mapea correctamente las columnas al tipo `DatosDiaFestivoVariable`
- [ ] Ejecuta `fn_obtenerFechasDeDiasFestivosVariables` con el año y datos proporcionados
- [ ] Retorna todas las fechas calculadas
- [ ] Si no hay festivos activos, retorna tabla vacía (sin errores)
- [ ] Sigue las convenciones de nomenclatura y estilo del proyecto
- [ ] El archivo se crea en la ubicación correcta
