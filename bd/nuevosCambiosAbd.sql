use FitnessGymCenterDB 
-- NUEVOS CAMBIOS A LA BASE DE DATOS

-- 3. Tabla estadosDeClases
CREATE TABLE FitnessCenterDB.dbo.estadosDeClases (
    idEstadoClase INT PRIMARY KEY IDENTITY,
    nombreEstado NVARCHAR(50) NOT NULL,
    descripcionEstado NVARCHAR(MAX),
    fechaCreacion DATETIME DEFAULT GETDATE(),
    fechaModificacion DATETIME DEFAULT GETDATE()
);
ALTER TABLE FitnessCenterDB.dbo.Clases
ADD fkEstadoClase INT;

ALTER TABLE FitnessCenterDB.dbo.Clases
ADD CONSTRAINT FK_Clases_estadosDeClases 
FOREIGN KEY (fkEstadoClase) REFERENCES FitnessCenterDB.dbo.estadosDeClases(idEstadoClase);


-- 4. Tabla diasDeLaSemana
CREATE TABLE FitnessCenterDB.dbo.diasDeLaSemana (
    idDia INT PRIMARY KEY IDENTITY,
    nombreDia VARCHAR(10) NOT NULL,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FechaModificacion DATETIME DEFAULT GETDATE(),
    Activo BIT DEFAULT 1
);

-- 5. Tabla horasLaborales
CREATE TABLE FitnessCenterDB.dbo.horasLaborales (
    idHora INT PRIMARY KEY IDENTITY,
    horaInicio TIME NOT NULL,
    horaFin TIME NOT NULL,
    fechaCreacion DATETIME DEFAULT GETDATE(),
    fechaModificacion DATETIME DEFAULT GETDATE()
);

-- 6. Tabla años
CREATE TABLE FitnessCenterDB.dbo.años (
    idAño INT PRIMARY KEY IDENTITY,
    año INT NOT NULL,
    fechaCreacion DATETIME DEFAULT GETDATE(),
    fechaModificacion DATETIME DEFAULT GETDATE()
);

-- 7. Tabla de relación diasDeLaSemana_horasLaborales
CREATE TABLE FitnessCenterDB.dbo.diasDeLaSemana_horasLaborales (
    idHorarioLaboral INT PRIMARY KEY IDENTITY,
    fkDiaDeLaSemana INT NOT NULL,
    fkHoraLaboral INT NOT NULL,
    fkAño INT NOT NULL,
    CONSTRAINT FK_diasDeLaSemana_horasLaborales_diasDeLaSemana FOREIGN KEY (fkDiaDeLaSemana) REFERENCES FitnessCenterDB.dbo.diasDeLaSemana(idDia),
    CONSTRAINT FK_diasDeLaSemana_horasLaborales_horasLaborales FOREIGN KEY (fkHoraLaboral) REFERENCES FitnessCenterDB.dbo.horasLaborales(idHora),
    CONSTRAINT FK_diasDeLaSemana_horasLaborales_años FOREIGN KEY (fkAño) REFERENCES FitnessCenterDB.dbo.años(idAño),
    CONSTRAINT UQ_diasDeLaSemana_horasLaborales_Compuesto UNIQUE (fkDiaDeLaSemana, fkHoraLaboral, fkAño)
);

CREATE TABLE FitnessCenterDB.dbo.horariosDeClasesProgramadas (
    idHorarioDeClaseProgramada INT PRIMARY KEY IDENTITY,
    fkClaseProgramada INT NOT NULL,
    fkHorarioLaboral INT NOT NULL,
    CONSTRAINT FK_horariosDeClasesProgramadas_clasesProgramadas FOREIGN KEY (fkClaseProgramada) REFERENCES FitnessCenterDB.dbo.clasesProgramadas(idProgramacionClase),
    CONSTRAINT FK_horariosDeClasesProgramadas_diasDeLaSemana_horasLaborales FOREIGN KEY (fkHorarioLaboral) REFERENCES FitnessCenterDB.dbo.diasDeLaSemana_horasLaborales(idHorarioLaboral),
    CONSTRAINT UQ_horariosDeClasesProgramadas_Compuesto UNIQUE (fkClaseProgramada, fkHorarioLaboral)
);


