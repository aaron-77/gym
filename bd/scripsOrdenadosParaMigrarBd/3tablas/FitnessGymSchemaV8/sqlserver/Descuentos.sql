-- =============================================
-- Tabla: Descuentos
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.Descuentos;

CREATE TABLE FitnessCenterDb.dbo.Descuentos (
	DescuentoID int IDENTITY(1,1) NOT NULL,
	Porcentaje decimal(5,2) NOT NULL,
	Descripcion nvarchar(255) COLLATE Modern_Spanish_CI_AS NULL,
	FechaInicio datetime NOT NULL,
	FechaFin datetime NOT NULL,
	CONSTRAINT PK__Descuent__0C2C1138689BA8C4 PRIMARY KEY (DescuentoID)
);



GO
