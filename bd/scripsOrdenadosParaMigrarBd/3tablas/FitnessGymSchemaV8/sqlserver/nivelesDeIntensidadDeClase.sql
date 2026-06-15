-- =============================================
-- Tabla: nivelesDeIntensidadDeClase
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.nivelesDeIntensidadDeClase;

CREATE TABLE FitnessCenterDb.dbo.nivelesDeIntensidadDeClase (
	idNivelDeIntensidad int IDENTITY(1,1) NOT NULL,
	nombreNivelDeIntensidad nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	fechaDeCreacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__nivelesD__6F6E9594C607DCB8 PRIMARY KEY (idNivelDeIntensidad)
);



GO
