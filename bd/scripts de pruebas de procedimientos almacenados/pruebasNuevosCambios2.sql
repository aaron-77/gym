-- Script para probar las funcionalidades definidas en nuevosCambiosAbd.sql
-- Archivo: pruebasNuevosCambios2.sql
-- Este script debe ejecutarse después de haber aplicado los cambios de nuevosCambiosAbd.sql

USE FitnessCenterDB;

PRINT '========== SCRIPT DE PRUEBAS PARA NUEVOS CAMBIOS ==========';
PRINT 'Fecha de ejecución: ' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '';

-- 1. Verificar las tablas creadas
PRINT '1. VERIFICANDO TABLAS CREADAS';
PRINT '----------------------------------------';

-- 1.1 Verificar estadosDeClases
IF OBJECT_ID('dbo.estadosDeClases', 'U') IS NULL
BEGIN
    PRINT '  ERROR: La tabla estadosDeClases no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Tabla estadosDeClases encontrada.';
    SELECT TOP 5 * FROM dbo.estadosDeClases;
END

-- 1.2 Verificar diasDeLaSemana
IF OBJECT_ID('dbo.diasDeLaSemana', 'U') IS NULL
BEGIN
    PRINT '  ERROR: La tabla diasDeLaSemana no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Tabla diasDeLaSemana encontrada.';
    SELECT * FROM dbo.diasDeLaSemana;
END

-- 1.3 Verificar horasLaborales
IF OBJECT_ID('dbo.horasLaborales', 'U') IS NULL
BEGIN
    PRINT '  ERROR: La tabla horasLaborales no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Tabla horasLaborales encontrada.';
    
    -- Si no hay datos en la tabla, insertamos algunos
    IF NOT EXISTS (SELECT 1 FROM dbo.horasLaborales)
    BEGIN
        PRINT '  Insertando horas laborales de ejemplo...';
        INSERT INTO dbo.horasLaborales (horaInicio, horaFin)
        VALUES 
            ('08:00:00', '09:00:00'),
            ('09:00:00', '10:00:00'),
            ('10:00:00', '11:00:00'),
            ('11:00:00', '12:00:00'),
            ('12:00:00', '13:00:00'),
            ('14:00:00', '15:00:00'),
            ('15:00:00', '16:00:00'),
            ('16:00:00', '17:00:00'),
            ('17:00:00', '18:00:00'),
            ('18:00:00', '19:00:00');
    END
    
    SELECT TOP 5 * FROM dbo.horasLaborales;
END

-- 1.4 Verificar años
IF OBJECT_ID('dbo.años', 'U') IS NULL
BEGIN
    PRINT '  ERROR: La tabla años no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Tabla años encontrada.';
    SELECT * FROM dbo.años;
END

-- 1.5 Verificar diasDeLaSemana_horasLaborales
IF OBJECT_ID('dbo.diasDeLaSemana_horasLaborales', 'U') IS NULL
BEGIN
    PRINT '  ERROR: La tabla diasDeLaSemana_horasLaborales no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Tabla diasDeLaSemana_horasLaborales encontrada.';
    
    -- Verificar si hay datos en la tabla de relación
    IF NOT EXISTS (SELECT 1 FROM dbo.diasDeLaSemana_horasLaborales)
    BEGIN
        PRINT '  Generando horarios laborales de ejemplo...';
        
        -- Obtener el id del año actual
        DECLARE @idAnio INT = (SELECT TOP 1 idAño FROM dbo.años);
        
        -- Generar combinaciones para días laborables (lunes a viernes)
        INSERT INTO dbo.diasDeLaSemana_horasLaborales (fkDiaDeLaSemana, fkHoraLaboral, fkAño)
        SELECT d.idDia, h.idHora, @idAnio
        FROM dbo.diasDeLaSemana d
        CROSS JOIN dbo.horasLaborales h
        WHERE d.nombreDia IN ('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes')
              AND d.Activo = 1
              AND NOT EXISTS (
                  SELECT 1 FROM dbo.diasDeLaSemana_horasLaborales 
                  WHERE fkDiaDeLaSemana = d.idDia 
                    AND fkHoraLaboral = h.idHora 
                    AND fkAño = @idAnio
              );
        
        PRINT '  Insertados ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros de horarios laborales.';
    END
    
    SELECT TOP 10 
        dh.idHorarioLaboral,
        d.nombreDia,
        FORMAT(h.horaInicio, 'hh:mm tt') AS horaInicio,
        FORMAT(h.horaFin, 'hh:mm tt') AS horaFin,
        a.año
    FROM dbo.diasDeLaSemana_horasLaborales dh
    JOIN dbo.diasDeLaSemana d ON dh.fkDiaDeLaSemana = d.idDia
    JOIN dbo.horasLaborales h ON dh.fkHoraLaboral = h.idHora
    JOIN dbo.años a ON dh.fkAño = a.idAño;
