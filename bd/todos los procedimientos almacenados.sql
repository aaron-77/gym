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

CREATE     FUNCTION dbo.ObtenerClasesProgramadas(@IdClase  int)
RETURNS TABLE
AS
RETURN
(
	
    SELECT 
        cp.IdProgramacionClase,
        c.NombreClase,
        DATENAME(WEEKDAY, hcp.fechaDeLaClase) AS DiaDeLaSemana,
        hl.horaInicio AS HoraInicio,
        hl.horaFin AS HoraFin,
        e.NombreCompleto + ' ' + e.Apellido AS NombreEntrenador
    FROM 
        ClasesProgramadas cp
        INNER JOIN Clases c ON cp.FkClase = c.claseId
        INNER JOIN FitnessCenterDB.dbo.AspNetUsers e ON cp.FkEntrenador = e.Id
        INNER JOIN FitnessCenterDB.dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
        INNER JOIN FitnessCenterDB.dbo.horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
    WHERE 
    	cp.fkClase  = @IdClase
    	AND
        YEAR(hcp.fechaDeLaClase) = YEAR(GETDATE())
        AND cp.fkEstadoClaseProgramada  = 1--disponible
);

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

CREATE PROCEDURE ObtenerParametrosDeMedicion
    @PageNumber INT,       
    @PageSize INT          
AS
BEGIN
    SET NOCOUNT ON;

    -- Calcular el índice de desplazamiento
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    -- Obtener los resultados paginados
    SELECT 
        parametroMedicionId,
        nombre
    FROM parametrosDeMedicion
    ORDER BY parametroMedicionId ASC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;

    SET NOCOUNT OFF;
END;

CREATE   FUNCTION dbo.VerificarDisponibilidadHorario
(
    @fechaInicioClaseQueSeQuiereProgramar datetime,
    @fechaFinClaseQueSePlaneaProgramar datetime
)
RETURNS BIT
AS
BEGIN
    DECLARE @Disponible BIT = 1;
    
    IF EXISTS (
        SELECT 1
        FROM ClasesProgramadas
        WHERE 
           fkEstadoClaseProgramada = 1 --LA CLASE DEBE ESTAR DISPONIBLE
            AND (
                ( fechaInicio < @fechaInicioClaseQueSeQuiereProgramar AND fechaFin > @fechaInicioClaseQueSeQuiereProgramar)
                OR
                (fechaInicio < @fechaFinClaseQueSePlaneaProgramar AND fechaFin >= @fechaFinClaseQueSePlaneaProgramar) 
                OR
                (fechaFin > @fechaInicioClaseQueSeQuiereProgramar AND fechaFin <= @fechaFinClaseQueSePlaneaProgramar)
            )
    )
    BEGIN
        SET @Disponible = 0;
    END
    
    RETURN @Disponible;
END;

CREATE   PROCEDURE buscarClaseProgramadas
    @idClase INT = NULL,
    -- MODIFICADO: Tipo de dato de @idEntrenador de INT a NVARCHAR(450)
    @idEntrenador NVARCHAR(450) = NULL,
    @idHoraLaboral INT = NULL,
    @fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        cp.idProgramacionClase,
        c.NombreClase AS nombreDeLaClase,
        -- MODIFICADO: Campo 'NombreCompleto' y 'Apellido' de 'AspNetUsers' en lugar de 'Nombre' y 'Apellido' de 'Usuarios'
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreCompletoDelEntrenador,
        hcp.fechaDeLaClase,
        h.horaInicio,
        h.horaFin
    FROM
        FitnessCenterDB.dbo.clasesProgramadas cp
    INNER JOIN
        FitnessCenterDB.dbo.Clases c ON cp.fkClase = c.ClaseID
    INNER JOIN
        FitnessCenterDB.dbo.AspNetUsers u
        -- MODIFICADO: Tabla 'AspNetUsers' y campo 'Id' en lugar de 'Usuarios' y 'UsuarioID'
        ON cp.fkEntrenador = u.Id
    INNER JOIN
        FitnessCenterDB.dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
    INNER JOIN
        FitnessCenterDB.dbo.horasLaborales h ON hcp.fkHorarioLaboral = h.idHora
    WHERE
        (@idClase IS NULL OR cp.fkClase = @idClase) AND
        -- MODIFICADO: Campo 'Id' de 'AspNetUsers' en lugar de 'UsuarioID' de 'Usuarios'
        (@idEntrenador IS NULL OR cp.fkEntrenador = @idEntrenador) AND
        (@idHoraLaboral IS NULL OR hcp.fkHorarioLaboral = @idHoraLaboral) AND
        (@fecha IS NULL OR hcp.fechaDeLaClase = @fecha);
END;

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

CREATE   FUNCTION dbo.fn_encontrarPreReservasCaducadas()
RETURNS table
AS 
return
(
	select idPreReserva 
	from preReservasDeHorario 
	where GETDATE() NOT BETWEEN fechaInicioDeLaReserva and fechaDeExpiracionDeLaReserva
);

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

CREATE FUNCTION fn_obtenerClases()
RETURNS TABLE
AS
RETURN (
    SELECT ClaseID, NombreClase
    FROM FitnessCenterDB.dbo.Clases
    where fkEstadoClase = (select idEstadoClase from v_estadoActivoClases)
);

CREATE   FUNCTION dbo.fn_obtenerClasesProgramadaPorIdProgramacionClase(@idProgramacionClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        cp.idProgramacionClase AS idClaseProgramada,
        cp.fkClase,
        cp.cupoMaximo,
        (SELECT dbo.fn_cupoDisponibleClaseProgramada(cp.idProgramacionClase)) as cupoDisponible,
        hcp.fechaDeLaClase,
        hl.idHora,
        hl.horaInicio,
        hl.horaFin,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreEntrenador
    FROM FitnessCenterDB.dbo.clasesProgramadas cp
    INNER JOIN FitnessCenterDB.dbo.horariosDeClasesProgramadas hcp 
        ON cp.idProgramacionClase = hcp.fkClaseProgramada
    INNER JOIN FitnessCenterDB.dbo.horasLaborales hl 
        ON hcp.fkHorarioLaboral = hl.idHora
    INNER JOIN FitnessCenterDB.dbo.AspNetUsers u 
        ON cp.fkEntrenador = u.Id
    WHERE cp.idProgramacionClase = @idProgramacionClase
        AND (select dbo.fn_cupoDisponibleClaseProgramada(cp.idProgramacionClase)) > 0
);

CREATE         FUNCTION dbo.fn_obtenerClasesProgramadasPorIdClase(@idClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        cp.idProgramacionClase AS idClaseProgramada,
        cp.fkClase,
        cp.cupoMaximo,
        (select dbo.fn_cupoDisponibleClaseProgramada(cp.idProgramacionClase) )as cupoDisponible,
        hcp.fechaDeLaClase,
        hl.idHora,
        hl.horaInicio,
        hl.horaFin,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreEntrenador
    FROM
        FitnessCenterDB.dbo.clasesProgramadas cp
        INNER JOIN FitnessCenterDB.dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
        INNER JOIN FitnessCenterDB.dbo.horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
        INNER JOIN FitnessCenterDB.dbo.AspNetUsers u ON cp.fkEntrenador = u.Id
    WHERE
        cp.fkClase = @idClase
);

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

