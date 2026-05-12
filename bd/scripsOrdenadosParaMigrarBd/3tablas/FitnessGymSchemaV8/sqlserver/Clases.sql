-- =============================================
-- Tabla: Clases
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.Clases;

CREATE TABLE FitnessCenterDb.dbo.Clases (
	ClaseID int IDENTITY(1,1) NOT NULL,
	NombreClase nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Cupo int NOT NULL,
	Descripcion nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	duracionEnMinutos int NULL,
	fkIntensidad int NULL,
	fkDificultad int NULL,
	tiempoDeDescansoEnMinutos int DEFAULT 15 NOT NULL,
	duracionEnMinutosConDescansoIncluido int DEFAULT 60 NOT NULL,
	fkEstadoClase int NULL,
	InstructorId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__Clases__F54296B30E7E66FD PRIMARY KEY (ClaseID),
	CONSTRAINT FK_Clases_AspNetUsers_NewInstructorId FOREIGN KEY (InstructorId) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id),
	CONSTRAINT FK_Clases_Dificultad FOREIGN KEY (fkDificultad) REFERENCES FitnessCenterDb.dbo.nivelesDeDificultadDeClase(idNivelDeDificultadDeClase),
	CONSTRAINT FK_Clases_Intensidad FOREIGN KEY (fkIntensidad) REFERENCES FitnessCenterDb.dbo.nivelesDeIntensidadDeClase(idNivelDeIntensidad),
	CONSTRAINT FK_Clases_estadosDeClases FOREIGN KEY (fkEstadoClase) REFERENCES FitnessCenterDb.dbo.estadosDeClases(idEstadoClase)
);



GO
