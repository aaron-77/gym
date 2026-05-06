-- =============================================
-- Tabla: iconsForParameters
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.iconsForParameters;

CREATE TABLE FitnessCenterDb.dbo.iconsForParameters (
	iconId int IDENTITY(1,1) NOT NULL,
	nombre nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	urlPrivada nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	urlPublica nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK__iconsFor__5CE3968F35DA5BE8 PRIMARY KEY (iconId)
);



GO
