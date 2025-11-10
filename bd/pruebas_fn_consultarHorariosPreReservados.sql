-- Script de prueba para dbo.fn_consultarHorariosPreReservados

-- Prueba 1: Consultar pre-reservas para una fecha específica (ajusta la fecha según tus datos)
DECLARE @fechaTentativa DATE = '2024-06-15';
SELECT * FROM dbo.fn_consultarHorariosPreReservados(@fechaTentativa);

-- Prueba 2: Consultar pre-reservas para la fecha actual
DECLARE @fechaTentativaActual DATE = GETDATE();
SELECT * FROM dbo.fn_consultarHorariosPreReservados(@fechaTentativaActual);

-- Prueba 3: Consultar pre-reservas para una fecha futura
DECLARE @fechaTentativaFutura DATE = DATEADD(DAY, 7, GETDATE());
SELECT * FROM dbo.fn_consultarHorariosPreReservados(@fechaTentativaFutura);

-- Puedes agregar más pruebas cambiando el valor de @fechaTentativa según lo necesites. 