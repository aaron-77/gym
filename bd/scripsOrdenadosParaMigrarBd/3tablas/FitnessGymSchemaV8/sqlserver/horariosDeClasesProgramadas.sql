-- =============================================
-- Tabla: horariosDeClasesProgramadas
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.horariosDeClasesProgramadas;

CREATE TABLE FitnessCenterDb.dbo.horariosDeClasesProgramadas (
	idHorarioDeClaseProgramada int IDENTITY(1,1) NOT NULL,
	fkClaseProgramada int NOT NULL,
	fkHorarioLaboral int NOT NULL,
	fkEstadoHorarioClase int DEFAULT 1 NOT NULL,
	CONSTRAINT PK__horarios__873B1A4EFA42A731 PRIMARY KEY (idHorarioDeClaseProgramada),
	CONSTRAINT FK_horariosDeClasesProgramadas_clasesProgramadas FOREIGN KEY (fkClaseProgramada) REFERENCES FitnessCenterDb.dbo.clasesProgramadas(idProgramacionClase),
	CONSTRAINT FK_horasLborales_horariosClasesProgramadas FOREIGN KEY (fkHorarioLaboral) REFERENCES FitnessCenterDb.dbo.horasLaborales(idHora),
	CONSTRAINT fk_estadosClasesProgramadas_horariosDeClasesProgramadas FOREIGN KEY (fkEstadoHorarioClase) REFERENCES FitnessCenterDb.dbo.estadosHorarioClaseProgramada(idEstadoHorarioClase)
);



GO
