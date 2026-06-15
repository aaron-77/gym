-- =============================================
-- Tabla: parametros_unidadesDeMedida
-- Fuente: FitnessGymSchemaV8 (2025-05-04)
-- =============================================


-- Drop table

-- DROP TABLE FitnessCenterDb.dbo.parametros_unidadesDeMedida;

CREATE TABLE FitnessCenterDb.dbo.parametros_unidadesDeMedida (
	fkParametroDeMedicion int NOT NULL,
	fkUnidadDeMedida int NOT NULL,
	fechaDeRegistro datetime DEFAULT getdate() NOT NULL,
	CONSTRAINT PK__Parametr__44945C4A9DEF7EB4 PRIMARY KEY (fkParametroDeMedicion,fkUnidadDeMedida),
	CONSTRAINT FK__Parametro__fkPar__4924D839 FOREIGN KEY (fkParametroDeMedicion) REFERENCES FitnessCenterDb.dbo.parametrosDeMedicion(parametroMedicionId),
	CONSTRAINT FK__Parametro__fkUni__4A18FC72 FOREIGN KEY (fkUnidadDeMedida) REFERENCES FitnessCenterDb.dbo.unidadesDeMedida(unidadDeMedidaId)
);



GO
