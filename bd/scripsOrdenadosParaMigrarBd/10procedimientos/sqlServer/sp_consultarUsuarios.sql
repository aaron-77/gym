-- =============================================
-- PROCEDURE: sp_consultarUsuarios
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
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

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	consulta todos los clientes con el estado asignado en el parametro
-- =============================================

GO
