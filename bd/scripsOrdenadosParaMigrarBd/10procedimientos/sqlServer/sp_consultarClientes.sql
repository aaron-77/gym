-- =============================================
-- PROCEDURE: sp_consultarClientes
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
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

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

GO
