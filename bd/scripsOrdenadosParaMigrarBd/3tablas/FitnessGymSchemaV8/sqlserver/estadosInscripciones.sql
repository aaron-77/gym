-- =============================================
-- Tabla: estadosInscripciones
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.estadosInscripciones;

CREATE TABLE FitnessCenterDb.dbo.estadosInscripciones (
	idEstadoInscripcion int IDENTITY(1,1) NOT NULL,
	nombreEstadoInscripcion nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fechaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__estadosI__5CD68FF4850AB16F PRIMARY KEY (idEstadoInscripcion)
);



GO
