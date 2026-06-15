-- =============================================
-- Tabla: Cupones
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.Cupones;

CREATE TABLE FitnessCenterDb.dbo.Cupones (
	CuponID int IDENTITY(1,1) NOT NULL,
	Codigo nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	DescuentoID int NULL,
	FechaExpiracion datetime NOT NULL,
	Estado nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK__Cupones__C43568B78A3A377F PRIMARY KEY (CuponID),
	CONSTRAINT FK__Cupones__Descuen__6B24EA82 FOREIGN KEY (DescuentoID) REFERENCES FitnessCenterDb.dbo.Descuentos(DescuentoID)
);
ALTER TABLE FitnessCenterDb.dbo.Cupones WITH NOCHECK ADD CONSTRAINT CK__Cupones__Estado__6C190EBB CHECK (([Estado]='Expirado' OR [Estado]='Usado' OR [Estado]='Activo'));



GO
