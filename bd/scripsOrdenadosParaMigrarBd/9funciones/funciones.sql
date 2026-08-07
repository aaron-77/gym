/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR$SQLEXPRESS at 01/23/2026 17:26:27
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.esDiaFestivo(@fechaAnalizada date)
RETURNS INT
AS 
BEGIN
	DECLARE @estaDiaFestivo BIT = 0;

	IF dbo.esDiaFestivoEstatico(@fechaAnalizada) = 1
	BEGIN 
		SET @estaDiaFestivo = 1;
	END
	
	IF dbo.fn_esDiaFestivoVariableVersionNormal(@fechaAnalizada) = 1
	BEGIN 
		SET @estaDiaFestivo = 1;
	END
	
	RETURN @estaDiaFestivo;
    
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.esDiaFestivoEstatico(@fechaAnalizada DATE)
RETURNS INT
AS 
BEGIN
	DECLARE @estaDiaFestivoEstatico BIT = 0;

	IF (
	select 1 
	FROM diasFestivosYDescansos dfy 
	JOIN estadosDeActividadLaboral edal 
	ON dfy.fkEstadoActividadLaboral = edal.idEstadoActividadLaboral
	WHERE fechaFestivaODescanso = @fechaAnalizada 
		AND edal.nombreEstadoActividadLaboral = 'no se labora'
	) = 1
	BEGIN 
		SET @estaDiaFestivoEstatico = 1;
	END
	RETURN @estaDiaFestivoEstatico;
    
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION dbo.fn_consultarHorariosPreReservados(@fechaTentativa DATE)
RETURNS TABLE
AS
RETURN (
    
	
	SELECT 
    pr.idPreReserva,
    pr.fechaReservada,
    hl.idHora,
    hl.horaInicio,
    hl.horaFin,
    idUsuarioQueReserva,
    pr.fechaDeExpiracionDeLaReserva
    FROM FitnessCenterDB.dbo.preReservasDeHorario pr
    LEFT JOIN dbo.horasLaborales hl
        ON pr.fkHoraLaboral = hl.idHora
    WHERE (
pr.fechaReservada >= @fechaTentativa 
and pr.fechaReservada >= DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),DAY(GETDATE()))
and (GETDATE() BETWEEN pr.fechaInicioDeLaReserva AND pr.fechaDeExpiracionDeLaReserva)
 )   
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_cupoDisponibleClaseProgramada
(
    @idProgramacionClase INT
)
RETURNS INT
AS
BEGIN
    DECLARE @cupoMaximo INT;
    DECLARE @inscritos INT;
    DECLARE @cupoDisponible INT;

    -- Obtener el cupo máximo de la clase programada
    SELECT @cupoMaximo = cupoMaximo
    FROM clasesProgramadas
    WHERE idProgramacionClase = @idProgramacionClase;

    -- Contar la cantidad de inscritos vigentes (no cancelados) a la clase programada
    SELECT @inscritos = COUNT(*)
    FROM inscripcionesDeClases ic
    INNER JOIN estadosInscripciones ei ON ic.fkEstadoInscripcion = ei.idEstadoInscripcion
    WHERE ic.fkProgramacionClase = @idProgramacionClase
      AND LOWER(ei.nombreEstadoInscripcion) = 'vigente';

    -- Calcular cupo disponible
    SET @cupoDisponible = @cupoMaximo - @inscritos;

    RETURN @cupoDisponible;
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION dbo.fn_encontrarPreReservasCaducadas()
RETURNS table
AS 
return
(
	select idPreReserva 
	from preReservasDeHorario 
	where GETDATE() NOT BETWEEN fechaInicioDeLaReserva and fechaDeExpiracionDeLaReserva
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_esDiaFestivoVariableVersionJoin (
    @fechaAnalizada DATE,                   -- Fecha a comprobar
    @diaDeFechaVariable INT,                -- Interpretación según los parámetros disponibles
    @semanaDeFechaVariable INT = NULL,      -- Semana del mes (1-4) o semana del año (1-52)
    @mesDeFechaVariable INT = NULL,         -- Mes (1-12)
    @idTipoDeRecurrencia INT = NULL         -- ID del tipo de recurrencia
)
RETURNS nvarchar(max)
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
            DECLARE @primerDiaMes_caso1 DATE = DATEFROMPARTS(@anioActual, @mesDeFechaVariable, 1);
            
            -- Encontrar el primer día de la semana especificado (@diaDeFechaVariable) en el mes
            DECLARE @primerDiaSemanaEnMes_caso1 DATE = @primerDiaMes_caso1;
            WHILE (DATEPART(dw, @primerDiaSemanaEnMes_caso1) != @diaDeFechaVariable)
            BEGIN
                SET @primerDiaSemanaEnMes_caso1 = DATEADD(DAY, 1, @primerDiaSemanaEnMes_caso1);
            END
            
            -- Calcular el día festivo sumando las semanas necesarias
            DECLARE @diaFestivo_caso1 DATE = DATEADD(WEEK, @semanaDeFechaVariable - 1, @primerDiaSemanaEnMes_caso1);
            
            -- Verificar que sigue estando en el mismo mes
            IF MONTH(@diaFestivo_caso1) = @mesDeFechaVariable
            BEGIN
                -- Comprobar si la fecha analizada coincide con el día festivo calculado
                IF @fechaAnalizada = @diaFestivo_caso1
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
        DECLARE @primerDiaAnio_caso2 DATE = DATEFROMPARTS(@anioActual, 1, 1);
        
        -- Calcular la fecha de inicio de la semana especificada
        DECLARE @inicioDeSemana_caso2 DATE = DATEADD(WEEK, @semanaDeFechaVariable - 1, @primerDiaAnio_caso2);
        
        -- Ajustar al primer día de la semana (asumiendo que 1 = domingo en DATEPART)
        WHILE (DATEPART(dw, @inicioDeSemana_caso2) != 1)
        BEGIN
            SET @inicioDeSemana_caso2 = DATEADD(DAY, -1, @inicioDeSemana_caso2);
        END
        
        -- Calcular el día específico dentro de esa semana
        DECLARE @diaEspecifico_caso2 DATE = DATEADD(DAY, @diaDeFechaVariable - 1, @inicioDeSemana_caso2);
        
        -- Verificar si coincide con la fecha analizada
        IF @fechaAnalizada = @diaEspecifico_caso2
        BEGIN
            SET @resultado = 1;
        END
    END

    --CASO 3 MENSUAL,un dia especifico de una semana especifica de cualquier mes
    ELSE IF @diaDeFechaVariable IS NOT NULL 
       AND @semanaDeFechaVariable IS NOT NULL 
       AND @mesDeFechaVariable IS NULL
       AND @nombreTipoDeRecurrencia = 'mensual'
    BEGIN
	        
        -- Primer día del mes especificado
        DECLARE @primerDiaMes_caso3 DATE = DATEFROMPARTS(@anioActual, MONTH(@fechaAnalizada), 1);
            

	       
       	-- Encontrar el primer día de la semana que sea igual a @diaDeFechaVariable en el mes
            DECLARE @primerDiaSemanaEnMes_caso3 DATE = @primerDiaMes_caso3;

           WHILE (DATEPART(dw, @primerDiaSemanaEnMes_caso3) != @diaDeFechaVariable)
            BEGIN
                SET @primerDiaSemanaEnMes_caso3 = DATEADD(DAY, 1, @primerDiaSemanaEnMes_caso3);
            END
                       
        
            -- Calcular el día festivo sumando las semanas necesarias
            DECLARE @diaFestivo_caso3 DATE = DATEADD(WEEK, @semanaDeFechaVariable - 1, @primerDiaSemanaEnMes_caso3);
        
        --RETURN CONVERT(NVARCHAR(10), @diaFestivo_caso3, 23) + CONVERT(NVARCHAR(10), @fechaAnalizada, 23);
           IF @fechaAnalizada = @diaFestivo_caso3
                BEGIN
	    
                    SET @resultado = 1;
                END 
        
            
    END
    
    -- CASO 4 solo dia y mes tienen valor,la fecha festiva es mensual 
    --un dia espeficico de cualquier mes(dia 1-31) 
    ELSE IF @diaDeFechaVariable IS NOT NULL 
               AND @mesDeFechaVariable IS NULL 
               AND @semanaDeFechaVariable IS NULL
               AND @nombreTipoDeRecurrencia = 'mensual'
        BEGIN
            DECLARE @fechaFestiva_caso4 DATE = DATEFROMPARTS(YEAR(@fechaAnalizada), MONTH(@fechaAnalizada), @diaDeFechaVariable);
            IF @fechaFestiva_caso4 = @fechaAnalizada
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
        DECLARE @diaDelAnio_caso6 DATE = DATEADD(DAY, @diaDeFechaVariable - 1, DATEFROMPARTS(@anioActual, 1, 1));
        
        -- Verificar si coincide con la fecha analizada
        IF @fechaAnalizada = @diaDelAnio_caso6
        BEGIN
            SET @resultado = 1;
        END
    END
    
    RETURN @resultado;
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION dbo.fn_esDiaFestivoVariableVersionNormal (
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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_estaDisponibleElHorario(
	@fechaReservada date,
	@fksHorasKaborales IdsHorasLaborales READONLY
	)
RETURNS BIT
AS
BEGIN
    DECLARE @estaDisponible BIT = 1;
    
    -- Verificar si la clase programada tiene horarios asignados
   
   
   IF dbo.yaExisteClaseProgramada(@fechaReservada,@fksHorasKaborales) = 1
			
    BEGIN
        SET @estaDisponible = 0;
	END;
	
    -- Verificar si algún horario de la clase está pre-reservado
    
   IF dbo.yaExistePreRegistroDeClase(@fechaReservada,@fksHorasKaborales) = 1
    BEGIN
        SET @estaDisponible = 0;
    END;
   
	   
    RETURN @estaDisponible;
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_estaVigenteLaPreReserva(@idPreReserva int)
RETURNS BIT
AS 
BEGIN
	declare @estaVigente bit = 1;

	if not exists (
		select 1 
		from preReservasDeHorario prdh 
		where idPreReserva = @idPreReserva 
		and GETDATE() BETWEEN prdh.fechaInicioDeLaReserva and prdh.fechaDeExpiracionDeLaReserva
	)
	BEGIN 
		set @estaVigente = 0;
	END
	return @estaVigente;
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION fn_inscripcionEstaVigente(@idInscripcion INT)
RETURNS BIT
AS
BEGIN
    DECLARE @estadoInscripcion INT;
    DECLARE @resultado BIT; -- Nueva variable para almacenar el resultado

    -- Obtener el estado de la inscripción
    SELECT @estadoInscripcion = fkEstadoInscripcion
    FROM FitnessCenterDB.dbo.inscripcionesDeClases
    WHERE idInscripcion = @idInscripcion;

    -- Comparar con el estado vigente y almacenar el resultado
    IF @estadoInscripcion = (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase)
    BEGIN
        SET @resultado = 1; -- true
    END
    ELSE
    BEGIN
        SET @resultado = 0; -- false
    END

    RETURN @resultado; -- Devolver el resultado
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION fn_obtenerClases()
RETURNS TABLE
AS
RETURN (
    SELECT ClaseID, NombreClase
    FROM FitnessCenterDB.dbo.Clases
    where fkEstadoClase = (select idEstadoClase from v_estadoActivoClases)
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_obtenerClasesProgramadaPorIdProgramacionClase(@idProgramacionClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        cp.idProgramacionClase AS idClaseProgramada,
        cp.fkClase,
        cp.cupoMaximo,
        (SELECT dbo.fn_cupoDisponibleClaseProgramada(cp.idProgramacionClase)) as cupoDisponible,
        cp.fechaDeLaClase,
        hl.idHora,
        hl.horaInicio,
        hl.horaFin,
        CONCAT(CONVERT(varchar(5), hl.horaInicio, 108), ' - ', CONVERT(varchar(5), hl.horaFin, 108)) AS labelHorario,
        cp.fkEntrenador,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreEntrenador
    FROM clasesProgramadas cp
    INNER JOIN horariosDeClasesProgramadas hcp 
        ON cp.idProgramacionClase = hcp.fkClaseProgramada
    INNER JOIN horasLaborales hl 
        ON hcp.fkHorarioLaboral = hl.idHora
    LEFT JOIN AspNetUsers u 
        ON cp.fkEntrenador = u.Id
    WHERE cp.idProgramacionClase = @idProgramacionClase
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Modified function adapted to schema V6
CREATE   FUNCTION dbo.fn_obtenerClasesProgramadaPorIdProgramacionClase_v6(@idProgramacionClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        cp.idProgramacionClase AS idClaseProgramada,
        cp.fkClase,
        cp.cupoMaximo,
        (SELECT dbo.fn_cupoDisponibleClaseProgramada(cp.idProgramacionClase)) as cupoDisponible,
        cp.fechaDeLaClase,
        hl.idHora,
        hl.horaInicio,
        hl.horaFin,
        CONCAT(CONVERT(varchar(5), hl.horaInicio, 108), ' - ', CONVERT(varchar(5), hl.horaFin, 108)) AS labelHorario,
        cp.fkEntrenador,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreEntrenador
    FROM dbo.clasesProgramadas cp
    INNER JOIN dbo.horariosDeClasesProgramadas hcp 
        ON cp.idProgramacionClase = hcp.fkClaseProgramada
    INNER JOIN dbo.horasLaborales hl 
        ON hcp.fkHorarioLaboral = hl.idHora
    LEFT JOIN dbo.AspNetUsers u 
        ON cp.fkEntrenador = u.Id
    WHERE cp.idProgramacionClase = @idProgramacionClase
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_obtenerClasesProgramadasPorIdClase(@idClase INT, @fechaReferencia DATE = NULL)
RETURNS TABLE
AS
RETURN
(
    SELECT
        cp.idProgramacionClase AS idClaseProgramada,
        cp.fkClase,
        cp.cupoMaximo,
        (SELECT dbo.fn_cupoDisponibleClaseProgramada(cp.idProgramacionClase)) as cupoDisponible,
        cp.fechaDeLaClase,
        hl.idHora,
        hl.horaInicio,
        hl.horaFin,
        CONCAT(CONVERT(varchar(10), hl.horaInicio, 108), ' - ', CONVERT(varchar(10), hl.horaFin, 108)) AS labelHorario,
        cp.fkEntrenador,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreEntrenador
    FROM clasesProgramadas cp
        INNER JOIN horariosDeClasesProgramadas hcp 
            ON cp.idProgramacionClase = hcp.fkClaseProgramada
        INNER JOIN horasLaborales hl 
            ON hcp.fkHorarioLaboral = hl.idHora
        LEFT JOIN AspNetUsers u 
            ON cp.fkEntrenador = u.Id
    WHERE cp.fkClase = @idClase
        AND cp.fechaDeLaClase >= COALESCE(@fechaReferencia, CAST(GETDATE() AS DATE))
);
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Modified function adapted to schema V6
CREATE   FUNCTION dbo.fn_obtenerClasesProgramadasPorIdClase_v6(@idClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        cp.idProgramacionClase AS idClaseProgramada,
        cp.fkClase,
        cp.cupoMaximo,
        (SELECT dbo.fn_cupoDisponibleClaseProgramada(cp.idProgramacionClase)) as cupoDisponible,
        cp.fechaDeLaClase,
        hl.idHora,
        hl.horaInicio,
        hl.horaFin,
        CONCAT(CONVERT(varchar(10), hl.horaInicio, 108), ' - ', CONVERT(varchar(10), hl.horaFin, 108)) AS labelHorario,
        cp.fkEntrenador,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreEntrenador
    FROM dbo.clasesProgramadas cp
        INNER JOIN dbo.horariosDeClasesProgramadas hcp 
            ON cp.idProgramacionClase = hcp.fkClaseProgramada
        INNER JOIN dbo.horasLaborales hl 
            ON hcp.fkHorarioLaboral = hl.idHora
        LEFT JOIN dbo.AspNetUsers u 
            ON cp.fkEntrenador = u.Id
    WHERE cp.fkClase = @idClase
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION fn_obtenerEstadosDeClasesProgramdas()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        idEstadoClaseProgramada,
        nombresEstado,
        fechaCreacion,
        fechaModificacion
    FROM estadosClasesProgramadas
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION dbo.fn_obtenerNombreTipoDeRecurrencia (
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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fnu_ObjetosDependenTabla
(
    @NombreTabla NVARCHAR(256)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        OBJECT_SCHEMA_NAME(referencing_id) AS Esquema,
        OBJECT_NAME(referencing_id) AS NombreObjeto,
        o.type_desc AS TipoObjeto
    FROM sys.sql_expression_dependencies sed
    INNER JOIN sys.objects o ON sed.referencing_id = o.object_id
    WHERE sed.referenced_entity_name = @NombreTabla
);
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fnu_ObjetosUsanColumna
(
    @NombreTabla NVARCHAR(256),
    @NombreColumna NVARCHAR(256)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        OBJECT_SCHEMA_NAME(o.object_id) AS Esquema,
        o.name AS NombreObjeto,
        o.type_desc AS TipoObjeto
    FROM sys.sql_modules m
    INNER JOIN sys.objects o ON m.object_id = o.object_id
    WHERE m.definition LIKE '%' + @NombreColumna + '%'
      AND m.definition LIKE '%' + @NombreTabla + '%'
);
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Function to retrieve the benefits of the class (from beneficios table)
CREATE   FUNCTION dbo.ObtenerBeneficiosDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        bc.beneficio,
        descripcionBeneficio,
        ifp.urlPublica
    FROM 
        BeneficiosDeClase bc
        left join iconsForParameters ifp on bc.fkIcon = ifp.iconId 
    WHERE 
        bc.FkClase = @IdClase
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION dbo.ObtenerCaracteristicasDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        c.DuracionEnMinutos,
        ni.NombreNivelDeIntensidad AS NivelDeIntensidad,
        nd.NombreNivelDeDificultad AS NivelDeDificultad,
        c.Descripcion AS DescripcionDeLaClase
    FROM 
        Clases c
        INNER JOIN NivelesDeIntensidadDeClase ni ON c.FkIntensidad = ni.IdNivelDeIntensidad
        INNER JOIN NivelesDeDificultadDeClase nd ON c.FkDificultad = nd.IdNivelDeDificultadDeClase
    WHERE 
        c.claseId = @IdClase
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.ObtenerClasesProgramadas(@IdClase int)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        cp.idProgramacionClase,
        c.NombreClase,
        DATENAME(WEEKDAY, cp.fechaDeLaClase) AS DiaDeLaSemana,
        hl.horaInicio AS HoraInicio,
        hl.horaFin AS HoraFin,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS NombreEntrenador
    FROM clasesProgramadas cp
        INNER JOIN Clases c ON cp.fkClase = c.ClaseID
        LEFT JOIN AspNetUsers u ON cp.fkEntrenador = u.Id
        INNER JOIN horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
        INNER JOIN horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
    WHERE cp.fkClase = @IdClase
        AND YEAR(cp.fechaDeLaClase) = YEAR(GETDATE())
        AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas)
);
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Modified function adapted to schema V6
CREATE   FUNCTION dbo.ObtenerClasesProgramadas_v6(@IdClase int)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        cp.idProgramacionClase,
        c.NombreClase,
        DATENAME(WEEKDAY, cp.fechaDeLaClase) AS DiaDeLaSemana,
        hl.horaInicio AS HoraInicio,
        hl.horaFin AS HoraFin,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS NombreEntrenador
    FROM dbo.clasesProgramadas cp
        INNER JOIN dbo.Clases c ON cp.fkClase = c.ClaseID
        LEFT JOIN dbo.AspNetUsers u ON cp.fkEntrenador = u.Id
        INNER JOIN dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
        INNER JOIN dbo.horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
    WHERE cp.fkClase = @IdClase
        AND YEAR(cp.fechaDeLaClase) = YEAR(GETDATE())
        AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM dbo.v_idEstadoDisponibleClasesProgramadas)
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION dbo.ObtenerConsejosDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT 
        c.FkClase,
        c.IntroduccionDeConsejo, 
       JSON_QUERY(
        '["' + 
        REPLACE(
            c.consejos,
            ',', 
            '","'
        ) + 
        '"]'
    ) AS consejos
    FROM 
        consejosParaLasClases c
    WHERE 
        c.FkClase = @IdClase
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION dbo.ObtenerDetalleDeClase(@IdClase INT)
    RETURNS TABLE
    AS
    RETURN
    (
        SELECT 
            c.claseId,
            c.NombreClase,
            c.DuracionEnMinutos as Duracion,
            ni.NombreNivelDeIntensidad as NivelDeIntensidad ,
            nd.NombreNivelDeDificultad as NivelDeDificultad ,
            c.Descripcion AS DescripcionDeLaClase,
            (SELECT * FROM dbo.obtenerImagenesDeLaClase(@IdClase) FOR JSON AUTO) as imagenesDeClase,
            (SELECT * FROM dbo.ObtenerBeneficiosDeClase(@IdClase) FOR JSON AUTO) AS BeneficiosDeLaClase,
        (SELECT * FROM (SELECT * FROM dbo.ObtenerEstructuraDeClase(@IdClase)) AS ec 
                ORDER BY ec.NumeroConsecutivoDelBloque FOR JSON AUTO) AS EstructuraDeLaClase,
            (SELECT * FROM dbo.ObtenerEjerciciosDeClase(@IdClase) FOR JSON AUTO) AS EjerciciosDeClase,
            (SELECT * FROM dbo.ObtenerConsejosDeClase(@IdClase) FOR JSON AUTO) AS Consejos,
            (SELECT * FROM dbo.ObtenerEquipamientoRecomendado(@IdClase) FOR JSON AUTO) AS EquipamientoRecomendado,
            (SELECT * FROM dbo.ObtenerClasesProgramadas(@IdClase) FOR JSON AUTO) AS HorariosProgramados
        FROM 
            Clases c
            INNER JOIN nivelesDeIntensidadDeClase  ni ON c.FkIntensidad = ni.IdNivelDeIntensidad
            INNER JOIN nivelesDeDificultadDeClase nd ON c.FkDificultad = nd.IdNivelDeDificultadDeClase
        WHERE 
            c.claseId = @IdClase
    );

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION dbo.ObtenerEjerciciosDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        i.urlPublica as UrlIcono,
        e.NombreEjercicio,
        e.Descripcion as DescripcionEjercicio,
        ife.urlPublica as urlImagen
    FROM 
    	Rutinas r 
    	INNER JOIN RutinaEjercicios re on re.RutinaID =  r.RutinaID
        INNER JOIN Ejercicios e on e.EjercicioId = re.EjercicioID
        LEFT JOIN iconsForParameters  i ON e.FkIcon = i.iconId
        LEFT JOIN imagesForExercises ife on ife.fkEjercicio = e.EjercicioId 
    WHERE 
        r.fkClase = @IdClase
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION dbo.ObtenerEquipamientoRecomendado(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
        e.EquipoId,
        e.NombreEquipo,
        e.Descripcion,
        i.urlPublica AS UrlIcono
    FROM 
        Rutinas r
        INNER JOIN RutinaEjercicios re on r.RutinaId =  re.RutinaId
        INNER JOIN Ejercicios ej on re.EjercicioId = ej.EjercicioId
        INNER JOIN EjercicioEquipos ee ON ee.EjercicioId = ej.EjercicioID
        INNER JOIN Equipos e ON ee.EquipoId = e.EquipoId
        LEFT JOIN IconsForParameters i ON e.FkIcon = i.iconId
    WHERE 
        r.FkClase = @IdClase
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION dbo.ObtenerEstructuraDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ec.IdBloque,
        c.NombreClase AS NombreDeLaClase,
        ec.NumeroConsecutivoDelBloque,
        ec.DuracionMenorEnMinutos,
        ec.DuracionMayorEnMinutos,
        ec.TituloBloque,
        ec.DescripcionBloque
    FROM 
        EstructuraDeClase ec
        INNER JOIN Clases c ON ec.FkClase = c.claseId
    WHERE 
        ec.FkClase = @IdClase
    
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION dbo.obtenerImagenesDeLaClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
    urlParaBanner,
	urlParaParaDescripcionDeClase,
	urlParaBloqueConsejos 
FROM imagesForClases i
    WHERE 
        i.FkClase = @IdClase
);

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[yaExisteClaseProgramada](
    @fkClase INT,
    @fkEntrenador NVARCHAR(450),
    @fecha DATE,
    @fksHorasLaborales IdsHorasLaborales READONLY
)
RETURNS BIT
AS
BEGIN
    DECLARE @yaExiste BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM clasesProgramadas cp
        INNER JOIN horariosDeClasesProgramadas hcp 
            ON cp.idProgramacionClase = hcp.fkClaseProgramada
            AND hcp.fkEstadoHorarioClase = 1
            AND hcp.fkHorarioLaboral IN (SELECT fkHoraLaboral FROM @fksHorasLaborales)
        WHERE cp.fechaDeLaClase = @fecha
          AND cp.fkClase = @fkClase
          AND (@fkEntrenador IS NULL OR cp.fkEntrenador = @fkEntrenador)
          AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas)
    )
    BEGIN
        SET @yaExiste = 1;
    END;

    RETURN @yaExiste;
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION dbo.yaExisteClaseProgramada_v6(
    @fkClase INT,
    @fkEntrenador NVARCHAR(450),
    @fecha DATE,
    @fksHorasLaborales dbo.IdsHorasLaborales READONLY
)
RETURNS BIT
AS
BEGIN
    DECLARE @yaExiste BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM dbo.clasesProgramadas cp
        INNER JOIN dbo.horariosDeClasesProgramadas hcp 
            ON cp.idProgramacionClase = hcp.fkClaseProgramada
            AND hcp.fkEstadoHorarioClase = 1
            AND hcp.fkHorarioLaboral IN (SELECT fkHoraLaboral FROM @fksHorasLaborales)
        WHERE cp.fechaDeLaClase = @fecha
          AND cp.fkClase = @fkClase
          AND (@fkEntrenador IS NULL OR cp.fkEntrenador = @fkEntrenador)
          AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM dbo.v_idEstadoDisponibleClasesProgramadas)
    )
    BEGIN
        SET @yaExiste = 1;
    END;
    RETURN @yaExiste;