CREATE PROCEDURE showtables
    @tableName NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        TABLE_CATALOG,
        TABLE_SCHEMA,
        TABLE_NAME,
        COLUMN_NAME, 
        DATA_TYPE, 
        IS_NULLABLE, 
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @tableName;
END;

CREATE PROCEDURE sp_ObtenerEquipamientoRecomendadoClase
    @idClase INT
AS
BEGIN
    SELECT DISTINCT
        e.EquipoID,
        e.NombreEquipo,
        e.Descripcion
    FROM 
        Clases c
    INNER JOIN 
        Rutinas r ON c.ClaseID = r.fkClase
    INNER JOIN 							
        RutinaEjercicios re ON re.RutinaId = r.RutinaId
    INNER JOIN 
        EjercicioEquipos ee ON ee.EjercicioID = re.EjercicioID
    INNER JOIN 
        Equipos e ON e.EquipoID = ee.EquipoID
    WHERE 
        c.ClaseID = @idClase
END;

CREATE PROCEDURE sp_ObtenerEstructuraClase
    @idClase INT
AS
BEGIN
    SELECT 
        es.idBloque,
        es.fkClase,
        es.numeroConsecutivoDelBloque,
        es.tituloBloque,
        es.duracionMenorEnMinutos,
        es.duracionMayorEnMinutos,
        es.descripcionBloque
    FROM 
        estructuraDeClase es
    WHERE 
        es.fkClase = @idClase
    ORDER BY 
        es.numeroConsecutivoDelBloque
END;

CREATE PROCEDURE sp_ObtenerMedidasPorAñosEspecificos
    @idCliente INT,
    @idParametro INT,
    @idEjercicio INT,
    @años UnidadDeTiempo readonly,
    @conDetalles int
AS
BEGIN
	declare @listadoMeses UnidadDeTiempo;
	insert into @listadoMeses values
	(1),(2),(3),(4),(5),
	(6),(7),(8),(9),(10),
	(11),(12);

	declare @parametrosConcatenados nvarchar(max);  
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro, ', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
       	'años',(SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años),',',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPOrAñosEspecificos',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;
	-- si la cosulta requiere informacion detallada,es decir todas la medidas encontradas dentro de las fechas establecidas
	IF @conDetalles = 1
	begin
		-- Consulta principal
    SELECT 
        m.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        m.valor,
        m.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        m.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        m.fkUsuario
    FROM medidas m
    INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON m.fkEjercicio = e.ejercicioId 
    WHERE m.fkUsuario = @idCliente
      AND pm.parametroMedicionId = @idParametro
      AND (m.fkEjercicio = @idEjercicio or m.fkEjercicio is null )
      AND MONTH(m.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(m.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by m.fechaDeCreacion ;
	end
	ELSE
	begin
		-- si solo se requieren las ulimas medidas(informacion resumida)
		;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro , 
            								YEAR(m.fechaDeCreacion)
            								ORDER BY fechaDeCreacion DESC
            					) AS rn
        FROM medidas m
        	where CAST(fkUsuario AS NVARCHAR(450)) = @idCliente
        	AND m.fkParametro = @idParametro
        	AND MONTH(m.fechaDeCreacion) in  (select mesOAño from @listadoMeses)
        	AND YEAR(m.fechaDeCreacion) in (select mesOAño from @años)
    	)
    	
		 SELECT 
        ro.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        ro.valor,
        ro.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        ro.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON ro.fkEjercicio = e.ejercicioId 
    WHERE 
      ro.fkUsuario = @idCliente
      AND ro.rn =1
      AND pm.parametroMedicionId = @idParametro
      AND (ro.fkEjercicio = @idEjercicio or ro.fkEjercicio is null )
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
	
	
END;

CREATE PROCEDURE sp_obtenerMedidasPorMesesEspecificos
    @idCliente INT,
    @idParametro INT,
    @idEjercicio INT,
    @años UnidadDeTiempo readonly,
    @listadoDeMeses UnidadDeTiempo readonly,
    @conDetalles int
AS
BEGIN
	--Si debe devolver todas las medias asociadas no solo las mas relevantes
	IF @conDetalles = 1
	begin
		-- Consulta principal
	    SELECT 
	        m.medidaId,
	        pm.parametroMedicionId AS fkParametro,
	        pm.nombre AS nombreParametro,
	        m.valor,
	        m.fechaDeCreacion,
	        udm.unidadDeMedidaId,
	        udm.nombre AS nombreUnidadDeMedida,
	        m.fkEjercicio,
	        e.nombreEjercicio,
	        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
	        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
	        m.fkUsuario
	    FROM medidas m
	    INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId
	    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
	    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
	    LEFT JOIN ejercicios e ON m.fkEjercicio = e.ejercicioId 
	    WHERE m.fkUsuario = @idCliente
	      AND pm.parametroMedicionId = @idParametro
	      AND ((@idEjercicio IS NULL AND m.fkEjercicio IS NULL) OR (@idEjercicio IS NOT NULL AND m.fkEjercicio = @idEjercicio))
	      AND MONTH(m.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoDeMeses)
	      AND YEAR(m.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
	     order by m.fechaDeCreacion ;
	end
	ELSE
	begin
		-- en este caso deben devolverse solo las medidas mas relevantes (ultima de cada mes o año segun el caso) 
		;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro , 
            								YEAR(m.fechaDeCreacion), 
                							MONTH(m.fechaDeCreacion) 
            								ORDER BY fechaDeCreacion DESC
            					) AS rn
        FROM medidas m
        	where CAST(fkUsuario AS NVARCHAR(450)) = @idCliente
        	AND m.fkParametro = @idParametro
        	AND MONTH(m.fechaDeCreacion) in  (select mesOAño from @listadoDeMeses)
        	AND YEAR(m.fechaDeCreacion) in (select mesOAño from @años)
    	)
    	
		 SELECT 
        ro.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        ro.valor,
        ro.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        ro.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON ro.fkEjercicio = e.ejercicioId 
    WHERE 
      ro.rn =1
      AND (@idEjercicio IS NULL OR ro.fkEjercicio = @idEjercicio)
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoDeMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
END;

CREATE PROCEDURE sp_ObtenerMedidasPorAñosEspecificos
    @idCliente INT,
    @idParametro INT,
    @idEjercicio INT,
    @años UnidadDeTiempo readonly,
    @conDetalles int
