-- bd/probarBuscarClaseProgramadas.sql

-- Ejemplo de prueba del procedimiento almacenado buscarClaseProgramadas

-- Limpiar la salida
PRINT 'Prueba del procedimiento almacenado buscarClaseProgramadas';

-- Probar el procedimiento con diferentes combinaciones de parámetros

-- 1. Sin parámetros (debería devolver todas las clases programadas)
EXEC buscarClaseProgramadas;

-- 2. Filtrar por idClase
EXEC buscarClaseProgramadas @idClase = 1;

-- 3. Filtrar por idEntrenador
EXEC buscarClaseProgramadas @idEntrenador = 2;

-- 4. Filtrar por idHoraLaboral
EXEC buscarClaseProgramadas @idHoraLaboral = 3;

-- 5. Filtrar por fecha
EXEC buscarClaseProgramadas @fecha = '2023-10-01';

-- 6. Filtrar por múltiples parámetros
EXEC buscarClaseProgramadas @idClase = 1, @idEntrenador = 2, @fecha = '2023-10-01';

-- 7. Filtrar por todos los parámetros
EXEC buscarClaseProgramadas @idClase = 1, @idEntrenador = 2, @idHoraLaboral = 3, @fecha = '2023-10-01';