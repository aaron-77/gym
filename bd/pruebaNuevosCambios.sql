-- Script para probar las funcionalidades definidas en nuevosCambiosAbd.sql
-- Este script debe ejecutarse después de haber aplicado los cambios de nuevosCambiosAbd.sql

USE FitnessCenterDB;
GO

-- 1. Probar inserción y consulta en estadosDeClases
PRINT '1. Prueba de estadosDeClases';
SELECT * FROM dbo.estadosDeClases;

-- 2. Probar la actualización del campo fkEstadoClase en tabla Clases
PRINT '2. Actualizar estado de clases existentes';
UPDATE dbo.Clases SET fkEstadoClase = 1 WHERE fkEstadoClase IS NULL;
SELECT ClaseID, NombreClase, fkEstadoClase FROM dbo.Clases;

-- 3. Probar datos iniciales de diasDeLaSemana
PRINT '3. Datos de la tabla diasDeLaSemana';
SELECT * FROM dbo.diasDeLaSemana;

-- 4. Probar inserción y consulta en horasLaborales
PRINT '4. Insertar horas laborales y consultarlas';
INSERT INTO dbo.horasLaborales (horaInicio, horaFin)
VALUES 
    ('08:00:00', '09:00:00'),
    ('09:00:00', '10:00:00'),
    ('10:00:00', '11:00:00'),
    ('11:00:00', '12:00:00'),
    ('12:00:00', '13:00:00'),
    ('13:00:00', '14:00:00'),
    ('14:00:00', '15:00:00'),
    ('15:00:00', '16:00:00'),
    ('16:00:00', '17:00:00'),
    ('17:00:00', '18:00:00'),
    ('18:00:00', '19:00:00'),
    ('19:00:00', '20:00:00'),
    ('20:00:00', '21:00:00');

SELECT * FROM dbo.horasLaborales;

-- 5. Probar consulta de años
PRINT '5. Año(s) registrado(s)';
SELECT * FROM dbo.años;

-- 6. Probar relación diasDeLaSemana_horasLaborales
PRINT '6. Crear horarios laborales (diasDeLaSemana_horasLaborales)';
DECLARE @idAño INT = (SELECT TOP 1 idAño FROM dbo.años);

-- Insertar horarios laborales para todos los días y horas
INSERT INTO dbo.diasDeLaSemana_horasLaborales (fkDiaDeLaSemana, fkHoraLaboral, fkAño)
SELECT d.idDia, h.idHora, @idAño
FROM dbo.diasDeLaSemana d
CROSS JOIN dbo.horasLaborales h
WHERE d.Activo = 1
ORDER BY d.idDia, h.idHora;

-- Consultar algunos horarios laborales creados
SELECT TOP 20
    dh.idHorarioLaboral,
    d.nombreDia,
    CONVERT(VARCHAR(5), h.horaInicio, 108) AS HoraInicio,
    CONVERT(VARCHAR(5), h.horaFin, 108) AS HoraFin,
    a.año
FROM dbo.diasDeLaSemana_horasLaborales dh
JOIN dbo.diasDeLaSemana d ON dh.fkDiaDeLaSemana = d.idDia
JOIN dbo.horasLaborales h ON dh.fkHoraLaboral = h.idHora
JOIN dbo.años a ON dh.fkAño = a.idAño
ORDER BY d.idDia, h.horaInicio;

-- 7. Probar la función fn_obtenerClases
PRINT '7. Prueba de la función fn_obtenerClases';
SELECT * FROM dbo.fn_obtenerClases();

-- 8. Probar vistas de niveles
PRINT '8. Prueba de vistas de niveles de dificultad e intensidad';
SELECT * FROM dbo.v_nivelesDeDificultad;
SELECT * FROM dbo.v_nivelesDeIntensidad;

-- 9. Crear una clase programada y horarios asociados
PRINT '9. Crear una clase programada y sus horarios';

-- Verificar que hay clases disponibles
IF NOT EXISTS (SELECT 1 FROM dbo.Clases WHERE fkEstadoClase = 1)
BEGIN
    PRINT 'Creando una clase de ejemplo...';
    INSERT INTO dbo.Clases (
        NombreClase, InstructorID, Cupo, Descripcion, 
        duracionEnMinutos, fkIntensidad, fkDificultad, 
        tiempoDeDescansoEnMinutos, duracionEnMinutosConDescansoIncluido, fkEstadoClase
    )
    VALUES (
        'Yoga Intensivo', 1, 20, 'Clase de yoga de alto rendimiento',
        45, 2, 2, 10, 55, 1
    );
END

-- Crear una tabla temporal para almacenar los datos de la clase programada
DECLARE @DatosClaseProgramada TABLE (
    fkClase INT,
    fechaInicio DATETIME,
    fechaFin DATETIME,
    fkEntrenador INT,
    cupoMaximo INT,
    fkEstadoClaseProgramada INT
);

-- Insertar datos de ejemplo en la tabla temporal
INSERT INTO @DatosClaseProgramada
VALUES (
    (SELECT TOP 1 ClaseID FROM dbo.Clases WHERE fkEstadoClase = 1),
    GETDATE(),
    DATEADD(DAY, 30, GETDATE()),
    (SELECT TOP 1 UsuarioID FROM dbo.Usuarios WHERE RolID = 2), -- Asumiendo rol 2 para entrenadores
    15,
    1
);

-- Crear una tabla temporal para almacenar los horarios
DECLARE @DatosHorarios TABLE (
    fkHorarioLaboral INT
);

