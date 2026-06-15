-- =============================================
-- Tabla: inscripcionesDeClases
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.inscripcionesDeClases;

CREATE TABLE FitnessCenterDb.dbo.inscripcionesDeClases (
	idInscripcion int IDENTITY(1,1) NOT NULL,
	fkProgramacionClase int NOT NULL,
	fechaDeInscripcion datetime DEFAULT getdate() NULL,
	fkEstadoInscripcion int NOT NULL,
	fkCliente nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	CONSTRAINT PK__inscripc__3D58AB69B61D8617 PRIMARY KEY (idInscripcion),
	CONSTRAINT FK_InscripcionesDeClases_AspNetUsers_NewFkCliente FOREIGN KEY (fkCliente) REFERENCES FitnessCenterDb.dbo.AspNetUsers(Id),
	CONSTRAINT FK_InscripcionesDeClases_EstadoInscripcion FOREIGN KEY (fkEstadoInscripcion) REFERENCES FitnessCenterDb.dbo.estadosInscripciones(idEstadoInscripcion),
	CONSTRAINT FK_InscripcionesDeClases_ProgramacionClase FOREIGN KEY (fkProgramacionClase) REFERENCES FitnessCenterDb.dbo.clasesProgramadas(idProgramacionClase)
);



GO
