-- =============================================
-- Tabla: ejercicios_parametrosDeMedicion
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.ejercicios_parametrosDeMedicion;

CREATE TABLE FitnessCenterDb.dbo.ejercicios_parametrosDeMedicion (
	id int IDENTITY(1,1) NOT NULL,
	fkEjercicio int NOT NULL,
	fkParametro int NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NOT NULL,
	fechaModificacion datetime NULL,
	CONSTRAINT PK__ejercici__3213E83FF0FCCAAC PRIMARY KEY (id),
	CONSTRAINT FK_ejercicios_parametrosDeMedicion_Ejercicios FOREIGN KEY (fkEjercicio) REFERENCES FitnessCenterDb.dbo.Ejercicios(EjercicioID),
	CONSTRAINT FK_ejercicios_parametrosDeMedicion_parametrosDeMedicion FOREIGN KEY (fkParametro) REFERENCES FitnessCenterDb.dbo.parametrosDeMedicion(parametroMedicionId)
);
 CREATE NONCLUSTERED INDEX idx_ejercicios_parametrosDeMedicion_ejercicio ON FitnessCenterDb.dbo.ejercicios_parametrosDeMedicion (  fkEjercicio ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX idx_ejercicios_parametrosDeMedicion_parametro ON FitnessCenterDb.dbo.ejercicios_parametrosDeMedicion (  fkParametro ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



GO
