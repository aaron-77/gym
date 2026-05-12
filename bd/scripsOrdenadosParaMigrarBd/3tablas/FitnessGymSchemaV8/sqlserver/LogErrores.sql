-- =============================================
-- Tabla: LogErrores
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.LogErrores;

CREATE TABLE FitnessCenterDb.dbo.LogErrores (
	id int IDENTITY(1,1) NOT NULL,
	procedimiento nvarchar(200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	mensaje nvarchar(4000) COLLATE Modern_Spanish_CI_AS NOT NULL,
	severidad int NOT NULL,
	estado int NOT NULL,
	fecha datetime DEFAULT getdate() NULL,
	usuario nvarchar(100) COLLATE Modern_Spanish_CI_AS DEFAULT suser_name() NULL,
	host nvarchar(100) COLLATE Modern_Spanish_CI_AS DEFAULT host_name() NULL,
	aplicacion nvarchar(200) COLLATE Modern_Spanish_CI_AS DEFAULT app_name() NULL,
	CONSTRAINT PK__LogError__3213E83F2E02FD9A PRIMARY KEY (id)
);



GO
