-- =============================================
-- Tabla: diasFestivosYDescansos
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.diasFestivosYDescansos;

CREATE TABLE FitnessCenterDb.dbo.diasFestivosYDescansos (
	idDiaFestivo int IDENTITY(1,1) NOT NULL,
	fechaFestivaODescanso date NOT NULL,
	descripcion nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	fkEstadoActividadLaboral int NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fcehaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__diasFest__A066CE26B7DC05E6 PRIMARY KEY (idDiaFestivo),
	CONSTRAINT fecha_unica UNIQUE (fechaFestivaODescanso),
	CONSTRAINT FK_diasFestivosYDescansos_EstadoActividadLaboral FOREIGN KEY (fkEstadoActividadLaboral) REFERENCES FitnessCenterDb.dbo.estadosDeActividadLaboral(idEstadoActividadLaboral)
);
 CREATE NONCLUSTERED INDEX IX_diasFestivosYDescansos_Fecha ON FitnessCenterDb.dbo.diasFestivosYDescansos (  fechaFestivaODescanso ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



GO
