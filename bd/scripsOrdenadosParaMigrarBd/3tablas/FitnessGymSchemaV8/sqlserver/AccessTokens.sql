-- =============================================
-- Tabla: AccessTokens
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.AccessTokens;

CREATE TABLE FitnessCenterDb.dbo.AccessTokens (
	AccessTokenId uniqueidentifier DEFAULT newid() NOT NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ClientId nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	TokenHash nvarchar(256) COLLATE Modern_Spanish_CI_AS NOT NULL,
	IssuedAt datetime2 DEFAULT sysutcdatetime() NOT NULL,
	ExpiresAt datetime2 NOT NULL,
	RevokedAt datetime2 NULL,
	IpAddress nvarchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	UserAgent nvarchar(250) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK_AccessTokens PRIMARY KEY (AccessTokenId),
	CONSTRAINT FK_AccessTokens_AspNetUsers FOREIGN KEY (UserId) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id) ON DELETE CASCADE
);
 CREATE NONCLUSTERED INDEX IX_AccessTokens_UserId ON FitnessCenterDb.dbo.AccessTokens (  UserId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



GO
