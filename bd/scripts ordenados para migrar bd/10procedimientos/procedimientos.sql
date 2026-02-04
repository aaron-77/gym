/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR$SQLEXPRESS at 01/23/2026 16:54:04
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Modified copy adapted to FitnessGymSchemaV6
CREATE   PROCEDURE dbo.buscarClaseProgramadas
    @idClase INT = NULL,
    @idEntrenador NVARCHAR(450) = NULL,
    @idHoraLaboral INT = NULL,
    @fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        cp.idProgramacionClase,
        c.NombreClase AS nombreDeLaClase,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreCompletoDelEntrenador,
        cp.fechaDeLaClase,
        hl.horaInicio,
        hl.horaFin,
        h.idHorarioDeClaseProgramada
    FROM dbo.clasesProgramadas cp
    INNER JOIN dbo.Clases c ON cp.fkClase = c.ClaseID
    LEFT JOIN dbo.AspNetUsers u ON cp.fkEntrenador = u.Id
    INNER JOIN dbo.horariosDeClasesProgramadas h ON cp.idProgramacionClase = h.fkClaseProgramada
    INNER JOIN dbo.horasLaborales hl ON h.fkHorarioLaboral = hl.idHora
    WHERE
        (@idClase IS NULL OR cp.fkClase = @idClase)
        AND (@idEntrenador IS NULL OR cp.fkEntrenador = @idEntrenador)
        AND (@idHoraLaboral IS NULL OR h.fkHorarioLaboral = @idHoraLaboral)
        AND (@fecha IS NULL OR cp.fechaDeLaClase = @fecha);
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_asignarEjercicio]
( 
@rutinaID int,
@ejercicioID int,
@sets int,
@repeticiones int,
@peso decimal,
@tiempo int,
@metaRepeticiones int
)	
AS
BEGIN
	
	
		insert into RutinaEjercicios(
		RutinaID,
		EjercicioID,
		Sets,
		Repeticiones,
		Peso,
		Tiempo,
		MetaRepeticiones
		)
		values(
		@rutinaID,
		@ejercicioID,
		@sets,
		@repeticiones,
		@peso,
		@tiempo,
		@metaRepeticiones
		)
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_cancelarClasesProgramadas]
    @idClaseProgramada int =null,
	@fechaDeReferencia DATE = null,
    @idEntrenador nvarchar(450) = null,
    @idClase int = null
AS
BEGIN
    SET NOCOUNT ON;
    declare @idsClasesCanceladas ListadoIdsGenericos; 
   -- Si la fechaDeReferencia es NULL, se establece como la fecha actual
    
   --si no se da ua fecha se toma como referencia la fecha actual
   if @fechaDeReferencia is null
   begin
   	 set  @fechaDeReferencia = GETDATE();
   end
   
   IF @idClaseProgramada is not null
   BEGIN
   		insert into @idsClasesCanceladas(id)
   		select idProgramacionClase 
   		from clasesProgramadas cp 
		WHERE cp.fkEstadoClaseProgramada =  (select idEstadoClaseProgramada 
		  								from v_idEstadoDisponibleClasesProgramadas)
		and cp.idProgramacionClase = @idClaseProgramada
   END
   ELSE
   	BEGIN
   		IF @fechadeReferencia = GETDATE() and @idEntrenador is null and @idClase is null
		    BEGIN
			    PRINT 'FECHA POR DEFECTO';
		    	insert into @idsClasesCanceladas
		    	select idProgramacionClase  
		   		from clasesProgramadas cp	
		   		join horariosDeClasesProgramadas hdcp on cp.idProgramacionClase = hdcp.fkClaseProgramada 
		  		where hdcp.fechaDeLaClase  >= @fechaDeReferencia 
		  			and cp.fkEstadoClaseProgramada = (select idEstadoClaseProgramada 
		  								from v_idEstadoDisponibleClasesProgramadas)
		    END
		    ELSE 
		    BEGIN
			    PRINT 'FECHA CUSTOM'+CAST(@fechaDeReferencia as  nvarchar(20));
		    	insert into @idsClasesCanceladas
		    	select idProgramacionClase  
		   		from clasesProgramadas cp	
		   		join horariosDeClasesProgramadas 
		   		hdcp on cp.idProgramacionClase = hdcp.fkClaseProgramada 
		  		where 
		  		((@fechaDeReferencia is null 
		  		or hdcp.fechaDeLaClase  = @fechaDeReferencia)
		  			and (@idEntrenador is null or cp.fkEntrenador  = @idEntrenador)
		  			and (@idClase is null or cp.fkClase  = @idClase))
		  			and cp.fkEstadoClaseProgramada = (select idEstadoClaseProgramada 
		  								from v_idEstadoDisponibleClasesProgramadas)
		    END
   	END
   
   	if not exists (select 1 from @idsClasesCanceladas)
   	begin
   		THROW 51000, 'No se encontraron clases activas para cancelar', 1;
   	end
   	
    --Actualizar el estado de las clases programadas a 'Cancelada' para la fecha especificada
    UPDATE FitnessCenterDB.dbo.clasesProgramadas
    SET fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM FitnessCenterDB.dbo.estadosClasesProgramadas WHERE nombresEstado = 'cancelada')
    WHERE idProgramacionClase in (select * from @idsClasesCanceladas);

    select * from @idsClasesCanceladas;
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Modified stored procedure adapted to schema V6
CREATE   PROCEDURE dbo.sp_cancelarClasesProgramadas_v6
    @idClaseProgramada int = null,
    @fechaDeReferencia DATE = null,
    @idEntrenador nvarchar(450) = null,
    @idClase int = null
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @idsClasesCanceladas dbo.ListadoIdsGenericos; 

    IF @fechaDeReferencia IS NULL
    BEGIN
        SET @fechaDeReferencia = CAST(GETDATE() AS DATE);
    END

    IF @idClaseProgramada IS NOT NULL
    BEGIN
        INSERT INTO @idsClasesCanceladas(id)
        SELECT idProgramacionClase
        FROM dbo.clasesProgramadas cp
        WHERE cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM dbo.v_idEstadoDisponibleClasesProgramadas)
          AND cp.idProgramacionClase = @idClaseProgramada;
    END
    ELSE
    BEGIN
        IF @fechaDeReferencia = CAST(GETDATE() AS DATE) AND @idEntrenador IS NULL AND @idClase IS NULL
        BEGIN
            INSERT INTO @idsClasesCanceladas
            SELECT idProgramacionClase
            FROM dbo.clasesProgramadas cp
            JOIN dbo.horariosDeClasesProgramadas hdcp ON cp.idProgramacionClase = hdcp.fkClaseProgramada
            WHERE cp.fechaDeLaClase >= @fechaDeReferencia
              AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM dbo.v_idEstadoDisponibleClasesProgramadas);
        END
        ELSE
        BEGIN
            INSERT INTO @idsClasesCanceladas
            SELECT idProgramacionClase
            FROM dbo.clasesProgramadas cp
            JOIN dbo.horariosDeClasesProgramadas hdcp ON cp.idProgramacionClase = hdcp.fkClaseProgramada
            WHERE ((@fechaDeReferencia IS NULL OR cp.fechaDeLaClase= @fechaDeReferencia)
                AND (@idEntrenador IS NULL OR cp.fkEntrenador = @idEntrenador)
                AND (@idClase IS NULL OR cp.fkClase = @idClase))
              AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM dbo.v_idEstadoDisponibleClasesProgramadas);
        END
    END

    IF NOT EXISTS (SELECT 1 FROM @idsClasesCanceladas)
    BEGIN
        THROW 51000, 'No se encontraron clases activas para cancelar', 1;
    END

    UPDATE dbo.clasesProgramadas
    SET fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM dbo.estadosClasesProgramadas WHERE nombresEstado = 'cancelada')
    WHERE idProgramacionClase IN (SELECT id FROM @idsClasesCanceladas);

    SELECT * FROM @idsClasesCanceladas;
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_cancelarInscripcionAClase
    @idInscripcion int = null
