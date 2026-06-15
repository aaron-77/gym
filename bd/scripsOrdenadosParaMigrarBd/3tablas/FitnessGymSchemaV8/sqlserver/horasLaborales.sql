-- =============================================
-- Tabla: horasLaborales
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.horasLaborales;

CREATE TABLE FitnessCenterDb.dbo.horasLaborales (
	idHora int IDENTITY(1,1) NOT NULL,
	horaInicio time NOT NULL,
	horaFin time NOT NULL,
	fechaCreacion datetime DEFAULT getdate() NULL,
	fechaModificacion datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__horasLab__770403DB6FE2950B PRIMARY KEY (idHora)
);



GO
