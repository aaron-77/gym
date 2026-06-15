-- =============================================
-- PROCEDURE: sp_obtenerUsuariosConCitasAgendadas
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

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
