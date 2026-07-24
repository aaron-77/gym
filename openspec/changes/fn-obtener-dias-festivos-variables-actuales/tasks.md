# Tasks: `fn_obtenerDiasFestivosVariablesActuales`

## Task 1: Crear función SQL Server

**Archivo:** `bd/scripsOrdenadosParaMigrarBd/9funciones/sqlServer/fn_obtenerDiasFestivosVariablesActuales.sql`

**Pasos:**

1. [x] Crear el archivo de la función con:
   - Cabecera con comentario de fuente y descripción
   - `CREATE FUNCTION dbo.fn_obtenerDiasFestivosVariablesActuales (@anio INT)`
   - `RETURNS @fechas TABLE (fechaExacta DATE)`
   - Declarar `@datos DatosDiaFestivoVariable`
   - Poblar `@datos` con SELECT desde `diasFestivosVariables` JOIN `estadosDeActividadLaboral` WHERE `nombre = 'activo'`
   - Ejecutar `fn_obtenerFechasDeDiasFestivosVariables(@anio, @datos)` e insertar en `@fechas`
   - `RETURN`

## Task 2 (opcional): Agregar al archivo consolidado

**Archivo:** `bd/scripsOrdenadosParaMigrarBd/9funciones/funciones.sql`

1. [ ] Agregar la función al archivo `funciones.sql` siguiendo el orden existente
