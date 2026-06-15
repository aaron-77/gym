USE [FitnessCenterDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Modified stored procedure adapted to schema V6
CREATE OR ALTER PROCEDURE dbo.sp_obtenerEntrenadoresDisponibles_v6
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
        WHERE CAST(hcp.fechaDeLaClase AS DATE) = CAST(@fechaReferencia AS DATE)
    );
END;
GO
