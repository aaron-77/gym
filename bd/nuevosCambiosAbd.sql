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
CREATE PROCEDURE dbo.sp_registrarClaseProgramada
    @datos dbo.DatosClaseProgramada READONLY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @idClaseProgramada INT;
        DECLARE @fkClase INT, 
                @fkEntrenador INT,
                @cupoMaximo INT, 
                @fkEstadoClaseProgramada INT,
                @fkHorarioLaboralString NVARCHAR(MAX),
                @idPreReservaDeHorario INT,
               	@fechaDeLaClase DATE;

        -- se extraen los datos del parametro en variables indepedientes para facilitar su insercion posterioemnete
        SELECT TOP 1 
            @fkClase = fkClase,
            @fkEntrenador = fkEntrenador,
            @cupoMaximo = cupoMaximo,
            @fkEstadoClaseProgramada = fkEstadoClaseProgramada,
            @fkHorarioLaboralString = fkHoraLaboral,
            @idPreReservaDeHorario = idPreservaDeHorario,
            @fechaDeLaClase = fechaDeLaClase
        FROM @datos;

        -- Insertar en clasesProgramadas
        
        -- Si hay datos de horarios, registrarlos
        IF @fkHorarioLaboralString IS NOT NULL AND LEN(@fkHorarioLaboralString) > 0
        BEGIN
            DECLARE @horarioId INT;
            DECLARE @posicion INT = 1;
            DECLARE @longitud INT = LEN(@fkHorarioLaboralString);
            DECLARE @valorActual VARCHAR(20);
           	DECLARE @estaDisponibleElHorario BIT = 0;
			DECLARE @idsHorasLabotales IdsHorasLaborales;
            WHILE @posicion <= @longitud
            BEGIN
                -- Extraer el siguiente valor hasta la coma
                SET @valorActual = '';
                WHILE @posicion <= @longitud AND SUBSTRING(@fkHorarioLaboralString, @posicion, 1) != ','
                BEGIN
                    SET @valorActual = @valorActual + SUBSTRING(@fkHorarioLaboralString, @posicion, 1);
                    SET @posicion = @posicion + 1;
                END

                -- Saltar la coma
                SET @posicion = @posicion + 1;
				
                	-- Convertir a entero y validar
                	IF ISNUMERIC(@valorActual) = 1
                		BEGIN
                    	SET @horarioId = CAST(@valorActual AS INT);
						insert into @idsHorasLabotales(fkHoraLaboral) values(@horarioId);
                    	IF	dbo.fn_estaDisponibleElHorario(@fkClase,@fechaDeLaClase,@idsHorasLabotales) = 0
							BEGIN
			        			THROW 50001, 'El horario seleccionado no esta diponible', 1;
			    			END
				
                   		
                    	INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (
            				fkClase, fkEntrenador, cupoMaximo, fkEstadoClaseProgramada
        				)
				        VALUES (
				            @fkClase, @fkEntrenador, @cupoMaximo, @fkEstadoClaseProgramada
				        );

        			SET @idClaseProgramada = SCOPE_IDENTITY();

                    -- Registrar el horario
                    IF @horarioId > 0
                    BEGIN
                        EXEC FitnessCenterDB.dbo.sp_registrarHorarioDeClaseProgramada 
                            @fkClaseProgramada = @idClaseProgramada,
                            @fkHorarioLaboral = @horarioId;
                    END
                    ELSE
                    BEGIN
                    	THROW 50001, 'El id horario no es valido', 1;
                    END
                    
                END
            END
        END

        COMMIT TRANSACTION;

        SELECT @idClaseProgramada AS IdClaseProgramada;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
	
        DECLARE 
        @ProcName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
        @ErrorNumber INT = ERROR_NUMBER(),
        @ErrorSeverity INT = ERROR_SEVERITY(),
        @ErrorState INT = ERROR_STATE(),
        @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
        @ErrorLine INT = ERROR_LINE(); 
        
       EXEC sp_RegistrarError 
        @ProcName,
        @ErrorNumber,
        @ErrorSeverity,
        @ErrorState,
        @ErrorMessage,
        @ErrorLine; 
        
        -- Opcional: volver a lanzar el error para que el cliente lo reciba
        THROW;
    END CATCH
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
    -- Verificación para días festivos variables usando la función fn_esDiaFestivoVariable
    LEFT JOIN dbo.diasFestivosVariables dfv ON
        dbo.fn_esDiaFestivoVariable(f.Fecha, dfv.deQueDia, dfv.deQueSemana, dfv.deQueMes, dfv.fkTipoDeRecurrenciaDelFestivo) = 1
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
        AND (dfv.idDiaFestivoVariable IS NULL OR eal2.nombreEstadoActividadLaboral <> 'no se labora')
        -- La fecha no es anterior a la fecha actual
        AND f.Fecha >= CAST(GETDATE() AS DATE)
    ORDER BY
        f.Fecha,
        hl.horaInicio;
