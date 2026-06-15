USE FitnessGymCenterDB;
GO

-- Script de prueba para la función fn_obtenerHorariosDisponibles
-- Este script prepara datos de prueba y ejecuta varios escenarios

SET NOCOUNT ON;
PRINT '=== SCRIPT DE PRUEBA DE fn_obtenerHorariosDisponibles ===';

-- 1. Crear algunos datos de prueba
PRINT '1. Preparando datos de prueba...';

-- 1.1. Insertar algunas horas laborales si no existen
IF NOT EXISTS (SELECT 1 FROM dbo.horasLaborales)
BEGIN
    PRINT '  Insertando horas laborales de ejemplo...';
    INSERT INTO dbo.horasLaborales (horaInicio, horaFin)
    VALUES
        ('08:00:00', '09:00:00'),
        ('09:00:00', '10:00:00'),
        ('10:00:00', '11:00:00'),
        ('11:00:00', '12:00:00'),
        ('13:00:00', '14:00:00'),
        ('14:00:00', '15:00:00'),
        ('15:00:00', '16:00:00'),
        ('16:00:00', '17:00:00'),
        ('17:00:00', '18:00:00'),
        ('18:00:00', '19:00:00');
    
    PRINT '  ' + CAST(@@ROWCOUNT AS VARCHAR) + ' horas laborales insertadas.';
END
ELSE
BEGIN
    PRINT '  Las horas laborales ya existen.';
END

-- 1.2. Asegurarse que existen los estados de actividad laboral
IF NOT EXISTS (SELECT 1 FROM dbo.estadosDeActividadLaboral WHERE nombreEstadoActividadLaboral = 'no se labora')
BEGIN
    PRINT '  Insertando estados de actividad laboral...';
    INSERT INTO dbo.estadosDeActividadLaboral (nombreEstadoActividadLaboral)
    VALUES 
        ('laboral'),
        ('no se labora'),
        ('medio día');
    
    PRINT '  ' + CAST(@@ROWCOUNT AS VARCHAR) + ' estados de actividad laboral insertados.';
END
ELSE
BEGIN
    PRINT '  Los estados de actividad laboral ya existen.';
END

-- 1.3. Insertar algunos días festivos o de descanso
PRINT '  Eliminando días festivos anteriores para el ejemplo...';
DELETE FROM dbo.diasFestivosYDescansos WHERE YEAR(fechaFestivaODescanso) = YEAR(GETDATE());

PRINT '  Insertando días festivos y de descanso de ejemplo...';
DECLARE @estadoNoLaboral INT = (SELECT idEstadoActividadLaboral FROM dbo.estadosDeActividadLaboral WHERE nombreEstadoActividadLaboral = 'no se labora');
DECLARE @estadoMedioDia INT = (SELECT idEstadoActividadLaboral FROM dbo.estadosDeActividadLaboral WHERE nombreEstadoActividadLaboral = 'medio día');

-- Conseguir primer día del mes actual y primer día del mes siguiente
DECLARE @primerDiaMes DATE = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
DECLARE @ultimoDiaMes DATE = EOMONTH(@primerDiaMes);

-- Obtener el primer domingo del mes
DECLARE @primerDomingo DATE = @primerDiaMes;
WHILE (DATEPART(dw, @primerDomingo) != 1) -- 1 = domingo en SQL Server
BEGIN
    SET @primerDomingo = DATEADD(DAY, 1, @primerDomingo);
END

-- Crear un festivo en el primer domingo del mes
INSERT INTO dbo.diasFestivosYDescansos (fechaFestivaODescanso, descripcion, fkEstadoActividadLaboral)
VALUES (@primerDomingo, 'Día festivo de prueba', @estadoNoLaboral);

-- Crear un festivo en un día específico del mes en curso
DECLARE @diaFestivo DATE = DATEADD(DAY, 15, @primerDiaMes);
IF @diaFestivo <= @ultimoDiaMes
BEGIN
    INSERT INTO dbo.diasFestivosYDescansos (fechaFestivaODescanso, descripcion, fkEstadoActividadLaboral)
    VALUES (@diaFestivo, 'Día festivo a mitad de mes', @estadoNoLaboral);
END

-- Crear un día de medio trabajo en otro día específico
DECLARE @diaMedioLaboral DATE = DATEADD(DAY, 20, @primerDiaMes);
IF @diaMedioLaboral <= @ultimoDiaMes
BEGIN
    INSERT INTO dbo.diasFestivosYDescansos (fechaFestivaODescanso, descripcion, fkEstadoActividadLaboral)
    VALUES (@diaMedioLaboral, 'Medio día de trabajo', @estadoMedioDia);
END

PRINT '  ' + CAST(@@ROWCOUNT AS VARCHAR) + ' días festivos y de descanso insertados para el mes actual.';

-- 1.4. Simular horarios de clases programadas
PRINT '  Simulando algunas clases programadas...';

-- Verificar si existen entrenadores, clases, y estados de clases programadas
DECLARE @hayDatos BIT = 1;

