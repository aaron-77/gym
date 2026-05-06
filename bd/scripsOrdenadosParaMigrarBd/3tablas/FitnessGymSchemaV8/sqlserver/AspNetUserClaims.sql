-- =============================================
-- Tabla: AspNetUserClaims
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.AspNetUserClaims;

CREATE TABLE FitnessCenterDb.dbo.AspNetUserClaims (
	Id int IDENTITY(1,1) NOT NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ClaimType nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	ClaimValue nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK_AspNetUserClaims PRIMARY KEY (Id),
	CONSTRAINT FK_AspNetUserClaims_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id) ON DELETE CASCADE
);
 CREATE NONCLUSTERED INDEX IX_AspNetUserClaims_UserId ON FitnessCenterDb.dbo.AspNetUserClaims (  UserId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



GO
