-- =============================================
-- Tabla: RegistrosEntrenamiento
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.RegistrosEntrenamiento;

CREATE TABLE FitnessCenterDb.dbo.RegistrosEntrenamiento (
	RegistroID int IDENTITY(1,1) NOT NULL,
	RutinaID int NULL,
	FechaRegistro datetime DEFAULT getdate() NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__Registro__B897313EAB9C2539 PRIMARY KEY (RegistroID),
	CONSTRAINT FK_RegistrosEntrenamiento_AspNetUsers_NewUserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id),
	CONSTRAINT FK__Registros__Rutin__6FE99F9F FOREIGN KEY (RutinaID) REFERENCES FitnessCenterDb.dbo.Rutinas(RutinaID)
);



GO
