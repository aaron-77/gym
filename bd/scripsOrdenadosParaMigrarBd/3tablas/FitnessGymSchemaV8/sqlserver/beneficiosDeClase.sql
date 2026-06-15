-- =============================================
-- Tabla: beneficiosDeClase
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.beneficiosDeClase;

CREATE TABLE FitnessCenterDb.dbo.beneficiosDeClase (
	idBeneficio int IDENTITY(1,1) NOT NULL,
	fkClase int NOT NULL,
	beneficio nvarchar(200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	fechaDeCreacion datetime DEFAULT getdate() NULL,
	fechaDeModificacion datetime DEFAULT getdate() NULL,
	fkIcon int NULL,
	descripcionBeneficio nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__benefici__00AAC26A2D2E6E7C PRIMARY KEY (idBeneficio),
	CONSTRAINT FK_Beneficio_Clase FOREIGN KEY (fkClase) REFERENCES FitnessCenterDb.dbo.Clases(ClaseID),
	CONSTRAINT FK_iconsForParameters_beneficios_del_clase FOREIGN KEY (fkIcon) REFERENCES FitnessCenterDb.dbo.iconsForParameters(iconId)
);



GO
