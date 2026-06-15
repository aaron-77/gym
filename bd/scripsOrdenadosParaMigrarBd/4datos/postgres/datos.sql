-- =============================================
-- DATA: Seed data
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

-- Enable sequences for IDs
ALTER TABLE public.usuarios ALTER COLUMN usuario_id RESTART WITH 23;

-- Usuarios data
INSERT INTO public.usuarios (nombre, apellido, email, telefono, nombre_usuario, contrasena, fecha_nacimiento, fecha_registro, rol_id, estado) 
VALUES 
('Juan', 'Martinez', 'aaronhl1313@gmail.com', '9999999', 'elusuario', 'password123', '2024-01-15', '2024-07-19 14:32:30', 1, 'activo'),
('aaron', 'Azcarraga', 'uno@gmail.com', '2291250501', 'elusuario20/07/2024 03:15:36', 'password1', '2024-07-16', '2024-07-20 15:15:38', 2, 'activo'),
('Yesenia', 'esquivel', 'yesyes@gmail.com', '33289392929', 'yes92', 'yes123', '2024-11-15', '2024-08-03 03:38:05', 2, 'activo'),
('matias', 'botero', 'matias@gmail.com', '+522291250501', 'elusuario10/08/2024 12:17:41', '$2a$11$amSmPDPY/lzbqu1BGS.Q0O6cq0tlb.m.sOHr7yij6hwzQtFn0xhnK', '2024-08-06', '2024-08-10 00:17:45', 2, 'activo'),
('Rebeca', 'delgado', 'rebeca@gmail.com', '227372828399', 'elusuario17/08/2024 01:24:35', '$2a$11$at7qAllPsGTMSrzEBiacYerCbDNAyjVJTsApHPfHS69iUIUk7vNr.', '2024-08-17', '2024-08-17 01:24:44', 1, 'activo'),
('Valeria', 'Gomez', 'valeriag@gmail.com', '337483839202', 'elusuario17/08/2024 01:31:50', '$2a$11$aKH3BpGNJtDqBopYlLTABulWQx9lRYembOjJtSjfl/B.nB9kRSDHG', '1998-10-06', '2024-08-17 01:31:50', 1, 'activo'),
('antonio', 'marquez', 'antoniom@gmail.com', '2237940475', 'elusuario30/4/2025 11:15:06', '$2a$11$g4MxQsmf4jbLP5J3IjtZkuJYTFjSaG9zpHS0gwERelpN56hQNl1e2', '2025-04-16', '2025-04-30 11:15:06', 2, 'activo');

-- __EFMigrationsHistory data
INSERT INTO public.__ef_migrations_history (migration_id, product_version) VALUES 
('20250806212755_IdentityInicial', '8.0.19'),
('20250813001705_SeedRoles', '8.0.19'),
('20250813002524_SeedRoles2', '8.0.19'),
('20250813003236_SeedRoles3', '8.0.19'),
('20250813210445_NumeroDeIdentificacionAdded', '8.0.19'),
('20250813210639_NumeroDeIdentificacionAdded2', '8.0.19'),
('20250820181715_DireccionAndFechaAdded', '8.0.19'),
('20250820185017_SeedUsuariosActualizados', '8.0.19'),
('20250904004429_AddedTokenTables', '8.0.19'),
('20250911183018_addmisinguusariosfields', '8.0.19'),
('20250911185215_addIdAntiguoField', '8.0.19'),
('20250915191036_addedNewFkFieldsForAspnetusersRelations', '8.0.19'),
('20251209191136_AddIdSecundario', '8.0.22'),
('20251212021803_ResyncSnapshot', '8.0.22'),
('20251212023759_RemoveFkHashEntrenador', '8.0.22');

-- AccessTokens (sample data - hashed values need to be regenerated for PostgreSQL)
-- Note: Token hashes are not portable between SQL Server and PostgreSQL

-- Roles de clase iniciales
INSERT INTO public.roles (nombre_rol) VALUES 
('Administrador'),
('Entrenador'),
('Cliente');

-- Estados de clases
INSERT INTO public.estados_de_clases (nombre_estado, descripcion_estado) VALUES 
('Activo', 'Clase disponible para programar'),
('Inactivo', 'Clase no disponible temporalmente'),
('Cancelada', 'ClaseCancelada');

-- Estados de clases programadas
INSERT INTO public.estados_clases_programadas (nombre_estado) VALUES 
('Disponible'),
('Completada'),
('Cancelada');

-- Estados de inscripciones
INSERT INTO public.estados_inscripciones (nombre_estado_inscripcion) VALUES 
('Vigente'),
('Cancelada'),
('Pendiente');

-- States for activities
INSERT INTO public.estados_de_actividad_laboral (nombre_estado_actividad_laboral) VALUES 
('se labora'),
('no se labora');

-- Niveles de dificultad
INSERT INTO public.niveles_de_dificultad_de_clase (nombre_nivel_de_dificultad) VALUES 
('Principiante'),
('Intermedio'),
('Avanzado');

-- Niveles de intensidad
INSERT INTO public.niveles_de_intensidad_de_clase (nombre_nivel_de_intensidad) VALUES 
('Bajo'),
('Medio'),
('Alto');

-- Horas laborales (sample)
INSERT INTO public.horas_laborales (hora_inicio, hora_fin) VALUES 
('06:00:00', '07:00:00'),
('07:00:00', '08:00:00'),
('08:00:00', '09:00:00'),
('09:00:00', '10:00:00'),
('10:00:00', '11:00:00'),
('11:00:00', '12:00:00'),
('12:00:00', '13:00:00'),
('13:00:00', '14:00:00'),
('14:00:00', '15:00:00'),
('15:00:00', '16:00:00'),
('16:00:00', '17:00:00'),
('17:00:00', '18:00:00'),
('18:00:00', '19:00:00'),
('19:00:00', '20:00:00'),
('20:00:00', '21:00:00'),
('21:00:00', '22:00:00');

-- Duracion de citas
INSERT INTO public.duracion_citas (duracion, frecuencia_notificaciones) VALUES 
(30, 15),
(45, 15),
(60, 20);

-- Tipo de recurrencia de dias festivos  
INSERT INTO public.tipos_de_recurrencia_de_dias_festivos (nombre_tipo_de_recurrencia) VALUES 
('anual'),
('mensual'),
('diaSemana'),
('diaRelativo'),
('diaConsecutivo');

-- Niveles de logro
INSERT INTO public.niveles_de_logro (nombre) VALUES 
('Bronce'),
('Plata'),
('Oro'),
('Diamante');

-- Unidades de medida
INSERT INTO public.unidades_de_medida (nombre) VALUES 
('kg'),
('lb'),
('cm'),
('m'),
('km'),
('calorias'),
('repeticiones'),
('segundos');

-- Parametros de medicion
INSERT INTO public.parametros_de_medicion (nombre) VALUES 
('Peso'),
('Altura'),
('Circunferencia'),
('Grasa Corporal'),
('Musculo');

-- Intenciones
INSERT INTO public.intenciones (nombre) VALUES 
('Bajar de peso'),
('Ganar musculo'),
('Mantenerse'),
('Mejorar resistencia');

-- Configuracion final
DO $$
BEGIN
    RAISE NOTICE 'Seed data loaded successfully';
END $$;