AS
BEGIN
    SET NOCOUNT ON;
   BEGIN TRY 
   		if @idInscripcion is null
		begin
		  THROW 51000, '1/5 debe suministrarse una insrcipcion para cancelar', 1;
		end
	  
	   update inscripcionesDeClases 
	   set fkEstadoInscripcion = (SELECT idEstadoInscripcion FROM v_idEstadoCanceladoInscripcionAClase) -- Comparar directamente con la vista
	   where idInscripcion = @idInscripcion
	   if @@ROWCOUNT = 0
	   BEGIN 
	   	THROW 51000, 'no existe una insrcipcion con ese id', 1;
	   END
	   
   END TRY
   BEGIN CATCH
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
   END CATCH 
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_cancelarInscripcionesDeClasesCanceladas(
    @idsClasesProgramadasCanceladas ListadoIdsGenericos READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;
    -- Actualizar el estado de las clases programadas a 'Cancelada' para la fecha especificada
    UPDATE FitnessCenterDB.dbo.inscripcionesDeClases 
    SET fkEstadoInscripcion = (SELECT top 1 idEstadoInscripcion 
    							FROM FitnessCenterDB.dbo.estadosInscripciones ei 
    							WHERE ei.nombreEstadoInscripcion = 'cancelada'
    						   )
    WHERE fkProgramacionClase in (select * from @idsClasesProgramadasCanceladas);
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	consulta todos los clientes con el estado asignado en el parametro
-- =============================================
CREATE PROCEDURE [dbo].[sp_consultarClientes]
( 
@estado nvarchar(50)
)	
AS
BEGIN
	select
	Nombre,
	Apellido,
	Email,
	Telefono,
	Contrasena,
	FechaNacimiento,
	FechaRegistro
	FROM Usuarios 
	WHERE Estado = @estado and RolID = 1;
		
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_consultarEjercicios]
AS
BEGIN
		select * from Ejercicios;
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_consultarRutinasDeUsuario]
(
    @usuarioID NVARCHAR(450) -- MODIFICADO: Tipo de dato de INT a NVARCHAR(450)
)
AS
BEGIN
    SELECT
        RutinaID,
        UserId as UsuarioID,       -- MODIFICADO: UsuarioID a UserId
        EntrenadorId, -- MODIFICADO: EntrenadorID a EntrenadorId
        FechaCreacion,
        Observaciones
    FROM FitnessCenterDB.dbo.Rutinas -- MODIFICADO: Añadido esquema
    WHERE UserId = @usuarioID;      -- MODIFICADO: UsuarioID a UserId
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	consulta todos los clientes con el estado asignado en el parametro
-- =============================================
CREATE     PROCEDURE [dbo].[sp_consultarUsuarios]
(
@tipoUsuario nvarchar(max),
@estado nvarchar(50)
)	
AS
BEGIN
declare @rolId nvarchar(max);
select @rolId = Id   from AspNetRoles where Name = @tipoUsuario;
	select
	Id as UsuarioID,
	NombreCompleto as Nombre,
	Apellido,
	Email,
	PhoneNumber as Telefono,
	FechaDeNacimiento as FechaNacimiento,
	FechaDeRegistro as FechaRegistro 
	FROM [FitnessCenterDB].[dbo].aspnetusers u
	join AspNetUserRoles aur on aur.RoleId = @rolId  and u.Id = aur.UserId 
	WHERE Estado = @estado
		
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	consulta todos los clientes con el estado asignado en el parametro
-- =============================================
CREATE   PROCEDURE [dbo].[sp_consultarUsuariosProximosAcita]
	
