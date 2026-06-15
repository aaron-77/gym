-- =============================================
-- Tabla: medidas
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.medidas;

CREATE TABLE FitnessCenterDb.dbo.medidas (
	medidaId int IDENTITY(1,1) NOT NULL,
	fechaDeCreacion datetime DEFAULT getdate() NULL,
	fkParametro int NULL,
	valor decimal(10,2) NULL,
	fkEjercicio int NULL,
	fkUsuario nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__medidas__1C299EFA6221D68B PRIMARY KEY (medidaId),
	CONSTRAINT FK_Medidas_AspNetUsers_NewFkUsuario FOREIGN KEY (fkUsuario) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id),
	CONSTRAINT fk_medidas_ejercicios FOREIGN KEY (fkEjercicio) REFERENCES FitnessCenterDb.dbo.Ejercicios(EjercicioID),
	CONSTRAINT fk_medidas_parametros FOREIGN KEY (fkParametro) REFERENCES FitnessCenterDb.dbo.parametrosDeMedicion(parametroMedicionId)
);



GO
