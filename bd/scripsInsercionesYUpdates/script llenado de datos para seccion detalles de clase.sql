 
INSERT INTO Usuarios (NombreUsario, Apellido, Email, Telefono, FechaNacimiento, Contrasena, FechaRegistro, RolID, Estado) 
VALUES 
('Corona', 'Pera', 'vidalsanchez@gmail.com', '+34707 20 87 02', '1983-05-22', 'hashed_pass_1', '2021-03-03 03:16:59', 1, 'Activo'),
('Marcio', 'Sáenz', 'tvillaverde@pozuelo-fuentes.com', '+34 727 938 900', '1990-08-02', 'hashed_pass_2', '2022-12-22 13:08:17', 1, 'Activo'),
('Calista', 'López', 'angelitaalamo@maestre.org', '+34710 538 151', '2002-12-17', 'hashed_pass_3', '2022-12-05 22:52:25', 1, 'Activo'),
('Mario', 'Garzón', 'pedro89@hotmail.com', '+34978 98 55 91', '1974-06-27', 'hashed_pass_4', '2020-05-07 22:27:00', 1, 'Activo'),
('Ofelia', 'Arce', 'agapitojimenez@yahoo.com', '+34 708514999', '2001-12-24', 'hashed_pass_5', '2020-10-08 05:03:14', 1, 'Activo'),
('Adelina', 'Polo', 'hortensiamendoza@batalla.com', '+34 747418833', '1977-03-28', 'hashed_pass_6', '2024-03-02 03:10:03', 1, 'Activo'),
('Eustaquio', 'Diéguez', 'cgil@galan.org', '+34839 80 43 08', '1992-09-22', 'hashed_pass_7', '2022-04-24 10:34:30', 1, 'Activo'),
('Rosalva', 'Borrás', 'lola28@salamanca.com', '+34916 234 485', '1982-02-13', 'hashed_pass_8', '2022-12-04 06:39:50', 1, 'Activo'),
('Adán', 'Serna', 'ltudela@hotmail.com', '+34 741334677', '1966-09-12', 'hashed_pass_9', '2021-12-11 12:12:42', 1, 'Activo'),
('Concha', 'Cabeza', 'kocana@yahoo.com', '+34890 83 45 10', '1996-12-17', 'hashed_pass_10', '2020-10-19 06:23:20', 1, 'Activo');


INSERT INTO nivelesDeDificultadDeClase (NombreNivelDeDificultad) 
VALUES 
('principiante'),
('intermedio'),
('avanzado')
INSERT INTO nivelesDeIntensidadDeClase (NombreNivelDeIntensidad) 
VALUES
('baja'),
('media'),
('alta')


select * from Clases c
select * from nivelesDeIntensidadDeClase ndidc 
INSERT INTO Clases (NombreClase, InstructorID, fkDificultad, fkIntensidad, DuracionEnMinutos, TiempoDeDescansoEnMinutos, DuracionEnMinutosConDescansoIncluido,cupo) 
VALUES ('Hiit', 15, 3, 2, 45, 15, 60,10),
('Crossfit', 15, 3, 3, 45, 15, 60,10),
('Fuerza y potencia', 15, 3, 3, 45, 15, 60,10),
('Boxeo', 17, 1, 2, 45, 15, 60,10),
('Entrenamiento Funcional', 19, 1, 1, 45, 15, 60,10),
('Entrenamiento Personal', 17, 3, 1, 45, 15, 60,10)



INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, tituloBloque, descripcionBloque, duracionMenorEnMinutos,duracionMayorEnMinutos)
VALUES 
( 5, 1, 'Calentamiento', 'Comenzamos con un calentamiento dinámico para preparar el cuerpo para el ejercicio intenso. Incluye movilidad articular, activación muscular y elevación gradual del ritmo cardíaco.', 5, 7),
(5, 2, 'Bloques Hiit', 'El núcleo de la clase consiste en 4-6 bloques de ejercicios de alta intensidad. Cada bloque alterna entre 20-40 segundos de trabajo máximo y 10-20 segundos de descanso. Realizamos 3-4 rondas de cada bloque con un minuto de recuperación entre bloques.', 30, 30),
(5, 3, 'Enfiramiento', 'Finalizamos con ejercicios de baja intensidad para reducir gradualmente el ritmo cardíaco, seguidos de estiramientos estáticos para mejorar la flexibilidad y acelerar la recuperación. ', 5, 7)
;



	INSERT INTO beneficiosDeClase (
	fkClase,
	beneficio,
	descripcionBeneficio
	) 
VALUES 
(6, 'Mejora Cardiovascular','Aumenta la capacidad aeróbica y anaeróbica'),
(6, 'Quema de Grasa','Mayor quema calórica durante y después del ejercicio'),
(6, 'Eficiencia','Resultados máximos en tiempo mínimo');
 


