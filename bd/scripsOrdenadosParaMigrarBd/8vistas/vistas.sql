/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR$SQLEXPRESS at 01/23/2026 16:46:38
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW dbo.v_estadoActivoClases AS
SELECT idEstadoClase from estadosDeClases edc where Lower(nombreEstado) = 'activa';

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- dbo.v_idEstadoCanceladoClasesProgramadas source

CREATE   VIEW v_idEstadoCanceladoClasesProgramadas AS
SELECT idEstadoClaseProgramada
FROM  estadosClasesProgramadas
WHERE nombresEstado = 'cancelada';

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- dbo.v_idEstadoCanceladoInscripcionAClase source

CREATE   VIEW v_idEstadoCanceladoInscripcionAClase
AS
SELECT 
    idEstadoInscripcion
FROM 
    FitnessCenterDB.dbo.estadosInscripciones
WHERE 
    nombreEstadoInscripcion = 'cancelada';

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- dbo.v_idEstadoDisponibleClasesProgramadas source

CREATE   VIEW v_idEstadoDisponibleClasesProgramadas AS
SELECT idEstadoClaseProgramada
FROM  estadosClasesProgramadas
WHERE nombresEstado = 'disponible';

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- dbo.v_idEstadoVigenteInscripcionAClase source

CREATE   VIEW v_idEstadoVigenteInscripcionAClase
AS
SELECT 
    idEstadoInscripcion
FROM 
    FitnessCenterDB.dbo.estadosInscripciones
WHERE 
    nombreEstadoInscripcion = 'vigente';

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- dbo.v_nivelesDeDificultad source

CREATE   VIEW v_nivelesDeDificultad
AS
SELECT 
    idNivelDeDificultadDeClase,
    nombreNivelDeDificultad
FROM 
    FitnessCenterDB.dbo.nivelesDeDificultadDeClase;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- dbo.v_nivelesDeIntensidad source

CREATE   VIEW v_nivelesDeIntensidad
AS
SELECT 
    idNivelDeIntensidad,
    nombreNivelDeIntensidad
FROM 
    FitnessCenterDB.dbo.nivelesDeIntensidadDeClase;

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW dbo.vw_HorariosOcupados
WITH SCHEMABINDING
AS
SELECT 
    cp.fkClase,
    cp.fechaDeLaClase,
    h.fkHorarioLaboral,
    h.idHorarioDeClaseProgramada
FROM dbo.clasesProgramadas cp
INNER JOIN dbo.horariosDeClasesProgramadas h 
    ON cp.idProgramacionClase = h.fkClaseProgramada
WHERE cp.fkEstadoClaseProgramada = 1;


GO