AS
BEGIN
	declare @listadoMeses UnidadDeTiempo;
	insert into @listadoMeses values
	(1),(2),(3),(4),(5),
	(6),(7),(8),(9),(10),
	(11),(12);

	declare @parametrosConcatenados nvarchar(max);  
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro, ', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
       	'años',(SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años),',',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPOrAñosEspecificos',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;
	-- si la cosulta requiere informacion detallada,es decir todas la medidas encontradas dentro de las fechas establecidas
	IF @conDetalles = 1
	begin
		-- Consulta principal
    SELECT 
        m.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        m.valor,
        m.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        m.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        m.fkUsuario
    FROM medidas m
    INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON m.fkEjercicio = e.ejercicioId 
    WHERE m.fkUsuario = @idCliente
      AND pm.parametroMedicionId = @idParametro
      AND (m.fkEjercicio = @idEjercicio or m.fkEjercicio is null )
      AND MONTH(m.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(m.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by m.fechaDeCreacion ;
	end
	ELSE
	begin
		-- si solo se requieren las ulimas medidas(informacion resumida)
		;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro , 
            								YEAR(m.fechaDeCreacion)
            								ORDER BY fechaDeCreacion DESC
            					) AS rn
        FROM medidas m
        	where CAST(fkUsuario AS NVARCHAR(450)) = @idCliente
        	AND m.fkParametro = @idParametro
        	AND MONTH(m.fechaDeCreacion) in  (select mesOAño from @listadoMeses)
        	AND YEAR(m.fechaDeCreacion) in (select mesOAño from @años)
    	)
    	
		 SELECT 
        ro.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        ro.valor,
        ro.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        ro.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON ro.fkEjercicio = e.ejercicioId 
    WHERE 
      ro.rn = 1
      AND (@idEjercicio IS NULL OR ro.fkEjercicio = @idEjercicio)
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
	
	
END;

CREATE PROCEDURE sp_obtenerMedidasPorAñosEspecificos
    @idCliente INT,
    @idParametro INT,
    @idEjercicio INT,
    @años UnidadDeTiempo readonly,
    @conDetalles int
AS
BEGIN
	declare @listadoMeses UnidadDeTiempo;
	insert into @listadoMeses values
	(1),(2),(3),(4),(5),
	(6),(7),(8),(9),(10),
	(11),(12);

	declare @parametrosConcatenados nvarchar(max);  
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro, ', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
       	'años',(SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años),',',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPOrAñosEspecificos',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;
	-- si la cosulta requiere informacion detallada,es decir todas la medidas encontradas dentro de las fechas establecidas
	IF @conDetalles = 1
	begin
		-- Consulta principal
    SELECT 
        m.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        m.valor,
        m.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        m.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        m.fkUsuario
    FROM medidas m
    INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON m.fkEjercicio = e.ejercicioId 
    WHERE m.fkUsuario = @idCliente
      AND pm.parametroMedicionId = @idParametro
      AND (m.fkEjercicio = @idEjercicio or m.fkEjercicio is null )
      AND MONTH(m.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(m.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by m.fechaDeCreacion ;
	end
	ELSE
	begin
		-- si solo se requieren las ulimas medidas(informacion resumida)
		;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro , 
            								YEAR(m.fechaDeCreacion)
            								ORDER BY fechaDeCreacion DESC
            					) AS rn
        FROM medidas m
        	where CAST(fkUsuario AS NVARCHAR(450)) = @idCliente
        	AND m.fkParametro = @idParametro
        	AND MONTH(m.fechaDeCreacion) in  (select mesOAño from @listadoMeses)
        	AND YEAR(m.fechaDeCreacion) in (select mesOAño from @años)
    	)
    	
		 SELECT 
        ro.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        ro.valor,
        ro.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        ro.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON ro.fkEjercicio = e.ejercicioId 
    WHERE 
      ro.rn = 1
      AND (@idEjercicio IS NULL OR ro.fkEjercicio = @idEjercicio)
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
	
	
END;

CREATE PROCEDURE sp_obtenerMedidasPorAñosEspecificos
    @idCliente INT,
    @idParametro INT,
    @idEjercicio INT,
    @años UnidadDeTiempo readonly,
    @conDetalles int
AS
BEGIN
	declare @listadoMeses UnidadDeTiempo;
	insert into @listadoMeses values
	(1),(2),(3),(4),(5),
	(6),(7),(8),(9),(10),
	(11),(12);

	declare @parametrosConcatenados nvarchar(max);  
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro, ', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
       	'años',(SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años),',',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPOrAñosEspecificos',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;
	-- si la cosulta requiere informacion detallada,es decir todas la medidas encontradas dentro de las fechas establecidas
	IF @conDetalles = 1
	begin
		-- Consulta principal
    SELECT 
        m.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        m.valor,
        m.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        m.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        m.fkUsuario
    FROM medidas m
    INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON m.fkEjercicio = e.ejercicioId 
    WHERE m.fkUsuario = @idCliente
      AND pm.parametroMedicionId = @idParametro
      AND (m.fkEjercicio = @idEjercicio or m.fkEjercicio is null )
      AND MONTH(m.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(m.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by m.fechaDeCreacion ;
	end
	ELSE
	begin
		-- si solo se requieren las ulimas medidas(informacion resumida)
		;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro , 
            								YEAR(m.fechaDeCreacion)
            								ORDER BY fechaDeCreacion DESC
            					) AS rn
        FROM medidas m
        	where CAST(fkUsuario AS NVARCHAR(450)) = @idCliente
        	AND m.fkParametro = @idParametro
        	AND MONTH(m.fechaDeCreacion) in  (select mesOAño from @listadoMeses)
        	AND YEAR(m.fechaDeCreacion) in (select mesOAño from @años)
    	)
    	
		 SELECT 
        ro.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        ro.valor,
        ro.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        ro.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON ro.fkEjercicio = e.ejercicioId 
    WHERE 
      ro.rn = 1
      AND (@idEjercicio IS NULL OR ro.fkEjercicio = @idEjercicio)
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
	
	
END;

CREATE PROCEDURE sp_obtenerMedidasPorAñosEspecificos
    @idCliente INT,
    @idParametro INT,
    @idEjercicio INT,
    @años UnidadDeTiempo readonly,
    @conDetalles int
AS
BEGIN
	declare @listadoMeses UnidadDeTiempo;
	insert into @listadoMeses values
	(1),(2),(3),(4),(5),
	(6),(7),(8),(9),(10),
	(11),(12);

	declare @parametrosConcatenados nvarchar(max);  
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro, ', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
       	'años',(SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años),',',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPOrAñosEspecificos',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;
	-- si la cosulta requiere informacion detallada,es decir todas la medidas encontradas dentro de las fechas establecidas
	IF @conDetalles = 1
	begin
		-- Consulta principal
    SELECT 
        m.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        m.valor,
        m.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        m.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        m.fkUsuario
    FROM medidas m
    INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON m.fkEjercicio = e.ejercicioId 
    WHERE m.fkUsuario = @idCliente
      AND pm.parametroMedicionId = @idParametro
      AND (m.fkEjercicio = @idEjercicio or m.fkEjercicio is null )
      AND MONTH(m.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(m.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by m.fechaDeCreacion ;
	end
	ELSE
	begin
		-- si solo se requieren las ulimas medidas(informacion resumida)
		;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro , 
            								YEAR(m.fechaDeCreacion)
            								ORDER BY fechaDeCreacion DESC
            					) AS rn
        FROM medidas m
        	where CAST(fkUsuario AS NVARCHAR(450)) = @idCliente
        	AND m.fkParametro = @idParametro
        	AND MONTH(m.fechaDeCreacion) in  (select mesOAño from @listadoMeses)
        	AND YEAR(m.fechaDeCreacion) in (select mesOAño from @años)
    	)
    	
		 SELECT 
        ro.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        ro.valor,
        ro.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        ro.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON ro.fkEjercicio = e.ejercicioId 
    WHERE 
      ro.rn = 1
      AND (@idEjercicio IS NULL OR ro.fkEjercicio = @idEjercicio)
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
	
	
END;

