-- =============================================
-- Tabla: Servicios
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.Servicios;

CREATE TABLE FitnessCenterDb.dbo.Servicios (
	ServicioID int IDENTITY(1,1) NOT NULL,
	NombreServicio nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Descripcion nvarchar(255) COLLATE Modern_Spanish_CI_AS NULL,
	TipoServicio nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Costo decimal(10,2) NOT NULL,
	CONSTRAINT PK__Servicio__D5AEEC221B5A2D82 PRIMARY KEY (ServicioID)
);
ALTER TABLE FitnessCenterDb.dbo.Servicios WITH NOCHECK ADD CONSTRAINT CK__Servicios__TipoS__412EB0B6 CHECK (([TipoServicio]='Combinado' OR [TipoServicio]='Rendimiento' OR [TipoServicio]='Estetica' OR [TipoServicio]='Salud'));



GO