END;

-- Función para obtener el nombre del tipo de recurrencia
CREATE OR ALTER FUNCTION dbo.fn_obtenerNombreTipoDeRecurrencia (
    @idTipoDeRecurrencia INT
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @nombreTipoDeRecurrencia NVARCHAR(100);
    
    SELECT @nombreTipoDeRecurrencia = nombreTipoDeRecurrencia
    FROM dbo.tiposDeRecurrenciaDeDiasFestivos
    WHERE idTipoDeRecurrenciaDeDiaFestivo = @idTipoDeRecurrencia;
    
    RETURN @nombreTipoDeRecurrencia;
END;




ALTER FUNCTION dbo.fn_esDiaFestivoVariableVersionJoin (
    @fechaAnalizada DATE,                   -- Fecha a comprobar
    @diaDeFechaVariable INT,                -- Interpretación según los parámetros disponibles
    @semanaDeFechaVariable INT = NULL,      -- Semana del mes (1-4) o semana del año (1-52)
    @mesDeFechaVariable INT = NULL,         -- Mes (1-12)
    @idTipoDeRecurrencia INT = NULL         -- ID del tipo de recurrencia
)
RETURNS BIT
AS
BEGIN
-- ////TODO VALIDAR QUE EL NUMERO DE SEMANA SEA VALIDO PARA EL MES,EN ALGUNOS HAY SEMANA 5 PERO EN FEBRERO NO
-----//////////////////////////////////////////////////////////////////////
    DECLARE @resultado BIT = 0;
    DECLARE @anioActual INT = YEAR(@fechaAnalizada);
    DECLARE @nombreTipoDeRecurrencia NVARCHAR(50) = NULL;
    
    -- Obtener el nombre del tipo de recurrencia si se proporciona un ID
    IF @idTipoDeRecurrencia IS NOT NULL
    BEGIN
        SET @nombreTipoDeRecurrencia = dbo.fn_obtenerNombreTipoDeRecurrencia(@idTipoDeRecurrencia);
    END
    
    -- CASO 1:dia festivo anual con fecha variable (ej: "el segundo lunes de enero del año")
    IF @diaDeFechaVariable IS NOT NULL 
       AND @semanaDeFechaVariable IS NOT NULL 
       AND @mesDeFechaVariable IS NOT NULL
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
    

    -- CASO 2:  dia festivo de acuerdo a al numero consecutivo de la semana en el año (1-52),(ej: "día 2 de la semana 15 del año")
    ELSE IF @diaDeFechaVariable IS NOT NULL 
            AND @semanaDeFechaVariable IS NOT NULL
            AND @mesDeFechaVariable IS NULL
            AND @nombreTipoDeRecurrencia = 'diaSemana'
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

    --CASO 3 MENSUAL,un dia especifico de una semana especifica de cualquier mes

    IF @diaDeFechaVariable IS NOT NULL 
       AND @semanaDeFechaVariable IS NOT NULL 
       AND @mesDeFechaVariable IS  NULL
       AND @nombreTipoDeRecurrencia = 'mensual'
    BEGIN
        
        -- Primer día del mes especificado
        DECLARE @primerDiaMes DATE = DATEFROMPARTS(@anioActual, MONTH(GETDATE()), 1);
            
            -- Encontrar el primer día de la semana que sea igual a @diaDeFechaVariable en el mes
            DECLARE @primerDiaDeSemanaEnMes DATE = @primerDiaMes;
            WHILE (DATEPART(dw, @primerDiaDeSemanaEnMes) != @diaDeFechaVariable)
            BEGIN
                SET @primerDiaDeSemanaEnMes = DATEADD(DAY, 1, @primerDiaDeSemanaEnMes);
            END
            
            -- Calcular el día festivo sumando las semanas necesarias
            DECLARE @diaFestivo DATE = DATEADD(WEEK, @semanaDeFechaVariable - 1, @primerDiaDeSemanaEnMes);
            
             IF @fechaAnalizada = @diaFestivo
                BEGIN
                    SET @resultado = 1;
                END 
    END
    
    -- CASO 4 solo dia y mes tienen valor,la fecha festiva es mensual un dia espeficico del mes(dia 1-31) 
    ELSE IF   @diaDeFechaVariable IS NOT NULL 
               AND @mesDeFechaVariable IS NOT NULL 
               AND @semanaDeFechaVariable IS NULL
        BEGIN
            DECLARE @fechaFestiva = DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),@diaDeFechaVariable);
            IF @fechaFestiva = @fechaAnalizada
            BEGIN
                SET @resultado = 1;
            END   
        END
    
    -- CASO 5: Solo día tiene valor y el tipo es relativo (ej: "todos los martes")
    ELSE IF @diaDeFechaVariable IS NOT NULL 
            AND @semanaDeFechaVariable IS NULL
            AND @mesDeFechaVariable IS NULL
            AND @nombreTipoDeRecurrencia = 'diaRelativo'
    BEGIN
        -- Verificar si el día de la semana coincide
        IF DATEPART(dw, @fechaAnalizada) = @diaDeFechaVariable
        BEGIN
            SET @resultado = 1;
        END
    END
    
    -- CASO 6: Solo día tiene valor y el tipo es consecutivo (ej: "día 100 del año")
    ELSE IF @diaDeFechaVariable IS NOT NULL 
            AND @semanaDeFechaVariable IS NULL
            AND @mesDeFechaVariable IS NULL
            AND @nombreTipoDeRecurrencia = 'diaConsecutivo'
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

