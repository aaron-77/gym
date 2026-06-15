-- =============================================
-- Tabla: Equipos
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.Equipos;

CREATE TABLE FitnessCenterDb.dbo.Equipos (
	EquipoID int IDENTITY(1,1) NOT NULL,
	NombreEquipo nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Descripcion nvarchar(255) COLLATE Modern_Spanish_CI_AS NULL,
	fkIcon int NULL,
	CONSTRAINT PK__Equipos__DE8A0BFFA22BEA11 PRIMARY KEY (EquipoID),
	CONSTRAINT FK_Equipos_iconsForParameters FOREIGN KEY (fkIcon) REFERENCES FitnessCenterDb.dbo.iconsForParameters(iconId)
);



GO
