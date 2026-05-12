/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:46
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[preReservasDeHorario](
	[idPreReserva] [int] IDENTITY(1,1) NOT NULL,
	[fechaInicioDeLaReserva] [datetime] NOT NULL,
	[fechaDeExpiracionDeLaReserva] [datetime] NOT NULL,
	[fkHoraLaboral] [int] NOT NULL,
	[idUsuarioQueReserva] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaReservada] [date] NOT NULL,
	[idClase] [int] NULL,
	[fechaDeLaClase] [date] NULL,
	[idEntrenador] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

