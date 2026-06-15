-- =============================================
-- Tabla: estadosHorarioClaseProgramada
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.estadosHorarioClaseProgramada;

CREATE TABLE FitnessCenterDb.dbo.estadosHorarioClaseProgramada (
	idEstadoHorarioClase int IDENTITY(1,1) NOT NULL,
	nombreEstadoHorario nvarchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fechaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__estadosH__FE1509CB80800E66 PRIMARY KEY (idEstadoHorarioClase)
);



GO