CREATE PROCEDURE sp_obtenerMedidasPorAñosEspecificos
    @idCliente INT,
    @idParametro INT,
    @idEjercicio INT,
    @años UnidadDeTiempo readonly,
    @conDetalles int
AS
BEGIN
	declare @listadoMeses UnidadDeTiempo;
	insert into @listadoMeses values
	(1),(2),(3),(4),(5),
	(6),(7),(8),(9),(10),
	(11),(12);

	declare @parametrosConcatenados nvarchar(max);  
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro, ', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
       	'años',(SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años),',',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPOrAñosEspecificos',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;
	-- si la cosulta requiere informacion detallada,es decir todas la medidas encontradas dentro de las fechas establecidas
	IF @conDetalles = 1
	begin
		-- Consulta principal
    SELECT 
        m.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        m.valor,
        m.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        m.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        m.fkUsuario
    FROM medidas m
    INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON m.fkEjercicio = e.ejercicioId 
    WHERE m.fkUsuario = @idCliente
      AND pm.parametroMedicionId = @idParametro
      AND (m.fkEjercicio = @idEjercicio or m.fkEjercicio is null )
      AND MONTH(m.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(m.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by m.fechaDeCreacion ;
	end
	ELSE
	begin
		-- si solo se requieren las ulimas medidas(informacion resumida)
		;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro , 
            								YEAR(m.fechaDeCreacion)
            								ORDER BY fechaDeCreacion DESC
            					) AS rn
        FROM medidas m
        	where CAST(fkUsuario AS NVARCHAR(450)) = @idCliente
        	AND m.fkParametro = @idParametro
        	AND MONTH(m.fechaDeCreacion) in  (select mesOAño from @listadoMeses)
        	AND YEAR(m.fechaDeCreacion) in (select mesOAño from @años)
    	)
    	
		 SELECT 
        ro.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        ro.valor,
        ro.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        ro.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON ro.fkEjercicio = e.ejercicioId 
    WHERE 
      ro.rn = 1
      AND (@idEjercicio IS NULL OR ro.fkEjercicio = @idEjercicio)
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
	
	
END;

CREATE PROCEDURE sp_obtenerMedidasPorAñosEspecificos
    @idCliente INT,
    @idParametro INT,
    @idEjercicio INT,
    @años UnidadDeTiempo readonly,
    @conDetalles int
AS
BEGIN
	declare @listadoMeses UnidadDeTiempo;
	insert into @listadoMeses values
	(1),(2),(3),(4),(5),
	(6),(7),(8),(9),(10),
	(11),(12);

	declare @parametrosConcatenados nvarchar(max);  
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro, ', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
       	'años',(SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años),',',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPOrAñosEspecificos',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;
	-- si la cosulta requiere informacion detallada,es decir todas la medidas encontradas dentro de las fechas establecidas
	IF @conDetalles = 1
	begin
		-- Consulta principal
    SELECT 
        m.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        m.valor,
        m.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        m.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        m.fkUsuario
    FROM medidas m
    INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON m.fkEjercicio = e.ejercicioId 
    WHERE m.fkUsuario = @idCliente
      AND pm.parametroMedicionId = @idParametro
      AND (m.fkEjercicio = @idEjercicio or m.fkEjercicio is null )
      AND MONTH(m.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(m.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by m.fechaDeCreacion ;
	end
	ELSE
	begin
		-- si solo se requieren las ulimas medidas(informacion resumida)
		;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro , 
            								YEAR(m.fechaDeCreacion)
            								ORDER BY fechaDeCreacion DESC
            					) AS rn
        FROM medidas m
        	where CAST(fkUsuario AS NVARCHAR(450)) = @idCliente
        	AND m.fkParametro = @idParametro
        	AND MONTH(m.fechaDeCreacion) in  (select mesOAño from @listadoMeses)
        	AND YEAR(m.fechaDeCreacion) in (select mesOAño from @años)
    	)
    	
		 SELECT 
        ro.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        ro.valor,
        ro.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        ro.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON ro.fkEjercicio = e.ejercicioId 
    WHERE 
      ro.rn = 1
      AND (@idEjercicio IS NULL OR ro.fkEjercicio = @idEjercicio)
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
	
	
END;

CREATE PROCEDURE sp_obtenerMedidasPorAñosEspecificos
    @idCliente INT,
    @idParametro INT,
    @idEjercicio INT,
    @años UnidadDeTiempo readonly,
    @conDetalles int
AS
BEGIN
	declare @listadoMeses UnidadDeTiempo;
	insert into @listadoMeses values
	(1),(2),(3),(4),(5),
	(6),(7),(8),(9),(10),
	(11),(12);

	declare @parametrosConcatenados nvarchar(max);  
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro, ', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
       	'años',(SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años),',',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPOrAñosEspecificos',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;
	-- si la cosulta requiere informacion detallada,es decir todas la medidas encontradas dentro de las fechas establecidas
	IF @conDetalles = 1
	begin
		-- Consulta principal
    SELECT 
        m.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        m.valor,
        m.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        m.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        m.fkUsuario
    FROM medidas m
    INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON m.fkEjercicio = e.ejercicioId 
    WHERE m.fkUsuario = @idCliente
      AND pm.parametroMedicionId = @idParametro
      AND (m.fkEjercicio = @idEjercicio or m.fkEjercicio is null )
      AND MONTH(m.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(m.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by m.fechaDeCreacion ;
	end
	ELSE
	begin
		-- si solo se requieren las ulimas medidas(informacion resumida)
		;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro , 
            								YEAR(m.fechaDeCreacion)
            								ORDER BY fechaDeCreacion DESC
            					) AS rn
        FROM medidas m
        	where CAST(fkUsuario AS NVARCHAR(450)) = @idCliente
        	AND m.fkParametro = @idParametro
        	AND MONTH(m.fechaDeCreacion) in  (select mesOAño from @listadoMeses)
        	AND YEAR(m.fechaDeCreacion) in (select mesOAño from @años)
    	)
    	
		 SELECT 
        ro.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        ro.valor,
        ro.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        ro.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON ro.fkEjercicio = e.ejercicioId 
    WHERE 
      ro.rn = 1
      AND (@idEjercicio IS NULL OR ro.fkEjercicio = @idEjercicio)
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
	
	
END;

