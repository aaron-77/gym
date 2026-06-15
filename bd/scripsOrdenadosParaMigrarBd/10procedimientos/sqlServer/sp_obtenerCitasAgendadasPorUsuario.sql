-- =============================================
-- PROCEDURE: sp_obtenerCitasAgendadasPorUsuario
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE       PROCEDURE [dbo].[sp_obtenerCitasAgendadasPorUsuario]
(
    @idUsuario NVARCHAR(450) -- MODIFICADO: Tipo de dato de INT a NVARCHAR(450)
)
AS
BEGIN
    SELECT
        CitaID ,
        UserId as UsuarioId,      
        EntrenadorId , 
        FechaHora ,
        FechaHoraFin ,
        TipoCita,
        Estado
    FROM FitnessCenterDB.dbo.Citas  -- MODIFICADO: Añadido esquema
    WHERE UserId = @idUsuario AND Estado IN ('agendada','Agendada'); -- MODIFICADO: UsuarioID a UserId
END;

CREATE   PROCEDURE sp_obtenerEjerciciosPorUsuario
    @UsuarioID nvarchar(450)
AS
BEGIN
    SELECT DISTINCT 
        E.*
    FROM 
        aspnetusers U
    INNER JOIN 
        Rutinas R ON U.Id= R.UserId
    INNER JOIN 
        RutinaEjercicios RE ON R.RutinaID = RE.RutinaID
    INNER JOIN 
        Ejercicios E ON RE.EjercicioID = E.EjercicioID
    WHERE 
        U.Id = @UsuarioID
    ORDER BY 
        E.EjercicioId
END;

GO