END

-- 1.6 Verificar horariosDeClasesProgramadas
IF OBJECT_ID('dbo.horariosDeClasesProgramadas', 'U') IS NULL
BEGIN
    PRINT '  ERROR: La tabla horariosDeClasesProgramadas no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Tabla horariosDeClasesProgramadas encontrada.';
    SELECT TOP 5 * FROM dbo.horariosDeClasesProgramadas;
END

-- 1.7 Verificar preReservasDeHorario
IF OBJECT_ID('dbo.preReservasDeHorario', 'U') IS NULL
BEGIN
    PRINT '  ERROR: La tabla preReservasDeHorario no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Tabla preReservasDeHorario encontrada.';
    SELECT TOP 5 * FROM dbo.preReservasDeHorario;
END

-- 1.8 Verificar campo fkEstadoClase en la tabla Clases
IF COL_LENGTH('dbo.Clases', 'fkEstadoClase') IS NULL
BEGIN
    PRINT '  ERROR: El campo fkEstadoClase no existe en la tabla Clases.';
END
ELSE
BEGIN
    PRINT '  OK: Campo fkEstadoClase encontrado en la tabla Clases.';
    
    -- Actualizar las clases sin estado
    UPDATE dbo.Clases 
    SET fkEstadoClase = 1 -- Activa
    WHERE fkEstadoClase IS NULL;
    
    PRINT '  Clases actualizadas con estado: ' + CAST(@@ROWCOUNT AS VARCHAR);
    
    -- Mostrar algunas clases con su estado
    SELECT TOP 5 
        c.ClaseID, 
        c.NombreClase, 
        e.nombreEstado AS Estado
    FROM dbo.Clases c
    LEFT JOIN dbo.estadosDeClases e ON c.fkEstadoClase = e.idEstadoClase;
END

PRINT '';

-- 2. Verificar funciones, vistas y procedimientos
PRINT '2. VERIFICANDO FUNCIONES, VISTAS Y PROCEDIMIENTOS';
PRINT '----------------------------------------';

-- 2.1 Probar función fn_obtenerClases
IF OBJECT_ID('dbo.fn_obtenerClases', 'IF') IS NULL
BEGIN
    PRINT '  ERROR: La función fn_obtenerClases no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Función fn_obtenerClases encontrada.';
    SELECT TOP 10 * FROM dbo.fn_obtenerClases();
END

-- 2.2 Probar vista v_nivelesDeDificultad
IF OBJECT_ID('dbo.v_nivelesDeDificultad', 'V') IS NULL
BEGIN
    PRINT '  ERROR: La vista v_nivelesDeDificultad no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Vista v_nivelesDeDificultad encontrada.';
    SELECT * FROM dbo.v_nivelesDeDificultad;
END

-- 2.3 Probar vista v_nivelesDeIntensidad
IF OBJECT_ID('dbo.v_nivelesDeIntensidad', 'V') IS NULL
BEGIN
    PRINT '  ERROR: La vista v_nivelesDeIntensidad no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Vista v_nivelesDeIntensidad encontrada.';
    SELECT * FROM dbo.v_nivelesDeIntensidad;
END

-- 2.4 Verificar procedimiento sp_registrarHorarioDeClaseProgramada
IF OBJECT_ID('dbo.sp_registrarHorarioDeClaseProgramada', 'P') IS NULL
BEGIN
    PRINT '  ERROR: El procedimiento sp_registrarHorarioDeClaseProgramada no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Procedimiento sp_registrarHorarioDeClaseProgramada encontrado.';
END

-- 2.5 Verificar tipos de datos personalizados
IF TYPE_ID('dbo.DatosHorarioClaseProgramada') IS NULL
BEGIN
    PRINT '  ERROR: Tipo de datos DatosHorarioClaseProgramada no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Tipo de datos DatosHorarioClaseProgramada encontrado.';
END

IF TYPE_ID('dbo.DatosClaseProgramada') IS NULL
BEGIN
    PRINT '  ERROR: Tipo de datos DatosClaseProgramada no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Tipo de datos DatosClaseProgramada encontrado.';
END

-- 2.6 Verificar procedimiento sp_registrarClaseProgramada
IF OBJECT_ID('dbo.sp_registrarClaseProgramada', 'P') IS NULL
BEGIN
    PRINT '  ERROR: El procedimiento sp_registrarClaseProgramada no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Procedimiento sp_registrarClaseProgramada encontrado.';
