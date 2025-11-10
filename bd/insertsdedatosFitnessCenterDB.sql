INSERT INTO FitnessCenterDB.dbo.AccessTokens
(AccessTokenId, UserId, ClientId, TokenHash, IssuedAt, ExpiresAt, RevokedAt, IpAddress, UserAgent)
VALUES(newid(), '', '', '', sysutcdatetime(), '', '', '', '');
INSERT INTO FitnessCenterDB.dbo.AspNetRoleClaims
(Id, RoleId, ClaimType, ClaimValue)
VALUES(0, '', '', '');
INSERT INTO FitnessCenterDB.dbo.AspNetRoles
(Id, Name, NormalizedName, ConcurrencyStamp)
VALUES('', '', '', '');
INSERT INTO FitnessCenterDB.dbo.AspNetUserClaims
(Id, UserId, ClaimType, ClaimValue)
VALUES(0, '', '', '');
INSERT INTO FitnessCenterDB.dbo.AspNetUserLogins
(LoginProvider, ProviderKey, ProviderDisplayName, UserId)
VALUES('', '', '', '');
INSERT INTO FitnessCenterDB.dbo.AspNetUserRoles
(UserId, RoleId)
VALUES('', '');
INSERT INTO FitnessCenterDB.dbo.AspNetUserTokens
(UserId, LoginProvider, Name, Value)
VALUES('', '', '', '');
INSERT INTO FitnessCenterDB.dbo.AspNetUsers
(Id, NombreCompleto, UserName, NormalizedUserName, Email, NormalizedEmail, EmailConfirmed, PasswordHash, SecurityStamp, ConcurrencyStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEnd, LockoutEnabled, AccessFailedCount, NumeroDeIdentificacion, Direccion, FechaDeNacimiento, Apellido, Estado, FechaDeRegistro, IdAntiguo)
VALUES('', '', '', '', '', '', 0, '', '', '', '', 0, 0, '', 0, 0, N'', N'', '0001-01-01T00:00:00.0000000', N'', N'', '0001-01-01T00:00:00.0000000', 0);
INSERT INTO FitnessCenterDB.dbo.Citas
(CitaID, FechaHora, TipoCita, Estado, FechaHoraFin, EntrenadorId, UserId)
VALUES(0, '', '', '', '', '', '');
INSERT INTO FitnessCenterDB.dbo.Clases
(ClaseID, NombreClase, Cupo, Descripcion, duracionEnMinutos, fkIntensidad, fkDificultad, tiempoDeDescansoEnMinutos, duracionEnMinutosConDescansoIncluido, fkEstadoClase, InstructorId)
VALUES(0, '', 0, '', 0, 0, 0, 15, 60, 0, '');
INSERT INTO FitnessCenterDB.dbo.Cupones
(CuponID, Codigo, DescuentoID, FechaExpiracion, Estado)
VALUES(0, '', 0, '', '');
INSERT INTO FitnessCenterDB.dbo.Descuentos
(DescuentoID, Porcentaje, Descripcion, FechaInicio, FechaFin)
VALUES(0, 0, '', '', '');
INSERT INTO FitnessCenterDB.dbo.DetalleEntrenamiento
(DetalleID, RegistroID, EjercicioID, [Sets], Repeticiones, Peso, Tiempo)
VALUES(0, 0, 0, 0, 0, 0, 0);
INSERT INTO FitnessCenterDB.dbo.EjercicioEquipos
(EjercicioEquipoID, EjercicioID, EquipoID)
VALUES(0, 0, 0);
INSERT INTO FitnessCenterDB.dbo.Ejercicios
(EjercicioID, NombreEjercicio, TipoEjercicio, Descripcion, fkIcon)
VALUES(0, '', '', '', 0);
INSERT INTO FitnessCenterDB.dbo.Equipos
(EquipoID, NombreEquipo, Descripcion, fkIcon)
VALUES(0, '', '', 0);
INSERT INTO FitnessCenterDB.dbo.LogErrores
(id, procedimiento, mensaje, severidad, estado, fecha, usuario, host, aplicacion)
VALUES(0, '', '', 0, 0, getdate(), suser_name(), host_name(), app_name());
INSERT INTO FitnessCenterDB.dbo.Pagos
(PagoID, Monto, FechaPago, MetodoPago, Estado, UserId)
VALUES(0, 0, getdate(), '', '', '');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens
(RefreshTokenId, UserId, ClientId, TokenHash, IssuedAt, ExpiresAt, RevokedAt, ReplacedByTokenId, IpAddress, UserAgent)
VALUES(newid(), '', '', '', sysutcdatetime(), '', '', '', '', '');
INSERT INTO FitnessCenterDB.dbo.RegistrosEntrenamiento
(RegistroID, RutinaID, FechaRegistro, UserId)
VALUES(0, 0, getdate(), '');
INSERT INTO FitnessCenterDB.dbo.Roles
(RolID, NombreRol)
VALUES(0, '');
INSERT INTO FitnessCenterDB.dbo.RutinaEjercicios
(RutinaEjercicioID, RutinaID, EjercicioID, [Sets], Repeticiones, Peso, Tiempo, MetaRepeticiones)
VALUES(0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO FitnessCenterDB.dbo.Rutinas
(RutinaID, FechaCreacion, Observaciones, fkClase, fkTipoRutina, EntrenadorId, UserId)
VALUES(0, getdate(), '', 0, 0, '', '');
INSERT INTO FitnessCenterDB.dbo.Servicios
(ServicioID, NombreServicio, Descripcion, TipoServicio, Costo)
VALUES(0, '', '', '', 0);
INSERT INTO FitnessCenterDB.dbo.TipoRutina
(idTipoRutina, nombreTipoRutina, fechaDeCreacion, fechaDeModificacion)
VALUES(0, '', getdate(), getdate());
INSERT INTO FitnessCenterDB.dbo.Usuarios
(UsuarioID, Nombre, Apellido, Email, Telefono, NombreUsuario, Contrasena, FechaNacimiento, FechaRegistro, RolID, Estado)
VALUES(0, '', '', '', '', '', '', '', getdate(), 0, '');
INSERT INTO FitnessCenterDB.dbo.[__EFMigrationsHistory]
(MigrationId, ProductVersion)
VALUES('', '');
INSERT INTO FitnessCenterDB.dbo.beneficiosDeClase
(idBeneficio, fkClase, beneficio, fechaDeCreacion, fechaDeModificacion, fkIcon, descripcionBeneficio)
VALUES(0, 0, '', getdate(), getdate(), 0, '');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas
(idProgramacionClase, fkClase, cupoMaximo, fkEstadoClaseProgramada, fechaCreacion, fechaModificacion, fkEntrenador)
VALUES(0, 0, 0, 0, getdate(), getdate(), '');
INSERT INTO FitnessCenterDB.dbo.consejosParaLasClases
(idConsejo, fkClase, fkEjercicio, introduccionDeConsejo, consejos)
VALUES(0, 0, 0, '', '');
INSERT INTO FitnessCenterDB.dbo.diasFestivosVariables
(idDiaFestivoVariable, nombreDiasFestivoVariable, deQueSemana, deQueMes, deQueDia, fechaCreacion, fechaModificacion, fkTipoDeRecurrenciaDelFestivo, fkEstadoActividadLaboral)
VALUES(0, '', 0, 0, 0, getdate(), '', 0, 0);
INSERT INTO FitnessCenterDB.dbo.diasFestivosYDescansos
(idDiaFestivo, fechaFestivaODescanso, descripcion, fkEstadoActividadLaboral, fechaCreacion, fcehaModificacion)
VALUES(0, '', '', 0, getdate(), getdate());
INSERT INTO FitnessCenterDB.dbo.duracionCitas
(DuracionID, Duracion, FrecuenciaNotificaciones)
VALUES(0, 0, 0);
INSERT INTO FitnessCenterDB.dbo.ejercicios_parametrosDeMedicion
(id, fkEjercicio, fkParametro, fechaCreacion, fechaModificacion)
VALUES(0, 0, 0, getdate(), '');
INSERT INTO FitnessCenterDB.dbo.estadosClasesProgramadas
(idEstadoClaseProgramada, nombresEstado, fechaCreacion, fechaModificacion)
VALUES(0, '', getdate(), getdate());
INSERT INTO FitnessCenterDB.dbo.estadosDeActividadLaboral
(idEstadoActividadLaboral, nombreEstadoActividadLaboral, fechaCreacion, fcehaModificacion)
VALUES(0, '', getdate(), getdate());
INSERT INTO FitnessCenterDB.dbo.estadosDeClases
(idEstadoClase, nombreEstado, descripcionEstado, fechaCreacion, fechaModificacion)
VALUES(0, '', '', getdate(), getdate());
INSERT INTO FitnessCenterDB.dbo.estadosHorarioClaseProgramada
(idEstadoHorarioClase, nombreEstadoHorario, fechaCreacion, fechaModificacion)
VALUES(0, '', getdate(), getdate());
INSERT INTO FitnessCenterDB.dbo.estadosInscripciones
(idEstadoInscripcion, nombreEstadoInscripcion, fechaCreacion, fechaModificacion)
VALUES(0, '', getdate(), getdate());
INSERT INTO FitnessCenterDB.dbo.estructuraDeClase
(idBloque, fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
VALUES(0, 0, 0, 0, 0, '', '', getdate(), getdate());
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas
(idHorarioDeClaseProgramada, fkClaseProgramada, fkHorarioLaboral, fkEstadoHorarioClase, fechaDeLaClase, fkEntrenador)
VALUES(0, 0, 0, 1, '', '');
INSERT INTO FitnessCenterDB.dbo.horasLaborales
(idHora, horaInicio, horaFin, fechaCreacion, fechaModificacion)
VALUES(0, '', '', getdate(), getdate());
INSERT INTO FitnessCenterDB.dbo.iconsForParameters
(iconId, nombre, urlPrivada, urlPublica)
VALUES(0, '', '', '');
INSERT INTO FitnessCenterDB.dbo.imagesForClases
(idClassImage, fkClase, urlParaBanner, urlParaParaDescripcionDeClase, urlParaBloqueConsejos, FechaDeCreacion, FechaDeModificacion)
VALUES(0, 0, '', '', '', getdate(), getdate());
INSERT INTO FitnessCenterDB.dbo.imagesForExercises
(idImage, fkEjercicio, nombreParaElFront, urlPrivada, urlPublica)
VALUES(0, 0, '', '', '');
INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases
(idInscripcion, fkProgramacionClase, fechaDeInscripcion, fkEstadoInscripcion, fkCliente)
VALUES(0, 0, getdate(), 0, '');
INSERT INTO FitnessCenterDB.dbo.intenciones
(intencionId, nombre, fechaDeRegistro, fechaModificacionDeRegistro)
VALUES(0, '', getdate(), '');
INSERT INTO FitnessCenterDB.dbo.medidas
(medidaId, fechaDeCreacion, fkParametro, valor, fkEjercicio, fkUsuario)
VALUES(0, getdate(), 0, 0, 0, '');
INSERT INTO FitnessCenterDB.dbo.metas
(metaId, fkIntencion, fkParametro, fkEjercicio, valorObjetivo, fechaDeInicioDeLaMeta, fechaLimite, fechaDeRegistro, fechaDeModificacionDeRegistro, fkNivelDeLogro, fkUsuario)
VALUES(0, 0, 0, 0, 0, '', '', getdate(), getdate(), 1, '');
INSERT INTO FitnessCenterDB.dbo.nivelesDeDificultadDeClase
(idNivelDeDificultadDeClase, nombreNivelDeDificultad, fechaDeCreacion, fechaDeModificacion)
VALUES(0, '', '', '');
INSERT INTO FitnessCenterDB.dbo.nivelesDeIntensidadDeClase
(idNivelDeIntensidad, nombreNivelDeIntensidad, fechaDeCreacion)
VALUES(0, '', getdate());
INSERT INTO FitnessCenterDB.dbo.nivelesDeLogro
(idNivelDeLogro, nombre, fechaDeRegistro, fechaModificacionDeRegistro)
VALUES(0, '', getdate(), getdate());
INSERT INTO FitnessCenterDB.dbo.parametrosDeMedicion
(parametroMedicionId, nombre, fechaDeRegistro, fechaModificacionDeRegistro, fkIcon)
VALUES(0, '', getdate(), '', 0);
INSERT INTO FitnessCenterDB.dbo.parametros_unidadesDeMedida
(fkParametroDeMedicion, fkUnidadDeMedida, fechaDeRegistro)
VALUES(0, 0, getdate());
INSERT INTO FitnessCenterDB.dbo.preReservasDeHorario
(idPreReserva, fechaInicioDeLaReserva, fechaDeExpiracionDeLaReserva, fkHoraLaboral, idUsuarioQueReserva, fechaReservada)
VALUES(0, '', '', 0, '', '');
INSERT INTO FitnessCenterDB.dbo.tiposDeRecurrenciaDeDiasFestivos
(idTipoDeRecurrenciaDeDiaFestivo, nombreTipoDeRecurrencia, descripcion, fechaCreacion, fechaModificacion)
VALUES(0, '', '', getdate(), '');
INSERT INTO FitnessCenterDB.dbo.unidadesDeMedida
(unidadDeMedidaId, nombre, fechaDeRegistro, fechaModificacionDeRegistro)
VALUES(0, '', getdate(), '');