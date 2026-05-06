-- =============================================
-- Tabla: nivelesDeLogro
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.nivelesDeLogro;

CREATE TABLE FitnessCenterDb.dbo.nivelesDeLogro (
	idNivelDeLogro int IDENTITY(1,1) NOT NULL,
	nombre nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	fechaDeRegistro datetime DEFAULT getdate() NOT NULL,
	fechaModificacionDeRegistro datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__nivelesD__0A5FC0796013EA3F PRIMARY KEY (idNivelDeLogro)
);



GO
