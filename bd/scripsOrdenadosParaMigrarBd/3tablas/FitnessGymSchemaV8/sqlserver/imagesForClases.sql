-- =============================================
-- Tabla: imagesForClases
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.imagesForClases;

CREATE TABLE FitnessCenterDb.dbo.imagesForClases (
	idClassImage int IDENTITY(1,1) NOT NULL,
	fkClase int NOT NULL,
	urlParaBanner nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	urlParaParaDescripcionDeClase nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	urlParaBloqueConsejos nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	FechaDeCreacion datetime DEFAULT getdate() NOT NULL,
	FechaDeModificacion datetime DEFAULT getdate() NOT NULL,
	CONSTRAINT PK__imagesFo__F0634AEDFB54D109 PRIMARY KEY (idClassImage),
	CONSTRAINT FK_imagesForClases_Clases FOREIGN KEY (fkClase) REFERENCES FitnessCenterDb.dbo.Clases(ClaseID) ON DELETE CASCADE ON UPDATE CASCADE
);



GO
