-- =============================================
-- Tabla: tiposDeRecurrenciaDeDiasFestivos
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.tiposDeRecurrenciaDeDiasFestivos;

CREATE TABLE FitnessCenterDb.dbo.tiposDeRecurrenciaDeDiasFestivos (
	idTipoDeRecurrenciaDeDiaFestivo int IDENTITY(1,1) NOT NULL,
	nombreTipoDeRecurrencia nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	descripcion nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	fechaCreacion datetime DEFAULT getdate() NOT NULL,
	fechaModificacion datetime NULL,
	CONSTRAINT PK__tiposDeR__3A34B1D521F4C5E6 PRIMARY KEY (idTipoDeRecurrenciaDeDiaFestivo)
);
 CREATE NONCLUSTERED INDEX IX_tiposDeRecurrenciaDeDiasFestivos_Nombre ON FitnessCenterDb.dbo.tiposDeRecurrenciaDeDiasFestivos (  nombreTipoDeRecurrencia ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



GO
