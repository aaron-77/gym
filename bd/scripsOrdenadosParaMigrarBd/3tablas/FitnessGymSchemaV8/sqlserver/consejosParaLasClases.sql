-- =============================================
-- Tabla: consejosParaLasClases
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.consejosParaLasClases;

CREATE TABLE FitnessCenterDb.dbo.consejosParaLasClases (
	idConsejo int IDENTITY(1,1) NOT NULL,
	fkClase int NULL,
	fkEjercicio int NULL,
	introduccionDeConsejo nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	consejos nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK__consejos__3DB777ADDB7A6091 PRIMARY KEY (idConsejo),
	CONSTRAINT FK_Consejos_Clase FOREIGN KEY (fkClase) REFERENCES FitnessCenterDb.dbo.Clases(ClaseID) ON DELETE SET NULL,
	CONSTRAINT FK_Consejos_Ejercicio FOREIGN KEY (fkEjercicio) REFERENCES FitnessCenterDb.dbo.Ejercicios(EjercicioID) ON DELETE SET NULL
);



GO
