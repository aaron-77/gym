-- =============================================
-- Tabla: EjercicioEquipos
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.EjercicioEquipos;

CREATE TABLE FitnessCenterDb.dbo.EjercicioEquipos (
	EjercicioEquipoID int IDENTITY(1,1) NOT NULL,
	EjercicioID int NULL,
	EquipoID int NULL,
	CONSTRAINT PK__Ejercici__A8CC48FDB85B7151 PRIMARY KEY (EjercicioEquipoID),
	CONSTRAINT FK__Ejercicio__Ejerc__571DF1D5 FOREIGN KEY (EjercicioID) REFERENCES FitnessCenterDb.dbo.Ejercicios(EjercicioID),
	CONSTRAINT FK__Ejercicio__Equip__5812160E FOREIGN KEY (EquipoID) REFERENCES FitnessCenterDb.dbo.Equipos(EquipoID)
);



GO