-- Función para determinar si una fecha es un día festivo variable utilizando solo la fecha como parámetro
CREATE OR ALTER FUNCTION dbo.fn_esDiaFestivoVariableVersionNormal (
    @fechaAnalizada DATE
)
RETURNS BIT
AS
BEGIN
    DECLARE @esDiaFestivo BIT = 0;
    
    -- Consultar si existe algún día festivo variable que coincida con la fecha analizada
    -- utilizando la función fn_esDiaFestivoVariable para cada registro en diasFestivosVariables
    IF EXISTS (
        SELECT 1
        FROM dbo.diasFestivosVariables dfv
        WHERE dbo.fn_esDiaFestivoVariableVersionJoin(
            @fechaAnalizada, 
            dfv.deQueDia, 
            dfv.deQueSemana, 
            dfv.deQueMes, 
            dfv.fkTipoDeRecurrenciaDelFestivo
        ) = 1
    )
    BEGIN
        SET @esDiaFestivo = 1;
    END
    
    RETURN @esDiaFestivo;
END;


CREATE FUNCTION dbo.fn_consultarHorariosPreReservados(@fechaTentativa DATE)
RETURNS TABLE
AS
RETURN (
    SELECT 
    pr.idPreReserva,
    pr.fechaReservada,
    hl.horaInicio,
    hl.horaFin,
    idUsuarioQueReserva,
    pr.fechaDeExpiracionDeLaReserva
    FROM FitnessCenterDB.dbo.preReservasDeHorario pr
    LEFT JOIN dbo.horasLaborales hl
        ON pr.fkHoraLaboral = hl.idHora
    WHERE (pr.fechaReservada >= @fechaTentativa and pr.fechaReservada >= GETDATE())
);

