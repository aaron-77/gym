-- =============================================
-- Tabla: imagesForExercises
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.imagesForExercises;

CREATE TABLE FitnessCenterDb.dbo.imagesForExercises (
	idImage int IDENTITY(1,1) NOT NULL,
	fkEjercicio int NOT NULL,
	nombreParaElFront nvarchar(200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	urlPrivada nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	urlPublica nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK__imagesFo__84D649AFC118D1B7 PRIMARY KEY (idImage),
	CONSTRAINT FK_ImagesForExercises_Ejercicio FOREIGN KEY (fkEjercicio) REFERENCES FitnessCenterDb.dbo.Ejercicios(EjercicioID)
);



GO