-- 8. Tabla preReservasDeHorario
CREATE TABLE FitnessCenterDB.dbo.preReservasDeHorario (
    idPreReserva INT PRIMARY KEY IDENTITY,
    fkHorarioClaseProgramada INT NOT NULL,
    fechaInicioDeLaReserva DATETIME NOT NULL,
    fechaDeExpiracionDeLaReserva DATETIME NOT NULL,
    CONSTRAINT FK_preReservasDeHorario_horariosClasesProgramadas FOREIGN KEY (fkHorarioClaseProgramada) REFERENCES FitnessCenterDB.dbo.horariosDeClasesProgramadas(idHorarioDeClaseProgramada)
);

-- 12. Función para devolver ClaseId y nombreDeClase de la tabla clases
CREATE FUNCTION FitnessCenterDB.dbo.fn_obtenerClases()
RETURNS TABLE
AS
RETURN (
    SELECT ClaseID, NombreClase
    FROM FitnessCenterDB.dbo.Clases
);

-- 13. Vista v_nivelesDeDificultad
CREATE VIEW FitnessCenterDB.dbo.v_nivelesDeDificultad
AS
SELECT 
    idNivelDeDificultadDeClase,
    nombreNivelDeDificultad
FROM 
    FitnessCenterDB.dbo.nivelesDeDificultadDeClase;

-- 14. Vista v_nivelesDeIntensidad
CREATE VIEW FitnessCenterDB.dbo.v_nivelesDeIntensidad
AS
SELECT 
    idNivelDeIntensidad,
    nombreNivelDeIntensidad
FROM 
    FitnessCenterDB.dbo.nivelesDeIntensidadDeClase;

-- 15. Procedimiento almacenado para registrar horario de clase programada
CREATE PROCEDURE FitnessCenterDB.dbo.sp_registrarHorarioDeClaseProgramada
    @fkClaseProgramada INT,
    @fkHorarioLaboral INT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral)
    VALUES (@fkClaseProgramada, @fkHorarioLaboral);
    
    RETURN SCOPE_IDENTITY();
END;

-- 16. Tipos de datos personalizados para sp_registrarClaseProgramada
CREATE TYPE FitnessCenterDB.dbo.DatosHorarioClaseProgramada AS TABLE (
    fkHorarioLaboral INT
);

CREATE TYPE FitnessCenterDB.dbo.DatosClaseProgramada AS TABLE (
    fkClase INT,
    fechaInicio DATETIME,
    fechaFin DATETIME,
    fkEntrenador INT,
    cupoMaximo INT,
    fkEstadoClaseProgramada INT,
    horarios DatosHorarioClaseProgramada READONLY
);

-- Procedimiento almacenado para registrar clase programada
CREATE PROCEDURE FitnessCenterDB.dbo.sp_registrarClaseProgramada
    @datos DatosClaseProgramada READONLY,
    @horariosData DatosHorarioClaseProgramada READONLY
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @idClaseProgramada INT;
    DECLARE @fkClase INT, 
    @fechaInicio DATETIME,
     @fechaFin DATETIME,
      @fkEntrenador INT,
       @cupoMaximo INT, 
       @fkEstadoClaseProgramada INT;
    
    -- Obtener datos de la tabla DatosClaseProgramada
    SELECT TOP 1 
        @fkClase = fkClase,
        @fechaInicio = fechaInicio,
        @fechaFin = fechaFin,
        @fkEntrenador = fkEntrenador,
        @cupoMaximo = cupoMaximo,
        @fkEstadoClaseProgramada = fkEstadoClaseProgramada
    FROM @datos;
    
    -- Insertar en clasesProgramadas
    INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (
        fkClase, fechaInicio, fechaFin, fkEntrenador, cupoMaximo, fkEstadoClaseProgramada
    )
    VALUES (
        @fkClase, @fechaInicio, @fechaFin, @fkEntrenador, @cupoMaximo, @fkEstadoClaseProgramada
    );
    
    SET @idClaseProgramada = SCOPE_IDENTITY();
    
    -- Si hay datos de horarios, registrarlos
    IF EXISTS (SELECT 1 FROM @horariosData)
    BEGIN
        DECLARE @fkHorarioLaboral INT;
        DECLARE horarios_cursor CURSOR FOR SELECT fkHorarioLaboral FROM @horariosData;
        
        OPEN horarios_cursor;
        FETCH NEXT FROM horarios_cursor INTO @fkHorarioLaboral;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC FitnessCenterDB.dbo.sp_registrarHorarioDeClaseProgramada 
                @fkClaseProgramada = @idClaseProgramada,
                @fkHorarioLaboral = @fkHorarioLaboral;
                
            FETCH NEXT FROM horarios_cursor INTO @fkHorarioLaboral;
        END;
        
        CLOSE horarios_cursor;
        DEALLOCATE horarios_cursor;
    END;
    
    SELECT @idClaseProgramada AS IdClaseProgramada;
