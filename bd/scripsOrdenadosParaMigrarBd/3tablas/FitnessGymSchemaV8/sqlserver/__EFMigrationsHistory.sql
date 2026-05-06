-- =============================================
-- Tabla: __EFMigrationsHistory
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.[__EFMigrationsHistory];

CREATE TABLE FitnessCenterDb.dbo.[__EFMigrationsHistory] (
	MigrationId nvarchar(150) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ProductVersion nvarchar(32) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK___EFMigrationsHistory PRIMARY KEY (MigrationId)
);



GO
