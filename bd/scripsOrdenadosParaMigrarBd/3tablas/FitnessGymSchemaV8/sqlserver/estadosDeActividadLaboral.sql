-- =============================================
-- Tabla: estadosDeActividadLaboral
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.estadosDeActividadLaboral;

CREATE TABLE FitnessCenterDb.dbo.estadosDeActividadLaboral (
	idEstadoActividadLaboral int IDENTITY(1,1) NOT NULL,
	nombreEstadoActividadLaboral nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fcehaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__estadosD__F41B8ED8EC454C75 PRIMARY KEY (idEstadoActividadLaboral)
);



GO