CREATE PROCEDURE sp_obtenerMedidasPorAñosEspecificos
    @idCliente INT,
    @idParametro INT,
    @idEjercicio INT,
    @años UnidadDeTiempo readonly,
    @conDetalles int
AS
BEGIN
	declare @listadoMeses UnidadDeTiempo;
	insert into @listadoMeses values
	(1),(2),(3),(4),(5),
	(6),(7),(8),(9),(10),
	(11),(12);

	declare @parametrosConcatenados nvarchar(max);  
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro, ', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
       	'años',(SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años),',',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPOrAñosEspecificos',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;
	-- si la cosulta requiere informacion detallada,es decir todas la medidas encontradas dentro de las fechas establecidas
	IF @conDetalles = 1
	begin
		-- Consulta principal
    SELECT 
        m.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        m.valor,
        m.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        m.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        m.fkUsuario
    FROM medidas m
    INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON m.fkEjercicio = e.ejercicioId 
    WHERE m.fkUsuario = @idCliente
      AND pm.parametroMedicionId = @idParametro
      AND (m.fkEjercicio = @idEjercicio or m.fkEjercicio is null )
      AND MONTH(m.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(m.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by m.fechaDeCreacion ;
	end
	ELSE
	begin
		-- si solo se requieren las ulimas medidas(informacion resumida)
		;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro , 
            								YEAR(m.fechaDeCreacion)
            								ORDER BY fechaDeCreacion DESC
            					) AS rn
        FROM medidas m
        	where CAST(fkUsuario AS NVARCHAR(450)) = @idCliente
        	AND m.fkParametro = @idParametro
        	AND MONTH(m.fechaDeCreacion) in  (select mesOAño from @listadoMeses)
        	AND YEAR(m.fechaDeCreacion) in (select mesOAño from @años)
    	)
    	
		 SELECT 
        ro.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        ro.valor,
        ro.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        ro.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON ro.fkEjercicio = e.ejercicioId 
    WHERE 
      ro.rn = 1
      AND (@idEjercicio IS NULL OR ro.fkEjercicio = @idEjercicio)
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
	
	
END;

CREATE PROCEDURE sp_obtenerMetaDeParametro
    @idUsuario INT,
    @idParametro INT,
    @idEjercicio INT = NULL,
    @fechaDeReferencia DATETIME = NULL
AS
BEGIN
    -- Asignar la fecha actual si no se proporciona un valor para @fechaDeReferencia
    IF @fechaDeReferencia IS NULL
        SET @fechaDeReferencia = GETDATE();

    SELECT 
        m.metaId,
        m.fkUsuario,
        m.fechaDeInicioDeLaMeta ,
        m.fechaLimite,
        m.fkParametro AS fkParametro,
        pm.nombre AS nombreParametro,
        m.fkEjercicio,
        e.NombreEjercicio,
        m.valorObjetivo 
    FROM 
        metas AS m
    INNER JOIN 
        parametrosDeMedicion AS pm ON m.fkParametro = pm.parametroMedicionId
    LEFT JOIN 
        ejercicios AS e ON m.fkEjercicio = e.EjercicioID 
    WHERE 
        m.fkUsuario = @idUsuario
        AND m.fkParametro = @idParametro
        AND (@idEjercicio IS NULL OR m.fkEjercicio = @idEjercicio)
        AND m.fechaDeInicioDeLaMeta <= @fechaDeReferencia
        AND m.fechaLimite >= @fechaDeReferencia;
END;

CREATE PROCEDURE dbo.sp_obtenerMetasActualesDelClientePorParametro
( 
@idUsuario int
)
AS 
BEGIN
	;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            metaId,
        	fkIntencion,
            fkParametro,
            fkEjercicio,
            valorObjetivo,
            fkNivelDeLogro,            
            fechaDeInicioDeLaMeta,
            fechaLimite,
            fkUsuario,
            ROW_NUMBER() OVER (PARTITION BY fkParametro ORDER BY fechaDeInicioDeLaMeta DESC) AS rn
        FROM metas
        	where fkUsuario =@idUsuario
    )
    
    SELECT ro.metaId,i.nombre as intencion,
    pm.nombre  as nombreParametro,
    ro.fkEjercicio,
    e.NombreEjercicio ,
    ro.valorObjetivo,
    ndl.nombre ,
    ro.fechaDeInicioDeLaMeta,
    ro.fechaLimite,
    ro.fkUsuario,
    ro.fkParametro,
    ndl.nombre as nombreNivelDeLogro
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro as ro
    join intenciones i  on i.intencionId = ro.fkIntencion
    join parametrosDeMedicion pm on pm.parametroMedicionId = ro.fkParametro
    left join Ejercicios e  on e.EjercicioID  = ro.fkEjercicio 
    join nivelesDeLogro ndl on  ndl.idNivelDeLogro = ro.fkNivelDeLogro
    WHERE ro.rn = 1;  
   
END;

CREATE PROCEDURE sp_obtenerMetasDeMedidas
    @idCliente INT,
    @idParametro INT,
    @idEjercicio INT = NULL,
    @datosDeMedida DatosObtencionMetasDeMedida READONLY
AS
BEGIN
    SET NOCOUNT ON;

    
    BEGIN TRY
        -- Declarar variables locales
        DECLARE @mesExtracted INT, @añoExtracted INT;

        -- Asignar valores a las variables desde el parámetro de entrada
        SELECT @mesExtracted = mes, @añoExtracted = año FROM @datosDeMedida; 

        -- Seleccionar las metas correspondientes
        SELECT 
            DISTINCT m.metaId,
            i.nombre AS intencion,
            pm.nombre AS nombreParametro,
            e.NombreEjercicio AS nombreEjercicio,
            m.valorObjetivo,
            nl.nombre AS nombreNivelDeLogro,
            m.fechaDeInicioDeLaMeta ,
            m.fechaLimite,
            m.fkEjercicio,
            m.fkParametro,
            m.fkUsuario
        FROM metas m
        LEFT JOIN intenciones i ON m.fkIntencion = i.intencionId
        INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId 
        LEFT JOIN ejercicios e ON m.fkEjercicio = e.EjercicioID 
        INNER JOIN nivelesDeLogro nl ON m.fkNivelDeLogro = nl.idNivelDeLogro 
        INNER JOIN @datosDeMedida dm ON MONTH(m.fechaDeInicioDeLaMeta) = dm.mes AND YEAR(m.fechaDeInicioDeLaMeta) = dm.año
        WHERE m.fkUsuario = @idCliente
          AND m.fkParametro = @idParametro
          AND (m.fkEjercicio = @idEjercicio OR @idEjercicio IS NULL);
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE 
            @ProcName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
            @ErrorNumber INT = ERROR_NUMBER(),
            @ErrorSeverity INT = ERROR_SEVERITY(),
            @ErrorState INT = ERROR_STATE(),
            @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
            @ErrorLine INT = ERROR_LINE(); 

        -- Registrar el error
        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorMessage,
            @ErrorSeverity,
            @ErrorState,
            NULL, -- Usuario
            NULL, -- Host
            NULL; -- Aplicación

        -- Relanzar el error para que sea visible en la aplicación
        THROW;
    END CATCH;