END;

GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[yaExistePreRegistroDeClase](
    @idClase INT,
    @idEntrenador NVARCHAR(450),
    @fechaReservada DATE,
    @fksHorasLaborales IdsHorasLaborales READONLY
)
RETURNS BIT
AS
BEGIN
    DECLARE @yaExiste BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM preReservasDeHorario pr
        WHERE pr.fechaDeLaClase = @fechaReservada
            AND pr.fkHoraLaboral IN (SELECT fkHoraLaboral FROM @fksHorasLaborales)
            AND (@idClase IS NULL OR pr.idClase = @idClase)
            AND (@idEntrenador IS NULL OR pr.idEntrenador = @idEntrenador)
            AND GETDATE() BETWEEN pr.fechaInicioDeLaReserva AND pr.fechaDeExpiracionDeLaReserva
    )
    BEGIN
        SET @yaExiste = 1;
    END;

    RETURN @yaExiste;
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_obtenerFechasDeDiasFestivosVariables (
    @anio INT,
    @datosDeDiasFestivosVariables DatosDiaFestivoVariable READONLY
)
RETURNS @fechas TABLE (fechaExacta DATE)
AS
BEGIN
    DECLARE @dia INT, @semana INT, @mes INT, @idTipo INT;
    DECLARE @nombreTipo NVARCHAR(100);
    DECLARE @primerDiaMes DATE, @primerDiaSemana DATE, @fechaFestiva DATE;
    DECLARE @primerDiaAnio DATE, @inicioSemana DATE, @primeraOcurrencia DATE;
    DECLARE @ultimoDia INT, @m INT;

    DECLARE c CURSOR FOR
        SELECT diaDeFechaVariable, semanaDeFechaVariable, mesDeFechaVariable, idTipoDeRecurrencia
        FROM @datosDeDiasFestivosVariables;

    OPEN c;
    FETCH NEXT FROM c INTO @dia, @semana, @mes, @idTipo;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @nombreTipo = dbo.fn_obtenerNombreTipoDeRecurrencia(@idTipo);

        IF @dia IS NOT NULL AND @semana IS NOT NULL AND @mes IS NOT NULL
        BEGIN
            SET @primerDiaMes = DATEFROMPARTS(@anio, @mes, 1);
            SET @primerDiaSemana = @primerDiaMes;
            WHILE DATEPART(dw, @primerDiaSemana) != @dia
                SET @primerDiaSemana = DATEADD(DAY, 1, @primerDiaSemana);
            SET @fechaFestiva = DATEADD(WEEK, @semana - 1, @primerDiaSemana);
            IF MONTH(@fechaFestiva) = @mes
                INSERT INTO @fechas VALUES (@fechaFestiva);
        END
        ELSE IF @dia IS NOT NULL AND @semana IS NOT NULL AND @mes IS NULL AND @nombreTipo = 'diaSemana'
        BEGIN
            SET @primerDiaAnio = DATEFROMPARTS(@anio, 1, 1);
            SET @inicioSemana = DATEADD(WEEK, @semana - 1, @primerDiaAnio);
            WHILE DATEPART(dw, @inicioSemana) != 1
                SET @inicioSemana = DATEADD(DAY, -1, @inicioSemana);
            SET @fechaFestiva = DATEADD(DAY, @dia - 1, @inicioSemana);
            INSERT INTO @fechas VALUES (@fechaFestiva);
        END
        ELSE IF @dia IS NOT NULL AND @semana IS NOT NULL AND @mes IS NULL AND @nombreTipo = 'mensual'
        BEGIN
            SET @m = 1;
            WHILE @m <= 12
            BEGIN
                SET @primerDiaMes = DATEFROMPARTS(@anio, @m, 1);
                SET @primerDiaSemana = @primerDiaMes;
                WHILE DATEPART(dw, @primerDiaSemana) != @dia
                    SET @primerDiaSemana = DATEADD(DAY, 1, @primerDiaSemana);
                SET @fechaFestiva = DATEADD(WEEK, @semana - 1, @primerDiaSemana);
                IF MONTH(@fechaFestiva) = @m
                    INSERT INTO @fechas VALUES (@fechaFestiva);
                SET @m = @m + 1;
            END
        END
        ELSE IF @dia IS NOT NULL AND @semana IS NULL AND @mes IS NULL AND @nombreTipo = 'mensual'
        BEGIN
            SET @m = 1;
            WHILE @m <= 12
            BEGIN
                SET @ultimoDia = DAY(EOMONTH(DATEFROMPARTS(@anio, @m, 1)));
                IF @dia <= @ultimoDia
                BEGIN
                    SET @fechaFestiva = DATEFROMPARTS(@anio, @m, @dia);
                    INSERT INTO @fechas VALUES (@fechaFestiva);
                END
                SET @m = @m + 1;
            END
        END
        ELSE IF @dia IS NOT NULL AND @semana IS NULL AND @mes IS NULL AND @nombreTipo = 'diaRelativo'
        BEGIN
            SET @primerDiaAnio = DATEFROMPARTS(@anio, 1, 1);
            SET @primeraOcurrencia = @primerDiaAnio;
            WHILE DATEPART(dw, @primeraOcurrencia) != @dia
                SET @primeraOcurrencia = DATEADD(DAY, 1, @primeraOcurrencia);
            SET @fechaFestiva = @primeraOcurrencia;
            WHILE YEAR(@fechaFestiva) = @anio
            BEGIN
                INSERT INTO @fechas VALUES (@fechaFestiva);
                SET @fechaFestiva = DATEADD(DAY, 7, @fechaFestiva);
            END
        END
        ELSE IF @dia IS NOT NULL AND @semana IS NULL AND @mes IS NULL AND @nombreTipo = 'diaConsecutivo'
        BEGIN
            SET @fechaFestiva = DATEADD(DAY, @dia - 1, DATEFROMPARTS(@anio, 1, 1));
            IF YEAR(@fechaFestiva) = @anio
                INSERT INTO @fechas VALUES (@fechaFestiva);
        END

        FETCH NEXT FROM c INTO @dia, @semana, @mes, @idTipo;
    END

    CLOSE c;
    DEALLOCATE c;

    RETURN;
END;
GO
