
CREATE OR ALTER FUNCTION dbo.fn_obtenerClasesProgramadaPorIdProgramacionClase(@idProgramacionClase INT)
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
        CONCAT(CONVERT(varchar(5), hl.horaInicio, 108), ' - ', CONVERT(varchar(5), hl.horaFin, 108)) AS labelHorario,
        cp.fkEntrenador,
        -- MODIFICADO: Campo 'NombreCompleto' y 'Apellido' de 'AspNetUsers' en lugar de 'Nombre' y 'Apellido' de 'Usuarios'
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreEntrenador
    FROM FitnessCenterDB.dbo.clasesProgramadas cp
    INNER JOIN FitnessCenterDB.dbo.horariosDeClasesProgramadas hcp
        ON cp.idProgramacionClase = hcp.fkClaseProgramada
    INNER JOIN FitnessCenterDB.dbo.horasLaborales hl
        ON hcp.fkHorarioLaboral = hl.idHora
    INNER JOIN FitnessCenterDB.dbo.AspNetUsers u
        -- MODIFICADO: Tabla 'AspNetUsers' y campo 'Id' en lugar de 'Usuarios' y 'UsuarioID'
        ON cp.fkEntrenador = u.Id
    WHERE cp.idProgramacionClase = @idProgramacionClase
        AND (select dbo.fn_cupoDisponibleClaseProgramada(cp.idProgramacionClase)) > 0
);
GO

CREATE FUNCTION dbo.fn_obtenerClasesProgramadasPorIdClase(@idClase INT)
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
        CONCAT(CONVERT(varchar(5), hl.horaInicio, 108), ' - ', CONVERT(varchar(5), hl.horaFin, 108)) AS labelHorario,
        cp.fkEntrenador,
        -- MODIFICADO: Campo 'NombreCompleto' y 'Apellido' de 'AspNetUsers' en lugar de 'Nombre' y 'Apellido' de 'Usuarios'
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreEntrenador
    FROM
        FitnessCenterDB.dbo.clasesProgramadas cp
        INNER JOIN FitnessCenterDB.dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
        INNER JOIN FitnessCenterDB.dbo.horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
        INNER JOIN FitnessCenterDB.dbo.AspNetUsers u
        -- MODIFICADO: Tabla 'AspNetUsers' y campo 'Id' en lugar de 'Usuarios' y 'UsuarioID'
        ON cp.fkEntrenador = u.Id
    WHERE
        cp.fkClase = @idClase
        and
        (select dbo.fn_cupoDisponibleClaseProgramada(cp.idProgramacionClase) ) > 0
);
GO

CREATE OR ALTER FUNCTION dbo.ObtenerClasesProgramadas(@IdClase  int)
RETURNS TABLE
AS
RETURN
(
    SELECT
        cp.IdProgramacionClase,
        c.NombreClase,
        -- MODIFICADO: Se obtiene la fecha de 'horariosDeClasesProgramadas'
        DATENAME(WEEKDAY, hcp.fechaDeLaClase) AS DiaDeLaSemana,
        -- MODIFICADO: Se obtienen las horas de 'horasLaborales'
        hl.horaInicio AS HoraInicio,
        hl.horaFin AS HoraFin,
        -- MODIFICADO: Campo 'NombreCompleto' y 'Apellido' de 'AspNetUsers' en lugar de 'Nombre' y 'Apellido' de 'Usuarios'
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS NombreEntrenador
    FROM
        FitnessCenterDB.dbo.clasesProgramadas cp
        INNER JOIN FitnessCenterDB.dbo.Clases c ON cp.FkClase = c.claseId
        -- NUEVO: Unión con 'horariosDeClasesProgramadas'
        INNER JOIN FitnessCenterDB.dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
        -- NUEVO: Unión con 'horasLaborales'
        INNER JOIN FitnessCenterDB.dbo.horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
        INNER JOIN FitnessCenterDB.dbo.AspNetUsers u
        -- MODIFICADO: Tabla 'AspNetUsers' y campo 'Id' en lugar de 'Usuarios' y 'UsuarioId'
        ON cp.FkEntrenador = u.Id
    WHERE
        cp.fkClase  = @IdClase
        AND
        -- MODIFICADO: Se usa la fecha de 'horariosDeClasesProgramadas'
        YEAR(hcp.fechaDeLaClase) = YEAR(GETDATE())
        AND cp.fkEstadoClaseProgramada  = 1 --disponible
);
GO

