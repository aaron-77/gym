-- =============================================
-- Tabla: parametrosDeMedicion
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.parametrosDeMedicion;

CREATE TABLE FitnessCenterDb.dbo.parametrosDeMedicion (
	parametroMedicionId int IDENTITY(1,1) NOT NULL,
	nombre nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	fechaDeRegistro datetime DEFAULT getdate() NOT NULL,
	fechaModificacionDeRegistro datetime NULL,
	fkIcon int NULL,
	CONSTRAINT PK__parametr__FE4B91C8ECDB659E PRIMARY KEY (parametroMedicionId),
	CONSTRAINT fk_parametrosDeMedicion_iconsForParameters FOREIGN KEY (fkIcon) REFERENCES FitnessCenterDb.dbo.iconsForParameters(iconId)
);



GO