END

-- 2.7 Verificar función fn_estaDisponibleElHorario
IF OBJECT_ID('dbo.fn_estaDisponibleElHorario', 'FN') IS NULL
BEGIN
    PRINT '  ERROR: La función fn_estaDisponibleElHorario no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Función fn_estaDisponibleElHorario encontrada.';
    -- Nota: Esta función se probará en la sección de pruebas de funcionalidad
END

-- 2.8 Verificar procedimiento sp_preReservarHorario
IF OBJECT_ID('dbo.sp_preReservarHorario', 'P') IS NULL
BEGIN
    PRINT '  ERROR: El procedimiento sp_preReservarHorario no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Procedimiento sp_preReservarHorario encontrado.';
END

-- 2.9 Verificar función fn_consultarHorariosPreReservados
IF OBJECT_ID('dbo.fn_consultarHorariosPreReservados', 'IF') IS NULL
BEGIN
    PRINT '  ERROR: La función fn_consultarHorariosPreReservados no existe.';
END
ELSE
BEGIN
    PRINT '  OK: Función fn_consultarHorariosPreReservados encontrada.';
    SELECT * FROM dbo.fn_consultarHorariosPreReservados(NULL);
END

PRINT '';

-- 3. Pruebas de funcionalidad
PRINT '3. PRUEBAS DE FUNCIONALIDAD';
PRINT '----------------------------------------';

-- 3.1 Registrar una clase programada (solo si existen clases y usuarios)
PRINT '3.1 Prueba de registro de clase programada';

-- Verificar si hay clases y usuarios
IF EXISTS (SELECT 1 FROM dbo.Clases WHERE fkEstadoClase = 1)
    AND EXISTS (SELECT 1 FROM dbo.Usuarios WHERE RolID = 2) -- Entrenadores