INSERT INTO consejosParaLasClases (
fkClase,
introduccionDeConsejo,
consejos) 
VALUES 
(6, 'Si eres nuevo en el HIIT, estos consejos te ayudarán a sacar el máximo provecho de tus entrenamientos mientras minimizas el riesgo de lesiones:', 'Comienza con versiones modificadas de los ejercicios hasta dominar la técnica correcta, escucha a tu cuerpo y toma descansos adicionales si los necesitas, mantén una buena hidratación antes, durante y después de la clase, prioriza la técnica sobre la velocidad o el número de repeticiones, comienza con 1-2 clases por semana y aumenta gradualmente, informa al instructor sobre cualquier lesión o limitación que tengas.');

INSERT INTO estadosClasesProgramadas (nombresEstado)
VALUES 
('disponible'),
('no disponible'),
('cancelada')
select * from Usuarios
select * from Roles 
INSERT INTO clasesProgramadas (
    fkClase,
    fechaInicio,
    fechaFin,
    fkEntrenador,
    cupoMaximo,
    fkEstadoClaseProgramada
)
VALUES 
(6,CAST('2025-04-16T16:00:00' AS DATETIME), CAST('2025-04-16T17:00:00' AS DATETIME), 15, 20,1),
(6,  CAST('2025-04-18T15:00:00' AS DATETIME),  CAST('2025-04-18T16:00:00' AS DATETIME), 15, 20, 1);


INSERT INTO TipoRutina (nombreTipoRutina) 
VALUES 
('clase'),
('personal')

select * from clasesProgramadas cp 

INSERT INTO
    Rutinas (
        UsuarioID,
        EntrenadorID,
        Observaciones,
        fkClase,
        fkTipoRutina
    )
VALUES
    (null, 15, 'hacen falta mancuernas se estan quejando los clientes', 6, 1);
   
   
INSERT INTO Ejercicios
(
    NombreEjercicio,
    Descripcion,
    TipoEjercicio
)
VALUES
('Burpees', 'Ejercicio de cuerpo completo que combina sentadilla, plancha, flexión y salto. Excelente para desarrollar resistencia cardiovascular y fuerza.', 'AMRAP'),
('Mountain Climbers', 'En posición de plancha, alternamos llevando las rodillas hacia el pecho. Trabaja el core y eleva el ritmo cardíaco.', 'Tiempo'),
('Jumping Jacks', 'Saltos abriendo y cerrando piernas y brazos simultáneamente. Excelente ejercicio cardiovascular que involucra todo el cuerpo.', 'Tiempo'),
('Sentadillas con Salto', 'Sentadilla tradicional seguida de un salto explosivo. Desarrolla potencia en el tren inferior y eleva el ritmo cardíaco.', 'AMRAP'),
('Planchas Laterales', 'Mantenemos el cuerpo recto apoyados sobre un antebrazo y el lateral del pie. Fortalece el core y los estabilizadores laterales.', 'Tiempo'),
('High Knees', 'Carrera estática elevando las rodillas al máximo. Excelente ejercicio cardiovascular que también trabaja el core.', 'Tiempo')



INSERT INTO
    RutinaEjercicios (
        RutinaID,
        EjercicioID,
        Sets,
        Repeticiones,
        Peso,
        Tiempo,
        MetaRepeticiones
    )
VALUES
    (19, 8, 3, 12, 0, 40, 15),  -- Burpees: 3 sets, 12 reps, peso 0, 40s, meta 15 reps
    (19, 9, 4, 0, 0, 45, 20),  -- Mountain Climbers: 4 sets, por tiempo, 45s, meta 20 reps
    (19, 10, 3, 0, 0, 40, 30), -- Jumping Jacks: 3 sets, por tiempo, 40s, meta 30 reps
    (19, 11, 4, 15, 0, 0, 15), -- Sentadillas con salto: 4 sets, 15 reps, sin peso, meta 15 reps
    (19, 12, 3, 0, 0, 30, 30), -- Planchas laterales: 3 sets, por tiempo, 30s cada lado
    (19, 13, 4, 0, 0, 45, 25); -- High Knees: 4 sets, por tiempo, 45s, meta 25 reps

  select * from Equipos e
  select * from Ejercicios e 
 INSERT INTO Equipos (NombreEquipo, Descripcion) 
VALUES 
    ('Mancuernas Ligeras', 'Para añadir resistencia a ejercicios como sentadillas o press de hombros.'),
    ('Kettlebells', 'Ideales para ejercicios balísticos como swings o clean and press.'),
    ('Esterilla', 'Para mayor comodidad en ejercicios de suelo como planchas o abdominales.'),
    ('Botella de Agua', 'Fundamental para mantenerte hidratado durante el entrenamiento intenso.');

INSERT INTO EjercicioEquipos (EjercicioID, EquipoID) 
VALUES 
(8, 4),   -- Burpees → Botella de Agua
(9, 3),   -- Mountain Climbers → Esterilla
(9, 4),   -- Mountain Climbers → Botella de Agua
(10, 4),  -- Jumping Jacks → Botella de Agua
(11, 1),  -- Sentadillas con Salto → Mancuernas Ligeras
(11, 4),  -- Sentadillas con Salto → Botella de Agua
(12, 3),  -- Planchas Laterales → Esterilla
(12, 4),  -- Planchas Laterales → Botella de Agua
(13, 4);  -- High Knees → Botella de Agua