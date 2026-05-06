-- =============================================
-- Tabla: AspNetUserLogins
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.AspNetUserLogins;

CREATE TABLE FitnessCenterDb.dbo.AspNetUserLogins (
	LoginProvider nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ProviderKey nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ProviderDisplayName nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	CONSTRAINT PK_AspNetUserLogins PRIMARY KEY (LoginProvider,ProviderKey),
	CONSTRAINT FK_AspNetUserLogins_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id) ON DELETE CASCADE
);
 CREATE NONCLUSTERED INDEX IX_AspNetUserLogins_UserId ON FitnessCenterDb.dbo.AspNetUserLogins (  UserId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



GO