AS
BEGIN
	declare @fechaActual datetime;
	set @fechaActual = GETDATE();
	select u.Email,c.FechaHora from aspnetusers u
	join Citas c on c.UserID = u.Id and c.FechaHora > GETDATE() and DATEDIFF(DAY,@fechaActual,c.FechaHora) = 15 ;		
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_eliminarCita]
( 
@citaId int	
)
	-- Add the parameters for the stored procedure here
	
	
AS
BEGIN
		delete from Citas where CitaID = @citaId;
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_eliminarPreReservasCaducadas
    @idsPreReservasCaducadas dbo.ListadoIdsGenericos READONLY
AS
BEGIN
    SET NOCOUNT ON;

    -- Eliminar las pre reservas de horario con los IDs contenidos en idsPreReservasCaducadas
    DELETE FROM FitnessCenterDB.dbo.preReservasDeHorario
    WHERE idPreReserva IN (SELECT id FROM @idsPreReservasCaducadas);
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_esElMismoTipoDeClase
(
    @idInscripcionCancelada INT,
    @idClaseProgramadaNueva INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @idClaseInscripcion INT;
    DECLARE @idClaseNueva INT;

    -- Obtener el idClase de la inscripción cancelada
    SELECT @idClaseInscripcion = c.fkClase
    FROM FitnessCenterDB.dbo.inscripcionesDeClases i
    JOIN FitnessCenterDB.dbo.clasesProgramadas c ON i.fkProgramacionClase = c.idProgramacionClase
    WHERE i.idInscripcion = @idInscripcionCancelada;

    -- Obtener el idClase de la nueva clase programada
    SELECT @idClaseNueva = fkClase
    FROM FitnessCenterDB.dbo.clasesProgramadas
    WHERE idProgramacionClase = @idClaseProgramadaNueva;

    -- Comparar los idClase
    IF @idClaseInscripcion = @idClaseNueva
    BEGIN
        RETURN; -- Si son iguales, simplemente retorna
    END
    ELSE
    BEGIN
        -- Lanzar excepción si no son iguales
        RAISERROR('Estás intentando reagendar una clase diferente a la original.', 16, 1);
    END
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_modificarCita]
(
@citaId int,
@entrenadorID nvarchar(450),
@fechaInicio datetime,
@estado nvarchar(50),
@fechaHoraFin datetime
	
)
	-- Add the parameters for the stored procedure here	
AS
BEGIN

	update Citas set 
	EntrenadorID= @entrenadorID,
	FechaHora=@fechaInicio,
	FechaHoraFin=@fechaHoraFin,
	Estado=@estado
	where CitaID = @citaId
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE       PROCEDURE [dbo].[sp_obtenerCitasAgendadasPorUsuario]
(
    @idUsuario NVARCHAR(450) -- MODIFICADO: Tipo de dato de INT a NVARCHAR(450)
)
AS
BEGIN
    SELECT
        CitaID ,
        UserId as UsuarioId,      
        EntrenadorId , 
        FechaHora ,
        FechaHoraFin ,
        TipoCita,
        Estado
    FROM FitnessCenterDB.dbo.Citas  -- MODIFICADO: Añadido esquema
    WHERE UserId = @idUsuario AND Estado IN ('agendada','Agendada'); -- MODIFICADO: UsuarioID a UserId
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE sp_obtenerEjerciciosPorUsuario
    @UsuarioID nvarchar(450)
