-- =============================================
-- Tabla: nivelesDeDificultadDeClase
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.nivelesDeDificultadDeClase;

CREATE TABLE FitnessCenterDb.dbo.nivelesDeDificultadDeClase (
	idNivelDeDificultadDeClase int IDENTITY(1,1) NOT NULL,
	nombreNivelDeDificultad nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaDeCreacion datetime NULL,
	fechaDeModificacion datetime NULL,
	CONSTRAINT PK__nivelesD__86F5BA39539AB17D PRIMARY KEY (idNivelDeDificultadDeClase)
);



GO
