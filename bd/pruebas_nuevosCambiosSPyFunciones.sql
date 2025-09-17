
-- Script de pruebas para los objetos modificados en bd/nuevosCambiosSPyFunciones.sql

PRINT '--- Iniciando pruebas de funciones y procedimientos almacenados modificados ---';
PRINT ' ';

-- 1. Prueba de fn_obtenerClasesProgramadaPorIdProgramacionClase
PRINT '--- Prueba: fn_obtenerClasesProgramadaPorIdProgramacionClase ---';
DECLARE @idProgramacionClase_test INT = 1; -- Asume un ID de programación de clase existente
IF NOT EXISTS (SELECT 1 FROM FitnessCenterDB.dbo.clasesProgramadas WHERE idProgramacionClase = @idProgramacionClase_test)
BEGIN
    PRINT 'Advertencia: idProgramacionClase = 1 no existe. Por favor, ajuste el valor para una prueba significativa.';
    SELECT 'No se encontraron resultados para idProgramacionClase = 1 (ID no existente o ajustado)' AS Mensaje;
END
ELSE
BEGIN
    SELECT * FROM dbo.fn_obtenerClasesProgramadaPorIdProgramacionClase(@idProgramacionClase_test);
END
PRINT ' ';

-- 2. Prueba de fn_obtenerClasesProgramadasPorIdClase
PRINT '--- Prueba: fn_obtenerClasesProgramadasPorIdClase ---';
DECLARE @idClase_test INT = 1; -- Asume un ID de clase existente
IF NOT EXISTS (SELECT 1 FROM FitnessCenterDB.dbo.Clases WHERE ClaseID = @idClase_test)
BEGIN
    PRINT 'Advertencia: idClase = 1 no existe. Por favor, ajuste el valor para una prueba significativa.';
    SELECT 'No se encontraron resultados para idClase = 1 (ID no existente o ajustado)' AS Mensaje;
END
ELSE
BEGIN
    SELECT * FROM dbo.fn_obtenerClasesProgramadasPorIdClase(@idClase_test);
END
PRINT ' ';

-- 3. Prueba de ObtenerClasesProgramadas
PRINT '--- Prueba: ObtenerClasesProgramadas ---';
DECLARE @IdClase_obtener_test INT = 1; -- Asume un ID de clase existente
IF NOT EXISTS (SELECT 1 FROM FitnessCenterDB.dbo.Clases WHERE ClaseID = @IdClase_obtener_test)
BEGIN
    PRINT 'Advertencia: IdClase = 1 no existe. Por favor, ajuste el valor para una prueba significativa.';
    SELECT 'No se encontraron resultados para IdClase = 1 (ID no existente o ajustado)' AS Mensaje;
END
ELSE
BEGIN
    SELECT * FROM dbo.ObtenerClasesProgramadas(@IdClase_obtener_test);
END
PRINT ' ';

-- 4. Prueba de buscarClaseProgramadas
PRINT '--- Prueba: buscarClaseProgramadas ---';
-- Para esta prueba, necesitas asegurarte de que existan datos que coincidan con los parámetros
-- Puedes obtener un fkEntrenador válido de la tabla AspNetUsers, por ejemplo:
-- SELECT TOP 1 Id FROM FitnessCenterDB.dbo.AspNetUsers WHERE Estado = 'Activo' AND Id IN (SELECT fkEntrenador FROM FitnessCenterDB.dbo.clasesProgramadas);
DECLARE @idClase_buscar INT = NULL; -- ID de clase opcional
DECLARE @idEntrenador_buscar NVARCHAR(450) = NULL; -- ID de entrenador de AspNetUsers opcional
DECLARE @idHoraLaboral_buscar INT = NULL; -- ID de hora laboral opcional
DECLARE @fecha_buscar DATE = NULL; -- Fecha opcional

PRINT 'Ejecutando buscarClaseProgramadas sin parámetros (todos NULL):';
EXEC dbo.buscarClaseProgramadas;

PRINT 'Ejecutando buscarClaseProgramadas con @idClase = 1:';
EXEC dbo.buscarClaseProgramadas @idClase = 1;