AS
BEGIN
    SELECT DISTINCT 
        E.*
    FROM 
        aspnetusers U
    INNER JOIN 
        Rutinas R ON U.Id= R.UserId
    INNER JOIN 
        RutinaEjercicios RE ON R.RutinaID = RE.RutinaID
    INNER JOIN 
        Ejercicios E ON RE.EjercicioID = E.EjercicioID
    WHERE 
        U.Id = @UsuarioID
    ORDER BY 
        E.EjercicioId
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_obtenerEjerciciosYParametrosDelCliente]
@idCliente nvarchar(450)
AS
BEGIN
	with ejercicios_del_usuario as(
		select distinct e.EjercicioID ,e.NombreEjercicio,pdm.parametroMedicionId,pdm.nombre as nombreParametro
		from medidas m 
		left join ejercicios_parametrosDeMedicion epdm  on epdm.fkEjercicio  = m.fkEjercicio 
		join Ejercicios e on e.EjercicioID  = epdm.fkEjercicio 
		join parametrosDeMedicion pdm ON epdm.fkParametro  = pdm.parametroMedicionId 
		where m.fkUsuario = @idCliente
	),
	parametros_del_usuario as (
		select distinct null as EjercicioId,null as NombreEjercicio,pdm.parametroMedicionId,pdm.nombre as nombreParametro
		from medidas m 
		join parametrosDeMedicion pdm on pdm.parametroMedicionId = m.fkParametro
		where m.fkUsuario = @idCliente and m.fkEjercicio is null
	)
	select * from ejercicios_del_usuario
	union all
	select * from parametros_del_usuario
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE           PROCEDURE [dbo].[sp_obtenerEntrenadoresDisponibles]
(
    @fechaReferencia datetime2
)
AS
BEGIN
    -- MODIFICADO: Tipo de dato de @rolEmpleadoId a NVARCHAR(450) y obtención del Id de AspNetRoles
    DECLARE @rolEmpleadoId nvarchar(450),@horaDeClaClase time;
    SELECT @rolEmpleadoId = Id FROM FitnessCenterDB.dbo.AspNetRoles WHERE Name = 'Empleado';
    set @horaDeClaClase = cast(@fechaReferencia as time)



    SELECT DISTINCT
        -- MODIFICADO: Campos de AspNetUsers y AspNetRoles
        u.Id AS UsuarioID,
        u.NombreCompleto AS Nombre,
        u.Apellido AS Apellido,
        u.Email,
        u.PhoneNumber AS Telefono,
        u.UserName AS NombreUsuario,
         u.FechaDeNacimiento as FechaNacimiento,
        u.FechaDeRegistro as FechaRegistro,
        ar.Id AS RolID,
        u.Estado
    FROM FitnessCenterDB.dbo.AspNetUsers AS u
    -- NUEVO: Uniones con AspNetUserRoles y AspNetRoles
    INNER JOIN FitnessCenterDB.dbo.AspNetUserRoles ur ON u.Id = ur.UserId
    INNER JOIN FitnessCenterDB.dbo.AspNetRoles ar ON ur.RoleId = ar.Id
    WHERE ar.Id = @rolEmpleadoId AND u.Estado = 'Activo'
    -- MODIFICADO: Nueva lógica para filtrar entrenadores no disponibles por clases programadas
    AND u.Id NOT IN (
        SELECT cp.fkEntrenador
        FROM FitnessCenterDB.dbo.clasesProgramadas cp
        INNER JOIN FitnessCenterDB.dbo.horariosDeClasesProgramadas hcp 
        ON cp.idProgramacionClase = hcp.fkClaseProgramada 
        INNER JOIN FitnessCenterDB.dbo.horasLaborales hl ON hl.idHora = hcp.fkHorarioLaboral AND hl.horaInicio = @horaDeClaClase
        WHERE 
         CAST(cp.fechaDeLaClase AS DATE) = CAST(@fechaReferencia AS DATE)
    );
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Modified stored procedure adapted to schema V6
CREATE   PROCEDURE dbo.sp_obtenerEntrenadoresDisponibles_v6
(
    @fechaReferencia datetime2
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @rolEmpleadoId nvarchar(450);
    SELECT @rolEmpleadoId = Id FROM dbo.AspNetRoles WHERE Name = 'Empleado';

    SELECT DISTINCT
        u.Id AS UsuarioID,
        u.NombreCompleto AS Nombre,
        u.Apellido AS Apellido,
        u.Email,
        u.PhoneNumber AS Telefono,
        u.UserName AS NombreUsuario,
        u.FechaDeNacimiento as FechaNacimiento,
        u.FechaDeRegistro as FechaRegistro,
        ar.Id AS RolID,
        u.Estado
    FROM dbo.AspNetUsers AS u
    INNER JOIN dbo.AspNetUserRoles ur ON u.Id = ur.UserId
    INNER JOIN dbo.AspNetRoles ar ON ur.RoleId = ar.Id
    WHERE ar.Id = @rolEmpleadoId AND u.Estado = 'Activo'
    AND u.Id NOT IN (
        SELECT cp.fkEntrenador
        FROM dbo.clasesProgramadas cp
        INNER JOIN dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
        WHERE CAST(cp.fechaDeLaClase AS DATE) = CAST(@fechaReferencia AS DATE)
    );
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_obtenerHorariosDisponibles]
    @Fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET @Fecha = ISNULL(@Fecha, CAST(GETDATE() AS DATE));

    -- Build calendar dates for the month
    WITH FechasDelMes AS (
        SELECT
            DATEADD(DAY, n.number, DATEFROMPARTS(YEAR(@Fecha), MONTH(@Fecha), 1)) AS Fecha
        FROM master.dbo.spt_values n
        WHERE n.type = 'P'
          AND n.number BETWEEN 0 AND DATEDIFF(DAY, DATEFROMPARTS(YEAR(@Fecha), MONTH(@Fecha), 1), EOMONTH(@Fecha))
    ),

    -- All possible slots: every date x every work hour
    AllSlots AS (
        SELECT
            f.Fecha,
            hl.idHora,
            hl.horaInicio,
            hl.horaFin,
            CASE WHEN DATENAME(dw, f.Fecha) IN ('Sábado','Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
        FROM FechasDelMes f
        CROSS JOIN dbo.horasLaborales hl
        WHERE f.Fecha >= CAST(GETDATE() AS DATE)
    ),

    -- Slots occupied by scheduled classes (use clasesProgramadas.fechaDeLaClase)
    OccupiedByProgramadas AS (
        SELECT DISTINCT
            cp.fechaDeLaClase AS Fecha,
            hl.idHora,
            hl.horaInicio,
            hl.horaFin,
            CASE WHEN DATENAME(dw, cp.fechaDeLaClase) IN ('Sábado','Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
        FROM dbo.horariosDeClasesProgramadas hcp
        INNER JOIN dbo.clasesProgramadas cp ON hcp.fkClaseProgramada = cp.idProgramacionClase
        INNER JOIN dbo.horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
        WHERE cp.fechaDeLaClase IS NOT NULL AND cp.fechaDeLaClase >= @Fecha
    ),

    -- Slots occupied by active pre-reservations
    OccupiedByPreReservas AS (
        SELECT DISTINCT
            pr.fechaReservada AS Fecha,
            hl.idHora,
            hl.horaInicio,
            hl.horaFin,
            CASE WHEN DATENAME(dw, pr.fechaReservada) IN ('Sábado','Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
        FROM dbo.preReservasDeHorario pr
        INNER JOIN dbo.horasLaborales hl ON pr.fkHoraLaboral = hl.idHora
        WHERE CAST(GETDATE() AS DATE) BETWEEN CAST(pr.fechaInicioDeLaReserva AS DATE) AND CAST(pr.fechaDeExpiracionDeLaReserva AS DATE)
    ),

    -- Slots disabled by fixed holidays / rest days
    OccupiedByFixedHolidays AS (
        SELECT DISTINCT
            dfd.fechaFestivaODescanso AS Fecha,
            hl.idHora,
            hl.horaInicio,
            hl.horaFin,
            CASE WHEN DATENAME(dw, dfd.fechaFestivaODescanso) IN ('Sábado','Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
        FROM dbo.diasFestivosYDescansos dfd
        INNER JOIN dbo.estadosDeActividadLaboral eal ON dfd.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
        CROSS JOIN dbo.horasLaborales hl
        WHERE eal.nombreEstadoActividadLaboral = 'no se labora'
    ),

    -- Slots disabled by variable holidays (evaluated per date)
    OccupiedByVariableHolidays AS (
        SELECT DISTINCT
            f.Fecha AS Fecha,
            hl.idHora,
            hl.horaInicio,
            hl.horaFin,
            CASE WHEN DATENAME(dw, f.Fecha) IN ('Sábado','Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
        FROM FechasDelMes f
        INNER JOIN dbo.diasFestivosVariables dfv ON dbo.fn_esDiaFestivoVariableVersionJoin(f.Fecha, dfv.deQueDia, dfv.deQueSemana, dfv.deQueMes, dfv.fkTipoDeRecurrenciaDelFestivo) = 1
        INNER JOIN dbo.estadosDeActividadLaboral eal2 ON dfv.fkEstadoActividadLaboral = eal2.idEstadoActividadLaboral
        CROSS JOIN dbo.horasLaborales hl
        WHERE eal2.nombreEstadoActividadLaboral = 'no se labora'
    ),

    OccupiedSlots AS (
        SELECT Fecha, idHora, horaInicio, horaFin, TipoDeDia FROM OccupiedByProgramadas
        UNION
        SELECT Fecha, idHora, horaInicio, horaFin, TipoDeDia FROM OccupiedByPreReservas
        UNION
        SELECT Fecha, idHora, horaInicio, horaFin, TipoDeDia FROM OccupiedByFixedHolidays
        UNION
        SELECT Fecha, idHora, horaInicio, horaFin, TipoDeDia FROM OccupiedByVariableHolidays
    )

    -- Return all slots except those occupied
    SELECT
        DATENAME(dw, s.Fecha) AS DiaDeLaSemana,
        s.Fecha AS FechaDisponible,
        s.horaInicio,
        s.horaFin,
        s.idHora,
        s.TipoDeDia
    FROM (
        SELECT Fecha, idHora, horaInicio, horaFin, TipoDeDia FROM AllSlots
        EXCEPT
        SELECT Fecha, idHora, horaInicio, horaFin, TipoDeDia FROM OccupiedSlots
    ) s
    ORDER BY s.Fecha, s.horaInicio;
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_obtenerMedidasDelUsuarioPorTiempo]
    @idCliente nvarchar(450),
    @idParametro INT,
    @idEjercicio INT = NULL,
    @espaciadoTemporal NVARCHAR(30),
    @tipoDeBusqueda NVARCHAR(10),
    @meses UnidadDeTiempo readonly,
    @años UnidadDeTiempo readonly, -- Tabla de enteros para meses o años
    @fechaDeInicio DATETIME = NULL,
    @fechaFin DATETIME = NULL,
    @conDetalles int
AS
BEGIN
     SET NOCOUNT ON;
    
declare @parametrosConcatenados nvarchar(max);
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro ,', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
        'Espaciado Temporal: ', @espaciadoTemporal, ', ',
        'Tipo de Búsqueda: ', @tipoDeBusqueda, ', ',
        'Meses: ', (SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @meses), ', ',
        'Años: ', (SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años), ', ',
        'Fecha de Inicio: ', COALESCE(CAST(@fechaDeInicio AS NVARCHAR), 'NULL'), ', ',
        'Fecha Fin: ', COALESCE(CAST(@fechaFin AS NVARCHAR), 'NULL'), ', ',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPorTiempo',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;
	IF @espaciadoTemporal = 'rango'
    BEGIN
        -- Llamar a sp_obtenerMedidasPorRangoDeMeses
        EXEC sp_obtenerMedidasPorRangoDeMeses 
            @idCliente = @idCliente,
            @idParametro = @idParametro,
            @idEjercicio = @idEjercicio,
            @fechaInicial = @fechaDeInicio,
            @fechaFinal = @fechaFin,
            @conDetalles = @conDetalles
           ;
    END
    ELSE
	BEGIN
		-- Se verifica si @espaciadoTemporal es 'individual' y @tipoDeBusqueda es 'MES'
		    IF @espaciadoTemporal = 'individual' AND @tipoDeBusqueda = 'MES'
		    BEGIN
		        -- Llamar a sp_ObtenerMedidasPorMesesEspecificos
		        EXEC sp_ObtenerMedidasPorMesesEspecificos 
		            @idCliente = @idCliente,
		            @idParametro = @idParametro,
		            @idEjercicio = @idEjercicio,
		            @años =@años,
		            @listadoDeMeses = @meses,
		            @conDetalles = @conDetalles;	
		    END
		    ELSE
			    BEGIN
			   		 -- Se verifica si @espaciadoTemporal es 'individual' y @tipoDeBusqueda es 'AÑO'
				    IF @espaciadoTemporal = 'individual' AND @tipoDeBusqueda = 'AÑO'
					    BEGIN
					        -- Llamar a sp_ObtenerMedidasPorAñosEspecificos
					        EXEC sp_ObtenerMedidasPorAñosEspecificos 
					            @idCliente = @idCliente,
					            @idParametro = @idParametro,
					            @idEjercicio = @idEjercicio,
					            @años = @años,
					            @conDetalles = @conDetalles;
					    END 	
			    END
	END
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--obtiene los parametros de las medidas de los cliente de los ejercicio que ya realizo el cliente, 
-- no se devuelve ningun nombre de parametro de ejercicios que el cliente no ha hecho
CREATE PROCEDURE [dbo].[sp_obtenerMedidasDeUsuario]
( 
@idUsuario nvarchar(450)
)	
AS
BEGIN
	select parametroMedicionId,nombre as nombreParametro 
	from parametrosDeMedicion pdm 
	where parametroMedicionId 
		in(select DISTINCT fkParametro from medidas where fkUsuario = @idUsuario );
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ObtenerMedidasPorAñosEspecificos]
    @idCliente nvarchar(450),
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
        	where m.fkUsuario =@idCliente
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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ObtenerMedidasPorMesesEspecificos]
    @idCliente nvarchar(450),
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
        	where m.fkUsuario =@idCliente
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
      ro.fkUsuario = @idCliente
      AND ro.rn =1
      AND pm.parametroMedicionId = @idParametro
      AND ((@idEjercicio IS NULL AND ro.fkEjercicio IS NULL) OR (@idEjercicio IS NOT NULL AND ro.fkEjercicio = @idEjercicio))
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoDeMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_obtenerMedidasPorMesIndividual]
    @idUsuario nvarchar(450),
    @idParametro INT,
    @idEjercicio INT = NULL,
    @listadoDeMeses UnidadDeTiempo readonly
AS
BEGIN
    SELECT 
    m.medidaId,
    pm.parametroMedicionId as fkParametro ,
    pm.nombre as nombreParametro,
    m.valor,
    m.fechaDeCreacion,
    udm.unidadDeMedidaId,
    udm.nombre  as nombreUnidadDeMedida,
    m.fkEjercicio,
    e.NombreEjercicio,
    (select iconsf.urlPublica from iconsForParameters iconsf where iconsf.iconId = pm.fkIcon) as urlIconoParametro ,
    (select iconsf.urlPublica from iconsForParameters iconsf where iconsf.iconId = e.fkIcon) as urlIconoEjercicio,
    m.fkUsuario 
    FROM medidas as m
    join parametrosDeMedicion pm on pm.parametroMedicionId = m.fkParametro 
    join parametros_unidadesDeMedida pum on pum.fkParametroDeMedicion = pm.parametroMedicionId
    join unidadesDeMedida udm on pum.fkUnidadDeMedida  = udm.unidadDeMedidaId
    left join Ejercicios e  on e.EjercicioID  = m.fkEjercicio
    WHERE     m.fkUsuario  = @idUsuario 
    	  and m.fkParametro  = @idParametro
    	  and (@idEjercicio IS NULL OR m.fkEjercicio = @idEjercicio)
    	  and DATEPART(MONTH,m.fechaDeCreacion) in (select * from @listadoDeMeses)
    	  order by m.fechaDeCreacion
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_obtenerMedidasPorRangoDeMeses]
    @idCliente nvarchar(450),
    @idParametro INT,
    @idEjercicio INT,
    @fechaInicial DATETIME,
    @fechaFinal DATETIME,
    @conDetalles int
