USE [FitnessCenterDB]
GO

/****** Script: Agregar columnas a preReservasDeHorario ******/
/****** Esto es PASO 1 de la migración ******/

-- Paso 1: Agregar nuevas columnas a preReservasDeHorario
ALTER TABLE [dbo].[preReservasDeHorario]
ADD 
    [idClase] [int] NULL,
    [fechaDeLaClase] [date] NULL,
    [idEntrenador] [nvarchar](450) NULL
GO


-- Paso 3: Crear índice UNIQUE para garantizar una única pre-reserva por combinación
-- (clase, fecha, hora, entrenador)
CREATE UNIQUE NONCLUSTERED INDEX [UX_preReservasDeHorario_Unique]
ON [dbo].[preReservasDeHorario] 
(
    [idClase] ASC,
    [fechaDeLaClase] ASC,
    [fkHoraLaboral] ASC,
    [idEntrenador] ASC
)
WHERE ([idClase] IS NOT NULL AND [fechaDeLaClase] IS NOT NULL AND [idEntrenador] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- Paso 4: Crear índice para búsquedas por fecha y clase
CREATE NONCLUSTERED INDEX [IX_preReservasDeHorario_FechaClase]
ON [dbo].[preReservasDeHorario] 
(
    [fechaDeLaClase] ASC,
    [idClase] ASC
)
INCLUDE ([fkHoraLaboral], [idEntrenador])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

PRINT 'Tabla preReservasDeHorario modificada exitosamente'
GO
