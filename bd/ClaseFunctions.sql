CREATE OR ALTER FUNCTION dbo.ObtenerClasesProgramadas(@IdClase  int)
RETURNS TABLE
AS
RETURN
(
	
    SELECT 
        cp.IdProgramacionClase,
        c.NombreClase,
        DATENAME(WEEKDAY, cp.fechaInicio) AS DiaDeLaSemana,
        (SELECT CONVERT(VARCHAR(5), DATEADD(MINUTE, c.tiempoDeDescansoEnMinutos, cp.fechaInicio), 108)) as HoraInicio,
        (SELECT CONVERT(VARCHAR(5), DATEADD(MINUTE, c.tiempoDeDescansoEnMinutos, cp.fechaFin), 108)) as HoraFin,
        e.Nombre + ' ' + e.Apellido AS NombreEntrenador
    FROM 
        ClasesProgramadas cp
        INNER JOIN Clases c ON cp.FkClase = c.claseId
        INNER JOIN Usuarios e ON cp.FkEntrenador = e.UsuarioId
    WHERE 
    	cp.fkClase  = @IdClase
    	AND
        YEAR(cp.fechaInicio) = YEAR(GETDATE())
        AND cp.fkEstadoClaseProgramada  = 1--disponible
);
GO



-- Stored Procedure to insert records in the table ClasesProgramadas
CREATE OR ALTER PROCEDURE dbo.InsertarClaseProgramada
    @FkClase INT,
    @fechaInicio DATETIME,
    @fechaFin DATETIME,
    @FkEntrenador INT,
    @CupoMaximo INT,
    @FkEstadoClaseProgramada INT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO ClasesProgramadas (FkClase,fechaInicio, fechaFin, FkEntrenador, CupoMaximo, fkEstadoClaseProgramada)
    VALUES (@FkClase, @fechaInicio, @fechaFin, @FkEntrenador,@CupoMaximo,@FkEstadoClaseProgramada);
    
    SELECT SCOPE_IDENTITY() AS IdProgramacionClase;
END;
GO



-- Function to check class time availability
CREATE OR ALTER FUNCTION dbo.VerificarDisponibilidadHorario
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
GO



-- Function to retrieve the characteristics of the class (dificultad, intensidad, duración)
--obtiene la informacion del primer bloque de la seccion de detalles de la clase,la que aparece el pricnipio de la pagina
CREATE OR ALTER FUNCTION dbo.ObtenerCaracteristicasDeClase(@IdClase INT)
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



-- Function to retrieve the benefits of the class (from beneficios table)
CREATE OR ALTER FUNCTION dbo.ObtenerBeneficiosDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        bc.beneficio
    FROM 
        BeneficiosDeClase bc
    WHERE 
        bc.FkClase = @IdClase
);
GO

-- Function to retrieve the structure of the class (from estructuraDeClase table)
CREATE OR ALTER FUNCTION dbo.ObtenerEstructuraDeClase(@IdClase INT)
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



-- Function to retrieve the class exercises
CREATE OR ALTER FUNCTION dbo.ObtenerEjerciciosDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        i.urlPublica as UrlIcono,
        e.NombreEjercicio,
        e.Descripcion as DescripcionEjercicio
    FROM 
    	Rutinas r 
    	INNER JOIN RutinaEjercicios re on re.RutinaID =  r.RutinaID
        INNER JOIN Ejercicios e on e.EjercicioId = re.EjercicioID
        LEFT JOIN iconsForParameters  i ON e.FkIcon = i.iconId
    WHERE 
        r.fkClase = @IdClase
);
GO



-- Function to retrieve the class tips
CREATE OR ALTER FUNCTION dbo.ObtenerConsejosDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        c.FkClase,
        c.IntroduccionDeConsejo,
        c.Consejos
    FROM 
        consejosParaLasClases c
    WHERE 
        c.FkClase = @IdClase
);
GO



-- Function to retrieve the recommended equipment for the class
CREATE OR ALTER FUNCTION dbo.ObtenerEquipamientoRecomendado(@IdClase INT)
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

-- Function to retrieve the class schedule data


-- Function to query all class details
    CREATE OR ALTER FUNCTION dbo.ObtenerDetalleDeClase(@IdClase INT)
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
