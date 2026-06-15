/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR$SQLEXPRESS at 01/23/2026 17:57:49
	See https://dbatools.io/Export-DbaScript for more information
*/
CREATE TYPE [dbo].[DatosClaseProgramada] AS TABLE(
	[fkClase] [int] NULL,
	[fkEntrenador] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL,
	[cupoMaximo] [int] NULL,
	[fkEstadoClaseProgramada] [int] NULL,
	[fechaDeLaClase] [date] NULL,
	[idUsuarioQueReserva] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL,
	[fkHoraLaboral] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[idPreservaDeHorario] [int] NULL
)
GO

CREATE TYPE [dbo].[DatosObtencionMetasDeMedida] AS TABLE(
	[mes] [int] NULL,
	[año] [int] NULL
)
GO

CREATE TYPE [dbo].[FechasDeReferencia] AS TABLE(
	[fechas] [date] NULL
)
GO

CREATE TYPE [dbo].[IdsHorasLaborales] AS TABLE(
	[fkHoraLaboral] [int] NULL
)
GO

CREATE TYPE [dbo].[ListadoIdsGenericos] AS TABLE(
	[id] [int] NULL
)
GO

CREATE TYPE [dbo].[UnidadDeTiempo] AS TABLE(
	[mesOAño] [int] NULL
)
GO

