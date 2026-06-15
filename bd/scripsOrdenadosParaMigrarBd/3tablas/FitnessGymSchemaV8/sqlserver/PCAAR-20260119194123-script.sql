/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:23
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[clasesProgramadas](
	[idProgramacionClase] [int] IDENTITY(1,1) NOT NULL,
	[fkClase] [int] NOT NULL,
	[cupoMaximo] [int] NOT NULL,
	[fkEstadoClaseProgramada] [int] NOT NULL,
	[fechaCreacion] [datetime] NULL,
	[fechaModificacion] [datetime] NULL,
	[fkEntrenador] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaDeLaClase] [date] NULL
) ON [PRIMARY]

GO

