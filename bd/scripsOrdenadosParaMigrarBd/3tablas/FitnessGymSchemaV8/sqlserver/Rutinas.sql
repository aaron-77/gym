-- =============================================
-- Tabla: Rutinas
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.Rutinas;

CREATE TABLE FitnessCenterDb.dbo.Rutinas (
	RutinaID int IDENTITY(1,1) NOT NULL,
	FechaCreacion datetime DEFAULT getdate() NULL,
	Observaciones nvarchar(255) COLLATE Modern_Spanish_CI_AS NULL,
	fkClase int NULL,
	fkTipoRutina int NULL,
	EntrenadorId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__Rutinas__E76E165A11753A49 PRIMARY KEY (RutinaID),
	CONSTRAINT FK_Rutinas_AspNetUsers_NewEntrenadorId FOREIGN KEY (EntrenadorId) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id),
	CONSTRAINT FK_Rutinas_AspNetUsers_NewUserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id),
	CONSTRAINT FK_Rutinas_Clases FOREIGN KEY (fkClase) REFERENCES FitnessCenterDb.dbo.Clases(ClaseID),
	CONSTRAINT FK_Rutinas_TipoRutina FOREIGN KEY (fkTipoRutina) REFERENCES FitnessCenterDb.dbo.TipoRutina(idTipoRutina)
);



GO
