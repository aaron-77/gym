-- =============================================
-- Tabla: RutinaEjercicios
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.RutinaEjercicios;

CREATE TABLE FitnessCenterDb.dbo.RutinaEjercicios (
	RutinaEjercicioID int IDENTITY(1,1) NOT NULL,
	RutinaID int NULL,
	EjercicioID int NULL,
	[Sets] int NULL,
	Repeticiones int NULL,
	Peso decimal(5,2) NULL,
	Tiempo int NULL,
	MetaRepeticiones int NULL,
	CONSTRAINT PK__RutinaEj__56420023FA3B532E PRIMARY KEY (RutinaEjercicioID),
	CONSTRAINT FK__RutinaEje__Ejerc__52593CB8 FOREIGN KEY (EjercicioID) REFERENCES FitnessCenterDb.dbo.Ejercicios(EjercicioID),
	CONSTRAINT FK__RutinaEje__Rutin__5165187F FOREIGN KEY (RutinaID) REFERENCES FitnessCenterDb.dbo.Rutinas(RutinaID)
);



GO
