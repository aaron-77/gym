-- =============================================
-- Tabla: AspNetRoles
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.AspNetRoles;

CREATE TABLE FitnessCenterDb.dbo.AspNetRoles (
	Id nvarchar(450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	Name nvarchar(256) COLLATE Modern_Spanish_CI_AS NULL,
	NormalizedName nvarchar(256) COLLATE Modern_Spanish_CI_AS NULL,
	ConcurrencyStamp nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK_AspNetRoles PRIMARY KEY (Id)
);
 CREATE UNIQUE NONCLUSTERED INDEX RoleNameIndex ON FitnessCenterDb.dbo.AspNetRoles (  NormalizedName ASC  )  
	 WHERE  ([NormalizedName] IS NOT NULL)
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



GO
