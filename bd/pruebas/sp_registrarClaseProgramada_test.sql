-- ============================================
-- Script de prueba para sp_registrarClaseProgramada
-- ============================================

-- 1. Declarar variable del tipo tabla
DECLARE @datos dbo.DatosClaseProgramada;

-- 2. Insertar datos de prueba
INSERT INTO @datos (
    fkClase, 
    fkEntrenador, 
    cupboardMaximo, 
    fkEstadoClaseProgramada, 
    fechaDeLaClase,
    idUsuarioQueReserva,
    fkHoraLaboral,
    idPreservaDeHorario
)
VALUES (
    1,                                      -- fkClase
    'e47637e0-1971-4e46-99fb-186db0847fac', -- fkEntrenador (GUID de uno@gmail.com)
    20,                                     -- cupboardMaximo
    1,                                      -- fkEstadoClaseProgramada (1 = disponible)
    '2026-04-15',                          -- fechaDeLaClase
    'e47637e0-1971-4e46-99fb-186db0847fac', -- idUsuarioQueReserva
    '1',                                    -- fkHoraLaboral (string)
    NULL                                    -- idPreservaDeHorario
);

-- 3. Ejecutar el stored procedure
EXEC dbo.sp_registrarClaseProgramada @datos;

-- 4. Verificar resultado
SELECT TOP 5 * 
FROM clasesProgramadas 
ORDER BY idProgramacionClase DESC;

-- 5. Verificar horariosDeClasesProgramadas
SELECT TOP 5 * 
FROM horariosDeClasesProgramadas 
ORDER BY idHorarioDeClaseProgramada DESC;
