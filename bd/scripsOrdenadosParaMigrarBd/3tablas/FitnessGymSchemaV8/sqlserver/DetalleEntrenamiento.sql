-- =============================================
-- Tabla: DetalleEntrenamiento
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.DetalleEntrenamiento;

CREATE TABLE FitnessCenterDb.dbo.DetalleEntrenamiento (
	DetalleID int IDENTITY(1,1) NOT NULL,
	RegistroID int NULL,
	EjercicioID int NULL,
	[Sets] int NULL,
	Repeticiones int NULL,
	Peso decimal(5,2) NULL,
	Tiempo int NULL,
	CONSTRAINT PK__DetalleE__6E19D6FA406B23BB PRIMARY KEY (DetalleID),
	CONSTRAINT FK__DetalleEn__Ejerc__74AE54BC FOREIGN KEY (EjercicioID) REFERENCES FitnessCenterDb.dbo.Ejercicios(EjercicioID),
	CONSTRAINT FK__DetalleEn__Regis__73BA3083 FOREIGN KEY (RegistroID) REFERENCES FitnessCenterDb.dbo.RegistrosEntrenamiento(RegistroID)
);

GO