END;

-- 17. Función para validar disponibilidad de horario
CREATE FUNCTION FitnessCenterDB.dbo.fn_estaDisponibleElHorario(@idClaseProgramada INT)
RETURNS BIT
AS
BEGIN
    DECLARE @estaDisponible BIT = 1;
    
    -- Verificar si la clase programada tiene horarios asignados
    IF EXISTS (
        SELECT 1 
        FROM FitnessCenterDB.dbo.horariosDeClasesProgramadas 
        WHERE idHorarioDeClaseProgramada = @idHorarioDeClaseProgramada
    )
    BEGIN
        SET @estaDisponible = 0;
    END;
    
    -- Verificar si algún horario de la clase está pre-reservado
    IF EXISTS (
        SELECT 1 
        FROM FitnessCenterDB.dbo.preReservasDeHorario 
        WHERE fkHorarioDeClaseProgramada = @idHorarioDeClaseProgramada
        
    )
    BEGIN
        SET @estaDisponible = 0;
    END;
    
    RETURN @estaDisponible;
END;

-- 18. Procedimiento almacenado para pre-reservar horario
CREATE PROCEDURE dbo.sp_preReservarHorario
    @idHorarioDeClaseProgramada INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si el horario está disponible
    IF FitnessCenterDB.dbo.fn_estaDisponibleElHorario(@idHorarioDeClaseProgramada) = 1
    BEGIN
        -- Horario disponible, realizar la pre-reserva
        -- Por defecto, la pre-reserva expira después de 30 minutos
        INSERT INTO FitnessCenterDB.dbo.preReservasDeHorario (
            fkHorarioClaseProgramada,
            fechaInicioDeLaReserva,
            fechaDeExpiracionDeLaReserva
        )
        VALUES (
            @idHorarioDeClaseProgramada,
            GETDATE(),
            DATEADD(MINUTE, 5, GETDATE())
        );
        
        SELECT SCOPE_IDENTITY() AS IdPreReserva, 'Horario pre-reservado exitosamente' AS Mensaje;
    END
    ELSE
    BEGIN
        -- Horario no disponible
        SELECT 0 AS IdPreReserva, 'El horario seleccionado no está disponible' AS Mensaje;
    END;
END;

