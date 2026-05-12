-- =============================================
-- PROCEDURE: sp_obtenerEntrenadoresDisponibles
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
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

-- Modified stored procedure adapted to schema V6

GO