AS
BEGIN
	IF @conDetalles = 1
	BEGIN
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
        (SELECT iconsf.urlPublica 
         FROM iconsForParameters iconsf 
         WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica 
         FROM iconsForParameters iconsf 
         WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        m.fkUsuario
    FROM medidas m
    INNER JOIN parametrosDeMedicion pm 
        ON m.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  
    	ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion
    INNER JOIN unidadesDeMedida udm 
        ON pudm.fkUnidadDeMedida = udm.unidadDeMedidaId
    LEFT JOIN ejercicios e 
        ON m.fkEjercicio = e.ejercicioId
    WHERE 
      m.fkUsuario = @idCliente
      AND pm.parametroMedicionId = @idParametro
      AND (@idEjercicio IS NULL OR m.fkEjercicio = @idEjercicio)
      AND m.fechaDeCreacion BETWEEN @fechaInicial AND @fechaFinal;	
	END
	ELSE
	BEGIN
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
		        	where fkUsuario =@idCliente
		        	AND m.fkParametro = @idParametro
		      		AND m.fechaDeCreacion BETWEEN @fechaInicial AND @fechaFinal
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
        (SELECT iconsf.urlPublica 
         FROM iconsForParameters iconsf 
         WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica 
         FROM iconsForParameters iconsf 
         WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm 
        ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  
    	ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion
    INNER JOIN unidadesDeMedida udm 
        ON pudm.fkUnidadDeMedida = udm.unidadDeMedidaId
    LEFT JOIN ejercicios e 
        ON ro.fkEjercicio = e.ejercicioId
    WHERE 
      ro.rn =1
      AND (@idEjercicio IS NULL OR ro.fkEjercicio = @idEjercicio)
	END
	
	
    
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_obtenerMetaDeParametro]
    @idUsuario nvarchar(450),
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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_obtenerMetasActualesDelClientePorParametro]
( 
@idUsuario nvarchar(450)
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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_obtenerMetasDeMedidas]
    @idCliente nvarchar(450),
    @idParametro INT,
    @idEjercicio INT = NULL,
    @datosDeMedida DatosObtencionMetasDeMedida READONLY