-- Paso 1: Eliminar las claves foráneas existentes que referencian a la tabla Usuarios

IF OBJECT_ID('FK__Citas__Entrenado__44FF419A', 'F') IS NOT NULL
    ALTER TABLE FitnessCenterDB.dbo.Citas DROP CONSTRAINT FK__Citas__Entrenado__44FF419A;
IF OBJECT_ID('FK__Citas__UsuarioID__440B1D61', 'F') IS NOT NULL
    ALTER TABLE FitnessCenterDB.dbo.Citas DROP CONSTRAINT FK__Citas__UsuarioID__440B1D61;
IF OBJECT_ID('FK__Clases__Instruct__5AEE82B9', 'F') IS NOT NULL
    ALTER TABLE FitnessCenterDB.dbo.Clases DROP CONSTRAINT FK__Clases__Instruct__5AEE82B9;
IF OBJECT_ID('FK__Pagos__UsuarioID__6383C8BA', 'F') IS NOT NULL
    ALTER TABLE FitnessCenterDB.dbo.Pagos DROP CONSTRAINT FK__Pagos__UsuarioID__6383C8BA;
IF OBJECT_ID('FK__Rutinas__Entrena__4AB81AF0', 'F') IS NOT NULL
    ALTER TABLE FitnessCenterDB.dbo.Rutinas DROP CONSTRAINT FK__Rutinas__Entrena__4AB81AF0;
IF OBJECT_ID('FK__Rutinas__Usuario__49C3F6B7', 'F') IS NOT NULL
    ALTER TABLE FitnessCenterDB.dbo.Rutinas DROP CONSTRAINT FK__Rutinas__Usuario__49C3F6B7;
IF OBJECT_ID('FK_ClasesProgramadas_Usuarios', 'F') IS NOT NULL
    ALTER TABLE FitnessCenterDB.dbo.clasesProgramadas DROP CONSTRAINT FK_ClasesProgramadas_Usuarios;
IF OBJECT_ID('FK_InscripcionesDeClases_Cliente', 'F') IS NOT NULL
    ALTER TABLE FitnessCenterDB.dbo.inscripcionesDeClases DROP CONSTRAINT FK_InscripcionesDeClases_Cliente;
IF OBJECT_ID('FK_UsuarioMedida', 'F') IS NOT NULL
    ALTER TABLE FitnessCenterDB.dbo.medidas DROP CONSTRAINT FK_UsuarioMedida;
IF OBJECT_ID('FK_Metas_Usuarios', 'F') IS NOT NULL
    ALTER TABLE FitnessCenterDB.dbo.metas DROP CONSTRAINT FK_Metas_Usuarios;
IF OBJECT_ID('FK__Registros__Usuar__6EF57B66', 'F') IS NOT NULL
    ALTER TABLE FitnessCenterDB.dbo.RegistrosEntrenamiento DROP CONSTRAINT FK__Registros__Usuar__6EF57B66;
IF OBJECT_ID('fk_usuarios_horariosClasesProgramadas', 'F') IS NOT NULL
    ALTER TABLE FitnessCenterDB.dbo.horariosDeClasesProgramadas DROP CONSTRAINT fk_usuarios_horariosClasesProgramadas;

-- Paso 2: Agregar nuevas columnas en las tablas para referenciar a AspNetUsers.Id

ALTER TABLE FitnessCenterDB.dbo.Citas
ADD NewUserId nvarchar(450) NULL,
    NewEntrenadorId nvarchar(450) NULL;

ALTER TABLE FitnessCenterDB.dbo.Clases
ADD NewInstructorId nvarchar(450) NULL;

