CREATE   PROCEDURE [dbo].[sp_consultarUsuarios]
(
    @tipoUsuario NVARCHAR(MAX),
    @estado NVARCHAR(50)
)
AS
BEGIN
    SELECT
        u.Id AS UsuarioID,
        u.NombreCompleto AS Nombre,
        u.Apellido,
        u.Email,
        u.PhoneNumber AS Telefono,
        u.FechaDeNacimiento AS FechaNacimiento,
        u.FechaDeRegistro AS FechaRegistro
    FROM FitnessCenterDB.dbo.AspNetUsers AS u
    INNER JOIN FitnessCenterDB.dbo.AspNetUserRoles AS aur ON u.Id = aur.UserId
    INNER JOIN FitnessCenterDB.dbo.AspNetRoles AS ar ON aur.RoleId = ar.Id
    WHERE u.Estado = @estado AND ar.Name = @tipoUsuario;
END; 