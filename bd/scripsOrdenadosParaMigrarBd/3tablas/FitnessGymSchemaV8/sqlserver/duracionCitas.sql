-- =============================================
-- Tabla: duracionCitas
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.duracionCitas;

CREATE TABLE FitnessCenterDb.dbo.duracionCitas (
	DuracionID int IDENTITY(1,1) NOT NULL,
	Duracion int NOT NULL,
	FrecuenciaNotificaciones int NOT NULL,
	CONSTRAINT PK__duracion__3B2C07DA2413E2C8 PRIMARY KEY (DuracionID)
);



GO