AS
BEGIN
    SET NOCOUNT ON;

    
    BEGIN TRY
    declare @mesExtracted int,@añoExtracted int;
   select @mesExtracted = mes,@añoExtracted = año from @datosDeMedida; 
	INSERT INTO LogErrores (procedimiento, mensaje, severidad, estado)
        VALUES ('sp_obtenerMetasDeMedidas', 
        concat(
        'idCliente ',
        @idCliente,
       	' Parametro: ',
      	@idParametro,
     	' Ejercicio: ',
    	@idEjercicio,
   		' mes ',
  		@mesExtracted,
  		' año ',
  		@añoExtracted
  		)
  		,
  		1
 		,
 		3
		);

    -- Selección de los datos requeridos
    SELECT 
        distinct m.metaId,
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
    --INNER JOIN medidas md ON pm.parametroMedicionId = md.fkParametro 
    INNER JOIN @datosDeMedida dm ON MONTH(m.fechaDeInicioDeLaMeta) = dm.mes AND YEAR(m.fechaDeInicioDeLaMeta) = dm.año
    WHERE m.fkUsuario = @idCliente
      AND m.fkParametro = @idParametro
      AND (m.fkEjercicio = @idEjercicio OR @idEjercicio IS NULL);
  END TRY
  BEGIN CATCH
        -- Capturar información del error
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        -- Registrar el error en una tabla de logs (opcional)
        INSERT INTO LogErrores (procedimiento, mensaje, severidad, estado)
        VALUES ('sp_obtenerMetasDeMedidas', @ErrorMessage, @ErrorSeverity, @ErrorState);

        -- Relanzar el error para que sea visible en la aplicación
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;

