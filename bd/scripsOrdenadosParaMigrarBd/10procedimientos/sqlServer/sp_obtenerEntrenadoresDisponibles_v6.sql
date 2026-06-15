-- =============================================
-- PROCEDURE: sp_obtenerEntrenadoresDisponibles_v6
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

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

GO