END;

CREATE PROCEDURE sp_obtenerParametrosDeMedicionConUnidad
AS
BEGIN
    SELECT 
        pm.parametroMedicionId,
        pm.nombre,
        pum.fkUnidadDeMedida,
        um.nombre AS nombreUnidadDeMedida,
        pm.fkICon
    FROM parametrosDeMedicion pm
    JOIN parametros_unidadesDeMedida pum ON pm.parametroMedicionId = pum.fkParametroDeMedicion
    JOIN unidadesDeMedida um ON pum.fkUnidadDeMedida = um.unidadDeMedidaId
    ORDER BY pm.nombre;
END;

CREATE   PROCEDURE dbo.sp_obtenerUltimasMedidasDelUsuario
( 
@idUsuario nvarchar(450)
)
AS 
BEGIN
	;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro ORDER BY fechaDeCreacion DESC) AS rn
        FROM medidas
        	where CAST(fkUsuario AS NVARCHAR(450)) = @idUsuario
    )
    SELECT ro.medidaId,pm.parametroMedicionId as fkParametro ,pm.nombre as nombreParametro,ro.valor,ro.fechaDeCreacion,udm.unidadDeMedidaId,
    udm.nombre  as nombreUnidadDeMedida,ro.fkEjercicio,e.NombreEjercicio,(select iconsf.urlPublica from iconsForParameters iconsf where iconsf.iconId = pm.fkIcon) as urlIconoParametro ,(select iconsf.urlPublica from iconsForParameters iconsf where iconsf.iconId = e.fkIcon) as urlIconoEjercicio,ro.fkUsuario 
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro as ro
    join parametrosDeMedicion pm on pm.parametroMedicionId = ro.fkParametro 
    join parametros_unidadesDeMedida pum on pum.fkParametroDeMedicion = pm.parametroMedicionId
    join unidadesDeMedida udm on pum.fkUnidadDeMedida  = udm.unidadDeMedidaId
    left join Ejercicios e  on e.EjercicioID  = ro.fkEjercicio
    WHERE ro.rn = 1;  
   
END;

CREATE   PROCEDURE [dbo].[sp_obtenerUsuariosConCitasAgendadas]
AS
BEGIN
    SELECT
        -- MODIFICADO: Campos de AspNetUsers y AspNetRoles
        u.NombreCompleto AS Nombre,
        u.Apellido,
        u.Email,
        u.PhoneNumber AS Telefono,
        u.UserName AS NombreUsuario,
        u.PasswordHash AS Contrasena,
        u.FechaDeNacimiento AS FechaNacimiento,
        u.FechaDeRegistro AS FechaRegistro,
        ar.Name AS Rol,
        u.Estado
    FROM FitnessCenterDB.dbo.AspNetUsers AS u
    -- NUEVO: Uniones con AspNetUserRoles y AspNetRoles
    INNER JOIN FitnessCenterDB.dbo.AspNetUserRoles ur ON u.Id = ur.UserId
    INNER JOIN FitnessCenterDB.dbo.AspNetRoles ar ON ur.RoleId = ar.Id
    INNER JOIN FitnessCenterDB.dbo.Citas AS c
    -- MODIFICADO: Campo 'UserId' de 'Citas' en lugar de 'UsuarioID'
    ON c.UserId = u.Id AND c.Estado IN ('agendada','Agendada');
END;

CREATE       PROCEDURE dbo.sp_preReservarHorario
    @idUsuarioQueReserva nvarchar(450),
    @fechaTentativa date,
    @idHoraLaboral int,
    @idPrereservaOut int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    PRINT '1/9 iniciando...'
    
    DECLARE @idsHoraLaborales IdsHorasLaborales;
    INSERT INTO @idsHoraLaborales(fkHoraLaboral) VALUES(@idHoraLaboral);
    PRINT '2/9 ids horas laborales insertados';

    BEGIN TRY
        PRINT '3/9 obteniendo bloqueo';
        -- Obtener el bloqueo exclusivo en la fila
        SELECT idHora 
        FROM FitnessCenterDB.dbo.horasLaborales WITH (ROWLOCK, UPDLOCK, NOWAIT)
        WHERE idHora = @idHoraLaboral;

        PRINT '4/9 verificando disponibilidad';
        -- Verificar que no exista una clase programada
        IF dbo.fn_estaDisponibleElHorario(@fechaTentativa,@idsHoraLaborales) = 1
        BEGIN
            PRINT '5/9 registrando preReserva';
            -- Horario disponible, realizar la pre-reserva
            INSERT INTO FitnessCenterDB.dbo.preReservasDeHorario (
                fkHoraLaboral,
                idUsuarioQueReserva,
                fechaReservada,
                fechaInicioDeLaReserva,
                fechaDeExpiracionDeLaReserva
            )
            VALUES (
                @idHoraLaboral,
                @idUsuarioQueReserva,
                @fechaTentativa,
                GETDATE(),
                DATEADD(MINUTE, 5, GETDATE())
            );
            
            COMMIT TRANSACTION;
            PRINT '6/9 preReserva registrada con éxito'; 
            SELECT @idPrereservaOut = SCOPE_IDENTITY() ;
        END
        ELSE
        BEGIN
            PRINT '7/9 horario no disponible ROLLBACK!!';
            ROLLBACK TRANSACTION;
            SELECT 0 AS IdPreReserva, 'El horario seleccionado no está disponible' AS Mensaje;
        END;
    END TRY
    BEGIN CATCH
        PRINT '8/9 error al registrar la pre reserva ROLLBACK!!!';
        ROLLBACK TRANSACTION;
        
        IF ERROR_NUMBER() = 1222 -- Error de timeout de bloqueo
        BEGIN
            SELECT 0 AS IdPreReserva, 'El horario está siendo reservado por otro usuario. Por favor, intente nuevamente.' AS Mensaje;
        END
        ELSE
        BEGIN
            PRINT '9/9 relanzando error original';
            THROW;
        END
    END CATCH
END;

CREATE PROCEDURE dbo.sp_procesoCompletoCancelacionDeInscripcionAClase
    @idInscripcion INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validar que la inscripción tenga estado "vigente"
        IF dbo.fn_inscripcionEstaVigente(@idInscripcion) = 0
        BEGIN
            THROW 51000, 'Esa inscripción no puede ser cancelada, posiblemente ya fue cancelada o es un id equivocado.', 1;
        END

        -- Llamar al procedimiento para cancelar la inscripción
        EXEC dbo.sp_cancelarInscripcionAClase @idInscripcion;

    END TRY
    BEGIN CATCH
        PRINT N'2/5 excepción capturada';

        DECLARE 
        @ProcName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
        @ErrorNumber INT = ERROR_NUMBER(),
        @ErrorSeverity INT = ERROR_SEVERITY(),
        @ErrorState INT = ERROR_STATE(),
        @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
        @ErrorLine INT = ERROR_LINE(); 

        PRINT N'3/5 registrando log de error';
        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorNumber,
            @ErrorSeverity,
            @ErrorState,
            @ErrorMessage,
            @ErrorLine;

        PRINT N'4/5 error registrado correctamente';

        -- Opcional: volver a lanzar el error para que el cliente lo reciba
        PRINT N'5/5 relanzando THROW'; 
        THROW;
    END CATCH