END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
        	where fkUsuario =@idUsuario
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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_preReservarHorario]
    @idUsuarioQueReserva nvarchar(450),
    @fechaTentativa date,
    @idHoraLaboral int,
    @idClase int = NULL,
    @idEntrenador nvarchar(450) = NULL,
    @idPrereservaOut int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    DECLARE @idsHoraLaborales IdsHorasLaborales;
    INSERT INTO @idsHoraLaborales(fkHoraLaboral) VALUES(@idHoraLaboral);

    BEGIN TRY
        -- Verificar que no exista ya una clase programada para la combinación
        IF dbo.yaExisteClaseProgramada(@idClase, @idEntrenador, @fechaTentativa, @idsHoraLaborales) = 1
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('Ya existe una clase programada para esa combinación (clase, fecha, hora, entrenador)',16,1);
            RETURN;
        END

        -- Verificar que no exista ya una pre-reserva vigente para la combinación
        IF dbo.yaExistePreRegistroDeClase(@idClase, @idEntrenador, @fechaTentativa, @idsHoraLaborales) = 1
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('Ya existe una pre-reserva vigente para esa combinación (clase, fecha, hora, entrenador)',16,1);
            RETURN;
        END

        -- Insertar pre-reserva (incluye idClase, fechaDeLaClase, idEntrenador)
        INSERT INTO preReservasDeHorario (
            fkHoraLaboral,
            idUsuarioQueReserva,
            fechaReservada,
            fechaInicioDeLaReserva,
            fechaDeExpiracionDeLaReserva,
            idClase,
            fechaDeLaClase,
            idEntrenador
        )
        VALUES (
            @idHoraLaboral,
            @idUsuarioQueReserva,
            @fechaTentativa,
            GETDATE(),
            DATEADD(MINUTE, 5, GETDATE()),
            @idClase,
            @fechaTentativa,
            @idEntrenador
        );

        SET @idPrereservaOut = SCOPE_IDENTITY();
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        
       IF ERROR_NUMBER() IN (2627, 2601) -- unique constraint / duplicate key
        BEGIN
            RAISERROR('Ya existe una pre-reserva duplicada (constraint unique violada).',16,1);
            RETURN;
        END
        
        ;THROW 50002, 'Ya existe una pre-reserva vigente para esa combinación (clase, fecha, hora, entrenador)', 1;
       
     
        
    END CATCH