-- 19. Procedimiento almacenado para obtener horarios disponibles para clases programadas
CREATE OR ALTER PROCEDURE dbo.sp_obtenerHorariosDisponibles
    @Fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Si no se proporciona fecha, usar la fecha actual
    SET @Fecha = ISNULL(@Fecha, GETDATE());
    
    -- Generar todas las fechas del mes
    WITH FechasDelMes AS (
        SELECT
            DATEADD(DAY, n.number, DATEFROMPARTS(
                YEAR(@Fecha),
                MONTH(@Fecha),
                1)
            ) AS Fecha
        FROM
            master.dbo.spt_values n
        WHERE
            n.type = 'P'
            AND n.number BETWEEN 0 AND DATEDIFF(DAY,
                DATEFROMPARTS(YEAR(@Fecha), MONTH(@Fecha), 1),
                EOMONTH(@Fecha)
            )
    )
    SELECT
        DATENAME(dw, f.Fecha) AS DiaDeLaSemana,
        f.Fecha AS FechaDisponible,
        hl.horaInicio,
        hl.horaFin,
        hl.idHora,
        CASE WHEN DATENAME(dw, f.Fecha) IN ('Sábado', 'Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
    FROM
        FechasDelMes f
    CROSS JOIN dbo.horasLaborales hl
    -- Excluir las horas que están en horarios de clases programadas para esa fecha
    LEFT JOIN dbo.horariosDeClasesProgramadas hcp ON
        hl.idHora = hcp.fkHorarioLaboral AND
        f.Fecha = hcp.fechaDeLaClase
    -- Excluir las horas que están pre-reservadas para esa fecha
    LEFT JOIN dbo.preReservasDeHorario pr ON
        hl.idHora = pr.fkHoraLaboral AND
        f.Fecha = pr.fechaReservada AND
        GETDATE() BETWEEN pr.fechaInicioDeLaReserva AND pr.fechaDeExpiracionDeLaReserva
    -- Excluir los días festivos y descansos fijos
    LEFT JOIN dbo.diasFestivosYDescansos dfd ON
        f.Fecha = dfd.fechaFestivaODescanso
    LEFT JOIN dbo.estadosDeActividadLaboral eal ON
        dfd.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
    -- Verificación para días festivos variables
    LEFT JOIN dbo.diasFestivosVariables dfv ON
        1=1 -- Join cruzado para verificar cada día festivo variable
    LEFT JOIN dbo.estadosDeActividadLaboral eal2 ON
        dfv.fkEstadoActividadLaboral = eal2.idEstadoActividadLaboral
    WHERE
        -- No existe en horariosDeClasesProgramadas
        hcp.idHorarioDeClaseProgramada IS NULL
        -- No existe en preReservasDeHorario vigentes
        AND pr.idPreReserva IS NULL
        -- No es día festivo o de descanso fijo con estado "no se labora"
        AND (dfd.idDiaFestivo IS NULL OR eal.nombreEstadoActividadLaboral <> 'no se labora')
        -- No es día festivo variable con estado "no se labora"
        AND NOT EXISTS (
            SELECT 1
            FROM dbo.diasFestivosVariables dfv2
            INNER JOIN dbo.estadosDeActividadLaboral eal3 ON
                dfv2.fkEstadoActividadLaboral = eal3.idEstadoActividadLaboral
            INNER JOIN dbo.tiposDeRecurrenciaDeDiasFestivos tr ON
                dfv2.fkTipoDeRecurrenciaDelFestivo = tr.idTipoDeRecurrenciaDeDiaFestivo
            WHERE 
                eal3.nombreEstadoActividadLaboral = 'no se labora'
                AND dbo.fn_esDiaFestivoVariable(f.Fecha, dfv2.deQueDia, dfv2.deQueSemana, dfv2.deQueMes, tr.nombreTipoDeRecurrencia) = 1
        )
        -- La fecha no es anterior a la fecha actual
        AND f.Fecha >= CAST(GETDATE() AS DATE)
    ORDER BY
        f.Fecha,
        hl.horaInicio;
END;

-- Función para determinar si una fecha coincide con un día festivo variable
CREATE OR ALTER FUNCTION dbo.fn_esDiaFestivoVariable (
    @fechaAnalizada DATE,                   -- Fecha a comprobar
    @diaDeFechaVariable INT,                -- Interpretación según los parámetros disponibles
    @semanaDeFechaVariable INT = NULL,      -- Semana del mes (1-4) o semana del año (1-52)
    @mesDeFechaVariable INT = NULL,         -- Mes (1-12)
    @nombreTipoDeRecurrencia NVARCHAR(50) = NULL   -- 'relativo' o 'consecutivo', solo usado con día único
)
RETURNS BIT
AS
BEGIN
    DECLARE @resultado BIT = 0;
    DECLARE @anioActual INT = YEAR(@fechaAnalizada);
    
    -- CASO 1: Día, semana y mes tienen valor (ej: "el segundo lunes de enero")
    IF @diaDeFechaVariable IS NOT NULL 
       AND @semanaDeFechaVariable IS NOT NULL 
       AND @mesDeFechaVariable IS NOT NULL
       AND @diaDeFechaVariable BETWEEN 1 AND 7
       AND @semanaDeFechaVariable BETWEEN 1 AND 4
       AND @mesDeFechaVariable BETWEEN 1 AND 12
    BEGIN
        -- Solo proceder si la fecha analizada está en el mes especificado
        IF MONTH(@fechaAnalizada) = @mesDeFechaVariable
        BEGIN
            -- Primer día del mes especificado
            DECLARE @primerDiaMes DATE = DATEFROMPARTS(@anioActual, @mesDeFechaVariable, 1);
            
            -- Encontrar el primer día de la semana especificado (@diaDeFechaVariable) en el mes
            DECLARE @primerDiaDeSemanaEnMes DATE = @primerDiaMes;
            WHILE (DATEPART(dw, @primerDiaDeSemanaEnMes) != @diaDeFechaVariable)
            BEGIN
                SET @primerDiaDeSemanaEnMes = DATEADD(DAY, 1, @primerDiaDeSemanaEnMes);
            END
            
            -- Calcular el día festivo sumando las semanas necesarias
            DECLARE @diaFestivo DATE = DATEADD(WEEK, @semanaDeFechaVariable - 1, @primerDiaDeSemanaEnMes);
            
            -- Verificar que sigue estando en el mismo mes
            IF MONTH(@diaFestivo) = @mesDeFechaVariable
            BEGIN
                -- Comprobar si la fecha analizada coincide con el día festivo calculado
                IF @fechaAnalizada = @diaFestivo
                BEGIN
                    SET @resultado = 1;
                END
            END
        END
    END
    
    -- CASO 2: Día y semana tienen valor, mes es NULL (ej: "día 2 de la semana 15 del año")
    ELSE IF @diaDeFechaVariable IS NOT NULL 
            AND @semanaDeFechaVariable IS NOT NULL
            AND @mesDeFechaVariable IS NULL
            AND @diaDeFechaVariable BETWEEN 1 AND 7
            AND @semanaDeFechaVariable BETWEEN 1 AND 52
    BEGIN
        -- Primer día del año actual
        DECLARE @primerDiaAnio DATE = DATEFROMPARTS(@anioActual, 1, 1);
        
        -- Calcular la fecha de inicio de la semana especificada
        DECLARE @inicioDeSemana DATE = DATEADD(WEEK, @semanaDeFechaVariable - 1, @primerDiaAnio);
        
        -- Ajustar al primer día de la semana (asumiendo que 1 = domingo en DATEPART)
        WHILE (DATEPART(dw, @inicioDeSemana) != 1)
        BEGIN
            SET @inicioDeSemana = DATEADD(DAY, -1, @inicioDeSemana);
        END
        
        -- Calcular el día específico dentro de esa semana
        DECLARE @diaEspecifico DATE = DATEADD(DAY, @diaDeFechaVariable - 1, @inicioDeSemana);
        
        -- Verificar si coincide con la fecha analizada
        IF @fechaAnalizada = @diaEspecifico
        BEGIN
            SET @resultado = 1;
        END
    END
    
    -- CASO 3: Solo día tiene valor y el tipo es relativo (ej: "todos los martes")
    ELSE IF @diaDeFechaVariable IS NOT NULL 
            AND @semanaDeFechaVariable IS NULL
            AND @mesDeFechaVariable IS NULL
            AND @diaDeFechaVariable BETWEEN 1 AND 7
            AND @nombreTipoDeRecurrencia = 'relativo'
    BEGIN
        -- Verificar si el día de la semana coincide
        IF DATEPART(dw, @fechaAnalizada) = @diaDeFechaVariable
        BEGIN
            SET @resultado = 1;
        END
    END
    
    -- CASO 4: Solo día tiene valor y el tipo es consecutivo (ej: "día 100 del año")
    ELSE IF @diaDeFechaVariable IS NOT NULL 
            AND @semanaDeFechaVariable IS NULL
            AND @mesDeFechaVariable IS NULL
            AND @diaDeFechaVariable BETWEEN 1 AND 366
            AND @nombreTipoDeRecurrencia = 'consecutivo'
    BEGIN
        -- Calcular el día especificado dentro del año
        DECLARE @diaDelAnio DATE = DATEADD(DAY, @diaDeFechaVariable - 1, DATEFROMPARTS(@anioActual, 1, 1));
        
        -- Verificar si coincide con la fecha analizada
        IF @fechaAnalizada = @diaDelAnio
        BEGIN
            SET @resultado = 1;
        END
    END
    
    RETURN @resultado;
END;