-- Obtener 3 horarios aleatorios para la clase programada
INSERT INTO @DatosHorarios (fkHorarioLaboral)
SELECT TOP 3 idHorarioLaboral
FROM dbo.diasDeLaSemana_horasLaborales
ORDER BY NEWID();

-- Declarar variables para recibir el output
DECLARE @idClaseProgramada INT;

-- Ejecutar el procedimiento almacenado
BEGIN TRY
    -- Registrar la clase programada usando el procedimiento almacenado
    DECLARE @DatosClase AS dbo.DatosClaseProgramada;
    INSERT INTO @DatosClase
    SELECT * FROM @DatosClaseProgramada;

    DECLARE @DatosHorariosTabla AS dbo.DatosHorarioClaseProgramada;
    INSERT INTO @DatosHorariosTabla
    SELECT * FROM @DatosHorarios;

    -- Ejecutar el procedimiento
    EXEC dbo.sp_registrarClaseProgramada
        @datos = @DatosClase,
        @horariosData = @DatosHorariosTabla;
    
    PRINT 'Clase programada registrada exitosamente';
    
    -- Mostrar la clase programada creada
    SELECT 
        cp.idProgramacionClase,
        c.NombreClase,
        u.Nombre + ' ' + u.Apellido AS Instructor,
        cp.fechaInicio,
        cp.fechaFin,
        cp.cupoMaximo
    FROM dbo.clasesProgramadas cp
    JOIN dbo.Clases c ON cp.fkClase = c.ClaseID
    JOIN dbo.Usuarios u ON cp.fkEntrenador = u.UsuarioID
    WHERE cp.idProgramacionClase = (
        SELECT MAX(idProgramacionClase) FROM dbo.clasesProgramadas
    );
    
    -- Mostrar los horarios asignados a la clase programada
    SELECT 
        hcp.idHorarioDeClaseProgramada,
        d.nombreDia,
        CONVERT(VARCHAR(5), h.horaInicio, 108) AS HoraInicio,
        CONVERT(VARCHAR(5), h.horaFin, 108) AS HoraFin,
        a.año
    FROM dbo.horariosDeClasesProgramadas hcp
    JOIN dbo.diasDeLaSemana_horasLaborales dh ON hcp.fkHorarioLaboral = dh.idHorarioLaboral
    JOIN dbo.diasDeLaSemana d ON dh.fkDiaDeLaSemana = d.idDia
    JOIN dbo.horasLaborales h ON dh.fkHoraLaboral = h.idHora
    JOIN dbo.años a ON dh.fkAño = a.idAño
    WHERE hcp.fkClaseProgramada = (
        SELECT MAX(idProgramacionClase) FROM dbo.clasesProgramadas
    );
END TRY
BEGIN CATCH
    PRINT 'Error al registrar la clase programada:';
    PRINT ERROR_MESSAGE();
END CATCH;

-- 10. Probar función fn_estaDisponibleElHorario
PRINT '10. Probar disponibilidad de horarios';

-- Obtener un horario de clase programada existente
DECLARE @idHorarioDeClaseProgramada INT;
SELECT TOP 1 @idHorarioDeClaseProgramada = idHorarioDeClaseProgramada 
FROM dbo.horariosDeClasesProgramadas;

IF @idHorarioDeClaseProgramada IS NOT NULL
BEGIN
    -- Verificar disponibilidad del horario
    SELECT 
        @idHorarioDeClaseProgramada AS idHorarioDeClaseProgramada,
        CASE 
            WHEN dbo.fn_estaDisponibleElHorario(@idHorarioDeClaseProgramada) = 1 THEN 'Disponible'
            ELSE 'No disponible'
        END AS EstadoDisponibilidad;
END
ELSE
BEGIN
    PRINT 'No se encontraron horarios de clases programadas para probar.';
END

-- 11. Probar pre-reserva de horario
PRINT '11. Probar pre-reserva de horario';

-- Intentar pre-reservar un horario
IF @idHorarioDeClaseProgramada IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC dbo.sp_preReservarHorario @idHorarioDeClaseProgramada = @idHorarioDeClaseProgramada;
        
        -- Consultar la pre-reserva
        SELECT * FROM dbo.preReservasDeHorario 
        WHERE fkHorarioDeClaseProgramada = @idHorarioDeClaseProgramada;
    END TRY
    BEGIN CATCH
        PRINT 'Error al pre-reservar el horario:';
        PRINT ERROR_MESSAGE();
    END CATCH
END;

-- 12. Probar función fn_consultarHorariosPreReservados
PRINT '12. Consultar horarios pre-reservados';

-- Consultar todos los horarios pre-reservados
SELECT * FROM dbo.fn_consultarHorariosPreReservados(NULL);

-- Si hay clases programadas, consultar horarios pre-reservados para una clase específica
DECLARE @idClaseProgramadaTest INT;
SELECT TOP 1 @idClaseProgramadaTest = idProgramacionClase FROM dbo.clasesProgramadas;

IF @idClaseProgramadaTest IS NOT NULL
BEGIN
    SELECT @idClaseProgramadaTest AS idClaseProgramada;
    SELECT * FROM dbo.fn_consultarHorariosPreReservados(@idClaseProgramadaTest);
END
ELSE
BEGIN
    PRINT 'No se encontraron clases programadas para probar la función de consulta.';
END;

PRINT 'Fin de las pruebas';
GO 