IF NOT EXISTS (SELECT 1 FROM dbo.Usuarios WHERE RolID = (SELECT RolID FROM dbo.Roles WHERE NombreRol = 'Entrenador'))
BEGIN
    PRINT '  ADVERTENCIA: No hay entrenadores registrados. No se pueden crear clases programadas.';
    SET @hayDatos = 0;
END

IF NOT EXISTS (SELECT 1 FROM dbo.Clases)
BEGIN
    PRINT '  ADVERTENCIA: No hay clases registradas. No se pueden crear clases programadas.';
    SET @hayDatos = 0;
END

IF NOT EXISTS (SELECT 1 FROM dbo.estadosClasesProgramadas)
BEGIN
    PRINT '  ADVERTENCIA: No hay estados de clases programadas. No se pueden crear clases programadas.';
    SET @hayDatos = 0;
END

-- Si existen los datos necesarios, crear una clase programada de ejemplo
IF @hayDatos = 1
BEGIN
    -- Obtener un entrenador existente
    DECLARE @entrenadorID INT = (
        SELECT TOP 1 UsuarioID 
        FROM dbo.Usuarios 
        WHERE RolID = (SELECT RolID FROM dbo.Roles WHERE NombreRol = 'Entrenador')
    );
    
    -- Obtener una clase existente
    DECLARE @claseID INT = (SELECT TOP 1 ClaseID FROM dbo.Clases);
    
    -- Obtener estado activo para clase programada
    DECLARE @estadoClaseProgramada INT = (
        SELECT TOP 1 idEstadoClaseProgramada 
        FROM dbo.estadosClasesProgramadas 
        WHERE nombresEstado LIKE '%activ%'
    );
    
    -- Crear clase programada para una hora específica dentro del mes actual
    DECLARE @fechaClase DATE = DATEADD(DAY, 10, @primerDiaMes);
    
    -- Limpiar datos anteriores de prueba para evitar duplicados
    DELETE FROM dbo.preReservasDeHorario WHERE MONTH(fechaReservada) = MONTH(GETDATE()) AND YEAR(fechaReservada) = YEAR(GETDATE());
    
    -- Crear clase programada para el mes actual
    IF NOT EXISTS (
        SELECT 1 FROM dbo.clasesProgramadas cp
        INNER JOIN dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
        WHERE MONTH(hcp.fechaDeLaClase) = MONTH(GETDATE()) AND YEAR(hcp.fechaDeLaClase) = YEAR(GETDATE())
    )
    BEGIN
        -- Insertar la clase programada
        INSERT INTO dbo.clasesProgramadas (fkClase, fkEntrenador, cupoMaximo, fkEstadoClaseProgramada)
        VALUES (@claseID, @entrenadorID, 20, @estadoClaseProgramada);
        
        DECLARE @idProgramacionClase INT = SCOPE_IDENTITY();
        
        -- Asignar horario a la clase programada (por ejemplo, 10:00 - 11:00)
        DECLARE @idHora INT = (
            SELECT TOP 1 idHora FROM dbo.horasLaborales 
            WHERE horaInicio = '10:00:00' AND horaFin = '11:00:00'
        );
        
        IF @idHora IS NOT NULL
        BEGIN
            INSERT INTO dbo.horariosDeClasesProgramadas (
                fkClaseProgramada, 
                fkHorarioLaboral, 
                fkEstadoHorarioClase, 
                fkEntrenador, 
                fechaDeLaClase
            )
            VALUES (
                @idProgramacionClase, 
                @idHora, 
                1, -- Asumiendo que 1 es el ID del estado "Disponible"
                @entrenadorID, 
                @fechaClase
            );
            
            PRINT '  Clase programada creada para el ' + CONVERT(VARCHAR, @fechaClase, 103) + ' a las 10:00 AM.';
        END
        ELSE
        BEGIN
            PRINT '  No se encontró la hora laboral 10:00-11:00. No se pudo asignar horario a la clase.';
        END
    END
    ELSE
    BEGIN
        PRINT '  Ya existen clases programadas para el mes actual.';
    END
    
    -- 1.5. Crear una pre-reserva para otro día del mes
    DECLARE @fechaPreReserva DATE = DATEADD(DAY, 5, @primerDiaMes);
    
    -- Obtener un ID de hora diferente para la pre-reserva
    DECLARE @idHoraPreReserva INT = (
        SELECT TOP 1 idHora FROM dbo.horasLaborales 
        WHERE horaInicio = '14:00:00' AND horaFin = '15:00:00'
    );
    
    IF @idHoraPreReserva IS NOT NULL
    BEGIN
        INSERT INTO dbo.preReservasDeHorario (
            fkHoraLaboral,
            fechaInicioDeLaReserva,
            fechaDeExpiracionDeLaReserva,
            idUsuarioQueReserva,
            fechaReservada
        )
        VALUES (
            @idHoraPreReserva,
            GETDATE(),
            DATEADD(DAY, 5, GETDATE()), -- Expira en 5 días
            @entrenadorID, -- Usando al entrenador como usuario que reserva
            @fechaPreReserva
        );
        
        PRINT '  Pre-reserva creada para el ' + CONVERT(VARCHAR, @fechaPreReserva, 103) + ' a las 14:00.';
    END
    ELSE
    BEGIN
        PRINT '  No se encontró la hora laboral 14:00-15:00. No se pudo crear la pre-reserva.';
    END
