/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR$SQLEXPRESS at 01/23/2026 16:11:16
	See https://dbatools.io/Export-DbaScript for more information
*/
ALTER TABLE [dbo].[AccessTokens]  WITH CHECK ADD  CONSTRAINT [FK_AccessTokens_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AccessTokens] CHECK CONSTRAINT [FK_AccessTokens_AspNetUsers]
GO

ALTER TABLE [dbo].[AspNetRoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
GO

ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
GO

ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
GO

ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
GO

ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
GO

ALTER TABLE [dbo].[AspNetUserTokens]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
GO

ALTER TABLE [dbo].[beneficiosDeClase]  WITH CHECK ADD  CONSTRAINT [FK_Beneficio_Clase] FOREIGN KEY([fkClase])
REFERENCES [dbo].[Clases] ([ClaseID])
GO

ALTER TABLE [dbo].[beneficiosDeClase] CHECK CONSTRAINT [FK_Beneficio_Clase]
GO

ALTER TABLE [dbo].[beneficiosDeClase]  WITH CHECK ADD  CONSTRAINT [FK_iconsForParameters_beneficios_del_clase] FOREIGN KEY([fkIcon])
REFERENCES [dbo].[iconsForParameters] ([iconId])
GO

ALTER TABLE [dbo].[beneficiosDeClase] CHECK CONSTRAINT [FK_iconsForParameters_beneficios_del_clase]
GO

ALTER TABLE [dbo].[Citas]  WITH CHECK ADD  CONSTRAINT [FK_Citas_AspNetUsers_NewEntrenadorId] FOREIGN KEY([EntrenadorId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO

ALTER TABLE [dbo].[Citas] CHECK CONSTRAINT [FK_Citas_AspNetUsers_NewEntrenadorId]
GO

ALTER TABLE [dbo].[Citas]  WITH CHECK ADD  CONSTRAINT [FK_Citas_AspNetUsers_NewUserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
	
ALTER TABLE [dbo].[Citas] CHECK CONSTRAINT [FK_Citas_AspNetUsers_NewUserId]
GO

ALTER TABLE [dbo].[Clases]  WITH CHECK ADD  CONSTRAINT [FK_Clases_AspNetUsers_NewInstructorId] FOREIGN KEY([InstructorId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO

ALTER TABLE [dbo].[Clases] CHECK CONSTRAINT [FK_Clases_AspNetUsers_NewInstructorId]
GO

ALTER TABLE [dbo].[Clases]  WITH CHECK ADD  CONSTRAINT [FK_Clases_Dificultad] FOREIGN KEY([fkDificultad])
REFERENCES [dbo].[nivelesDeDificultadDeClase] ([idNivelDeDificultadDeClase])
GO

ALTER TABLE [dbo].[Clases] CHECK CONSTRAINT [FK_Clases_Dificultad]
GO

ALTER TABLE [dbo].[Clases]  WITH CHECK ADD  CONSTRAINT [FK_Clases_estadosDeClases] FOREIGN KEY([fkEstadoClase])
REFERENCES [dbo].[estadosDeClases] ([idEstadoClase])
GO

ALTER TABLE [dbo].[Clases] CHECK CONSTRAINT [FK_Clases_estadosDeClases]
GO

ALTER TABLE [dbo].[Clases]  WITH CHECK ADD  CONSTRAINT [FK_Clases_Intensidad] FOREIGN KEY([fkIntensidad])
REFERENCES [dbo].[nivelesDeIntensidadDeClase] ([idNivelDeIntensidad])
GO

ALTER TABLE [dbo].[Clases] CHECK CONSTRAINT [FK_Clases_Intensidad]
GO

ALTER TABLE [dbo].[clasesProgramadas]  WITH CHECK ADD  CONSTRAINT [FK_ClasesProgramadas_AspNetUsers_NewFkEntrenador] FOREIGN KEY([fkEntrenador])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO

ALTER TABLE [dbo].[clasesProgramadas] CHECK CONSTRAINT [FK_ClasesProgramadas_AspNetUsers_NewFkEntrenador]
GO

ALTER TABLE [dbo].[clasesProgramadas]  WITH CHECK ADD  CONSTRAINT [FK_ClasesProgramadas_Clase] FOREIGN KEY([fkClase])
REFERENCES [dbo].[Clases] ([ClaseID])
GO

ALTER TABLE [dbo].[clasesProgramadas] CHECK CONSTRAINT [FK_ClasesProgramadas_Clase]
GO

ALTER TABLE [dbo].[clasesProgramadas]  WITH CHECK ADD  CONSTRAINT [FK_ClasesProgramadas_EstadoClaseProgramada] FOREIGN KEY([fkEstadoClaseProgramada])
REFERENCES [dbo].[estadosClasesProgramadas] ([idEstadoClaseProgramada])
GO

ALTER TABLE [dbo].[clasesProgramadas] CHECK CONSTRAINT [FK_ClasesProgramadas_EstadoClaseProgramada]
GO

ALTER TABLE [dbo].[consejosParaLasClases]  WITH CHECK ADD  CONSTRAINT [FK_Consejos_Clase] FOREIGN KEY([fkClase])
REFERENCES [dbo].[Clases] ([ClaseID])
ON DELETE SET NULL
GO

ALTER TABLE [dbo].[consejosParaLasClases] CHECK CONSTRAINT [FK_Consejos_Clase]
GO

ALTER TABLE [dbo].[consejosParaLasClases]  WITH CHECK ADD  CONSTRAINT [FK_Consejos_Ejercicio] FOREIGN KEY([fkEjercicio])
REFERENCES [dbo].[Ejercicios] ([EjercicioID])
ON DELETE SET NULL
GO

ALTER TABLE [dbo].[consejosParaLasClases] CHECK CONSTRAINT [FK_Consejos_Ejercicio]
GO

ALTER TABLE [dbo].[Cupones]  WITH CHECK ADD  CONSTRAINT [FK__Cupones__Descuen__6B24EA82] FOREIGN KEY([DescuentoID])
REFERENCES [dbo].[Descuentos] ([DescuentoID])
GO

ALTER TABLE [dbo].[Cupones] CHECK CONSTRAINT [FK__Cupones__Descuen__6B24EA82]
GO

ALTER TABLE [dbo].[DetalleEntrenamiento]  WITH CHECK ADD  CONSTRAINT [FK__DetalleEn__Ejerc__74AE54BC] FOREIGN KEY([EjercicioID])
REFERENCES [dbo].[Ejercicios] ([EjercicioID])
GO

ALTER TABLE [dbo].[DetalleEntrenamiento] CHECK CONSTRAINT [FK__DetalleEn__Ejerc__74AE54BC]
GO

ALTER TABLE [dbo].[DetalleEntrenamiento]  WITH CHECK ADD  CONSTRAINT [FK__DetalleEn__Regis__73BA3083] FOREIGN KEY([RegistroID])
REFERENCES [dbo].[RegistrosEntrenamiento] ([RegistroID])
GO

ALTER TABLE [dbo].[DetalleEntrenamiento] CHECK CONSTRAINT [FK__DetalleEn__Regis__73BA3083]
GO

ALTER TABLE [dbo].[diasFestivosVariables]  WITH CHECK ADD  CONSTRAINT [fk_estadosDeActividdadLaboral_diasFestivosVariables] FOREIGN KEY([fkEstadoActividadLaboral])
REFERENCES [dbo].[estadosDeActividadLaboral] ([idEstadoActividadLaboral])
GO

ALTER TABLE [dbo].[diasFestivosVariables] CHECK CONSTRAINT [fk_estadosDeActividdadLaboral_diasFestivosVariables]
GO

ALTER TABLE [dbo].[diasFestivosVariables]  WITH CHECK ADD  CONSTRAINT [fk_tiposDeRecurrenciaDeDiasFestivos_diasFestivosVariables] FOREIGN KEY([fkTipoDeRecurrenciaDelFestivo])
REFERENCES [dbo].[tiposDeRecurrenciaDeDiasFestivos] ([idTipoDeRecurrenciaDeDiaFestivo])
GO

ALTER TABLE [dbo].[diasFestivosVariables] CHECK CONSTRAINT [fk_tiposDeRecurrenciaDeDiasFestivos_diasFestivosVariables]
GO

ALTER TABLE [dbo].[diasFestivosYDescansos]  WITH CHECK ADD  CONSTRAINT [FK_diasFestivosYDescansos_EstadoActividadLaboral] FOREIGN KEY([fkEstadoActividadLaboral])
REFERENCES [dbo].[estadosDeActividadLaboral] ([idEstadoActividadLaboral])
GO

ALTER TABLE [dbo].[diasFestivosYDescansos] CHECK CONSTRAINT [FK_diasFestivosYDescansos_EstadoActividadLaboral]
GO

ALTER TABLE [dbo].[EjercicioEquipos]  WITH CHECK ADD  CONSTRAINT [FK__Ejercicio__Ejerc__571DF1D5] FOREIGN KEY([EjercicioID])
REFERENCES [dbo].[Ejercicios] ([EjercicioID])
GO

ALTER TABLE [dbo].[EjercicioEquipos] CHECK CONSTRAINT [FK__Ejercicio__Ejerc__571DF1D5]
GO

ALTER TABLE [dbo].[EjercicioEquipos]  WITH CHECK ADD  CONSTRAINT [FK__Ejercicio__Equip__5812160E] FOREIGN KEY([EquipoID])
REFERENCES [dbo].[Equipos] ([EquipoID])
GO

ALTER TABLE [dbo].[EjercicioEquipos] CHECK CONSTRAINT [FK__Ejercicio__Equip__5812160E]
GO

ALTER TABLE [dbo].[Ejercicios]  WITH CHECK ADD  CONSTRAINT [fk_ejercicios_iconsForParameters] FOREIGN KEY([fkIcon])
REFERENCES [dbo].[iconsForParameters] ([iconId])
GO

ALTER TABLE [dbo].[Ejercicios] CHECK CONSTRAINT [fk_ejercicios_iconsForParameters]
GO

ALTER TABLE [dbo].[ejercicios_parametrosDeMedicion]  WITH CHECK ADD  CONSTRAINT [FK_ejercicios_parametrosDeMedicion_Ejercicios] FOREIGN KEY([fkEjercicio])
REFERENCES [dbo].[Ejercicios] ([EjercicioID])
GO

ALTER TABLE [dbo].[ejercicios_parametrosDeMedicion] CHECK CONSTRAINT [FK_ejercicios_parametrosDeMedicion_Ejercicios]
GO

ALTER TABLE [dbo].[ejercicios_parametrosDeMedicion]  WITH CHECK ADD  CONSTRAINT [FK_ejercicios_parametrosDeMedicion_parametrosDeMedicion] FOREIGN KEY([fkParametro])
REFERENCES [dbo].[parametrosDeMedicion] ([parametroMedicionId])
GO

ALTER TABLE [dbo].[ejercicios_parametrosDeMedicion] CHECK CONSTRAINT [FK_ejercicios_parametrosDeMedicion_parametrosDeMedicion]
GO

ALTER TABLE [dbo].[Equipos]  WITH CHECK ADD  CONSTRAINT [FK_Equipos_iconsForParameters] FOREIGN KEY([fkIcon])
REFERENCES [dbo].[iconsForParameters] ([iconId])
GO

ALTER TABLE [dbo].[Equipos] CHECK CONSTRAINT [FK_Equipos_iconsForParameters]
GO

ALTER TABLE [dbo].[estructuraDeClase]  WITH CHECK ADD  CONSTRAINT [FK_Estructura_Clase] FOREIGN KEY([fkClase])
REFERENCES [dbo].[Clases] ([ClaseID])
GO

ALTER TABLE [dbo].[estructuraDeClase] CHECK CONSTRAINT [FK_Estructura_Clase]
GO

ALTER TABLE [dbo].[horariosDeClasesProgramadas]  WITH CHECK ADD  CONSTRAINT [fk_estadosClasesProgramadas_horariosDeClasesProgramadas] FOREIGN KEY([fkEstadoHorarioClase])
REFERENCES [dbo].[estadosHorarioClaseProgramada] ([idEstadoHorarioClase])
GO

ALTER TABLE [dbo].[horariosDeClasesProgramadas] CHECK CONSTRAINT [fk_estadosClasesProgramadas_horariosDeClasesProgramadas]
GO

ALTER TABLE [dbo].[horariosDeClasesProgramadas]  WITH CHECK ADD  CONSTRAINT [FK_horariosDeClasesProgramadas_clasesProgramadas] FOREIGN KEY([fkClaseProgramada])
REFERENCES [dbo].[clasesProgramadas] ([idProgramacionClase])
GO

ALTER TABLE [dbo].[horariosDeClasesProgramadas] CHECK CONSTRAINT [FK_horariosDeClasesProgramadas_clasesProgramadas]
GO

ALTER TABLE [dbo].[horariosDeClasesProgramadas]  WITH CHECK ADD  CONSTRAINT [FK_horasLborales_horariosClasesProgramadas] FOREIGN KEY([fkHorarioLaboral])
REFERENCES [dbo].[horasLaborales] ([idHora])
GO

ALTER TABLE [dbo].[horariosDeClasesProgramadas] CHECK CONSTRAINT [FK_horasLborales_horariosClasesProgramadas]
GO

ALTER TABLE [dbo].[imagesForClases]  WITH CHECK ADD  CONSTRAINT [FK_imagesForClases_Clases] FOREIGN KEY([fkClase])
REFERENCES [dbo].[Clases] ([ClaseID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[imagesForClases] CHECK CONSTRAINT [FK_imagesForClases_Clases]
GO

ALTER TABLE [dbo].[imagesForExercises]  WITH CHECK ADD  CONSTRAINT [FK_ImagesForExercises_Ejercicio] FOREIGN KEY([fkEjercicio])
REFERENCES [dbo].[Ejercicios] ([EjercicioID])
GO

ALTER TABLE [dbo].[imagesForExercises] CHECK CONSTRAINT [FK_ImagesForExercises_Ejercicio]
GO

ALTER TABLE [dbo].[inscripcionesDeClases]  WITH CHECK ADD  CONSTRAINT [FK_InscripcionesDeClases_AspNetUsers_NewFkCliente] FOREIGN KEY([fkCliente])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO

ALTER TABLE [dbo].[inscripcionesDeClases] CHECK CONSTRAINT [FK_InscripcionesDeClases_AspNetUsers_NewFkCliente]
GO

ALTER TABLE [dbo].[inscripcionesDeClases]  WITH CHECK ADD  CONSTRAINT [FK_InscripcionesDeClases_EstadoInscripcion] FOREIGN KEY([fkEstadoInscripcion])
REFERENCES [dbo].[estadosInscripciones] ([idEstadoInscripcion])
GO

ALTER TABLE [dbo].[inscripcionesDeClases] CHECK CONSTRAINT [FK_InscripcionesDeClases_EstadoInscripcion]
GO

ALTER TABLE [dbo].[inscripcionesDeClases]  WITH CHECK ADD  CONSTRAINT [FK_InscripcionesDeClases_ProgramacionClase] FOREIGN KEY([fkProgramacionClase])
REFERENCES [dbo].[clasesProgramadas] ([idProgramacionClase])
GO

ALTER TABLE [dbo].[inscripcionesDeClases] CHECK CONSTRAINT [FK_InscripcionesDeClases_ProgramacionClase]
GO

ALTER TABLE [dbo].[medidas]  WITH CHECK ADD  CONSTRAINT [FK_Medidas_AspNetUsers_NewFkUsuario] FOREIGN KEY([fkUsuario])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO

ALTER TABLE [dbo].[medidas] CHECK CONSTRAINT [FK_Medidas_AspNetUsers_NewFkUsuario]
GO

ALTER TABLE [dbo].[medidas]  WITH CHECK ADD  CONSTRAINT [fk_medidas_ejercicios] FOREIGN KEY([fkEjercicio])
REFERENCES [dbo].[Ejercicios] ([EjercicioID])
GO

ALTER TABLE [dbo].[medidas] CHECK CONSTRAINT [fk_medidas_ejercicios]
GO

ALTER TABLE [dbo].[medidas]  WITH CHECK ADD  CONSTRAINT [fk_medidas_parametros] FOREIGN KEY([fkParametro])
REFERENCES [dbo].[parametrosDeMedicion] ([parametroMedicionId])
GO

ALTER TABLE [dbo].[medidas] CHECK CONSTRAINT [fk_medidas_parametros]
GO

ALTER TABLE [dbo].[metas]  WITH CHECK ADD  CONSTRAINT [FK_Metas_AspNetUsers_NewFkUsuario] FOREIGN KEY([fkUsuario])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO

ALTER TABLE [dbo].[metas] CHECK CONSTRAINT [FK_Metas_AspNetUsers_NewFkUsuario]
GO

ALTER TABLE [dbo].[metas]  WITH CHECK ADD  CONSTRAINT [FK_Metas_Ejercicios] FOREIGN KEY([fkEjercicio])
REFERENCES [dbo].[Ejercicios] ([EjercicioID])
GO

ALTER TABLE [dbo].[metas] CHECK CONSTRAINT [FK_Metas_Ejercicios]
GO

ALTER TABLE [dbo].[metas]  WITH CHECK ADD  CONSTRAINT [FK_Metas_Intenciones] FOREIGN KEY([fkIntencion])
REFERENCES [dbo].[intenciones] ([intencionId])
GO

ALTER TABLE [dbo].[metas] CHECK CONSTRAINT [FK_Metas_Intenciones]
GO

ALTER TABLE [dbo].[metas]  WITH CHECK ADD  CONSTRAINT [fk_metas_nivelesDeLogro] FOREIGN KEY([fkNivelDeLogro])
REFERENCES [dbo].[nivelesDeLogro] ([idNivelDeLogro])
GO

ALTER TABLE [dbo].[metas] CHECK CONSTRAINT [fk_metas_nivelesDeLogro]
GO

ALTER TABLE [dbo].[metas]  WITH CHECK ADD  CONSTRAINT [FK_Metas_Parametros] FOREIGN KEY([fkParametro])
REFERENCES [dbo].[parametrosDeMedicion] ([parametroMedicionId])
GO

ALTER TABLE [dbo].[metas] CHECK CONSTRAINT [FK_Metas_Parametros]
GO

ALTER TABLE [dbo].[Pagos]  WITH CHECK ADD  CONSTRAINT [FK_Pagos_AspNetUsers_NewUserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO

ALTER TABLE [dbo].[Pagos] CHECK CONSTRAINT [FK_Pagos_AspNetUsers_NewUserId]
GO

ALTER TABLE [dbo].[parametros_unidadesDeMedida]  WITH CHECK ADD  CONSTRAINT [FK__Parametro__fkPar__4924D839] FOREIGN KEY([fkParametroDeMedicion])
REFERENCES [dbo].[parametrosDeMedicion] ([parametroMedicionId])
GO

ALTER TABLE [dbo].[parametros_unidadesDeMedida] CHECK CONSTRAINT [FK__Parametro__fkPar__4924D839]
GO

ALTER TABLE [dbo].[parametros_unidadesDeMedida]  WITH CHECK ADD  CONSTRAINT [FK__Parametro__fkUni__4A18FC72] FOREIGN KEY([fkUnidadDeMedida])
REFERENCES [dbo].[unidadesDeMedida] ([unidadDeMedidaId])
GO

ALTER TABLE [dbo].[parametros_unidadesDeMedida] CHECK CONSTRAINT [FK__Parametro__fkUni__4A18FC72]
GO

ALTER TABLE [dbo].[parametrosDeMedicion]  WITH CHECK ADD  CONSTRAINT [fk_parametrosDeMedicion_iconsForParameters] FOREIGN KEY([fkIcon])
REFERENCES [dbo].[iconsForParameters] ([iconId])
GO

ALTER TABLE [dbo].[parametrosDeMedicion] CHECK CONSTRAINT [fk_parametrosDeMedicion_iconsForParameters]
GO

ALTER TABLE [dbo].[preReservasDeHorario]  WITH CHECK ADD  CONSTRAINT [FK_preReservasDeHorario_horariosClasesProgramadas] FOREIGN KEY([fkHoraLaboral])
REFERENCES [dbo].[horasLaborales] ([idHora])
GO

ALTER TABLE [dbo].[preReservasDeHorario] CHECK CONSTRAINT [FK_preReservasDeHorario_horariosClasesProgramadas]
GO

ALTER TABLE [dbo].[RefreshTokens]  WITH CHECK ADD  CONSTRAINT [FK_RefreshTokens_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[RefreshTokens] CHECK CONSTRAINT [FK_RefreshTokens_AspNetUsers]
GO

ALTER TABLE [dbo].[RegistrosEntrenamiento]  WITH CHECK ADD  CONSTRAINT [FK__Registros__Rutin__6FE99F9F] FOREIGN KEY([RutinaID])
REFERENCES [dbo].[Rutinas] ([RutinaID])
GO

ALTER TABLE [dbo].[RegistrosEntrenamiento] CHECK CONSTRAINT [FK__Registros__Rutin__6FE99F9F]
GO

ALTER TABLE [dbo].[RegistrosEntrenamiento]  WITH CHECK ADD  CONSTRAINT [FK_RegistrosEntrenamiento_AspNetUsers_NewUserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO

ALTER TABLE [dbo].[RegistrosEntrenamiento] CHECK CONSTRAINT [FK_RegistrosEntrenamiento_AspNetUsers_NewUserId]
GO

ALTER TABLE [dbo].[RutinaEjercicios]  WITH CHECK ADD  CONSTRAINT [FK__RutinaEje__Ejerc__52593CB8] FOREIGN KEY([EjercicioID])
REFERENCES [dbo].[Ejercicios] ([EjercicioID])
GO

ALTER TABLE [dbo].[RutinaEjercicios] CHECK CONSTRAINT [FK__RutinaEje__Ejerc__52593CB8]
GO

ALTER TABLE [dbo].[RutinaEjercicios]  WITH CHECK ADD  CONSTRAINT [FK__RutinaEje__Rutin__5165187F] FOREIGN KEY([RutinaID])
REFERENCES [dbo].[Rutinas] ([RutinaID])
GO

ALTER TABLE [dbo].[RutinaEjercicios] CHECK CONSTRAINT [FK__RutinaEje__Rutin__5165187F]
GO

ALTER TABLE [dbo].[Rutinas]  WITH CHECK ADD  CONSTRAINT [FK_Rutinas_AspNetUsers_NewEntrenadorId] FOREIGN KEY([EntrenadorId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO

ALTER TABLE [dbo].[Rutinas] CHECK CONSTRAINT [FK_Rutinas_AspNetUsers_NewEntrenadorId]
GO

ALTER TABLE [dbo].[Rutinas]  WITH CHECK ADD  CONSTRAINT [FK_Rutinas_AspNetUsers_NewUserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO

ALTER TABLE [dbo].[Rutinas] CHECK CONSTRAINT [FK_Rutinas_AspNetUsers_NewUserId]
GO

ALTER TABLE [dbo].[Rutinas]  WITH CHECK ADD  CONSTRAINT [FK_Rutinas_Clases] FOREIGN KEY([fkClase])
REFERENCES [dbo].[Clases] ([ClaseID])
GO

ALTER TABLE [dbo].[Rutinas] CHECK CONSTRAINT [FK_Rutinas_Clases]
GO

ALTER TABLE [dbo].[Rutinas]  WITH CHECK ADD  CONSTRAINT [FK_Rutinas_TipoRutina] FOREIGN KEY([fkTipoRutina])
REFERENCES [dbo].[TipoRutina] ([idTipoRutina])
GO

ALTER TABLE [dbo].[Rutinas] CHECK CONSTRAINT [FK_Rutinas_TipoRutina]
GO

ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [FK__Usuarios__RolID__3D5E1FD2] FOREIGN KEY([RolID])
REFERENCES [dbo].[Roles] ([RolID])
GO

ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK__Usuarios__RolID__3D5E1FD2]
GO

