-- =============================================
-- Tabla: Roles
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.Roles;

CREATE TABLE FitnessCenterDb.dbo.Roles (
	RolID int IDENTITY(1,1) NOT NULL,
	NombreRol nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK__Roles__F92302D1C65ABB7F PRIMARY KEY (RolID)
);



GO