END;

CREATE PROCEDURE dbo.sp_procesoCompletoCancelarClasesProgramadas
    @idClaseProgramada int = null,
	@fechaParaCancelar date = null,
    @idEntrenador int = null,
    @idClase int = null,
    @estadoDeOperaciones int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			declare @idsClasesCanceladas ListadoIdsGenericos;
			
			INSERT INTO @idsClasesCanceladas 
				EXEC 
				sp_cancelarClasesProgramadas @idClaseProgramada,@fechaParaCancelar,@idEntrenador,@idClase
			
			IF NOT EXISTS (SELECT 1 FROM @idsClasesCanceladas)
			BEGIN
				THROW 51000, '1/5 No hay clases por cancelar en esa fecha', 1;
			END
			
			EXEC sp_cancelarInscripcionesDeClasesCanceladas @idsClasesCanceladas
			
			set @estadoDeOperaciones = 1;
			
       	COMMIT TRANSACTION;
       --EL 1 INDICA QUE LA CANCELACION SE REALIZO CORRECTAMENTE
       return 1;
    END TRY
    BEGIN CATCH
        PRINT N'2/5 excepción capturada';
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

        PRINT N'3/5 registrando log de error';
        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorNumber,
            @ErrorSeverity,
            @ErrorState,
            @ErrorMessage,
            @ErrorLine;

        PRINT N'4/5 error registrado correctamente';

        -- Opcional: volver a lanzar el error para que el cliente lo reciba
        PRINT N'5/5 relanzando THROW'; 
        THROW;
    END CATCH
END;

CREATE PROCEDURE dbo.sp_procesoCompletoReagendacionDeInscripcion
    @idInscripcionCancelada INT,
    @idClaseProgramadaNueva INT,
    @idCliente INT,
    @estadoOperacion INT OUTPUT -- Parámetro de salida
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Llamar al procedimiento para cancelar la inscripción
        EXEC dbo.sp_procesoCompletoCancelacionDeInscripcionAClase @idInscripcion = @idInscripcionCancelada;

        -- Validar si es el mismo tipo de clase, si no lo es se arrojará una excepción
        EXEC dbo.sp_esElMismoTipoDeClase @idInscripcionCancelada, @idClaseProgramadaNueva;

        -- Si la validación es exitosa, registrar nueva inscripción en la clase programada
        EXEC dbo.sp_registrarInsrcipcionAClase @idCliente = @idCliente, @fkProgramacionClase = @idClaseProgramadaNueva;

        -- Asignar estado de operación a 1 si se completó sin problemas
        SET @estadoOperacion = 1;
        
        COMMIT TRANSACTION;

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

        PRINT N'3/5 registrando log de error';
        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorNumber,
            @ErrorSeverity,
            @ErrorState,
            @ErrorMessage,
            @ErrorLine;

        PRINT N'4/5 error registrado correctamente';

        -- Opcional: volver a lanzar el error para que el cliente lo reciba
        PRINT N'5/5 relanzando THROW'; 
        THROW;
    END CATCH
END;

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_registrarCita]
( 
@usuarioID nvarchar(450),
@entrenadorID nvarchar(450),
@fechaInicio datetime,
@tipoCita nvarchar(50),
@estado nvarchar(50),
@fechaHoraFin datetime
	
)
	-- Add the parameters for the stored procedure here
	
	
AS
BEGIN
	BEGIN TRY
		PRINT N'fecha inicio'+  CAST(@fechaInicio AS NVARCHAR(50));
		PRINT N'fecha fin'+  CAST(@fechaHoraFin AS NVARCHAR(50));
		insert into Citas(UserId,
							 EntrenadorID,
							 FechaHora,
							 TipoCita,
							 Estado,
							 FechaHoraFin)
						values(
							@usuarioID,
							@entrenadorID,
							@fechaInicio,
							@tipoCita,
							@estado,
							@fechaHoraFin
						)
	
	END TRY
	BEGIN CATCH
		PRINT N'11/14 excepción capturada';
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
    
        DECLARE 
        @ProcName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
        @ErrorNumber INT = ERROR_NUMBER(),
        @ErrorSeverity INT = ERROR_SEVERITY(),
        @ErrorState INT = ERROR_STATE(),
        @LoginOriginal SYSNAME = ORIGINAL_LOGIN(),
        @Host NVARCHAR(128) = HOST_NAME(),
        @App  NVARCHAR(128) = APP_NAME(),
        @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
        @ErrorLine INT = ERROR_LINE(),
        @CompleteMessage nvarchar(max) = '';
        SET @CompleteMessage = @ErrorMessage + CAST(@ErrorLine AS NVARCHAR(10))+ N'  ' + CAST(@fechaInicio AS NVARCHAR(50)) + N' ' + CAST(@fechaHoraFin AS NVARCHAR(50));

        PRINT N'12/14 registrando log de error';
        EXEC sp_RegistrarError 
            @ProcName,
            @CompleteMessage,
            @ErrorSeverity,
            @ErrorState,
            @LoginOriginal,
            @Host,
        	@App;

        PRINT N'13/14 error registrado correctamente';

        -- Opcional: volver a lanzar el error para que el cliente lo reciba
        PRINT N'14/14 relanzando THROW'; 
        THROW;
	END CATCH
		
END;

