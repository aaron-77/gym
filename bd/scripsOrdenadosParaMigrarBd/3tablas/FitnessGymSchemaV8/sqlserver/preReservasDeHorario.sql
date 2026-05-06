-- =============================================
-- Tabla: preReservasDeHorario
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.preReservasDeHorario;

CREATE TABLE FitnessCenterDb.dbo.preReservasDeHorario (
	idPreReserva int IDENTITY(1,1) NOT NULL,
	fechaInicioDeLaReserva datetime NOT NULL,
	fechaDeExpiracionDeLaReserva datetime NOT NULL,
	fkHoraLaboral int NOT NULL,
	idUsuarioQueReserva nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	fechaReservada date NOT NULL,
	idClase int NULL,
	fechaDeLaClase date NULL,
	idEntrenador nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__preReser__0FAC6FC5DD04E13F PRIMARY KEY (idPreReserva),
	CONSTRAINT FK_preReservasDeHorario_horariosClasesProgramadas FOREIGN KEY (fkHoraLaboral) REFERENCES FitnessCenterDb.dbo.horasLaborales(idHora)
);
 CREATE NONCLUSTERED INDEX IX_preReservasDeHorario_FechaClase ON FitnessCenterDb.dbo.preReservasDeHorario (  fechaDeLaClase ASC  , idClase ASC  )  
	 INCLUDE ( fkHoraLaboral , idEntrenador ) 
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE UNIQUE NONCLUSTERED INDEX UX_preReservasDeHorario_Unique ON FitnessCenterDb.dbo.preReservasDeHorario (  idClase ASC  , fechaDeLaClase ASC  , fkHoraLaboral ASC  , idEntrenador ASC  )  
	 WHERE  ([idClase] IS NOT NULL AND [fechaDeLaClase] IS NOT NULL AND [idEntrenador] IS NOT NULL)
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



GO