END;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_procesoCompletoReagendacionDeInscripcion]
    @idInscripcionCancelada INT,
    @idClaseProgramadaNueva INT,
    @idCliente nvarchar(450),
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

        SET @estadoOperacion = 0;
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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE         PROCEDURE [dbo].[sp_registrarCita]
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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_registrarClaseProgramada]
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

        -- Extraer datos del parámetro tabla
        SELECT TOP 1 
            @fkClase = fkClase,
            @fkEntrenador = fkEntrenador,
            @cupoMaximo = cupoMaximo,
            @fkEstadoClaseProgramada = fkEstadoClaseProgramada,
            @fkHorarioLaboralString = fkHoraLaboral,
            @idPreReservaDeHorario = idPreservaDeHorario,
            @fechaDeLaClase = fechaDeLaClase
        FROM @datos;

        -- Insertar clase programada con fecha y entrenador
        INSERT INTO clasesProgramadas (
            fkClase, 
            fkEntrenador, 
            cupoMaximo, 
            fkEstadoClaseProgramada,
            fechaDeLaClase
        )
        VALUES (
            @fkClase, @fkEntrenador, @cupoMaximo, @fkEstadoClaseProgramada, @fechaDeLaClase
        );

        SET @idClaseProgramada = SCOPE_IDENTITY();

        -- Si hay horarios en string (coma-separado), registrarlos
        IF @fkHorarioLaboralString IS NOT NULL AND LEN(@fkHorarioLaboralString) > 0
        BEGIN
            DECLARE @horarioId INT;
            DECLARE @posicion INT = 1;
            DECLARE @longitud INT = LEN(@fkHorarioLaboralString);
            DECLARE @valorActual VARCHAR(50);

            WHILE @posicion <= @longitud
            BEGIN
                SET @valorActual = '';
                WHILE @posicion <= @longitud AND SUBSTRING(@fkHorarioLaboralString, @posicion, 1) != ','
                BEGIN
                    SET @valorActual = @valorActual + SUBSTRING(@fkHorarioLaboralString, @posicion, 1);
                    SET @posicion = @posicion + 1;
                END

                IF SUBSTRING(@fkHorarioLaboralString, @posicion, 1) = ','
                    SET @posicion = @posicion + 1;

                IF ISNUMERIC(@valorActual) = 1 AND LEN(@valorActual) > 0
                BEGIN
                    SET @horarioId = CAST(@valorActual AS INT);

                    -- Registrar horario (procedimiento ya no requiere fkEntrenador)
                    EXEC sp_registrarHorarioDeClaseProgramada 
                        @fkClaseProgramada = @idClaseProgramada,
                        @fkHorarioLaboral = @horarioId;
                END
            END
        END

        -- Limpiar pre-reserva si existe
        IF @idPreReservaDeHorario IS NOT NULL
        BEGIN
            DELETE FROM preReservasDeHorario 
            WHERE idPreReserva = @idPreReservaDeHorario;
        END

        COMMIT TRANSACTION;
        SELECT @idClaseProgramada AS IdClaseProgramada;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

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

        THROW;
    END CATCH
END;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_RegistrarError]
    @Procedimiento NVARCHAR(255),
    @Mensaje NVARCHAR(MAX),
    @Severidad INT,
    @Estado INT,
    @Usuario NVARCHAR(100) = null, -- Obtiene el usuario actual por defecto
    @Host NVARCHAR(100) = null, -- Obtiene el nombre del host por defecto
    @Aplicacion NVARCHAR(255) = null -- Obtiene el nombre de la aplicación por defecto
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LogErrores (procedimiento, mensaje, severidad, estado, fecha, usuario, host, aplicacion)
    VALUES (@Procedimiento, @Mensaje, @Severidad, @Estado, GETDATE(), @Usuario, @Host, @Aplicacion);
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_registrarHorarioDeClaseProgramada]
    @fkClaseProgramada INT,
    @fkHorarioLaboral INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral, fkEstadoHorarioClase)
    VALUES (@fkClaseProgramada, @fkHorarioLaboral, 1);  -- 1 = activo por defecto
    SELECT SCOPE_IDENTITY() AS idHorarioDeClaseProgramada;
END;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_transferirClaseDelCliente]
    @idCliente nvarchar(450),
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
        EXEC FitnessCenterDB.dbo.sp_RegistrarError 
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

GO

