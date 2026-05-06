-- =============================================
-- Tabla: unidadesDeMedida
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.unidadesDeMedida;

CREATE TABLE FitnessCenterDb.dbo.unidadesDeMedida (
	unidadDeMedidaId int IDENTITY(1,1) NOT NULL,
	nombre nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	fechaDeRegistro datetime DEFAULT getdate() NOT NULL,
	fechaModificacionDeRegistro datetime NULL,
	CONSTRAINT PK__unidades__935D876DD487B38F PRIMARY KEY (unidadDeMedidaId)
);



GO