CREATE PROCEDURE buscarClaseProgramadas
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
END
GO

CREATE PROCEDURE [dbo].[sp_consultarUsuarios]
(
@tipoUsuario nvarchar(max),
@estado nvarchar(50)
)
AS
BEGIN
    -- MODIFICADO: Tipo de dato de @rolId a NVARCHAR(450) y obtención del Id de AspNetRoles
    DECLARE @rolId nvarchar(450);
    SELECT @rolId = Id FROM FitnessCenterDB.dbo.AspNetRoles WHERE Name = @tipoUsuario;

    SELECT
        -- MODIFICADO: Campos de AspNetUsers
        u.Id AS UsuarioID,
        u.NombreCompleto AS Nombre,
        u.Apellido AS Apellido,
        u.Email,
        u.PhoneNumber AS Telefono,
        u.FechaDeNacimiento AS FechaNacimiento,
        u.FechaDeRegistro AS FechaRegistro
    FROM FitnessCenterDB.dbo.AspNetUsers u
    -- NUEVO: Unión con AspNetUserRoles y AspNetRoles
    INNER JOIN FitnessCenterDB.dbo.AspNetUserRoles ur ON u.Id = ur.UserId
    INNER JOIN FitnessCenterDB.dbo.AspNetRoles r ON ur.RoleId = r.Id
    WHERE u.Estado = @estado AND r.Id = @rolId;
END;
GO

CREATE PROCEDURE [dbo].[sp_consultarUsuariosProximosAcita]
AS
BEGIN
    DECLARE @fechaActual datetime;
    SET @fechaActual = GETDATE();
    SELECT u.Email, c.FechaHora
    FROM FitnessCenterDB.dbo.AspNetUsers u
    -- MODIFICADO: Campo 'UserId' de 'Citas' en lugar de 'UsuarioID'
    JOIN FitnessCenterDB.dbo.Citas c ON c.UserId = u.Id AND c.FechaHora > GETDATE() AND DATEDIFF(DAY, @fechaActual, c.FechaHora) = 15;
END;
GO

CREATE PROCEDURE sp_obtenerEjerciciosPorUsuario
    -- MODIFICADO: Tipo de dato de @UsuarioID de INT a NVARCHAR(450)
    @UsuarioID NVARCHAR(450)
AS
BEGIN
    SELECT DISTINCT
        E.*
    FROM
        FitnessCenterDB.dbo.AspNetUsers U
    INNER JOIN
        FitnessCenterDB.dbo.Rutinas R
        -- MODIFICADO: Campo 'Id' de 'AspNetUsers' y 'UserId' de 'Rutinas' en lugar de 'UsuarioID'
        ON U.Id = R.UserId
    INNER JOIN
        FitnessCenterDB.dbo.RutinaEjercicios RE ON R.RutinaID = RE.RutinaID
    INNER JOIN
        FitnessCenterDB.dbo.Ejercicios E ON RE.EjercicioID = E.EjercicioID
    WHERE
        -- MODIFICADO: Campo 'Id' de 'AspNetUsers' en lugar de 'UsuarioID' de 'Usuarios'
        U.Id = @UsuarioID
    ORDER BY
        E.EjercicioId
END;
GO

CREATE PROCEDURE [dbo].[sp_obtenerEntrenadoresDisponibles]
(
    @fechaReferencia datetime
)
AS
BEGIN
    -- MODIFICADO: Tipo de dato de @rolEmpleadoId a NVARCHAR(450) y obtención del Id de AspNetRoles
    DECLARE @rolEmpleadoId nvarchar(450);
    SELECT @rolEmpleadoId = Id FROM FitnessCenterDB.dbo.AspNetRoles WHERE Name = 'Entrenador';

    SELECT DISTINCT
        -- MODIFICADO: Campos de AspNetUsers y AspNetRoles
        u.Id AS UsuarioID,
        u.NombreCompleto AS Nombre,
        u.Apellido AS Apellido,
        u.Email,
        u.PhoneNumber AS Telefono,
        u.UserName AS NombreUsuario,
        u.FechaDeNacimiento AS FechaNacimiento,
        u.FechaDeRegistro AS FechaRegistro,
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
        INNER JOIN FitnessCenterDB.dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
        WHERE hcp.fechaDeLaClase = CAST(@fechaReferencia AS DATE)
    );
END;
GO

CREATE PROCEDURE [dbo].[sp_obtenerUsuariosConCitasAgendadas]
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