-- =============================================
-- Tabla: Ejercicios
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.Ejercicios;

CREATE TABLE FitnessCenterDb.dbo.Ejercicios (
	EjercicioID int IDENTITY(1,1) NOT NULL,
	NombreEjercicio nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	TipoEjercicio nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Descripcion nvarchar(255) COLLATE Modern_Spanish_CI_AS NULL,
	fkIcon int NULL,
	CONSTRAINT PK__Ejercici__812226A1579B3B09 PRIMARY KEY (EjercicioID),
	CONSTRAINT fk_ejercicios_iconsForParameters FOREIGN KEY (fkIcon) REFERENCES FitnessCenterDb.dbo.iconsForParameters(iconId)
);
ALTER TABLE FitnessCenterDb.dbo.Ejercicios WITH NOCHECK ADD CONSTRAINT CK__Ejercicio__TipoE__4E88ABD4 CHECK (([TipoEjercicio]='AMRAP' OR [TipoEjercicio]='Tiempo' OR [TipoEjercicio]='Peso'));



GO
