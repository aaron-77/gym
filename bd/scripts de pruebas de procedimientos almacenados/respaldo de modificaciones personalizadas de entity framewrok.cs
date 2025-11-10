public virtual DbSet<DTO.Dtos.Ejercicio> ejercicioSP { get; set; }
    public virtual DbSet<DTO.Dtos.Rutina> rutinaSP { get; set; }
    public virtual DbSet<DTO.Dtos.QueryUser> userSP { get; set; }
    public virtual DbSet<DTO.Dtos.Cita> citaSP { get; set; }
    public virtual DbSet<DTO.Dtos.ClientesProximosACita> correosSP { get; set; }
    public virtual DbSet<DTO.Dtos.DTOParametroDeMedicion> parametrosDeMedicionSP { get; set; }

    public virtual DbSet<DTO.Dtos.DTOUltimaMedidaDeParametro> ultimasMedidasDeParametroSP { get; set; }

    public virtual DbSet<DTO.Dtos.DTOUltimaMetaDeParametro> ultimasMetasDeParametroSP { get; set; }


modelBuilder.Entity<DTO.Dtos.Rutina>(entity =>
        {
            entity.HasNoKey();
            entity.Property(e => e.RutinaId).HasColumnName("RutinaId");
            entity.Property(e => e.UsuarioID).HasColumnName("UsuarioID");
            entity.Property(e => e.EntrenadorID).HasColumnName("EntrenadorID");
            entity.Property(e => e.FechaCreacion).HasColumnName("FechaCreacion");
            entity.Property(e => e.Observaciones).HasColumnName("Observaciones");
        });

        modelBuilder.Entity<DTO.Dtos.QueryUser>(entity =>
        {
            entity.HasNoKey();
            entity.Property(e => e.UsuarioID).HasColumnName("UsuarioID");
            entity.Property(e => e.Nombre).HasColumnName("Nombre");
            entity.Property(e => e.Apellido).HasColumnName("Apellido");
            entity.Property(e => e.Email).HasColumnName("Email");
            entity.Property(e => e.Telefono).HasColumnName("Telefono");
            entity.Property(e => e.FechaNacimiento).HasColumnName("FechaNacimiento");
            entity.Property(e => e.FechaRegistro).HasColumnName("FechaRegistro");
        });
        modelBuilder.Entity<DTO.Dtos.Ejercicio>(entity =>
        {
            entity.HasNoKey();
            entity.Property(e => e.EjercicioID).HasColumnName("EjercicioID");
            entity.Property(e => e.NombreEjercicio).HasColumnName("NombreEjercicio");
            entity.Property(e => e.TipoEjercicio).HasColumnName("TipoEjercicio");
            entity.Property(e => e.Descripcion).HasColumnName("Descripcion");
        });

        modelBuilder.Entity<DTO.Dtos.Cita>(entity =>
        {
            entity.HasNoKey();
            entity.Property(e => e.Id).HasColumnName("CitaID");
            entity.Property(e => e.fkCliente).HasColumnName("UsuarioID");
            entity.Property(e => e.fkEntrenador).HasColumnName("EntrenadorID");
            entity.Property(e => e.fechaInicioCita).HasColumnName("FechaHora");
            entity.Property(e => e.fechaFinCita).HasColumnName("FechaHoraFin");
            entity.Property(e => e.tipoCita).HasColumnName("TipoCita");
            entity.Property(e => e.estado).HasColumnName("Estado");
        });


        modelBuilder.Entity<DTO.Dtos.ClientesProximosACita>(entity =>
        {
            entity.HasNoKey();
            entity.Property(e => e.correo).HasColumnName("Email");
            entity.Property(e => e.fechaCita).HasColumnName("FechaHora");

        });

        modelBuilder.Entity<DTO.Dtos.DTOParametroDeMedicion>(entity =>
        {
            entity.HasNoKey();
            entity.Property(parametrosDeMedicion => parametrosDeMedicion.parametroMedicionId).HasColumnName("parametroMedicionId");
            entity.Property(parametrosDeMedicion => parametrosDeMedicion.nombre).HasColumnName("nombre");
            entity.Property(parametrosDeMedicion => parametrosDeMedicion.fkUnidadDeMedida).HasColumnName("fkUnidadDeMedida");
            entity.Property(parametrosDeMedicion => parametrosDeMedicion.nombreUnidadDeMedida).HasColumnName("nombreUnidadDeMedida");
            entity.Property(parametrosDeMedicion => parametrosDeMedicion.fkIcon).HasColumnName("fkIcon");
        });

        modelBuilder.Entity<DTO.Dtos.DTOUltimaMedidaDeParametro>(entity =>
        {
            entity.HasNoKey();
            entity.Property(ultimasMedidasDeParametroSP => ultimasMedidasDeParametroSP.medidaId).HasColumnName("medidaId");
            entity.Property(ultimasMedidasDeParametroSP => ultimasMedidasDeParametroSP.fkParametro).HasColumnName("fkParametro");
            entity.Property(ultimasMedidasDeParametroSP => ultimasMedidasDeParametroSP.nombreParametro).HasColumnName("nombreParametro");
            entity.Property(ultimasMedidasDeParametroSP => ultimasMedidasDeParametroSP.valor).HasColumnName("valor");
            entity.Property(ultimasMedidasDeParametroSP => ultimasMedidasDeParametroSP.fechaDeCreacion).HasColumnName("fechaDeCreacion");
            entity.Property(ultimasMedidasDeParametroSP => ultimasMedidasDeParametroSP.unidadDeMedidaId).HasColumnName("unidadDeMedidaId");
            entity.Property(ultimasMedidasDeParametroSP => ultimasMedidasDeParametroSP.nombreUnidadDeMedida).HasColumnName("nombreUnidadDeMedida");
            entity.Property(ultimasMedidasDeParametroSP => ultimasMedidasDeParametroSP.fkEjercicio).HasColumnName("fkEjercicio");
            entity.Property(ultimasMedidasDeParametroSP => ultimasMedidasDeParametroSP.nombreEjercicio).HasColumnName("nombreEjercicio");
            entity.Property(ultimasMedidasDeParametroSP => ultimasMedidasDeParametroSP.urlIconoParametro).HasColumnName("urlIconoParametro");
            entity.Property(ultimasMedidasDeParametroSP => ultimasMedidasDeParametroSP.urlIconoEjercicio).HasColumnName("urlIconoEjercicio");
        });


        modelBuilder.Entity<DTO.Dtos.DTOUltimaMetaDeParametro>(entity =>
        {
            entity.HasNoKey();
            entity.Property(meta => meta.metaId).HasColumnName("metaId");
            entity.Property(meta => meta.intencion).HasColumnName("intencion");
            entity.Property(meta => meta.nombreParametro).HasColumnName("nombreParametro");
            entity.Property(meta => meta.nombreEjercicio).HasColumnName("nombreEjercicio");
            entity.Property(meta => meta.valorObjetivo).HasColumnName("valorObjetivo");
            entity.Property(meta => meta.nombreNivelDeLogro).HasColumnName("nombreNivelDeLogro");
            entity.Property(meta => meta.fechaDeInicioDeLaMeta).HasColumnName("fechaDeInicioDeLaMeta");
            entity.Property(meta => meta.fechaLimite).HasColumnName("fechaLimite");
            entity.Property(meta => meta.fkEjercicio).HasColumnName("fkEjercicio");
        });


