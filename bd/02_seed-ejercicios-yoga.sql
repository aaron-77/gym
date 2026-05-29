/*
    Seed script: Agregar ejercicios de yoga a la clase Yoga Avanzado (ClaseID = 12)
    Tarea 7 - backlog version listado
*/

USE [FitnessCenterDB]

BEGIN TRY
    BEGIN TRANSACTION

    -- =============================================
    -- 1. Insertar ejercicios de yoga en Ejercicios
    -- =============================================
    PRINT '--- Insertando ejercicios de yoga ---';

    INSERT [dbo].[Ejercicios] ([NombreEjercicio], [TipoEjercicio], [Descripcion], [fkIcon])
    VALUES (N'Adho Mukha Svanasana', N'Tiempo', N'Postura del perro boca abajo — estiramiento completo de cadena posterior', NULL)

    INSERT [dbo].[Ejercicios] ([NombreEjercicio], [TipoEjercicio], [Descripcion], [fkIcon])
    VALUES (N'Virabhadrasana I', N'Tiempo', N'Guerrero I — postura de fuerza y equilibrio en el tren inferior', NULL)

    INSERT [dbo].[Ejercicios] ([NombreEjercicio], [TipoEjercicio], [Descripcion], [fkIcon])
    VALUES (N'Virabhadrasana II', N'Tiempo', N'Guerrero II — apertura de cadera y fortalecimiento de piernas', NULL)

    INSERT [dbo].[Ejercicios] ([NombreEjercicio], [TipoEjercicio], [Descripcion], [fkIcon])
    VALUES (N'Vrksasana', N'Tiempo', N'Postura del árbol — equilibrio y concentración', NULL)

    INSERT [dbo].[Ejercicios] ([NombreEjercicio], [TipoEjercicio], [Descripcion], [fkIcon])
    VALUES (N'Trikonasana', N'Tiempo', N'Postura del triángulo — estiramiento lateral y apertura de caderas', NULL)

    INSERT [dbo].[Ejercicios] ([NombreEjercicio], [TipoEjercicio], [Descripcion], [fkIcon])
    VALUES (N'Bhujangasana', N'Tiempo', N'Postura de la cobra — apertura de pecho y fortalecimiento de espalda baja', NULL)

    INSERT [dbo].[Ejercicios] ([NombreEjercicio], [TipoEjercicio], [Descripcion], [fkIcon])
    VALUES (N'Balasana', N'Tiempo', N'Postura del niño — descanso y estiramiento de espalda', NULL)

    INSERT [dbo].[Ejercicios] ([NombreEjercicio], [TipoEjercicio], [Descripcion], [fkIcon])
    VALUES (N'Savasana', N'Tiempo', N'Postura del cadáver — relajación final y cierre de la práctica', NULL)

    PRINT '  8 ejercicios de yoga insertados'

    -- =============================================
    -- 2. Insertar rutina de yoga para ClaseID = 12
    -- =============================================
    PRINT '--- Insertando rutina de yoga ---'

    INSERT [dbo].[Rutinas] ([FechaCreacion], [Observaciones], [fkClase], [fkTipoRutina], [EntrenadorId], [UserId])
    VALUES (CAST(N'2026-05-29T00:00:00.000' AS DateTime), N'Rutina de yoga avanzado — posturas en sánscrito', 12, 1, N'8094a747-55d9-4782-9b31-b6602a79b7ed', N'8094a747-55d9-4782-9b31-b6602a79b7ed')

    DECLARE @RutinaID INT = SCOPE_IDENTITY()

    PRINT '  Rutina de yoga insertada (RutinaID = ' + CAST(@RutinaID AS NVARCHAR(10)) + ')'

    -- =============================================
    -- 3. Vincular ejercicios a la rutina
    -- =============================================
    PRINT '--- Vinculando ejercicios a la rutina ---'

    INSERT [dbo].[RutinaEjercicios] ([RutinaID], [EjercicioID], [Sets], [Repeticiones], [Peso], [Tiempo], [MetaRepeticiones])
    VALUES (@RutinaID, (SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Adho Mukha Svanasana'), 1, 0, CAST(0.00 AS Decimal(5, 2)), 60, NULL)

    INSERT [dbo].[RutinaEjercicios] ([RutinaID], [EjercicioID], [Sets], [Repeticiones], [Peso], [Tiempo], [MetaRepeticiones])
    VALUES (@RutinaID, (SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Virabhadrasana I'), 1, 0, CAST(0.00 AS Decimal(5, 2)), 45, NULL)

    INSERT [dbo].[RutinaEjercicios] ([RutinaID], [EjercicioID], [Sets], [Repeticiones], [Peso], [Tiempo], [MetaRepeticiones])
    VALUES (@RutinaID, (SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Virabhadrasana II'), 1, 0, CAST(0.00 AS Decimal(5, 2)), 45, NULL)

    INSERT [dbo].[RutinaEjercicios] ([RutinaID], [EjercicioID], [Sets], [Repeticiones], [Peso], [Tiempo], [MetaRepeticiones])
    VALUES (@RutinaID, (SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Vrksasana'), 1, 0, CAST(0.00 AS Decimal(5, 2)), 45, NULL)

    INSERT [dbo].[RutinaEjercicios] ([RutinaID], [EjercicioID], [Sets], [Repeticiones], [Peso], [Tiempo], [MetaRepeticiones])
    VALUES (@RutinaID, (SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Trikonasana'), 1, 0, CAST(0.00 AS Decimal(5, 2)), 45, NULL)

    INSERT [dbo].[RutinaEjercicios] ([RutinaID], [EjercicioID], [Sets], [Repeticiones], [Peso], [Tiempo], [MetaRepeticiones])
    VALUES (@RutinaID, (SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Bhujangasana'), 1, 0, CAST(0.00 AS Decimal(5, 2)), 45, NULL)

    INSERT [dbo].[RutinaEjercicios] ([RutinaID], [EjercicioID], [Sets], [Repeticiones], [Peso], [Tiempo], [MetaRepeticiones])
    VALUES (@RutinaID, (SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Balasana'), 1, 0, CAST(0.00 AS Decimal(5, 2)), 60, NULL)

    INSERT [dbo].[RutinaEjercicios] ([RutinaID], [EjercicioID], [Sets], [Repeticiones], [Peso], [Tiempo], [MetaRepeticiones])
    VALUES (@RutinaID, (SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Savasana'), 1, 0, CAST(0.00 AS Decimal(5, 2)), 90, NULL)

    PRINT '  8 ejercicios vinculados a la rutina'

    -- =============================================
    -- 4. Registrar imágenes para los ejercicios
    -- =============================================
    PRINT '--- Registrando imágenes de ejercicios de yoga ---'

    INSERT [dbo].[imagesForExercises] ([fkEjercicio], [nombreParaElFront], [urlPrivada], [urlPublica])
    VALUES ((SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Adho Mukha Svanasana'), N'Adho Mukha Svanasana', N'../img/adho-mukha-svanasana.jpg', N'../img/adho-mukha-svanasana.jpg')

    INSERT [dbo].[imagesForExercises] ([fkEjercicio], [nombreParaElFront], [urlPrivada], [urlPublica])
    VALUES ((SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Virabhadrasana I'), N'Virabhadrasana I', N'../img/virabhadrasana-i.jpg', N'../img/virabhadrasana-i.jpg')

    INSERT [dbo].[imagesForExercises] ([fkEjercicio], [nombreParaElFront], [urlPrivada], [urlPublica])
    VALUES ((SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Virabhadrasana II'), N'Virabhadrasana II', N'../img/virabhadrasana-ii.jpg', N'../img/virabhadrasana-ii.jpg')

    INSERT [dbo].[imagesForExercises] ([fkEjercicio], [nombreParaElFront], [urlPrivada], [urlPublica])
    VALUES ((SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Vrksasana'), N'Vrksasana', N'../img/vrksasana.jpg', N'../img/vrksasana.jpg')

    INSERT [dbo].[imagesForExercises] ([fkEjercicio], [nombreParaElFront], [urlPrivada], [urlPublica])
    VALUES ((SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Trikonasana'), N'Trikonasana', N'../img/trikonasana.jpg', N'../img/trikonasana.jpg')

    INSERT [dbo].[imagesForExercises] ([fkEjercicio], [nombreParaElFront], [urlPrivada], [urlPublica])
    VALUES ((SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Bhujangasana'), N'Bhujangasana', N'../img/bhujangasana.jpg', N'../img/bhujangasana.jpg')

    INSERT [dbo].[imagesForExercises] ([fkEjercicio], [nombreParaElFront], [urlPrivada], [urlPublica])
    VALUES ((SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Balasana'), N'Balasana', N'../img/balasana.jpg', N'../img/balasana.jpg')

    INSERT [dbo].[imagesForExercises] ([fkEjercicio], [nombreParaElFront], [urlPrivada], [urlPublica])
    VALUES ((SELECT EjercicioID FROM Ejercicios WHERE NombreEjercicio = N'Savasana'), N'Savasana', N'../img/savasana.jpg', N'../img/savasana.jpg')

    PRINT '  8 imágenes registradas para ejercicios de yoga'
    PRINT '=== Script completado: 8 ejercicios de yoga agregados a la clase Yoga Avanzado ==='

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    PRINT 'ERROR: ' + ERROR_MESSAGE()
    PRINT 'Line: ' + CAST(ERROR_LINE() AS NVARCHAR(10))
END CATCH
