# Proposal: `fn_obtenerDiasFestivosVariablesActuales`

## 1. Resumen

Crear una función SQL Server `fn_obtenerDiasFestivosVariablesActuales` que reciba un año como único parámetro, consulte los días festivos variables activos desde la tabla `diasFestivosVariables`, los cargue en una variable de tipo `DatosDiaFestivoVariable`, y delegue el cálculo de fechas a la función existente `fn_obtenerFechasDeDiasFestivosVariables`.

## 2. Intención

Centralizar la lógica de "obtener los días festivos variables vigentes para un año dado" en una única función que recibe el año como parámetro, reutilizando la función de cálculo de fechas ya existente.

## 3. Alcance

- **Incluye:**
  - Una función SQL Server `fn_obtenerDiasFestivosVariablesActuales` en `/bd/scripsOrdenadosParaMigrarBd/9funciones/sqlServer/`
  - Filtro por estado activo (`fkEstadoActividadLaboral`)
  - Mapeo de columnas de `diasFestivosVariables` al tipo `DatosDiaFestivoVariable`
  - Llamada a `fn_obtenerFechasDeDiasFestivosVariables` con el año recibido como parámetro
  - Retorno de todas las fechas calculadas

- **Excluye:**
  - Cambios en la función existente `fn_obtenerFechasDeDiasFestivosVariables`
  - Cambios en el tipo `DatosDiaFestivoVariable`
  - Cambios en la tabla `diasFestivosVariables`
  - Tests automatizados (es BD, no aplica test runner .NET)

## 4. Enfoque

- Función que recibe `@anio INT` como único parámetro
- Declarar variable `@datos` de tipo `DatosDiaFestivoVariable`
- Poblar con `INSERT INTO @datos SELECT deQueDia, deQueSemana, deQueMes, fkTipoDeRecurrenciaDelFestivo FROM diasFestivosVariables WHERE fkEstadoActividadLaboral = (SELECT idEstadoActividadLaboral FROM estadosDeActividadLaboral WHERE nombre = 'activo')`
- Retornar `SELECT fechaExacta FROM fn_obtenerFechasDeDiasFestivosVariables(@anio, @datos)`

## 5. Riesgos

- Bajo. Función simple que reutiliza lógica existente. No hay breaking changes.

## 6. Rollback

- Eliminar el archivo de la función. No hay dependencias externas.

## 7. Archivos involucrados

| Archivo | Acción |
|---------|--------|
| `bd/scripsOrdenadosParaMigrarBd/9funciones/sqlServer/fn_obtenerDiasFestivosVariablesActuales.sql` | Crear |
| `bd/scripsOrdenadosParaMigrarBd/9funciones/funciones.sql` | Opcional: agregar la función al archivo consolidado |