ALTER TABLE FitnessCenterDB.dbo.Rutinas
ADD NewUserId nvarchar(450) NULL,
    NewEntrenadorId nvarchar(450) NULL;

ALTER TABLE FitnessCenterDB.dbo.Pagos
ADD NewUserId nvarchar(450) NULL;

ALTER TABLE FitnessCenterDB.dbo.clasesProgramadas
ADD NewFkEntrenador nvarchar(450) NULL;

ALTER TABLE FitnessCenterDB.dbo.inscripcionesDeClases
ADD NewFkCliente nvarchar(450) NULL;

ALTER TABLE FitnessCenterDB.dbo.medidas
ADD NewFkUsuario nvarchar(450) NULL;

ALTER TABLE FitnessCenterDB.dbo.metas
ADD NewFkUsuario nvarchar(450) NULL;

ALTER TABLE FitnessCenterDB.dbo.RegistrosEntrenamiento
ADD NewUserId nvarchar(450) NULL;

ALTER TABLE FitnessCenterDB.dbo.horariosDeClasesProgramadas
ADD NewFkEntrenador nvarchar(450) NULL;

-- Paso 3: Actualizar las nuevas columnas (ESTO REQUIERE TU LÓGICA DE MIGRACIÓN DE DATOS)
-- Ejemplo: Asumiendo que tienes una forma de mapear UsuarioID a AspNetUsers.Id
-- Por ejemplo, si los IDs de AspNetUsers se guardaron temporalmente en la tabla Usuarios

UPDATE c
SET c.NewUserId = au.Id
FROM FitnessCenterDB.dbo.Citas c
JOIN FitnessCenterDB.dbo.Usuarios u ON c.UsuarioID = u.UsuarioID
JOIN FitnessCenterDB.dbo.AspNetUsers au ON u.Email = au.Email;

UPDATE c
SET c.NewEntrenadorId = au.Id
FROM FitnessCenterDB.dbo.Citas c
JOIN FitnessCenterDB.dbo.Usuarios u ON c.EntrenadorID = u.UsuarioID
JOIN FitnessCenterDB.dbo.AspNetUsers au ON u.Email = au.Email;

UPDATE cl
SET cl.NewInstructorId = au.Id
FROM FitnessCenterDB.dbo.Clases cl
JOIN FitnessCenterDB.dbo.Usuarios u ON cl.InstructorID = u.UsuarioID
JOIN FitnessCenterDB.dbo.AspNetUsers au ON u.Email = au.Email;

UPDATE r
SET r.NewUserId = au.Id
FROM FitnessCenterDB.dbo.Rutinas r
JOIN FitnessCenterDB.dbo.Usuarios u ON r.UsuarioID = u.UsuarioID
JOIN FitnessCenterDB.dbo.AspNetUsers au ON u.Email = au.Email;

UPDATE r
SET r.NewEntrenadorId = au.Id
FROM FitnessCenterDB.dbo.Rutinas r
JOIN FitnessCenterDB.dbo.Usuarios u ON r.EntrenadorID = u.UsuarioID
JOIN FitnessCenterDB.dbo.AspNetUsers au ON u.Email = au.Email;

UPDATE p
SET p.NewUserId = au.Id
FROM FitnessCenterDB.dbo.Pagos p
JOIN FitnessCenterDB.dbo.Usuarios u ON p.UsuarioID = u.UsuarioID
JOIN FitnessCenterDB.dbo.AspNetUsers au ON u.Email = au.Email;

UPDATE cp
SET cp.NewFkEntrenador = au.Id
FROM FitnessCenterDB.dbo.clasesProgramadas cp
JOIN FitnessCenterDB.dbo.Usuarios u ON cp.fkEntrenador = u.UsuarioID
JOIN FitnessCenterDB.dbo.AspNetUsers au ON u.Email = au.Email;

