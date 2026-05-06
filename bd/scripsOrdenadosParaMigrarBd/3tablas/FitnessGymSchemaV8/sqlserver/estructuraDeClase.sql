-- =============================================
-- Tabla: estructuraDeClase
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.estructuraDeClase;

CREATE TABLE FitnessCenterDb.dbo.estructuraDeClase (
	idBloque int IDENTITY(1,1) NOT NULL,
	fkClase int NOT NULL,
	numeroConsecutivoDelBloque int NOT NULL,
	duracionMenorEnMinutos int NOT NULL,
	duracionMayorEnMinutos int NOT NULL,
	tituloBloque nvarchar(200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	descripcionBloque nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaDeCreacion datetime DEFAULT getdate() NULL,
	fechaDeModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__estructu__EF4379A8928D581A PRIMARY KEY (idBloque),
	CONSTRAINT FK_Estructura_Clase FOREIGN KEY (fkClase) REFERENCES FitnessCenterDb.dbo.Clases(ClaseID)
);



GO
