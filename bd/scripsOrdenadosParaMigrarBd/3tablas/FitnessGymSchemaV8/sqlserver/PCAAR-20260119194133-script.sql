/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:33
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[horariosDeClasesProgramadas](
	[idHorarioDeClaseProgramada] [int] IDENTITY(1,1) NOT NULL,
	[fkClaseProgramada] [int] NOT NULL,
	[fkHorarioLaboral] [int] NOT NULL,
	[fkEstadoHorarioClase] [int] NOT NULL
) ON [PRIMARY]

GO

