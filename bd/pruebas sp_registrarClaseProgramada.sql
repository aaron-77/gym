-- Script de prueba para dbo.sp_registrarClaseProgramada

-- Prueba 1: Registrar una clase programada con datos válidos
DECLARE @datos dbo.DatosClaseProgramada;
INSERT INTO @datos (fkClase, fechaInicio, fechaFin, fkEntrenador, cupoMaximo, fkEstadoClaseProgramada, horarios)
VALUES (1, '2024-06-20 10:00:00', '2024-06-20 11:00:00', 1, 20, 1, NULL); -- Ajusta los valores según tu base de datos

EXEC dbo.sp_registrarClaseProgramada @datos;

-- Prueba 2: Intentar registrar una clase programada con un horario no disponible
DECLARE @datosNoDisponible dbo.DatosClaseProgramada;
INSERT INTO @datosNoDisponible (fkClase, fechaInicio, fechaFin, fkEntrenador, cupoMaximo, fkEstadoClaseProgramada, horarios)
VALUES (1, '2024-06-20 10:00:00', '2024-06-20 11:00:00', 1, 20, 1, NULL); -- Ajusta los valores según tu base de datos

EXEC dbo.sp_registrarClaseProgramada @datosNoDisponible;

-- Prueba 3: Registrar una clase programada con un cupo máximo de 0 (debería fallar)
DECLARE @datosCupoCero dbo.DatosClaseProgramada;
INSERT INTO @datosCupoCero (fkClase, fechaInicio, fechaFin, fkEntrenador, cupoMaximo, fkEstadoClaseProgramada, horarios)
VALUES (1, '2024-06-20 10:00:00', '2024-06-20 11:00:00', 1, 0, 1, NULL); -- Ajusta los valores según tu base de datos

EXEC dbo.sp_registrarClaseProgramada @datosCupoCero;

-- Puedes agregar más pruebas cambiando los valores de @datos según lo necesites.