BEGIN
    PRINT '  Requisitos cumplidos: existen clases activas y entrenadores';
    
    -- Variables para la prueba
    DECLARE @claseID INT, @instructorID INT, @fechaInicio DATETIME, @fechaFin DATETIME;
    
    -- Obtener una clase y un instructor
    SELECT TOP 1 @claseID = ClaseID FROM dbo.Clases WHERE fkEstadoClase = 1;
    SELECT TOP 1 @instructorID = UsuarioID FROM dbo.Usuarios WHERE RolID = 2;
    
    -- Establecer fechas para la clase
    SET @fechaInicio = DATEADD(DAY, 1, GETDATE()); -- Mañana
    SET @fechaFin = DATEADD(DAY, 30, GETDATE());  -- Un mes después
    
    -- Crear tabla para datos de la clase programada
    DECLARE @datosClase AS dbo.DatosClaseProgramada;
    
    -- Insertar datos en la tabla temporal
    INSERT INTO @datosClase (fkClase, 
    fechaInicio, 
    fechaFin, 
    fkEntrenador, 
    cupoMaximo, 
    fkEstadoClaseProgramada,
    fkHorarioLaboral
    )
    VALUES (@claseID, @fechaInicio, @fechaFin, @instructorID, 15, 1,'1,2');
    
    -- Crear tabla para los horarios
    DECLARE @horarios AS dbo.DatosHorarioClaseProgramada;
    
    -- Obtener algunos horarios para la clase (lunes, miércoles y viernes a las 10am)
    INSERT INTO @horarios (fkHorarioLaboral)
    SELECT TOP 3 dh.idHorarioLaboral
    FROM dbo.diasDeLaSemana_horasLaborales dh
    JOIN dbo.diasDeLaSemana d ON dh.fkDiaDeLaSemana = d.idDia
    JOIN dbo.horasLaborales h ON dh.fkHoraLaboral = h.idHora
    WHERE d.nombreDia IN ('Lunes', 'Miércoles', 'Viernes')
      AND h.horaInicio = '10:00:00'
    ORDER BY d.idDia;
    
    -- Número de horarios seleccionados
    DECLARE @numHorarios INT = (SELECT COUNT(*) FROM @horarios);
    
    IF @numHorarios > 0
    BEGIN
        PRINT '  Se encontraron ' + CAST(@numHorarios AS VARCHAR) + ' horarios disponibles';
        
        -- Variables para capturar resultado
        DECLARE @idClaseProgramada TABLE (IdClaseProgramada INT);
        
        -- Ejecutar el procedimiento
        BEGIN TRY
            INSERT INTO @idClaseProgramada
            EXEC dbo.sp_registrarClaseProgramada @datos = @datosClase;
            
            -- Obtener el ID de la clase programada
            DECLARE @nuevaClaseProgramadaID INT = (SELECT TOP 1 IdClaseProgramada FROM @idClaseProgramada);
            
            IF @nuevaClaseProgramadaID IS NOT NULL AND @nuevaClaseProgramadaID > 0
            BEGIN
                PRINT '  ÉXITO: Clase programada registrada con ID: ' + CAST(@nuevaClaseProgramadaID AS VARCHAR);
                
                -- Mostrar la clase programada y sus horarios
                PRINT '  Detalles de la clase programada:';
                SELECT 
                    cp.idProgramacionClase,
                    c.NombreClase,
                    u.Nombre + ' ' + u.Apellido AS Instructor,
                    FORMAT(cp.fechaInicio, 'dd/MM/yyyy') AS FechaInicio,
                    FORMAT(cp.fechaFin, 'dd/MM/yyyy') AS FechaFin
                FROM dbo.clasesProgramadas cp
                JOIN dbo.Clases c ON cp.fkClase = c.ClaseID
                JOIN dbo.Usuarios u ON cp.fkEntrenador = u.UsuarioID
                WHERE cp.idProgramacionClase = @nuevaClaseProgramadaID;
                
                PRINT '  Horarios asignados:';
                SELECT 
                    hcp.idHorarioDeClaseProgramada,
                    d.nombreDia,
                    FORMAT(h.horaInicio, 'hh:mm tt') AS HoraInicio,
                    FORMAT(h.horaFin, 'hh:mm tt') AS HoraFin
                FROM dbo.horariosDeClasesProgramadas hcp
                JOIN dbo.diasDeLaSemana_horasLaborales dh ON hcp.fkHorarioLaboral = dh.idHorarioLaboral
                JOIN dbo.diasDeLaSemana d ON dh.fkDiaDeLaSemana = d.idDia
                JOIN dbo.horasLaborales h ON dh.fkHoraLaboral = h.idHora
                WHERE hcp.fkClaseProgramada = @nuevaClaseProgramadaID;
                
                -- Probar función de disponibilidad
                PRINT '3.2 Prueba de función fn_estaDisponibleElHorario';
                
                -- Obtener un horario de clase programada
                DECLARE @idHorarioClase INT;
                SELECT TOP 1 @idHorarioClase = idHorarioDeClaseProgramada 
                FROM dbo.horariosDeClasesProgramadas
                WHERE fkClaseProgramada = @nuevaClaseProgramadaID;
                
                IF @idHorarioClase IS NOT NULL
                BEGIN
                    DECLARE @disponible BIT = dbo.fn_estaDisponibleElHorario(@idHorarioClase);
                    
                    PRINT '  Horario ID ' + CAST(@idHorarioClase AS VARCHAR) + 
                          ' está disponible: ' + CASE WHEN @disponible = 1 THEN 'SI' ELSE 'NO' END;
                    
                    -- Probar pre-reserva de horario
                    PRINT '3.3 Prueba de procedimiento sp_preReservarHorario';
                    
                    -- Variables para capturar resultado
                    DECLARE @resultadoReserva TABLE (IdPreReserva INT, Mensaje NVARCHAR(MAX));
                    
                    -- Ejecutar procedimiento
                    INSERT INTO @resultadoReserva
                    EXEC dbo.sp_preReservarHorario @idHorarioDeClaseProgramada = @idHorarioClase;
                    
                    -- Mostrar resultado
                    SELECT * FROM @resultadoReserva;
                    
                    -- Verificar pre-reservas registradas
                    PRINT '3.4 Prueba de función fn_consultarHorariosPreReservados';
                    SELECT * FROM dbo.fn_consultarHorariosPreReservados(@nuevaClaseProgramadaID);
                END
                ELSE
                BEGIN
                    PRINT '  ERROR: No se encontraron horarios asignados a la clase programada.';
                END
            END
            ELSE
            BEGIN
                PRINT '  ERROR: No se pudo obtener el ID de la clase programada registrada.';
            END
        END TRY
        BEGIN CATCH
            PRINT '  ERROR al registrar la clase programada: ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT '  ERROR: No se encontraron horarios disponibles para la prueba.';
    END
END
ELSE
BEGIN
    PRINT '  No se puede realizar la prueba: no hay clases activas o entrenadores.';
END

-- Resumen de pruebas
PRINT '';
PRINT '========== RESUMEN DE PRUEBAS ==========';
PRINT '- Tablas creadas y verificadas';
PRINT '- Funciones, vistas y procedimientos verificados';
PRINT '- Pruebas de funcionalidad completadas';
PRINT '=======================================';
PRINT '';
PRINT 'Fin de las pruebas: ' + CONVERT(VARCHAR, GETDATE(), 120);
