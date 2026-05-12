-- =============================================
-- Tabla: diasFestivosVariables
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.diasFestivosVariables;

CREATE TABLE FitnessCenterDb.dbo.diasFestivosVariables (
	idDiaFestivoVariable int IDENTITY(1,1) NOT NULL,
	nombreDiasFestivoVariable nvarchar(100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	deQueSemana int NULL,
	deQueMes int NULL,
	deQueDia int NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NOT NULL,
	fechaModificacion datetime NULL,
	fkTipoDeRecurrenciaDelFestivo int NOT NULL,
	fkEstadoActividadLaboral int NOT NULL,
	CONSTRAINT PK__diasFest__499CE46553695ECB PRIMARY KEY (idDiaFestivoVariable),
	CONSTRAINT fk_estadosDeActividdadLaboral_diasFestivosVariables FOREIGN KEY (fkEstadoActividadLaboral) REFERENCES FitnessCenterDb.dbo.estadosDeActividadLaboral(idEstadoActividadLaboral),
	CONSTRAINT fk_tiposDeRecurrenciaDeDiasFestivos_diasFestivosVariables FOREIGN KEY (fkTipoDeRecurrenciaDelFestivo) REFERENCES FitnessCenterDb.dbo.tiposDeRecurrenciaDeDiasFestivos(idTipoDeRecurrenciaDeDiaFestivo)
);



GO
