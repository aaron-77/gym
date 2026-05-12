-- =============================================
-- PROCEDURE: sp_consultarRutinasDeUsuario
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   PROCEDURE [dbo].[sp_consultarRutinasDeUsuario]
(
    @usuarioID NVARCHAR(450) -- MODIFICADO: Tipo de dato de INT a NVARCHAR(450)
)
AS
BEGIN
    SELECT
        RutinaID,
        UserId as UsuarioID,       -- MODIFICADO: UsuarioID a UserId
        EntrenadorId, -- MODIFICADO: EntrenadorID a EntrenadorId
        FechaCreacion,
        Observaciones
    FROM FitnessCenterDB.dbo.Rutinas -- MODIFICADO: Añadido esquema
    WHERE UserId = @usuarioID;      -- MODIFICADO: UsuarioID a UserId
END;

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	consulta todos los clientes con el estado asignado en el parametro
-- =============================================

GO
