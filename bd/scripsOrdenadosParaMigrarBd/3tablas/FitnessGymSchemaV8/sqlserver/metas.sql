-- =============================================
-- Tabla: metas
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.metas;

CREATE TABLE FitnessCenterDb.dbo.metas (
	metaId int IDENTITY(1,1) NOT NULL,
	fkIntencion int NOT NULL,
	fkParametro int NOT NULL,
	fkEjercicio int NULL,
	valorObjetivo decimal(10,2) NOT NULL,
	fechaDeInicioDeLaMeta datetime NOT NULL,
	fechaLimite datetime NOT NULL,
	fechaDeRegistro datetime DEFAULT getdate() NOT NULL,
	fechaDeModificacionDeRegistro datetime DEFAULT getdate() NULL,
	fkNivelDeLogro int DEFAULT 1 NOT NULL,
	fkUsuario nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__metas__8189FF8C363B9BB4 PRIMARY KEY (metaId),
	CONSTRAINT FK_Metas_AspNetUsers_NewFkUsuario FOREIGN KEY (fkUsuario) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id),
	CONSTRAINT FK_Metas_Ejercicios FOREIGN KEY (fkEjercicio) REFERENCES FitnessCenterDb.dbo.Ejercicios(EjercicioID),
	CONSTRAINT FK_Metas_Intenciones FOREIGN KEY (fkIntencion) REFERENCES FitnessCenterDb.dbo.intenciones(intencionId),
	CONSTRAINT FK_Metas_Parametros FOREIGN KEY (fkParametro) REFERENCES FitnessCenterDb.dbo.parametrosDeMedicion(parametroMedicionId),
	CONSTRAINT fk_metas_nivelesDeLogro FOREIGN KEY (fkNivelDeLogro) REFERENCES FitnessCenterDb.dbo.nivelesDeLogro(idNivelDeLogro)
);



GO
