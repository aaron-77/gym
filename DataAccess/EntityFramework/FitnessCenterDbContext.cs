using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace DataAccess.EntityFramework;

public partial class FitnessCenterDbContext : DbContext
{
    public FitnessCenterDbContext()
    {
    }

    public FitnessCenterDbContext(DbContextOptions<FitnessCenterDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<BeneficiosDeClase> BeneficiosDeClases { get; set; }

    public virtual DbSet<Cita> Citas { get; set; }

    public virtual DbSet<Clase> Clases { get; set; }

    public virtual DbSet<ClasesProgramada> ClasesProgramadas { get; set; }

    public virtual DbSet<ConsejosParaLasClase> ConsejosParaLasClases { get; set; }

    public virtual DbSet<Cupone> Cupones { get; set; }

    public virtual DbSet<Descuento> Descuentos { get; set; }

    public virtual DbSet<DetalleEntrenamiento> DetalleEntrenamientos { get; set; }

    public virtual DbSet<DuracionCita> DuracionCitas { get; set; }

    public virtual DbSet<Ejercicio> Ejercicios { get; set; }

    public virtual DbSet<EjercicioEquipo> EjercicioEquipos { get; set; }

    public virtual DbSet<EjerciciosParametrosDeMedicion> EjerciciosParametrosDeMedicions { get; set; }

    public virtual DbSet<Equipo> Equipos { get; set; }

    public virtual DbSet<EstadosClasesProgramada> EstadosClasesProgramadas { get; set; }

    public virtual DbSet<EstadosInscripcione> EstadosInscripciones { get; set; }

    public virtual DbSet<EstructuraDeClase> EstructuraDeClases { get; set; }

    public virtual DbSet<IconsForParameter> IconsForParameters { get; set; }

    public virtual DbSet<ImagesForExercise> ImagesForExercises { get; set; }

    public virtual DbSet<InscripcionesDeClase> InscripcionesDeClases { get; set; }

    public virtual DbSet<Intencione> Intenciones { get; set; }

    public virtual DbSet<LogErrore> LogErrores { get; set; }

    public virtual DbSet<Medida> Medidas { get; set; }

    public virtual DbSet<Meta> Metas { get; set; }

    public virtual DbSet<NivelesDeDificultadDeClase> NivelesDeDificultadDeClases { get; set; }

    public virtual DbSet<NivelesDeIntensidadDeClase> NivelesDeIntensidadDeClases { get; set; }

    public virtual DbSet<NivelesDeLogro> NivelesDeLogros { get; set; }

    public virtual DbSet<Pago> Pagos { get; set; }

    public virtual DbSet<ParametrosDeMedicion> ParametrosDeMedicions { get; set; }

    public virtual DbSet<ParametrosUnidadesDeMedidum> ParametrosUnidadesDeMedida { get; set; }

    public virtual DbSet<RegistrosEntrenamiento> RegistrosEntrenamientos { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<Rutina> Rutinas { get; set; }

    public virtual DbSet<RutinaEjercicio> RutinaEjercicios { get; set; }

    public virtual DbSet<Servicio> Servicios { get; set; }

    public virtual DbSet<TipoRutina> TipoRutinas { get; set; }

    public virtual DbSet<UnidadesDeMedidum> UnidadesDeMedida { get; set; }

    public virtual DbSet<Usuario> Usuarios { get; set; }

    // propiedades agregadas manualmente
    public virtual DbSet<DTO.Dtos.Ejercicio> ejercicioSP { get; set; }
    
    public virtual DbSet<DTO.Dtos.Rutina> rutinaSP { get; set; }
    public virtual DbSet<DTO.Dtos.QueryUser> userSP { get; set; }
    public virtual DbSet<DTO.Dtos.Cita> citaSP { get; set; }
    public virtual DbSet<DTO.Dtos.ClientesProximosACita> correosSP { get; set; }
    public virtual DbSet<DTO.Dtos.DTOParametroDeMedicion> parametrosDeMedicionSP { get; set; }

    public virtual DbSet<DTO.Dtos.DTOUltimaMedidaDeParametro> ultimasMedidasDeParametroSP { get; set; }

    public virtual DbSet<DTO.Dtos.DTOUltimaMetaDeParametro> ultimasMetasDeParametroSP { get; set; }
    public virtual DbSet<DTO.Dtos.DTOEjerciciosYParametrosDelCliente> ejerciciosYParametrosDelClienteSP { get; set; }
    public virtual DbSet<DTO.Dtos.DetalleDeClase> detalleDeClaseSP { get; set; }
    public virtual DbSet<DTO.Dtos.DetalleDeClaseRaw> detalleDeClaseRawSP { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=localhost;Database=FitnessCenterDB;User Id=aaronlogin;Password=Terrabreak13;Integrated Security=False;TrustServerCertificate=True;Trusted_Connection=False");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<BeneficiosDeClase>(entity =>
        {
            entity.HasKey(e => e.IdBeneficio).HasName("PK__benefici__00AAC26A2D2E6E7C");

            entity.ToTable("beneficiosDeClase");

            entity.Property(e => e.IdBeneficio).HasColumnName("idBeneficio");
            entity.Property(e => e.Beneficio)
                .HasMaxLength(200)
                .HasColumnName("beneficio");
            entity.Property(e => e.FechaDeCreacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeCreacion");
            entity.Property(e => e.FechaDeModificacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeModificacion");
            entity.Property(e => e.FkClase).HasColumnName("fkClase");

            entity.HasOne(d => d.FkClaseNavigation).WithMany(p => p.BeneficiosDeClases)
                .HasForeignKey(d => d.FkClase)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Beneficio_Clase");
        });

        modelBuilder.Entity<Cita>(entity =>
        {
            entity.HasKey(e => e.CitaId).HasName("PK__Citas__F0E2D9F2556E9C13");

            entity.Property(e => e.CitaId).HasColumnName("CitaID");
            entity.Property(e => e.EntrenadorId).HasColumnName("EntrenadorID");
            entity.Property(e => e.Estado).HasMaxLength(50);
            entity.Property(e => e.FechaHora).HasColumnType("datetime");
            entity.Property(e => e.FechaHoraFin).HasColumnType("datetime");
            entity.Property(e => e.TipoCita).HasMaxLength(50);
            entity.Property(e => e.UsuarioId).HasColumnName("UsuarioID");

            entity.HasOne(d => d.Entrenador).WithMany(p => p.CitaEntrenadors)
                .HasForeignKey(d => d.EntrenadorId)
                .HasConstraintName("FK__Citas__Entrenado__44FF419A");

            entity.HasOne(d => d.Usuario).WithMany(p => p.CitaUsuarios)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("FK__Citas__UsuarioID__440B1D61");
        });

        modelBuilder.Entity<Clase>(entity =>
        {
            entity.HasKey(e => e.ClaseId).HasName("PK__Clases__F54296B30E7E66FD");

            entity.Property(e => e.ClaseId).HasColumnName("ClaseID");
            entity.Property(e => e.Descripcion).HasMaxLength(255);
            entity.Property(e => e.DuracionEnMinutos).HasColumnName("duracionEnMinutos");
            entity.Property(e => e.FkDificultad).HasColumnName("fkDificultad");
            entity.Property(e => e.FkIntensidad).HasColumnName("fkIntensidad");
            entity.Property(e => e.InstructorId).HasColumnName("InstructorID");
            entity.Property(e => e.NombreClase).HasMaxLength(100);

            entity.HasOne(d => d.FkDificultadNavigation).WithMany(p => p.Clases)
                .HasForeignKey(d => d.FkDificultad)
                .HasConstraintName("FK_Clases_Dificultad");

            entity.HasOne(d => d.FkIntensidadNavigation).WithMany(p => p.Clases)
                .HasForeignKey(d => d.FkIntensidad)
                .HasConstraintName("FK_Clases_Intensidad");

            entity.HasOne(d => d.Instructor).WithMany(p => p.Clases)
                .HasForeignKey(d => d.InstructorId)
                .HasConstraintName("FK__Clases__Instruct__5AEE82B9");
        });

        modelBuilder.Entity<ClasesProgramada>(entity =>
        {
            entity.HasKey(e => e.IdProgramacionClase).HasName("PK__clasesPr__712E87EE8D30E7B0");

            entity.ToTable("clasesProgramadas");

            entity.Property(e => e.IdProgramacionClase).HasColumnName("idProgramacionClase");
            entity.Property(e => e.CupoMaximo).HasColumnName("cupoMaximo");
            entity.Property(e => e.FechaFin)
                .HasColumnType("datetime")
                .HasColumnName("fechaFin");
            entity.Property(e => e.FechaInicio)
                .HasColumnType("datetime")
                .HasColumnName("fechaInicio");
            entity.Property(e => e.FkClase).HasColumnName("fkClase");
            entity.Property(e => e.FkEntrenador).HasColumnName("fkEntrenador");
            entity.Property(e => e.FkEstadoClaseProgramada).HasColumnName("fkEstadoClaseProgramada");

            entity.HasOne(d => d.FkClaseNavigation).WithMany(p => p.ClasesProgramada)
                .HasForeignKey(d => d.FkClase)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ClasesProgramadas_Clase");

            entity.HasOne(d => d.FkEntrenadorNavigation).WithMany(p => p.ClasesProgramada)
                .HasForeignKey(d => d.FkEntrenador)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ClasesProgramadas_Usuarios");

            entity.HasOne(d => d.FkEstadoClaseProgramadaNavigation).WithMany(p => p.ClasesProgramada)
                .HasForeignKey(d => d.FkEstadoClaseProgramada)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ClasesProgramadas_EstadoClaseProgramada");
        });

        modelBuilder.Entity<ConsejosParaLasClase>(entity =>
        {
            entity.HasKey(e => e.IdConsejo).HasName("PK__consejos__3DB777ADDB7A6091");

            entity.ToTable("consejosParaLasClases");

            entity.Property(e => e.IdConsejo).HasColumnName("idConsejo");
            entity.Property(e => e.Consejos).HasColumnName("consejos");
            entity.Property(e => e.FkClase).HasColumnName("fkClase");
            entity.Property(e => e.FkEjercicio).HasColumnName("fkEjercicio");
            entity.Property(e => e.IntroduccionDeConsejo).HasColumnName("introduccionDeConsejo");

            entity.HasOne(d => d.FkClaseNavigation).WithMany(p => p.ConsejosParaLasClases)
                .HasForeignKey(d => d.FkClase)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("FK_Consejos_Clase");

            entity.HasOne(d => d.FkEjercicioNavigation).WithMany(p => p.ConsejosParaLasClases)
                .HasForeignKey(d => d.FkEjercicio)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("FK_Consejos_Ejercicio");
        });

        modelBuilder.Entity<Cupone>(entity =>
        {
            entity.HasKey(e => e.CuponId).HasName("PK__Cupones__C43568B78A3A377F");

            entity.Property(e => e.CuponId).HasColumnName("CuponID");
            entity.Property(e => e.Codigo).HasMaxLength(50);
            entity.Property(e => e.DescuentoId).HasColumnName("DescuentoID");
            entity.Property(e => e.Estado).HasMaxLength(50);
            entity.Property(e => e.FechaExpiracion).HasColumnType("datetime");

            entity.HasOne(d => d.Descuento).WithMany(p => p.Cupones)
                .HasForeignKey(d => d.DescuentoId)
                .HasConstraintName("FK__Cupones__Descuen__6B24EA82");
        });

        modelBuilder.Entity<Descuento>(entity =>
        {
            entity.HasKey(e => e.DescuentoId).HasName("PK__Descuent__0C2C1138689BA8C4");

            entity.Property(e => e.DescuentoId).HasColumnName("DescuentoID");
            entity.Property(e => e.Descripcion).HasMaxLength(255);
            entity.Property(e => e.FechaFin).HasColumnType("datetime");
            entity.Property(e => e.FechaInicio).HasColumnType("datetime");
            entity.Property(e => e.Porcentaje).HasColumnType("decimal(5, 2)");
        });

        modelBuilder.Entity<DetalleEntrenamiento>(entity =>
        {
            entity.HasKey(e => e.DetalleId).HasName("PK__DetalleE__6E19D6FA406B23BB");

            entity.ToTable("DetalleEntrenamiento");

            entity.Property(e => e.DetalleId).HasColumnName("DetalleID");
            entity.Property(e => e.EjercicioId).HasColumnName("EjercicioID");
            entity.Property(e => e.Peso).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.RegistroId).HasColumnName("RegistroID");

            entity.HasOne(d => d.Ejercicio).WithMany(p => p.DetalleEntrenamientos)
                .HasForeignKey(d => d.EjercicioId)
                .HasConstraintName("FK__DetalleEn__Ejerc__74AE54BC");

            entity.HasOne(d => d.Registro).WithMany(p => p.DetalleEntrenamientos)
                .HasForeignKey(d => d.RegistroId)
                .HasConstraintName("FK__DetalleEn__Regis__73BA3083");
        });

        modelBuilder.Entity<DuracionCita>(entity =>
        {
            entity.HasKey(e => e.DuracionId).HasName("PK__duracion__3B2C07DA2413E2C8");

            entity.ToTable("duracionCitas");

            entity.Property(e => e.DuracionId).HasColumnName("DuracionID");
        });

        modelBuilder.Entity<Ejercicio>(entity =>
        {
            entity.HasKey(e => e.EjercicioId).HasName("PK__Ejercici__812226A1579B3B09");

            entity.Property(e => e.EjercicioId).HasColumnName("EjercicioID");
            entity.Property(e => e.Descripcion).HasMaxLength(255);
            entity.Property(e => e.FkIcon).HasColumnName("fkIcon");
            entity.Property(e => e.NombreEjercicio).HasMaxLength(100);
            entity.Property(e => e.TipoEjercicio).HasMaxLength(50);

            entity.HasOne(d => d.FkIconNavigation).WithMany(p => p.Ejercicios)
                .HasForeignKey(d => d.FkIcon)
                .HasConstraintName("fk_ejercicios_iconsForParameters");
        });

        modelBuilder.Entity<EjercicioEquipo>(entity =>
        {
            entity.HasKey(e => e.EjercicioEquipoId).HasName("PK__Ejercici__A8CC48FDB85B7151");

            entity.Property(e => e.EjercicioEquipoId).HasColumnName("EjercicioEquipoID");
            entity.Property(e => e.EjercicioId).HasColumnName("EjercicioID");
            entity.Property(e => e.EquipoId).HasColumnName("EquipoID");

            entity.HasOne(d => d.Ejercicio).WithMany(p => p.EjercicioEquipos)
                .HasForeignKey(d => d.EjercicioId)
                .HasConstraintName("FK__Ejercicio__Ejerc__571DF1D5");

            entity.HasOne(d => d.Equipo).WithMany(p => p.EjercicioEquipos)
                .HasForeignKey(d => d.EquipoId)
                .HasConstraintName("FK__Ejercicio__Equip__5812160E");
        });

        modelBuilder.Entity<EjerciciosParametrosDeMedicion>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__ejercici__3213E83FF0FCCAAC");

            entity.ToTable("ejercicios_parametrosDeMedicion");

            entity.HasIndex(e => e.FkEjercicio, "idx_ejercicios_parametrosDeMedicion_ejercicio");

            entity.HasIndex(e => e.FkParametro, "idx_ejercicios_parametrosDeMedicion_parametro");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.FechaCreacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaCreacion");
            entity.Property(e => e.FechaModificacion)
                .HasColumnType("datetime")
                .HasColumnName("fechaModificacion");
            entity.Property(e => e.FkEjercicio).HasColumnName("fkEjercicio");
            entity.Property(e => e.FkParametro).HasColumnName("fkParametro");

            entity.HasOne(d => d.FkEjercicioNavigation).WithMany(p => p.EjerciciosParametrosDeMedicions)
                .HasForeignKey(d => d.FkEjercicio)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ejercicios_parametrosDeMedicion_Ejercicios");

            entity.HasOne(d => d.FkParametroNavigation).WithMany(p => p.EjerciciosParametrosDeMedicions)
                .HasForeignKey(d => d.FkParametro)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ejercicios_parametrosDeMedicion_parametrosDeMedicion");
        });

        modelBuilder.Entity<Equipo>(entity =>
        {
            entity.HasKey(e => e.EquipoId).HasName("PK__Equipos__DE8A0BFFA22BEA11");

            entity.Property(e => e.EquipoId).HasColumnName("EquipoID");
            entity.Property(e => e.Descripcion).HasMaxLength(255);
            entity.Property(e => e.FkIcon).HasColumnName("fkIcon");
            entity.Property(e => e.NombreEquipo).HasMaxLength(100);

            entity.HasOne(d => d.FkIconNavigation).WithMany(p => p.Equipos)
                .HasForeignKey(d => d.FkIcon)
                .HasConstraintName("FK_Equipos_iconsForParameters");
        });

        modelBuilder.Entity<EstadosClasesProgramada>(entity =>
        {
            entity.HasKey(e => e.IdEstadoClaseProgramada).HasName("PK__estadosC__C0C65CED53670AA4");

            entity.ToTable("estadosClasesProgramadas");

            entity.Property(e => e.IdEstadoClaseProgramada).HasColumnName("idEstadoClaseProgramada");
            entity.Property(e => e.FechaCreacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaCreacion");
            entity.Property(e => e.FechaModificacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaModificacion");
            entity.Property(e => e.NombresEstado).HasColumnName("nombresEstado");
        });

        modelBuilder.Entity<EstadosInscripcione>(entity =>
        {
            entity.HasKey(e => e.IdEstadoInscripcion).HasName("PK__estadosI__5CD68FF4850AB16F");

            entity.ToTable("estadosInscripciones");

            entity.Property(e => e.IdEstadoInscripcion).HasColumnName("idEstadoInscripcion");
            entity.Property(e => e.FechaCreacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaCreacion");
            entity.Property(e => e.FechaModificacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaModificacion");
            entity.Property(e => e.NombreEstadoInscripcion).HasColumnName("nombreEstadoInscripcion");
        });

        modelBuilder.Entity<EstructuraDeClase>(entity =>
        {
            entity.HasKey(e => e.IdBloque).HasName("PK__estructu__EF4379A8928D581A");

            entity.ToTable("estructuraDeClase");

            entity.Property(e => e.IdBloque).HasColumnName("idBloque");
            entity.Property(e => e.DescripcionBloque).HasColumnName("descripcionBloque");
            entity.Property(e => e.DuracionMayorEnMinutos).HasColumnName("duracionMayorEnMinutos");
            entity.Property(e => e.DuracionMenorEnMinutos).HasColumnName("duracionMenorEnMinutos");
            entity.Property(e => e.FechaDeCreacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeCreacion");
            entity.Property(e => e.FechaDeModificacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeModificacion");
            entity.Property(e => e.FkClase).HasColumnName("fkClase");
            entity.Property(e => e.NumeroConsecutivoDelBloque).HasColumnName("numeroConsecutivoDelBloque");
            entity.Property(e => e.TituloBloque)
                .HasMaxLength(200)
                .HasColumnName("tituloBloque");

            entity.HasOne(d => d.FkClaseNavigation).WithMany(p => p.EstructuraDeClases)
                .HasForeignKey(d => d.FkClase)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Estructura_Clase");
        });

        modelBuilder.Entity<IconsForParameter>(entity =>
        {
            entity.HasKey(e => e.IconId).HasName("PK__iconsFor__5CE3968F35DA5BE8");

            entity.ToTable("iconsForParameters");

            entity.Property(e => e.IconId).HasColumnName("iconId");
            entity.Property(e => e.Nombre).HasColumnName("nombre");
            entity.Property(e => e.UrlPrivada).HasColumnName("urlPrivada");
            entity.Property(e => e.UrlPublica).HasColumnName("urlPublica");
        });

        modelBuilder.Entity<ImagesForExercise>(entity =>
        {
            entity.HasKey(e => e.IdImage).HasName("PK__imagesFo__84D649AFC118D1B7");

            entity.ToTable("imagesForExercises");

            entity.Property(e => e.IdImage).HasColumnName("idImage");
            entity.Property(e => e.FkEjercicio).HasColumnName("fkEjercicio");
            entity.Property(e => e.NombreParaElFront)
                .HasMaxLength(200)
                .HasColumnName("nombreParaElFront");
            entity.Property(e => e.UrlPrivada).HasColumnName("urlPrivada");
            entity.Property(e => e.UrlPublica).HasColumnName("urlPublica");

            entity.HasOne(d => d.FkEjercicioNavigation).WithMany(p => p.ImagesForExercises)
                .HasForeignKey(d => d.FkEjercicio)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ImagesForExercises_Ejercicio");
        });

        modelBuilder.Entity<InscripcionesDeClase>(entity =>
        {
            entity.HasKey(e => e.IdInscripcion).HasName("PK__inscripc__3D58AB69B61D8617");

            entity.ToTable("inscripcionesDeClases");

            entity.Property(e => e.IdInscripcion).HasColumnName("idInscripcion");
            entity.Property(e => e.FechaDeInscripcion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeInscripcion");
            entity.Property(e => e.FkCliente).HasColumnName("fkCliente");
            entity.Property(e => e.FkEstadoInscripcion).HasColumnName("fkEstadoInscripcion");
            entity.Property(e => e.FkProgramacionClase).HasColumnName("fkProgramacionClase");

            entity.HasOne(d => d.FkClienteNavigation).WithMany(p => p.InscripcionesDeClases)
                .HasForeignKey(d => d.FkCliente)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_InscripcionesDeClases_Cliente");

            entity.HasOne(d => d.FkEstadoInscripcionNavigation).WithMany(p => p.InscripcionesDeClases)
                .HasForeignKey(d => d.FkEstadoInscripcion)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_InscripcionesDeClases_EstadoInscripcion");

            entity.HasOne(d => d.FkProgramacionClaseNavigation).WithMany(p => p.InscripcionesDeClases)
                .HasForeignKey(d => d.FkProgramacionClase)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_InscripcionesDeClases_ProgramacionClase");
        });

        modelBuilder.Entity<Intencione>(entity =>
        {
            entity.HasKey(e => e.IntencionId).HasName("PK__intencio__41F5EC2340AE7FEA");

            entity.ToTable("intenciones");

            entity.Property(e => e.IntencionId).HasColumnName("intencionId");
            entity.Property(e => e.FechaDeRegistro)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeRegistro");
            entity.Property(e => e.FechaModificacionDeRegistro)
                .HasColumnType("datetime")
                .HasColumnName("fechaModificacionDeRegistro");
            entity.Property(e => e.Nombre)
                .HasMaxLength(100)
                .HasColumnName("nombre");
        });

        modelBuilder.Entity<LogErrore>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__LogError__3213E83F2E02FD9A");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Aplicacion)
                .HasMaxLength(200)
                .HasDefaultValueSql("(app_name())")
                .HasColumnName("aplicacion");
            entity.Property(e => e.Estado).HasColumnName("estado");
            entity.Property(e => e.Fecha)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fecha");
            entity.Property(e => e.Host)
                .HasMaxLength(100)
                .HasDefaultValueSql("(host_name())")
                .HasColumnName("host");
            entity.Property(e => e.Mensaje)
                .HasMaxLength(4000)
                .HasColumnName("mensaje");
            entity.Property(e => e.Procedimiento)
                .HasMaxLength(200)
                .HasColumnName("procedimiento");
            entity.Property(e => e.Severidad).HasColumnName("severidad");
            entity.Property(e => e.Usuario)
                .HasMaxLength(100)
                .HasDefaultValueSql("(suser_name())")
                .HasColumnName("usuario");
        });

        modelBuilder.Entity<Medida>(entity =>
        {
            entity.HasKey(e => e.MedidaId).HasName("PK__medidas__1C299EFA6221D68B");

            entity.ToTable("medidas");

            entity.Property(e => e.MedidaId).HasColumnName("medidaId");
            entity.Property(e => e.FechaDeCreacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeCreacion");
            entity.Property(e => e.FkEjercicio).HasColumnName("fkEjercicio");
            entity.Property(e => e.FkParametro).HasColumnName("fkParametro");
            entity.Property(e => e.FkUsuario).HasColumnName("fkUsuario");
            entity.Property(e => e.Valor)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("valor");

            entity.HasOne(d => d.FkEjercicioNavigation).WithMany(p => p.Medida)
                .HasForeignKey(d => d.FkEjercicio)
                .HasConstraintName("fk_medidas_ejercicios");

            entity.HasOne(d => d.FkParametroNavigation).WithMany(p => p.Medida)
                .HasForeignKey(d => d.FkParametro)
                .HasConstraintName("fk_medidas_parametros");

            entity.HasOne(d => d.FkUsuarioNavigation).WithMany(p => p.Medida)
                .HasForeignKey(d => d.FkUsuario)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UsuarioMedida");
        });

        modelBuilder.Entity<Meta>(entity =>
        {
            entity.HasKey(e => e.MetaId).HasName("PK__metas__8189FF8C363B9BB4");

            entity.ToTable("metas");

            entity.Property(e => e.MetaId).HasColumnName("metaId");
            entity.Property(e => e.FechaDeInicioDeLaMeta)
                .HasColumnType("datetime")
                .HasColumnName("fechaDeInicioDeLaMeta");
            entity.Property(e => e.FechaDeModificacionDeRegistro)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeModificacionDeRegistro");
            entity.Property(e => e.FechaDeRegistro)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeRegistro");
            entity.Property(e => e.FechaLimite)
                .HasColumnType("datetime")
                .HasColumnName("fechaLimite");
            entity.Property(e => e.FkEjercicio).HasColumnName("fkEjercicio");
            entity.Property(e => e.FkIntencion).HasColumnName("fkIntencion");
            entity.Property(e => e.FkNivelDeLogro)
                .HasDefaultValueSql("((1))")
                .HasColumnName("fkNivelDeLogro");
            entity.Property(e => e.FkParametro).HasColumnName("fkParametro");
            entity.Property(e => e.FkUsuario).HasColumnName("fkUsuario");
            entity.Property(e => e.ValorObjetivo)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("valorObjetivo");

            entity.HasOne(d => d.FkEjercicioNavigation).WithMany(p => p.Meta)
                .HasForeignKey(d => d.FkEjercicio)
                .HasConstraintName("FK_Metas_Ejercicios");

            entity.HasOne(d => d.FkIntencionNavigation).WithMany(p => p.Meta)
                .HasForeignKey(d => d.FkIntencion)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Metas_Intenciones");

            entity.HasOne(d => d.FkNivelDeLogroNavigation).WithMany(p => p.Meta)
                .HasForeignKey(d => d.FkNivelDeLogro)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_metas_nivelesDeLogro");

            entity.HasOne(d => d.FkParametroNavigation).WithMany(p => p.Meta)
                .HasForeignKey(d => d.FkParametro)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Metas_Parametros");

            entity.HasOne(d => d.FkUsuarioNavigation).WithMany(p => p.Meta)
                .HasForeignKey(d => d.FkUsuario)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Metas_Usuarios");
        });

        modelBuilder.Entity<NivelesDeDificultadDeClase>(entity =>
        {
            entity.HasKey(e => e.IdNivelDeDificultadDeClase).HasName("PK__nivelesD__86F5BA39539AB17D");

            entity.ToTable("nivelesDeDificultadDeClase");

            entity.Property(e => e.IdNivelDeDificultadDeClase).HasColumnName("idNivelDeDificultadDeClase");
            entity.Property(e => e.FechaDeCreacion)
                .HasColumnType("datetime")
                .HasColumnName("fechaDeCreacion");
            entity.Property(e => e.FechaDeModificacion)
                .HasColumnType("datetime")
                .HasColumnName("fechaDeModificacion");
            entity.Property(e => e.NombreNivelDeDificultad).HasColumnName("nombreNivelDeDificultad");
        });

        modelBuilder.Entity<NivelesDeIntensidadDeClase>(entity =>
        {
            entity.HasKey(e => e.IdNivelDeIntensidad).HasName("PK__nivelesD__6F6E9594C607DCB8");

            entity.ToTable("nivelesDeIntensidadDeClase");

            entity.Property(e => e.IdNivelDeIntensidad).HasColumnName("idNivelDeIntensidad");
            entity.Property(e => e.FechaDeCreacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeCreacion");
            entity.Property(e => e.NombreNivelDeIntensidad).HasColumnName("nombreNivelDeIntensidad");
        });

        modelBuilder.Entity<NivelesDeLogro>(entity =>
        {
            entity.HasKey(e => e.IdNivelDeLogro).HasName("PK__nivelesD__0A5FC0796013EA3F");

            entity.ToTable("nivelesDeLogro");

            entity.Property(e => e.IdNivelDeLogro).HasColumnName("idNivelDeLogro");
            entity.Property(e => e.FechaDeRegistro)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeRegistro");
            entity.Property(e => e.FechaModificacionDeRegistro)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaModificacionDeRegistro");
            entity.Property(e => e.Nombre)
                .HasMaxLength(100)
                .HasColumnName("nombre");
        });

        modelBuilder.Entity<Pago>(entity =>
        {
            entity.HasKey(e => e.PagoId).HasName("PK__Pagos__F00B6158C2211D16");

            entity.Property(e => e.PagoId).HasColumnName("PagoID");
            entity.Property(e => e.Estado).HasMaxLength(50);
            entity.Property(e => e.FechaPago)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.MetodoPago).HasMaxLength(50);
            entity.Property(e => e.Monto).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.UsuarioId).HasColumnName("UsuarioID");

            entity.HasOne(d => d.Usuario).WithMany(p => p.Pagos)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("FK__Pagos__UsuarioID__6383C8BA");
        });

        modelBuilder.Entity<ParametrosDeMedicion>(entity =>
        {
            entity.HasKey(e => e.ParametroMedicionId).HasName("PK__parametr__FE4B91C8ECDB659E");

            entity.ToTable("parametrosDeMedicion");

            entity.Property(e => e.ParametroMedicionId).HasColumnName("parametroMedicionId");
            entity.Property(e => e.FechaDeRegistro)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeRegistro");
            entity.Property(e => e.FechaModificacionDeRegistro)
                .HasColumnType("datetime")
                .HasColumnName("fechaModificacionDeRegistro");
            entity.Property(e => e.FkIcon).HasColumnName("fkIcon");
            entity.Property(e => e.Nombre)
                .HasMaxLength(100)
                .HasColumnName("nombre");

            entity.HasOne(d => d.FkIconNavigation).WithMany(p => p.ParametrosDeMedicions)
                .HasForeignKey(d => d.FkIcon)
                .HasConstraintName("fk_parametrosDeMedicion_iconsForParameters");
        });

        modelBuilder.Entity<ParametrosUnidadesDeMedidum>(entity =>
        {
            entity.HasKey(e => new { e.FkParametroDeMedicion, e.FkUnidadDeMedida }).HasName("PK__Parametr__44945C4A9DEF7EB4");

            entity.ToTable("parametros_unidadesDeMedida");

            entity.Property(e => e.FkParametroDeMedicion).HasColumnName("fkParametroDeMedicion");
            entity.Property(e => e.FkUnidadDeMedida).HasColumnName("fkUnidadDeMedida");
            entity.Property(e => e.FechaDeRegistro)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeRegistro");

            entity.HasOne(d => d.FkParametroDeMedicionNavigation).WithMany(p => p.ParametrosUnidadesDeMedida)
                .HasForeignKey(d => d.FkParametroDeMedicion)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Parametro__fkPar__4924D839");

            entity.HasOne(d => d.FkUnidadDeMedidaNavigation).WithMany(p => p.ParametrosUnidadesDeMedida)
                .HasForeignKey(d => d.FkUnidadDeMedida)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Parametro__fkUni__4A18FC72");
        });

        modelBuilder.Entity<RegistrosEntrenamiento>(entity =>
        {
            entity.HasKey(e => e.RegistroId).HasName("PK__Registro__B897313EAB9C2539");

            entity.ToTable("RegistrosEntrenamiento");

            entity.Property(e => e.RegistroId).HasColumnName("RegistroID");
            entity.Property(e => e.FechaRegistro)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.RutinaId).HasColumnName("RutinaID");
            entity.Property(e => e.UsuarioId).HasColumnName("UsuarioID");

            entity.HasOne(d => d.Rutina).WithMany(p => p.RegistrosEntrenamientos)
                .HasForeignKey(d => d.RutinaId)
                .HasConstraintName("FK__Registros__Rutin__6FE99F9F");

            entity.HasOne(d => d.Usuario).WithMany(p => p.RegistrosEntrenamientos)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("FK__Registros__Usuar__6EF57B66");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RolId).HasName("PK__Roles__F92302D1C65ABB7F");

            entity.Property(e => e.RolId).HasColumnName("RolID");
            entity.Property(e => e.NombreRol).HasMaxLength(50);
        });

        modelBuilder.Entity<Rutina>(entity =>
        {
            entity.HasKey(e => e.RutinaId).HasName("PK__Rutinas__E76E165A11753A49");

            entity.Property(e => e.RutinaId).HasColumnName("RutinaID");
            entity.Property(e => e.EntrenadorId).HasColumnName("EntrenadorID");
            entity.Property(e => e.FechaCreacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.FkClase).HasColumnName("fkClase");
            entity.Property(e => e.FkTipoRutina).HasColumnName("fkTipoRutina");
            entity.Property(e => e.Observaciones).HasMaxLength(255);
            entity.Property(e => e.UsuarioId).HasColumnName("UsuarioID");

            entity.HasOne(d => d.Entrenador).WithMany(p => p.RutinaEntrenadors)
                .HasForeignKey(d => d.EntrenadorId)
                .HasConstraintName("FK__Rutinas__Entrena__4AB81AF0");

            entity.HasOne(d => d.FkClaseNavigation).WithMany(p => p.Rutinas)
                .HasForeignKey(d => d.FkClase)
                .HasConstraintName("FK_Rutinas_Clases");

            entity.HasOne(d => d.FkTipoRutinaNavigation).WithMany(p => p.Rutinas)
                .HasForeignKey(d => d.FkTipoRutina)
                .HasConstraintName("FK_Rutinas_TipoRutina");

            entity.HasOne(d => d.Usuario).WithMany(p => p.RutinaUsuarios)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("FK__Rutinas__Usuario__49C3F6B7");
        });

        modelBuilder.Entity<RutinaEjercicio>(entity =>
        {
            entity.HasKey(e => e.RutinaEjercicioId).HasName("PK__RutinaEj__56420023FA3B532E");

            entity.Property(e => e.RutinaEjercicioId).HasColumnName("RutinaEjercicioID");
            entity.Property(e => e.EjercicioId).HasColumnName("EjercicioID");
            entity.Property(e => e.Peso).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.RutinaId).HasColumnName("RutinaID");

            entity.HasOne(d => d.Ejercicio).WithMany(p => p.RutinaEjercicios)
                .HasForeignKey(d => d.EjercicioId)
                .HasConstraintName("FK__RutinaEje__Ejerc__52593CB8");

            entity.HasOne(d => d.Rutina).WithMany(p => p.RutinaEjercicios)
                .HasForeignKey(d => d.RutinaId)
                .HasConstraintName("FK__RutinaEje__Rutin__5165187F");
        });

        modelBuilder.Entity<Servicio>(entity =>
        {
            entity.HasKey(e => e.ServicioId).HasName("PK__Servicio__D5AEEC221B5A2D82");

            entity.Property(e => e.ServicioId).HasColumnName("ServicioID");
            entity.Property(e => e.Costo).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Descripcion).HasMaxLength(255);
            entity.Property(e => e.NombreServicio).HasMaxLength(100);
            entity.Property(e => e.TipoServicio).HasMaxLength(50);
        });

        modelBuilder.Entity<TipoRutina>(entity =>
        {
            entity.HasKey(e => e.IdTipoRutina).HasName("PK__TipoRuti__55C9CD78F168D142");

            entity.ToTable("TipoRutina");

            entity.Property(e => e.IdTipoRutina).HasColumnName("idTipoRutina");
            entity.Property(e => e.FechaDeCreacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeCreacion");
            entity.Property(e => e.FechaDeModificacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeModificacion");
            entity.Property(e => e.NombreTipoRutina)
                .HasMaxLength(100)
                .HasColumnName("nombreTipoRutina");
        });

        modelBuilder.Entity<UnidadesDeMedidum>(entity =>
        {
            entity.HasKey(e => e.UnidadDeMedidaId).HasName("PK__unidades__935D876DD487B38F");

            entity.ToTable("unidadesDeMedida");

            entity.Property(e => e.UnidadDeMedidaId).HasColumnName("unidadDeMedidaId");
            entity.Property(e => e.FechaDeRegistro)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("fechaDeRegistro");
            entity.Property(e => e.FechaModificacionDeRegistro)
                .HasColumnType("datetime")
                .HasColumnName("fechaModificacionDeRegistro");
            entity.Property(e => e.Nombre)
                .HasMaxLength(100)
                .HasColumnName("nombre");
        });

        modelBuilder.Entity<Usuario>(entity =>
        {
            entity.HasKey(e => e.UsuarioId).HasName("PK__Usuarios__2B3DE7981B26D7DC");

            entity.HasIndex(e => e.Telefono, "UQ__Usuarios__4EC5048011B00D5E").IsUnique();

            entity.HasIndex(e => e.NombreUsuario, "UQ__Usuarios__6B0F5AE04376F638").IsUnique();

            entity.HasIndex(e => e.Email, "UQ__Usuarios__A9D1053404A4BEF2").IsUnique();

            entity.Property(e => e.UsuarioId).HasColumnName("UsuarioID");
            entity.Property(e => e.Apellido).HasMaxLength(100);
            entity.Property(e => e.Contrasena).HasMaxLength(255);
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.Estado).HasMaxLength(50);
            entity.Property(e => e.FechaNacimiento).HasColumnType("date");
            entity.Property(e => e.FechaRegistro)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Nombre).HasMaxLength(100);
            entity.Property(e => e.NombreUsuario).HasMaxLength(50);
            entity.Property(e => e.RolId).HasColumnName("RolID");
            entity.Property(e => e.Telefono).HasMaxLength(15);

            entity.HasOne(d => d.Rol).WithMany(p => p.Usuarios)
                .HasForeignKey(d => d.RolId)
                .HasConstraintName("FK__Usuarios__RolID__3D5E1FD2");
        });

        // propiedades agregadas manualmente

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

        modelBuilder.Entity<DTO.Dtos.DTOEjerciciosYParametrosDelCliente>(entity =>
        {
            entity.HasNoKey();
            entity.Property(ep => ep.EjercicioId).HasColumnName("EjercicioId");
            entity.Property(ep => ep.NombreEjercicio).HasColumnName("NombreEjercicio");
            entity.Property(ep => ep.parametroMedicionId).HasColumnName("parametroMedicionId");
            entity.Property(ep => ep.nombreParametro).HasColumnName("nombreParametro");
        });

        modelBuilder.Entity<DTO.Dtos.DetalleDeClase>(entity =>
        {
            entity.HasNoKey();
            entity.Property(d => d.Duracion).HasColumnName("Duracion");
            entity.Property(d => d.NivelDeIntensidad).HasColumnName("NivelDeIntensidad");
            entity.Property(d => d.NivelDeDificultad).HasColumnName("NivelDeDificultad");
            entity.Property(d => d.DescripcionDeLaClase).HasColumnName("DescripcionDeLaClase");
            entity.Ignore(d => d.BeneficiosDeLaClase);
            entity.Ignore(d => d.EstructuraDeLaClase);
            entity.Ignore(d => d.EjerciciosDeClase);
            entity.Ignore(d => d.Consejos);
            entity.Ignore(d => d.EquipamientoRecomendado);
            entity.Ignore(d => d.HorariosProgramados);
        });

        modelBuilder.Entity<DTO.Dtos.DetalleDeClaseRaw>(entity =>
        {
            entity.HasNoKey();
            entity.Property(d => d.ClaseId).HasColumnName("claseId");
            entity.Property(d => d.NombreClase).HasColumnName("nombreClase");
            entity.Property(d => d.Duracion).HasColumnName("Duracion");
            entity.Property(d => d.NivelDeIntensidad).HasColumnName("NivelDeIntensidad");
            entity.Property(d => d.NivelDeDificultad).HasColumnName("NivelDeDificultad");
            entity.Property(d => d.DescripcionDeLaClase).HasColumnName("DescripcionDeLaClase");
            entity.Property(d => d.imagenesDeClase).HasColumnName("imagenesDeClase");
            entity.Property(d => d.BeneficiosDeLaClase).HasColumnName("BeneficiosDeLaClase");
            entity.Property(d => d.EstructuraDeLaClase).HasColumnName("EstructuraDeLaClase");
            entity.Property(d => d.EjerciciosDeClase).HasColumnName("EjerciciosDeClase");
            entity.Property(d => d.Consejos).HasColumnName("Consejos");
            entity.Property(d => d.EquipamientoRecomendado).HasColumnName("EquipamientoRecomendado");
            entity.Property(d => d.HorariosProgramados).HasColumnName("HorariosProgramados");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
