-- =============================================
-- Tabla: intenciones
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.intenciones;

CREATE TABLE FitnessCenterDb.dbo.intenciones (
	intencionId int IDENTITY(1,1) NOT NULL,
	nombre nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaDeRegistro datetime DEFAULT getdate() NOT NULL,
	fechaModificacionDeRegistro datetime NULL,
	CONSTRAINT PK__intencio__41F5EC2340AE7FEA PRIMARY KEY (intencionId)
);



GO
