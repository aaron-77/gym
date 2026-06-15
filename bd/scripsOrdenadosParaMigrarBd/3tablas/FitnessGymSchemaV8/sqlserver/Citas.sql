-- =============================================
-- Tabla: Citas
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.Citas;

CREATE TABLE FitnessCenterDb.dbo.Citas (
	CitaID int IDENTITY(1,1) NOT NULL,
	FechaHora datetime NOT NULL,
	TipoCita nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Estado nvarchar(50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	FechaHoraFin datetime NOT NULL,
	EntrenadorId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__Citas__F0E2D9F2556E9C13 PRIMARY KEY (CitaID),
	CONSTRAINT FK_Citas_AspNetUsers_NewEntrenadorId FOREIGN KEY (EntrenadorId) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id),
	CONSTRAINT FK_Citas_AspNetUsers_NewUserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id)
);
ALTER TABLE FitnessCenterDb.dbo.Citas WITH NOCHECK ADD CONSTRAINT CK__Citas__TipoCita__45F365D3 CHECK (([TipoCita]='Entrenamiento Personal' OR [TipoCita]='Medicion'));
ALTER TABLE FitnessCenterDb.dbo.Citas WITH NOCHECK ADD CONSTRAINT CK__Citas__Estado__46E78A0C CHECK (([Estado]='Cancelada' OR [Estado]='Completada' OR [Estado]='Agendada'));



GO