CREATE       PROCEDURE dbo.sp_registrarClaseProgramada
    @datos dbo.DatosClaseProgramada READONLY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @idClaseProgramada INT;
        DECLARE @fkClase INT, 
                @fkEntrenador NVARCHAR(450),
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
        PRINT N'1/14 determinando horarios laborales '+cast(@fkEntrenador as nvarchar(10));
       
        
       PRINT N'2/14 registrando clase programada';
        INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (
            fkClase, 
            fkEntrenador, 
            cupoMaximo, 
            fkEstadoClaseProgramada
        )
        VALUES (
            @fkClase, @fkEntrenador, @cupoMaximo, @fkEstadoClaseProgramada
        );

        PRINT N'3/14 clase programada registrada correctamente';
        SET @idClaseProgramada = SCOPE_IDENTITY();


        -- Si hay datos de horarios, registrarlos
        IF @fkHorarioLaboralString IS NOT NULL AND LEN(@fkHorarioLaboralString) > 0
        BEGIN
            PRINT N'4/14 se encontraron horarios laborales';
            DECLARE @horarioId INT;
            DECLARE @posicion INT = 1;
            DECLARE @longitud INT = LEN(@fkHorarioLaboralString);
            DECLARE @valorActual VARCHAR(20);
            DECLARE @estaDisponibleElHorario BIT = 0;
            DECLARE @idsHorasLabotales IdsHorasLaborales;
            WHILE @posicion <= @longitud
            BEGIN
                PRINT N'5/14 empieza bucle conversor de horarios laborales';
                -- Extraer el siguiente valor hasta la coma
                SET @valorActual = '';
                WHILE @posicion <= @longitud AND SUBSTRING(@fkHorarioLaboralString, @posicion, 1) != ','
                BEGIN
                    SET @valorActual = @valorActual + SUBSTRING(@fkHorarioLaboralString, @posicion, 1);
                    SET @posicion = @posicion + 1;
                END

                -- Saltar la coma
                SET @posicion = @posicion + 1;
                    
                PRINT N'6/14 determinando validez del horario';

                -- Convertir a entero y validar
                IF ISNUMERIC(@valorActual) = 1
                BEGIN
                    PRINT N'7/14 id hora laboral correcto';
                    SET @horarioId = CAST(@valorActual AS INT);             
                    -- Registrar el horario
                    PRINT N'8/14 registrando horario';
                    EXEC FitnessCenterDB.dbo.sp_registrarHorarioDeClaseProgramada 
                        @fkClaseProgramada = @idClaseProgramada,
                        @fkHorarioLaboral = @horarioId,
                        @fkEntrenador = @fkEntrenador,
                		@fechaDeLaClase = @fechaDeLaClase;

                    PRINT N'9/14 horario registrado correctamente';
                END
            END
        END

        PRINT N'10/14 transacción completada correctamente';
        COMMIT TRANSACTION;

        SELECT @idClaseProgramada AS IdClaseProgramada;

    END TRY
    BEGIN CATCH
        PRINT N'11/14 excepción capturada';
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

        PRINT N'12/14 registrando log de error';
        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorNumber,
            @ErrorSeverity,
            @ErrorState,
            @ErrorMessage,
            @ErrorLine;

        PRINT N'13/14 error registrado correctamente';

        -- Opcional: volver a lanzar el error para que el cliente lo reciba
        PRINT N'14/14 relanzando THROW'; 
        THROW;
    END CATCH
END;

CREATE     PROCEDURE dbo.sp_registrarHorarioDeClaseProgramada
    @fkClaseProgramada INT,
    @fkHorarioLaboral INT,
    @fkEntrenador nvarchar(450),
    @fechaDeLaClase DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral,fkEntrenador,fechaDeLaClase)
    VALUES (@fkClaseProgramada, @fkHorarioLaboral,@fkEntrenador,@fechaDeLaClase);
    
    RETURN SCOPE_IDENTITY();
END;

CREATE       PROCEDURE dbo.sp_registrarInsrcipcionAClase
(
    @idCliente nvarchar(450),
    @fkProgramacionClase INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @idEstatusActivoDeInscripcion INT = (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase);
        
        INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases
        (
            fkCliente, 
            fkProgramacionClase, 
            fechaDeInscripcion, 
            fkEstadoInscripcion
        )
        VALUES
        (
            @idCliente, 
            @fkProgramacionClase, 
            GETDATE(), 
            @idEstatusActivoDeInscripcion
        );

        COMMIT TRANSACTION;

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

        -- Registrar el error
        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorNumber,
            @ErrorSeverity,
            @ErrorState,
            @ErrorMessage,
            @ErrorLine;

        THROW;
    END CATCH
END;

-- =============================================
-- Author:		Yesenia Esquivel
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =====================================
CREATE PROCEDURE [dbo].[sp_registrarMedida]
( 
@fkUsuario int,
@peso decimal(5,1),
@altura decimal(5,1),
@imc decimal(5,1),
@edad int,
@genero nvarchar(60)
)
AS
BEGIN
		insert into medidas(
							 fkUsuario,
							 peso,
							 altura,
							 imc,
							 edad,
							 genero
							 )
						values(
							@fkUsuario,
							@peso,
							@altura,
							@imc,
							@edad,
							@genero
						)
END;

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_registrarRutina]
(
    @usuarioID NVARCHAR(450),    -- MODIFICADO: Tipo de dato de INT a NVARCHAR(450)
    @entrenadorID NVARCHAR(450), -- MODIFICADO: Tipo de dato de INT a NVARCHAR(450)
    @fechaCreacion datetime,
    @observaciones nvarchar(max)
)
AS
BEGIN
    IF @fechaCreacion IS NULL
    BEGIN
        SET @fechaCreacion = GETDATE();
    END

    INSERT INTO FitnessCenterDB.dbo.Rutinas(
        UserId,       -- MODsp_consultarRutinasDeUsuarioIFICADO: UsuarioID a UserId
        EntrenadorId, -- MODIFICADO: EntrenadorID a EntrenadorId
        FechaCreacion,
        Observaciones)
    VALUES(
        @usuarioID,
        @entrenadorID,
        @fechaCreacion,
        @observaciones)
END;

CREATE PROCEDURE dbo.sp_servicioLimpiarPreReservasCaducadas
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Declarar una variable tipo tabla para almacenar los IDs de pre-reservas caducadas
        DECLARE @idsPreReservasCaducadas dbo.ListadoIdsGenericos;

        -- Insertar los IDs encontrados por la función en la variable tipo tabla
        INSERT INTO @idsPreReservasCaducadas (id)
        SELECT idPreReserva
        FROM dbo.fn_encontrarPreReservasCaducadas();

        -- Llamar al procedimiento que elimina las pre-reservas caducadas
        EXEC dbo.sp_eliminarPreReservasCaducadas @idsPreReservasCaducadas = @idsPreReservasCaducadas;

        -- Devolver los IDs eliminados como resultado
        SELECT id AS IdPreReservaEliminada FROM @idsPreReservasCaducadas;

        COMMIT TRANSACTION;
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

        -- Registrar el error en la tabla de logs
        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorMessage,
            @ErrorSeverity,
            @ErrorState,
            NULL, -- Usuario
            NULL, -- Host
            NULL; -- Aplicación

        -- Relanzar el error para que sea visible en la aplicación
        THROW;
    END CATCH
END;

CREATE PROCEDURE sp_transferirClaseDelCliente
    @idCliente INT,
    @fkProgramacionClase INT
AS
BEGIN
    -- Comenzar una transacción
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Declarar una variable para almacenar el id del estado "vigente"
        DECLARE @idEstadoInscripcion INT;

        -- Obtener el id del estado "vigente"
        SELECT @idEstadoInscripcion = idEstadoInscripcion
        FROM FitnessCenterDB.dbo.estadosInscripciones
        WHERE nombreEstadoInscripcion = 'vigente';

        -- Insertar una nueva inscripción en la tabla inscripcionesDeClases
        INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases (fkCliente, fkProgramacionClase, fkEstadoInscripcion)
        VALUES (@idCliente, @fkProgramacionClase, @idEstadoInscripcion);

        -- Confirmar la transacción
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Si hay un error, revertir la transacción
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        -- Manejo de errores
        DECLARE 
            @ProcName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
            @ErrorNumber INT = ERROR_NUMBER(),
            @ErrorSeverity INT = ERROR_SEVERITY(),
            @ErrorState INT = ERROR_STATE(),
            @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
            @ErrorLine INT = ERROR_LINE(); 

        -- Registrar el error
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