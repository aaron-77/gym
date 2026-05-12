-- =============================================
-- Tabla: sysdiagrams
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.sysdiagrams;

CREATE TABLE FitnessCenterDb.dbo.sysdiagrams (
	name sysname COLLATE Modern_Spanish_CI_AS NOT NULL,
	principal_id int NOT NULL,
	diagram_id int IDENTITY(1,1) NOT NULL,
	version int NULL,
	definition varbinary(MAX) NULL,
	CONSTRAINT PK__sysdiagr__C2B05B6153CBA9AD PRIMARY KEY (diagram_id),
	CONSTRAINT UK_principal_name UNIQUE (principal_id,name)
);

-- Extended properties

EXEC FitnessCenterDb.sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=1, @level0type=N'Schema', @level0name=N'dbo', @level1type=N'Table', @level1name=N'sysdiagrams';



GO
