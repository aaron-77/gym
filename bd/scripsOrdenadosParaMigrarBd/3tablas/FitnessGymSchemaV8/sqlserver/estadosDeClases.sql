-- =============================================
-- Tabla: estadosDeClases
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.estadosDeClases;

CREATE TABLE FitnessCenterDb.dbo.estadosDeClases (
	idEstadoClase int IDENTITY(1,1) NOT NULL,
	nombreEstado nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	descripcionEstado nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fechaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__estadosD__A4F595D46615EEBC PRIMARY KEY (idEstadoClase)
);



GO