END

-- 2. Ejecutar la función para diferentes escenarios de prueba
PRINT '2. Ejecutando pruebas de la función fn_obtenerHorariosDisponibles:';

-- 2.1. Probar con la fecha actual
PRINT '  2.1. Obteniendo horarios disponibles para la fecha actual:';
SELECT TOP 10 * FROM dbo.fn_obtenerHorariosDisponibles(GETDATE());
PRINT '  (Mostrando solo los primeros 10 registros)';

-- 2.2. Probar con el primer día del mes siguiente
PRINT '  2.2. Obteniendo horarios disponibles para el primer día del mes siguiente:';
DECLARE @primerDiaMesSiguiente DATE = DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));
SELECT TOP 10 * FROM dbo.fn_obtenerHorariosDisponibles(@primerDiaMesSiguiente);
PRINT '  (Mostrando solo los primeros 10 registros)';

-- 2.3. Contar total de horarios disponibles para el mes actual
PRINT '  2.3. Contando total de horarios disponibles para el mes actual:';
SELECT COUNT(*) AS TotalHorariosDisponibles FROM dbo.fn_obtenerHorariosDisponibles(GETDATE());

-- 2.4. Verificar que se excluyen los días festivos marcados como "no se labora"
PRINT '  2.4. Verificando que se excluyen días festivos marcados como "no se labora":';
SELECT 
    dfd.fechaFestivaODescanso,
    dfd.descripcion,
    eal.nombreEstadoActividadLaboral,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM dbo.fn_obtenerHorariosDisponibles(dfd.fechaFestivaODescanso)
            WHERE CAST(FechaDisponible AS DATE) = dfd.fechaFestivaODescanso
        ) THEN 'DISPONIBLE - POSIBLE ERROR'
        ELSE 'NO DISPONIBLE - CORRECTO'
    END AS ResultadoEsperado
FROM 
    dbo.diasFestivosYDescansos dfd
    INNER JOIN dbo.estadosDeActividadLaboral eal ON dfd.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
WHERE 
    eal.nombreEstadoActividadLaboral = 'no se labora'
    AND MONTH(dfd.fechaFestivaODescanso) = MONTH(GETDATE())
    AND YEAR(dfd.fechaFestivaODescanso) = YEAR(GETDATE());

-- 2.5. Verificar que se excluyen las horas ya programadas para clases
PRINT '  2.5. Verificando que se excluyen horas ya programadas para clases:';
SELECT 
    hcp.fechaDeLaClase,
    hl.horaInicio,
    hl.horaFin,
    'CLASE PROGRAMADA' AS Estado,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM dbo.fn_obtenerHorariosDisponibles(hcp.fechaDeLaClase)
            WHERE 
                CAST(FechaDisponible AS DATE) = hcp.fechaDeLaClase
                AND idHora = hcp.fkHorarioLaboral
        ) THEN 'DISPONIBLE - POSIBLE ERROR'
        ELSE 'NO DISPONIBLE - CORRECTO'
    END AS ResultadoEsperado
FROM 
    dbo.horariosDeClasesProgramadas hcp
    INNER JOIN dbo.horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
WHERE 
    MONTH(hcp.fechaDeLaClase) = MONTH(GETDATE())
    AND YEAR(hcp.fechaDeLaClase) = YEAR(GETDATE());

-- 2.6. Verificar que se excluyen las horas con pre-reservas vigentes
PRINT '  2.6. Verificando que se excluyen horas con pre-reservas vigentes:';
SELECT 
    pr.fechaReservada,
    hl.horaInicio,
    hl.horaFin,
    'PRE-RESERVADA' AS Estado,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM dbo.fn_obtenerHorariosDisponibles(pr.fechaReservada)
            WHERE 
                CAST(FechaDisponible AS DATE) = pr.fechaReservada
                AND idHora = pr.fkHoraLaboral
        ) THEN 'DISPONIBLE - POSIBLE ERROR'
        ELSE 'NO DISPONIBLE - CORRECTO'
    END AS ResultadoEsperado
FROM 
    dbo.preReservasDeHorario pr
    INNER JOIN dbo.horasLaborales hl ON pr.fkHoraLaboral = hl.idHora
WHERE 
    MONTH(pr.fechaReservada) = MONTH(GETDATE())
    AND YEAR(pr.fechaReservada) = YEAR(GETDATE())
    AND GETDATE() BETWEEN pr.fechaInicioDeLaReserva AND pr.fechaDeExpiracionDeLaReserva;

PRINT '=== FIN DE PRUEBAS ==='; 