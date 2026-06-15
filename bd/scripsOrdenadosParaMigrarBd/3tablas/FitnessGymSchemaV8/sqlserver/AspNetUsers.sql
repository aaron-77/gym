-- =============================================
-- Tabla: AspNetUsers
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.AspNetUsers;

CREATE TABLE FitnessCenterDb.dbo.AspNetUsers (
	Id nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	NombreCompleto nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NOT NULL,
	UserName nvarchar(256) COLLATE Modern_Spanish_CI_AS NULL,
	NormalizedUserName nvarchar(256) COLLATE Modern_Spanish_CI_AS NULL,
	Email nvarchar(256) COLLATE Modern_Spanish_CI_AS NULL,
	NormalizedEmail nvarchar(256) COLLATE Modern_Spanish_CI_AS NULL,
	EmailConfirmed bit NOT NULL,
	PasswordHash nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	SecurityStamp nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	ConcurrencyStamp nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	PhoneNumber nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	PhoneNumberConfirmed bit NOT NULL,
	TwoFactorEnabled bit NOT NULL,
	LockoutEnd datetimeoffset NULL,
	LockoutEnabled bit NOT NULL,
	AccessFailedCount int NOT NULL,
	NumeroDeIdentificacion nvarchar(MAX) COLLATE Modern_Spanish_CI_AS DEFAULT N'' NOT NULL,
	Direccion nvarchar(MAX) COLLATE Modern_Spanish_CI_AS DEFAULT N'' NOT NULL,
	FechaDeNacimiento datetime2 DEFAULT '0001-01-01T00:00:00.0000000' NOT NULL,
	Apellido nvarchar(50) COLLATE Modern_Spanish_CI_AS DEFAULT N'' NOT NULL,
	Estado nvarchar(50) COLLATE Modern_Spanish_CI_AS DEFAULT N'' NOT NULL,
	FechaDeRegistro datetime2 DEFAULT '0001-01-01T00:00:00.0000000' NOT NULL,
	IdAntiguo int NULL,
	IdSecundario int IDENTITY(1,1) NOT NULL,
	CONSTRAINT PK_AspNetUsers PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX EmailIndex ON FitnessCenterDb.dbo.AspNetUsers (  NormalizedEmail ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE UNIQUE NONCLUSTERED INDEX UserNameIndex ON FitnessCenterDb.dbo.AspNetUsers (  NormalizedUserName ASC  )  
	 WHERE  ([NormalizedUserName] IS NOT NULL)
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



GO