-- Asegúrate de que este ID de entrenador exista en AspNetUsers y esté asignado a una clase programada
-- Puedes obtener un entrenador de prueba de la siguiente manera si tienes datos:
-- SELECT TOP 1 u.Id FROM FitnessCenterDB.dbo.AspNetUsers u INNER JOIN FitnessCenterDB.dbo.AspNetUserRoles ur ON u.Id = ur.UserId INNER JOIN FitnessCenterDB.dbo.AspNetRoles r ON ur.RoleId = r.Id WHERE r.Name = 'Entrenador' AND u.Estado = 'Activo';
-- Luego, usa ese ID para @idEntrenador_buscar.
SET @idEntrenador_buscar = (SELECT TOP 1 u.Id FROM FitnessCenterDB.dbo.AspNetUsers u INNER JOIN FitnessCenterDB.dbo.AspNetUserRoles ur ON u.Id = ur.UserId INNER JOIN FitnessCenterDB.dbo.AspNetRoles r ON ur.RoleId = r.Id WHERE r.Name = 'Entrenador' AND u.Estado = 'Activo');
IF @idEntrenador_buscar IS NULL
BEGIN
    PRINT 'Advertencia: No se encontró un entrenador activo con rol "Entrenador" para la prueba de buscarClaseProgramadas. Asegúrese de tener datos de prueba.';
END
ELSE
BEGIN
    PRINT 'Ejecutando buscarClaseProgramadas con @idEntrenador = ' + @idEntrenador_buscar + ':';
    EXEC dbo.buscarClaseProgramadas @idEntrenador = @idEntrenador_buscar;
END

PRINT 'Ejecutando buscarClaseProgramadas con @fecha = GETDATE():';
EXEC dbo.buscarClaseProgramadas @fecha = GETDATE();
PRINT ' ';

-- 5. Prueba de sp_consultarUsuarios
PRINT '--- Prueba: sp_consultarUsuarios ---';
PRINT 'Ejecutando sp_consultarUsuarios para rol "Cliente" y estado "Activo":';
EXEC dbo.sp_consultarUsuarios @tipoUsuario = 'Cliente', @estado = 'Activo';
PRINT 'Ejecutando sp_consultarUsuarios para rol "Entrenador" y estado "Activo":';
EXEC dbo.sp_consultarUsuarios @tipoUsuario = 'Entrenador', @estado = 'Activo';
PRINT ' ';

-- 6. Prueba de sp_consultarUsuariosProximosAcita
PRINT '--- Prueba: sp_consultarUsuariosProximosAcita ---';
EXEC dbo.sp_consultarUsuariosProximosAcita;
PRINT ' ';

-- 7. Prueba de sp_obtenerEjerciciosPorUsuario
PRINT '--- Prueba: sp_obtenerEjerciciosPorUsuario ---';
-- Asume un UsuarioID existente de AspNetUsers que tenga rutinas y ejercicios asignados
DECLARE @UsuarioID_ejercicio NVARCHAR(450) = (SELECT TOP 1 u.Id FROM FitnessCenterDB.dbo.AspNetUsers u WHERE u.Id IN (SELECT UserId FROM FitnessCenterDB.dbo.Rutinas));

IF @UsuarioID_ejercicio IS NULL
BEGIN
    PRINT 'Advertencia: No se encontró un usuario con rutinas para la prueba de sp_obtenerEjerciciosPorUsuario. Asegúrese de tener datos de prueba.';
END
ELSE
BEGIN
    PRINT 'Ejecutando sp_obtenerEjerciciosPorUsuario para UsuarioID = ' + @UsuarioID_ejercicio + ':';
    EXEC dbo.sp_obtenerEjerciciosPorUsuario @UsuarioID = @UsuarioID_ejercicio;
END
PRINT ' ';

-- 8. Prueba de sp_obtenerEntrenadoresDisponibles
PRINT '--- Prueba: sp_obtenerEntrenadoresDisponibles ---';
DECLARE @fechaReferencia_entrenador DATETIME = GETDATE();
PRINT 'Ejecutando sp_obtenerEntrenadoresDisponibles para la fecha de referencia actual:';
EXEC dbo.sp_obtenerEntrenadoresDisponibles @fechaReferencia = @fechaReferencia_entrenador;
PRINT ' ';

-- 9. Prueba de sp_obtenerUsuariosConCitasAgendadas
PRINT '--- Prueba: sp_obtenerUsuariosConCitasAgendadas ---';
EXEC dbo.sp_obtenerUsuariosConCitasAgendadas;
PRINT ' ';

PRINT '--- Pruebas de funciones y procedimientos almacenados modificados finalizadas ---'; 