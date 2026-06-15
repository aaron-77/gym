

CREATE TYPE DatosClaseProgramada AS TABLE (
	fkClase int NULL,
	fkEntrenador nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	cupoMaximo int NULL,
	fkEstadoClaseProgramada int NULL,
	fechaDeLaClase date NULL,
	idUsuarioQueReserva nvarchar(450) COLLATE Modern_Spanish_CI_AS NULL,
	fkHoraLaboral nvarchar(MAX) COLLATE Modern_Spanish_CI_AS NULL,
	idPreservaDeHorario int NULL
);
GO
-- DROP TYPE DatosObtencionMetasDeMedida;

CREATE TYPE DatosObtencionMetasDeMedida AS TABLE (
	mes int NULL,
	año int NULL
);
GO
-- DROP TYPE FechasDeReferencia;

CREATE TYPE FechasDeReferencia AS TABLE (
	fechas date NULL
);
GO
-- DROP TYPE IdsHorasLaborales;

CREATE TYPE IdsHorasLaborales AS TABLE (
	fkHoraLaboral int NULL
);
GO
-- DROP TYPE ListadoIdsGenericos;

CREATE TYPE ListadoIdsGenericos AS TABLE (
	id int NULL
);
GO
-- DROP TYPE UnidadDeTiempo;

CREATE TYPE UnidadDeTiempo AS TABLE (
	mesOAño int NULL
);
