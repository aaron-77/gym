-- =============================================
-- Tabla: AspNetUserTokens
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.AspNetUserTokens;

CREATE TABLE FitnessCenterDb.dbo.AspNetUserTokens (
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	LoginProvider nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Name nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Value nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK_AspNetUserTokens PRIMARY KEY (UserId,LoginProvider,Name),
	CONSTRAINT FK_AspNetUserTokens_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id) ON DELETE CASCADE
);



GO
