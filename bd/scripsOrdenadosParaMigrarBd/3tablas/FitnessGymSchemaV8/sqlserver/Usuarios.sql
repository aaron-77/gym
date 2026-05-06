-- =============================================
-- Tabla: Usuarios
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.Usuarios;

CREATE TABLE FitnessCenterDb.dbo.Usuarios (
	UsuarioID int IDENTITY(1,1) NOT NULL,
	Nombre nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Apellido nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Email nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Telefono nvarchar(15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	NombreUsuario nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Contrasena nvarchar(255) COLLATE Modern_Spanish_CI_AS NOT NULL,
	FechaNacimiento date NOT NULL,
	FechaRegistro datetime DEFAULT getdate() NULL,
	RolID int NULL,
	Estado nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK__Usuarios__2B3DE7981B26D7DC PRIMARY KEY (UsuarioID),
	CONSTRAINT UQ__Usuarios__4EC5048011B00D5E UNIQUE (Telefono),
	CONSTRAINT UQ__Usuarios__6B0F5AE04376F638 UNIQUE (NombreUsuario),
	CONSTRAINT UQ__Usuarios__A9D1053404A4BEF2 UNIQUE (Email),
	CONSTRAINT FK__Usuarios__RolID__3D5E1FD2 FOREIGN KEY (RolID) REFERENCES FitnessCenterDb.dbo.Roles(RolID)
);
ALTER TABLE FitnessCenterDb.dbo.Usuarios WITH NOCHECK ADD CONSTRAINT CK__Usuarios__Estado__3E52440B CHECK (([Estado]='PendienteVerificacion' OR [Estado]='Inactivo' OR [Estado]='Activo'));



GO
