-- =============================================
-- Tabla: TipoRutina
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.TipoRutina;

CREATE TABLE FitnessCenterDb.dbo.TipoRutina (
	idTipoRutina int IDENTITY(1,1) NOT NULL,
	nombreTipoRutina nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaDeCreacion datetime DEFAULT getdate() NULL,
	fechaDeModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__TipoRuti__55C9CD78F168D142 PRIMARY KEY (idTipoRutina)
);



GO