UPDATE ic
SET ic.NewFkCliente = au.Id
FROM FitnessCenterDB.dbo.inscripcionesDeClases ic
JOIN FitnessCenterDB.dbo.Usuarios u ON ic.fkCliente = u.UsuarioID
JOIN FitnessCenterDB.dbo.AspNetUsers au ON u.Email = au.Email;

UPDATE m
SET m.NewFkUsuario = au.Id
FROM FitnessCenterDB.dbo.medidas m
JOIN FitnessCenterDB.dbo.Usuarios u ON m.fkUsuario = u.UsuarioID
JOIN FitnessCenterDB.dbo.AspNetUsers au ON u.Email = au.Email;

UPDATE met
SET met.NewFkUsuario = au.Id
FROM FitnessCenterDB.dbo.metas met
JOIN FitnessCenterDB.dbo.Usuarios u ON met.fkUsuario = u.UsuarioID
JOIN FitnessCenterDB.dbo.AspNetUsers au ON u.Email = au.Email;

UPDATE re
SET re.NewUserId = au.Id
FROM FitnessCenterDB.dbo.RegistrosEntrenamiento re
JOIN FitnessCenterDB.dbo.Usuarios u ON re.UsuarioID = u.UsuarioID
JOIN FitnessCenterDB.dbo.AspNetUsers au ON u.Email = au.Email;

UPDATE hcp
SET hcp.NewFkEntrenador = au.Id
FROM FitnessCenterDB.dbo.horariosDeClasesProgramadas hcp
JOIN FitnessCenterDB.dbo.Usuarios u ON hcp.fkEntrenador = u.UsuarioID
JOIN FitnessCenterDB.dbo.AspNetUsers au ON u.Email = au.Email;

-- Repetir para todas las tablas afectadas

-- Paso 4: Agregar las nuevas claves foráneas a AspNetUsers.Id

