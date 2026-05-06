-- =============================================
-- Tabla: RefreshTokens
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.RefreshTokens;

CREATE TABLE FitnessCenterDb.dbo.RefreshTokens (
	RefreshTokenId uniqueidentifier DEFAULT newid() NOT NULL,
	UserId nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	ClientId nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	TokenHash nvarchar(256) COLLATE Modern_Spanish_CI_AS NOT NULL,
	IssuedAt datetime2 DEFAULT sysutcdatetime() NOT NULL,
	ExpiresAt datetime2 NOT NULL,
	RevokedAt datetime2 NULL,
	ReplacedByTokenId uniqueidentifier NULL,
	IpAddress nvarchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	UserAgent nvarchar(250) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK_RefreshTokens PRIMARY KEY (RefreshTokenId),
	CONSTRAINT FK_RefreshTokens_AspNetUsers FOREIGN KEY (UserId) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id) ON DELETE CASCADE
);
 CREATE NONCLUSTERED INDEX IX_RefreshTokens_UserId ON FitnessCenterDb.dbo.RefreshTokens (  UserId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



GO
