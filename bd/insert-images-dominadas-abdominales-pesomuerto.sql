-- Dominadas (EjercicioID 1)
IF NOT EXISTS (SELECT 1 FROM imagesForExercises WHERE fkEjercicio = 1)
    INSERT INTO imagesForExercises (fkEjercicio, nombreParaElFront, urlPrivada, urlPublica)
    VALUES (1, N'Dominadas', N'../img/dominadas.jpg', N'../img/dominadas.jpg');

-- Abdominales (EjercicioID 2)
IF NOT EXISTS (SELECT 1 FROM imagesForExercises WHERE fkEjercicio = 2)
    INSERT INTO imagesForExercises (fkEjercicio, nombreParaElFront, urlPrivada, urlPublica)
    VALUES (2, N'Abdominales', N'../img/abdominales.jpg', N'../img/abdominales.jpg');

-- peso muerto (EjercicioID 3)
IF NOT EXISTS (SELECT 1 FROM imagesForExercises WHERE fkEjercicio = 3)
    INSERT INTO imagesForExercises (fkEjercicio, nombreParaElFront, urlPrivada, urlPublica)
    VALUES (3, N'peso muerto', N'../img/PesoMuerto.jpg', N'../img/PesoMuerto.jpg');
