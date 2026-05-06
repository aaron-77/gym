-- =============================================
-- Tabla: estadosClasesProgramadas
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.estadosClasesProgramadas;

CREATE TABLE FitnessCenterDb.dbo.estadosClasesProgramadas (
	idEstadoClaseProgramada int IDENTITY(1,1) NOT NULL,
	nombresEstado nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fechaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__estadosC__C0C65CED53670AA4 PRIMARY KEY (idEstadoClaseProgramada)
);



GO