ALTER TABLE FitnessCenterDB.dbo.Citas
ADD CONSTRAINT FK_Citas_AspNetUsers_NewUserId FOREIGN KEY (NewUserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE NO ACTION;

ALTER TABLE FitnessCenterDB.dbo.Citas
ADD CONSTRAINT FK_Citas_AspNetUsers_NewEntrenadorId FOREIGN KEY (NewEntrenadorId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE NO ACTION;

ALTER TABLE FitnessCenterDB.dbo.Clases
ADD CONSTRAINT FK_Clases_AspNetUsers_NewInstructorId FOREIGN KEY (NewInstructorId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE NO ACTION;

ALTER TABLE FitnessCenterDB.dbo.Rutinas
ADD CONSTRAINT FK_Rutinas_AspNetUsers_NewUserId FOREIGN KEY (NewUserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE NO ACTION;

ALTER TABLE FitnessCenterDB.dbo.Rutinas
ADD CONSTRAINT FK_Rutinas_AspNetUsers_NewEntrenadorId FOREIGN KEY (NewEntrenadorId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE NO ACTION;

ALTER TABLE FitnessCenterDB.dbo.Pagos
ADD CONSTRAINT FK_Pagos_AspNetUsers_NewUserId FOREIGN KEY (NewUserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE NO ACTION;

ALTER TABLE FitnessCenterDB.dbo.clasesProgramadas
ADD CONSTRAINT FK_ClasesProgramadas_AspNetUsers_NewFkEntrenador FOREIGN KEY (NewFkEntrenador) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE NO ACTION;

ALTER TABLE FitnessCenterDB.dbo.inscripcionesDeClases
ADD CONSTRAINT FK_InscripcionesDeClases_AspNetUsers_NewFkCliente FOREIGN KEY (NewFkCliente) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE NO ACTION;

ALTER TABLE FitnessCenterDB.dbo.medidas
ADD CONSTRAINT FK_Medidas_AspNetUsers_NewFkUsuario FOREIGN KEY (NewFkUsuario) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE NO ACTION;

ALTER TABLE FitnessCenterDB.dbo.metas
ADD CONSTRAINT FK_Metas_AspNetUsers_NewFkUsuario FOREIGN KEY (NewFkUsuario) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE NO ACTION;

ALTER TABLE FitnessCenterDB.dbo.RegistrosEntrenamiento
ADD CONSTRAINT FK_RegistrosEntrenamiento_AspNetUsers_NewUserId FOREIGN KEY (NewUserId) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE NO ACTION;

ALTER TABLE FitnessCenterDB.dbo.horariosDeClasesProgramadas
ADD CONSTRAINT FK_HorariosDeClasesProgramadas_AspNetUsers_NewFkEntrenador FOREIGN KEY (NewFkEntrenador) REFERENCES FitnessCenterDB.dbo.AspNetUsers(Id) ON DELETE NO ACTION;

-- Paso 5: Eliminar las columnas antiguas de las tablas, sin eliminar los registros asociados.

ALTER TABLE FitnessCenterDB.dbo.Citas
DROP COLUMN UsuarioID, COLUMN EntrenadorID;

ALTER TABLE FitnessCenterDB.dbo.Clases
DROP COLUMN InstructorID;

ALTER TABLE FitnessCenterDB.dbo.Rutinas
DROP COLUMN UsuarioID, COLUMN EntrenadorID;

ALTER TABLE FitnessCenterDB.dbo.Pagos
DROP COLUMN UsuarioID;

ALTER TABLE FitnessCenterDB.dbo.clasesProgramadas
DROP COLUMN fkEntrenador;

ALTER TABLE FitnessCenterDB.dbo.inscripcionesDeClases
DROP COLUMN fkCliente;

ALTER TABLE FitnessCenterDB.dbo.medidas
DROP COLUMN fkUsuario;

ALTER TABLE FitnessCenterDB.dbo.metas
DROP COLUMN fkUsuario;

ALTER TABLE FitnessCenterDB.dbo.RegistrosEntrenamiento
DROP COLUMN UsuarioID;

ALTER TABLE FitnessCenterDB.dbo.horariosDeClasesProgramadas
DROP COLUMN fkEntrenador;

-- Paso 6: Eliminar la tabla Usuarios si ya no se necesita
-- DROP TABLE FitnessCenterDB.dbo.Usuarios;

-- Paso 7: Renombrar las nuevas columnas para que coincidan con los nombres originales (opcional)

EXEC sp_rename 'FitnessCenterDB.dbo.Citas.NewUserId', 'UserId', 'COLUMN';
EXEC sp_rename 'FitnessCenterDB.dbo.Citas.NewEntrenadorId', 'EntrenadorId', 'COLUMN';
EXEC sp_rename 'FitnessCenterDB.dbo.Clases.NewInstructorId', 'InstructorId', 'COLUMN';
EXEC sp_rename 'FitnessCenterDB.dbo.Rutinas.NewUserId', 'UserId', 'COLUMN';
EXEC sp_rename 'FitnessCenterDB.dbo.Rutinas.NewEntrenadorId', 'EntrenadorId', 'COLUMN';
EXEC sp_rename 'FitnessCenterDB.dbo.Pagos.NewUserId', 'UserId', 'COLUMN';
EXEC sp_rename 'FitnessCenterDB.dbo.clasesProgramadas.NewFkEntrenador', 'fkEntrenador', 'COLUMN';
EXEC sp_rename 'FitnessCenterDB.dbo.inscripcionesDeClases.NewFkCliente', 'fkCliente', 'COLUMN';
EXEC sp_rename 'FitnessCenterDB.dbo.medidas.NewFkUsuario', 'fkUsuario', 'COLUMN';
EXEC sp_rename 'FitnessCenterDB.dbo.metas.NewFkUsuario', 'fkUsuario', 'COLUMN';
EXEC sp_rename 'FitnessCenterDB.dbo.RegistrosEntrenamiento.NewUserId', 'UserId', 'COLUMN';
EXEC sp_rename 'FitnessCenterDB.dbo.horariosDeClasesProgramadas.NewFkEntrenador', 'fkEntrenador', 'COLUMN'