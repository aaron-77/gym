-- =============================================
-- Tabla: clasesProgramadas
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.clasesProgramadas;

CREATE TABLE FitnessCenterDb.dbo.clasesProgramadas (
	idProgramacionClase int IDENTITY(1,1) NOT NULL,
	fkClase int NOT NULL,
	cupoMaximo int NOT NULL,
	fkEstadoClaseProgramada int NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fechaModificacion datetime DEFAULT getdate() NULL,
	fkEntrenador nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	fechaDeLaClase date DEFAULT CONVERT([date],getdate()) NULL,
	CONSTRAINT PK__clasesPr__712E87EE8D30E7B0 PRIMARY KEY (idProgramacionClase),
	CONSTRAINT FK_ClasesProgramadas_AspNetUsers_NewFkEntrenador FOREIGN KEY (fkEntrenador) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id),
	CONSTRAINT FK_ClasesProgramadas_Clase FOREIGN KEY (fkClase) REFERENCES FitnessCenterDb.dbo.Clases(ClaseID),
	CONSTRAINT FK_ClasesProgramadas_EstadoClaseProgramada FOREIGN KEY (fkEstadoClaseProgramada) REFERENCES FitnessCenterDb.dbo.estadosClasesProgramadas(idEstadoClaseProgramada)
);



GO
