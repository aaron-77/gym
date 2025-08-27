using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DataAccess.Migrations
{
    /// <inheritdoc />
    public partial class IdentityInicial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            /* migrationBuilder.CreateTable( */
                name: "años",
                columns: table => new
                {
                    idAño = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    año = table.Column<int>(type: "int", nullable: false),
                    fechaCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__años__3E033B60DDD23740", x => x.idAño);
                });

            migrationBuilder.CreateTable(
                name: "AspNetRoles",
                columns: table => new
                {
                    Id = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    NormalizedName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUsers",
                columns: table => new
                {
                    Id = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    NombreCompleto = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    UserName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    NormalizedUserName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    Email = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    NormalizedEmail = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    EmailConfirmed = table.Column<bool>(type: "bit", nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    SecurityStamp = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PhoneNumberConfirmed = table.Column<bool>(type: "bit", nullable: false),
                    TwoFactorEnabled = table.Column<bool>(type: "bit", nullable: false),
                    LockoutEnd = table.Column<DateTimeOffset>(type: "datetimeoffset", nullable: true),
                    LockoutEnabled = table.Column<bool>(type: "bit", nullable: false),
                    AccessFailedCount = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUsers", x => x.Id);
                });
/* 
            migrationBuilder.CreateTable(
                name: "citaSP",
                columns: table => new
                {
                    FechaHora = table.Column<DateTime>(type: "datetime2", nullable: false),
                    FechaHoraFin = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UsuarioID = table.Column<int>(type: "int", nullable: false),
                    EntrenadorID = table.Column<int>(type: "int", nullable: false),
                    TipoCita = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Estado = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CitaID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "correosSP",
                columns: table => new
                {
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    FechaHora = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "Descuentos",
                columns: table => new
                {
                    DescuentoID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Porcentaje = table.Column<decimal>(type: "decimal(5,2)", nullable: false),
                    Descripcion = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    FechaInicio = table.Column<DateTime>(type: "datetime", nullable: false),
                    FechaFin = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Descuent__0C2C1138689BA8C4", x => x.DescuentoID);
                });

            migrationBuilder.CreateTable(
                name: "detalleDeClaseRawSP",
                columns: table => new
                {
                    claseId = table.Column<int>(type: "int", nullable: false),
                    nombreClase = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Duracion = table.Column<int>(type: "int", nullable: false),
                    NivelDeIntensidad = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    NivelDeDificultad = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DescripcionDeLaClase = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    imagenesDeClase = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    BeneficiosDeLaClase = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    EstructuraDeLaClase = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    EjerciciosDeClase = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Consejos = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    EquipamientoRecomendado = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    HorariosProgramados = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "diasDeLaSemana",
                columns: table => new
                {
                    idDia = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombreDia = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    FechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    Activo = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((1))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__diasDeLa__3E416597E1AE4B2B", x => x.idDia);
                });

            migrationBuilder.CreateTable(
                name: "DTOClasesProgramadaView",
                columns: table => new
                {
                    idClaseProgramada = table.Column<int>(type: "int", nullable: false),
                    fkClase = table.Column<int>(type: "int", nullable: false),
                    fechaDeLaClase = table.Column<DateTime>(type: "datetime2", nullable: false),
                    idHora = table.Column<int>(type: "int", nullable: false),
                    horaInicio = table.Column<TimeSpan>(type: "time", nullable: false),
                    horaFin = table.Column<TimeSpan>(type: "time", nullable: false),
                    labelHorario = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    fkEntrenador = table.Column<int>(type: "int", nullable: false),
                    nombreEntrenador = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    cupoMaximo = table.Column<int>(type: "int", nullable: false),
                    cupoDisponible = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "duracionCitas",
                columns: table => new
                {
                    DuracionID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Duracion = table.Column<int>(type: "int", nullable: false),
                    FrecuenciaNotificaciones = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__duracion__3B2C07DA2413E2C8", x => x.DuracionID);
                });

            migrationBuilder.CreateTable(
                name: "ejercicioSP",
                columns: table => new
                {
                    EjercicioID = table.Column<int>(type: "int", nullable: false),
                    NombreEjercicio = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    TipoEjercicio = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Descripcion = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "ejerciciosYParametrosDelClienteSP",
                columns: table => new
                {
                    EjercicioId = table.Column<int>(type: "int", nullable: true),
                    NombreEjercicio = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    parametroMedicionId = table.Column<int>(type: "int", nullable: false),
                    nombreParametro = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "estadosClasesProgramadas",
                columns: table => new
                {
                    idEstadoClaseProgramada = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombresEstado = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    fechaCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__estadosC__C0C65CED53670AA4", x => x.idEstadoClaseProgramada);
                });

            migrationBuilder.CreateTable(
                name: "estadosDeClases",
                columns: table => new
                {
                    idEstadoClase = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombreEstado = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    descripcionEstado = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    fechaCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__estadosD__A4F595D46615EEBC", x => x.idEstadoClase);
                });

            migrationBuilder.CreateTable(
                name: "estadosInscripciones",
                columns: table => new
                {
                    idEstadoInscripcion = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombreEstadoInscripcion = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    fechaCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__estadosI__5CD68FF4850AB16F", x => x.idEstadoInscripcion);
                });

            migrationBuilder.CreateTable(
                name: "FN_ObtenerClases",
                columns: table => new
                {
                    ClaseID = table.Column<int>(type: "int", nullable: false),
                    NombreClase = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "horasLaborales",
                columns: table => new
                {
                    idHora = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    horaInicio = table.Column<TimeSpan>(type: "time", nullable: false),
                    horaFin = table.Column<TimeSpan>(type: "time", nullable: false),
                    fechaCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__horasLab__770403DB6FE2950B", x => x.idHora);
                });

            migrationBuilder.CreateTable(
                name: "iconsForParameters",
                columns: table => new
                {
                    iconId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombre = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    urlPrivada = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    urlPublica = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__iconsFor__5CE3968F35DA5BE8", x => x.iconId);
                });

            migrationBuilder.CreateTable(
                name: "intenciones",
                columns: table => new
                {
                    intencionId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombre = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    fechaDeRegistro = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    fechaModificacionDeRegistro = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__intencio__41F5EC2340AE7FEA", x => x.intencionId);
                });

            migrationBuilder.CreateTable(
                name: "LogErrores",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    procedimiento = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    mensaje = table.Column<string>(type: "nvarchar(4000)", maxLength: 4000, nullable: false),
                    severidad = table.Column<int>(type: "int", nullable: false),
                    estado = table.Column<int>(type: "int", nullable: false),
                    fecha = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    usuario = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true, defaultValueSql: "(suser_name())"),
                    host = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true, defaultValueSql: "(host_name())"),
                    aplicacion = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true, defaultValueSql: "(app_name())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__LogError__3213E83F2E02FD9A", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "nivelesDeDificultadDeClase",
                columns: table => new
                {
                    idNivelDeDificultadDeClase = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombreNivelDeDificultad = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    fechaDeCreacion = table.Column<DateTime>(type: "datetime", nullable: true),
                    fechaDeModificacion = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__nivelesD__86F5BA39539AB17D", x => x.idNivelDeDificultadDeClase);
                });

            migrationBuilder.CreateTable(
                name: "nivelesDeIntensidadDeClase",
                columns: table => new
                {
                    idNivelDeIntensidad = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombreNivelDeIntensidad = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    fechaDeCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__nivelesD__6F6E9594C607DCB8", x => x.idNivelDeIntensidad);
                });

            migrationBuilder.CreateTable(
                name: "nivelesDeLogro",
                columns: table => new
                {
                    idNivelDeLogro = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombre = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    fechaDeRegistro = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    fechaModificacionDeRegistro = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__nivelesD__0A5FC0796013EA3F", x => x.idNivelDeLogro);
                });

            migrationBuilder.CreateTable(
                name: "parametrosDeMedicionSP",
                columns: table => new
                {
                    parametroMedicionId = table.Column<int>(type: "int", nullable: false),
                    nombre = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    fkUnidadDeMedida = table.Column<int>(type: "int", nullable: false),
                    nombreUnidadDeMedida = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    fkIcon = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    RolID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NombreRol = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Roles__F92302D1C65ABB7F", x => x.RolID);
                });

            migrationBuilder.CreateTable(
                name: "rutinaSP",
                columns: table => new
                {
                    RutinaId = table.Column<int>(type: "int", nullable: true),
                    UsuarioID = table.Column<int>(type: "int", nullable: false),
                    EntrenadorID = table.Column<int>(type: "int", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Observaciones = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "Servicios",
                columns: table => new
                {
                    ServicioID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NombreServicio = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Descripcion = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    TipoServicio = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Costo = table.Column<decimal>(type: "decimal(10,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Servicio__D5AEEC221B5A2D82", x => x.ServicioID);
                });

            migrationBuilder.CreateTable(
                name: "TipoRutina",
                columns: table => new
                {
                    idTipoRutina = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombreTipoRutina = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    fechaDeCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fechaDeModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__TipoRuti__55C9CD78F168D142", x => x.idTipoRutina);
                });

            migrationBuilder.CreateTable(
                name: "ultimasMedidasDeParametroSP",
                columns: table => new
                {
                    medidaId = table.Column<int>(type: "int", nullable: false),
                    fkParametro = table.Column<int>(type: "int", nullable: false),
                    nombreParametro = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    valor = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    fechaDeCreacion = table.Column<DateTime>(type: "datetime2", nullable: false),
                    unidadDeMedidaId = table.Column<int>(type: "int", nullable: false),
                    nombreUnidadDeMedida = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    fkEjercicio = table.Column<int>(type: "int", nullable: true),
                    nombreEjercicio = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    urlIconoParametro = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    urlIconoEjercicio = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    fkUsuario = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "ultimasMetasDeParametroSP",
                columns: table => new
                {
                    metaId = table.Column<int>(type: "int", nullable: false),
                    intencion = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    nombreParametro = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    nombreEjercicio = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    valorObjetivo = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    nombreNivelDeLogro = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    fechaDeInicioDeLaMeta = table.Column<DateTime>(type: "datetime2", nullable: false),
                    fechaLimite = table.Column<DateTime>(type: "datetime2", nullable: false),
                    fkEjercicio = table.Column<int>(type: "int", nullable: true),
                    fkParametro = table.Column<int>(type: "int", nullable: false),
                    fkUsuario = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "unidadesDeMedida",
                columns: table => new
                {
                    unidadDeMedidaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombre = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    fechaDeRegistro = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    fechaModificacionDeRegistro = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__unidades__935D876DD487B38F", x => x.unidadDeMedidaId);
                });

            migrationBuilder.CreateTable(
                name: "userSP",
                columns: table => new
                {
                    UsuarioID = table.Column<int>(type: "int", nullable: false),
                    Nombre = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Apellido = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Telefono = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    FechaNacimiento = table.Column<DateTime>(type: "datetime2", nullable: false),
                    FechaRegistro = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                });
 */
            migrationBuilder.CreateTable(
                name: "AspNetRoleClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RoleId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ClaimType = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ClaimValue = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoleClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ClaimType = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ClaimValue = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserLogins",
                columns: table => new
                {
                    LoginProvider = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ProviderKey = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ProviderDisplayName = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserLogins", x => new { x.LoginProvider, x.ProviderKey });
                    table.ForeignKey(
                        name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserRoles",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    RoleId = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserRoles", x => new { x.UserId, x.RoleId });
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserTokens",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    LoginProvider = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Value = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserTokens", x => new { x.UserId, x.LoginProvider, x.Name });
                    table.ForeignKey(
                        name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });
/* 
            migrationBuilder.CreateTable(
                name: "Cupones",
                columns: table => new
                {
                    CuponID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Codigo = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    DescuentoID = table.Column<int>(type: "int", nullable: true),
                    FechaExpiracion = table.Column<DateTime>(type: "datetime", nullable: false),
                    Estado = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Cupones__C43568B78A3A377F", x => x.CuponID);
                    table.ForeignKey(
                        name: "FK__Cupones__Descuen__6B24EA82",
                        column: x => x.DescuentoID,
                        principalTable: "Descuentos",
                        principalColumn: "DescuentoID");
                });

            migrationBuilder.CreateTable(
                name: "diasDeLaSemana_horasLaborales",
                columns: table => new
                {
                    idHorarioLaboral = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkDiaDeLaSemana = table.Column<int>(type: "int", nullable: false),
                    fkHoraLaboral = table.Column<int>(type: "int", nullable: false),
                    fkAño = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__diasDeLa__AC96C3A6A1255770", x => x.idHorarioLaboral);
                    table.ForeignKey(
                        name: "FK_diasDeLaSemana_horasLaborales_años",
                        column: x => x.fkAño,
                        principalTable: "años",
                        principalColumn: "idAño");
                    table.ForeignKey(
                        name: "FK_diasDeLaSemana_horasLaborales_diasDeLaSemana",
                        column: x => x.fkDiaDeLaSemana,
                        principalTable: "diasDeLaSemana",
                        principalColumn: "idDia");
                    table.ForeignKey(
                        name: "FK_diasDeLaSemana_horasLaborales_horasLaborales",
                        column: x => x.fkHoraLaboral,
                        principalTable: "horasLaborales",
                        principalColumn: "idHora");
                });

            migrationBuilder.CreateTable(
                name: "Ejercicios",
                columns: table => new
                {
                    EjercicioID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NombreEjercicio = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    TipoEjercicio = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Descripcion = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    fkIcon = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Ejercici__812226A1579B3B09", x => x.EjercicioID);
                    table.ForeignKey(
                        name: "fk_ejercicios_iconsForParameters",
                        column: x => x.fkIcon,
                        principalTable: "iconsForParameters",
                        principalColumn: "iconId");
                });

            migrationBuilder.CreateTable(
                name: "Equipos",
                columns: table => new
                {
                    EquipoID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NombreEquipo = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Descripcion = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    fkIcon = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Equipos__DE8A0BFFA22BEA11", x => x.EquipoID);
                    table.ForeignKey(
                        name: "FK_Equipos_iconsForParameters",
                        column: x => x.fkIcon,
                        principalTable: "iconsForParameters",
                        principalColumn: "iconId");
                });

            migrationBuilder.CreateTable(
                name: "parametrosDeMedicion",
                columns: table => new
                {
                    parametroMedicionId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombre = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    fechaDeRegistro = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    fechaModificacionDeRegistro = table.Column<DateTime>(type: "datetime", nullable: true),
                    fkIcon = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__parametr__FE4B91C8ECDB659E", x => x.parametroMedicionId);
                    table.ForeignKey(
                        name: "fk_parametrosDeMedicion_iconsForParameters",
                        column: x => x.fkIcon,
                        principalTable: "iconsForParameters",
                        principalColumn: "iconId");
                });

            migrationBuilder.CreateTable(
                name: "Usuarios",
                columns: table => new
                {
                    UsuarioID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Nombre = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Apellido = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Telefono = table.Column<string>(type: "nvarchar(15)", maxLength: 15, nullable: false),
                    NombreUsuario = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Contrasena = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    FechaNacimiento = table.Column<DateTime>(type: "date", nullable: false),
                    FechaRegistro = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    RolID = table.Column<int>(type: "int", nullable: true),
                    Estado = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Usuarios__2B3DE7981B26D7DC", x => x.UsuarioID);
                    table.ForeignKey(
                        name: "FK__Usuarios__RolID__3D5E1FD2",
                        column: x => x.RolID,
                        principalTable: "Roles",
                        principalColumn: "RolID");
                });

            migrationBuilder.CreateTable(
                name: "imagesForExercises",
                columns: table => new
                {
                    idImage = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkEjercicio = table.Column<int>(type: "int", nullable: false),
                    nombreParaElFront = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    urlPrivada = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    urlPublica = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__imagesFo__84D649AFC118D1B7", x => x.idImage);
                    table.ForeignKey(
                        name: "FK_ImagesForExercises_Ejercicio",
                        column: x => x.fkEjercicio,
                        principalTable: "Ejercicios",
                        principalColumn: "EjercicioID");
                });

            migrationBuilder.CreateTable(
                name: "EjercicioEquipos",
                columns: table => new
                {
                    EjercicioEquipoID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    EjercicioID = table.Column<int>(type: "int", nullable: true),
                    EquipoID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Ejercici__A8CC48FDB85B7151", x => x.EjercicioEquipoID);
                    table.ForeignKey(
                        name: "FK__Ejercicio__Ejerc__571DF1D5",
                        column: x => x.EjercicioID,
                        principalTable: "Ejercicios",
                        principalColumn: "EjercicioID");
                    table.ForeignKey(
                        name: "FK__Ejercicio__Equip__5812160E",
                        column: x => x.EquipoID,
                        principalTable: "Equipos",
                        principalColumn: "EquipoID");
                });

            migrationBuilder.CreateTable(
                name: "ejercicios_parametrosDeMedicion",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkEjercicio = table.Column<int>(type: "int", nullable: false),
                    fkParametro = table.Column<int>(type: "int", nullable: false),
                    fechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    fechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__ejercici__3213E83FF0FCCAAC", x => x.id);
                    table.ForeignKey(
                        name: "FK_ejercicios_parametrosDeMedicion_Ejercicios",
                        column: x => x.fkEjercicio,
                        principalTable: "Ejercicios",
                        principalColumn: "EjercicioID");
                    table.ForeignKey(
                        name: "FK_ejercicios_parametrosDeMedicion_parametrosDeMedicion",
                        column: x => x.fkParametro,
                        principalTable: "parametrosDeMedicion",
                        principalColumn: "parametroMedicionId");
                });

            migrationBuilder.CreateTable(
                name: "parametros_unidadesDeMedida",
                columns: table => new
                {
                    fkParametroDeMedicion = table.Column<int>(type: "int", nullable: false),
                    fkUnidadDeMedida = table.Column<int>(type: "int", nullable: false),
                    fechaDeRegistro = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Parametr__44945C4A9DEF7EB4", x => new { x.fkParametroDeMedicion, x.fkUnidadDeMedida });
                    table.ForeignKey(
                        name: "FK__Parametro__fkPar__4924D839",
                        column: x => x.fkParametroDeMedicion,
                        principalTable: "parametrosDeMedicion",
                        principalColumn: "parametroMedicionId");
                    table.ForeignKey(
                        name: "FK__Parametro__fkUni__4A18FC72",
                        column: x => x.fkUnidadDeMedida,
                        principalTable: "unidadesDeMedida",
                        principalColumn: "unidadDeMedidaId");
                });

            migrationBuilder.CreateTable(
                name: "Citas",
                columns: table => new
                {
                    CitaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UsuarioID = table.Column<int>(type: "int", nullable: true),
                    EntrenadorID = table.Column<int>(type: "int", nullable: true),
                    FechaHora = table.Column<DateTime>(type: "datetime", nullable: false),
                    TipoCita = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Estado = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FechaHoraFin = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Citas__F0E2D9F2556E9C13", x => x.CitaID);
                    table.ForeignKey(
                        name: "FK__Citas__Entrenado__44FF419A",
                        column: x => x.EntrenadorID,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioID");
                    table.ForeignKey(
                        name: "FK__Citas__UsuarioID__440B1D61",
                        column: x => x.UsuarioID,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioID");
                });

            migrationBuilder.CreateTable(
                name: "Clases",
                columns: table => new
                {
                    ClaseID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NombreClase = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    InstructorID = table.Column<int>(type: "int", nullable: true),
                    Cupo = table.Column<int>(type: "int", nullable: false),
                    Descripcion = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    duracionEnMinutos = table.Column<int>(type: "int", nullable: true),
                    fkIntensidad = table.Column<int>(type: "int", nullable: true),
                    fkDificultad = table.Column<int>(type: "int", nullable: true),
                    tiempoDeDescansoEnMinutos = table.Column<int>(type: "int", nullable: false, defaultValueSql: "((15))"),
                    duracionEnMinutosConDescansoIncluido = table.Column<int>(type: "int", nullable: false, defaultValueSql: "((60))"),
                    fkEstadoClase = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Clases__F54296B30E7E66FD", x => x.ClaseID);
                    table.ForeignKey(
                        name: "FK_Clases_Dificultad",
                        column: x => x.fkDificultad,
                        principalTable: "nivelesDeDificultadDeClase",
                        principalColumn: "idNivelDeDificultadDeClase");
                    table.ForeignKey(
                        name: "FK_Clases_Intensidad",
                        column: x => x.fkIntensidad,
                        principalTable: "nivelesDeIntensidadDeClase",
                        principalColumn: "idNivelDeIntensidad");
                    table.ForeignKey(
                        name: "FK_Clases_estadosDeClases",
                        column: x => x.fkEstadoClase,
                        principalTable: "estadosDeClases",
                        principalColumn: "idEstadoClase");
                    table.ForeignKey(
                        name: "FK__Clases__Instruct__5AEE82B9",
                        column: x => x.InstructorID,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioID");
                });

            migrationBuilder.CreateTable(
                name: "medidas",
                columns: table => new
                {
                    medidaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkUsuario = table.Column<int>(type: "int", nullable: false),
                    fechaDeCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fkParametro = table.Column<int>(type: "int", nullable: true),
                    valor = table.Column<decimal>(type: "decimal(10,2)", nullable: true),
                    fkEjercicio = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__medidas__1C299EFA6221D68B", x => x.medidaId);
                    table.ForeignKey(
                        name: "FK_UsuarioMedida",
                        column: x => x.fkUsuario,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioID");
                    table.ForeignKey(
                        name: "fk_medidas_ejercicios",
                        column: x => x.fkEjercicio,
                        principalTable: "Ejercicios",
                        principalColumn: "EjercicioID");
                    table.ForeignKey(
                        name: "fk_medidas_parametros",
                        column: x => x.fkParametro,
                        principalTable: "parametrosDeMedicion",
                        principalColumn: "parametroMedicionId");
                });

            migrationBuilder.CreateTable(
                name: "metas",
                columns: table => new
                {
                    metaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkUsuario = table.Column<int>(type: "int", nullable: false),
                    fkIntencion = table.Column<int>(type: "int", nullable: false),
                    fkParametro = table.Column<int>(type: "int", nullable: false),
                    fkEjercicio = table.Column<int>(type: "int", nullable: true),
                    valorObjetivo = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    fechaDeInicioDeLaMeta = table.Column<DateTime>(type: "datetime", nullable: false),
                    fechaLimite = table.Column<DateTime>(type: "datetime", nullable: false),
                    fechaDeRegistro = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    fechaDeModificacionDeRegistro = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fkNivelDeLogro = table.Column<int>(type: "int", nullable: false, defaultValueSql: "((1))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__metas__8189FF8C363B9BB4", x => x.metaId);
                    table.ForeignKey(
                        name: "FK_Metas_Ejercicios",
                        column: x => x.fkEjercicio,
                        principalTable: "Ejercicios",
                        principalColumn: "EjercicioID");
                    table.ForeignKey(
                        name: "FK_Metas_Intenciones",
                        column: x => x.fkIntencion,
                        principalTable: "intenciones",
                        principalColumn: "intencionId");
                    table.ForeignKey(
                        name: "FK_Metas_Parametros",
                        column: x => x.fkParametro,
                        principalTable: "parametrosDeMedicion",
                        principalColumn: "parametroMedicionId");
                    table.ForeignKey(
                        name: "FK_Metas_Usuarios",
                        column: x => x.fkUsuario,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioID");
                    table.ForeignKey(
                        name: "fk_metas_nivelesDeLogro",
                        column: x => x.fkNivelDeLogro,
                        principalTable: "nivelesDeLogro",
                        principalColumn: "idNivelDeLogro");
                });

            migrationBuilder.CreateTable(
                name: "Pagos",
                columns: table => new
                {
                    PagoID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UsuarioID = table.Column<int>(type: "int", nullable: true),
                    Monto = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    FechaPago = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    MetodoPago = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Estado = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Pagos__F00B6158C2211D16", x => x.PagoID);
                    table.ForeignKey(
                        name: "FK__Pagos__UsuarioID__6383C8BA",
                        column: x => x.UsuarioID,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioID");
                });

            migrationBuilder.CreateTable(
                name: "beneficiosDeClase",
                columns: table => new
                {
                    idBeneficio = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkClase = table.Column<int>(type: "int", nullable: false),
                    beneficio = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    fechaDeCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fechaDeModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fkIcon = table.Column<int>(type: "int", nullable: true),
                    descripcionBeneficio = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__benefici__00AAC26A2D2E6E7C", x => x.idBeneficio);
                    table.ForeignKey(
                        name: "FK_Beneficio_Clase",
                        column: x => x.fkClase,
                        principalTable: "Clases",
                        principalColumn: "ClaseID");
                    table.ForeignKey(
                        name: "FK_iconsForParameters_beneficios_del_clase",
                        column: x => x.fkIcon,
                        principalTable: "iconsForParameters",
                        principalColumn: "iconId");
                });

            migrationBuilder.CreateTable(
                name: "clasesProgramadas",
                columns: table => new
                {
                    idProgramacionClase = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkClase = table.Column<int>(type: "int", nullable: false),
                    fechaInicio = table.Column<DateTime>(type: "datetime", nullable: false),
                    fechaFin = table.Column<DateTime>(type: "datetime", nullable: false),
                    fkEntrenador = table.Column<int>(type: "int", nullable: false),
                    cupoMaximo = table.Column<int>(type: "int", nullable: false),
                    fkEstadoClaseProgramada = table.Column<int>(type: "int", nullable: false, comment: "los estados seran: disponible,no disponible,cancelada"),
                    fechaCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__clasesPr__712E87EE8D30E7B0", x => x.idProgramacionClase);
                    table.ForeignKey(
                        name: "FK_ClasesProgramadas_Clase",
                        column: x => x.fkClase,
                        principalTable: "Clases",
                        principalColumn: "ClaseID");
                    table.ForeignKey(
                        name: "FK_ClasesProgramadas_EstadoClaseProgramada",
                        column: x => x.fkEstadoClaseProgramada,
                        principalTable: "estadosClasesProgramadas",
                        principalColumn: "idEstadoClaseProgramada");
                    table.ForeignKey(
                        name: "FK_ClasesProgramadas_Usuarios",
                        column: x => x.fkEntrenador,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioID");
                });

            migrationBuilder.CreateTable(
                name: "consejosParaLasClases",
                columns: table => new
                {
                    idConsejo = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkClase = table.Column<int>(type: "int", nullable: true),
                    fkEjercicio = table.Column<int>(type: "int", nullable: true),
                    introduccionDeConsejo = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    consejos = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__consejos__3DB777ADDB7A6091", x => x.idConsejo);
                    table.ForeignKey(
                        name: "FK_Consejos_Clase",
                        column: x => x.fkClase,
                        principalTable: "Clases",
                        principalColumn: "ClaseID",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_Consejos_Ejercicio",
                        column: x => x.fkEjercicio,
                        principalTable: "Ejercicios",
                        principalColumn: "EjercicioID",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateTable(
                name: "estructuraDeClase",
                columns: table => new
                {
                    idBloque = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkClase = table.Column<int>(type: "int", nullable: false),
                    numeroConsecutivoDelBloque = table.Column<int>(type: "int", nullable: false),
                    duracionMenorEnMinutos = table.Column<int>(type: "int", nullable: false),
                    duracionMayorEnMinutos = table.Column<int>(type: "int", nullable: false),
                    tituloBloque = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    descripcionBloque = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    fechaDeCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fechaDeModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__estructu__EF4379A8928D581A", x => x.idBloque);
                    table.ForeignKey(
                        name: "FK_Estructura_Clase",
                        column: x => x.fkClase,
                        principalTable: "Clases",
                        principalColumn: "ClaseID");
                });

            migrationBuilder.CreateTable(
                name: "imagesForClases",
                columns: table => new
                {
                    idClassImage = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkClase = table.Column<int>(type: "int", nullable: false),
                    urlParaBanner = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    urlParaParaDescripcionDeClase = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    urlParaBloqueConsejos = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    FechaDeCreacion = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    FechaDeModificacion = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__imagesFo__F0634AEDFB54D109", x => x.idClassImage);
                    table.ForeignKey(
                        name: "FK_imagesForClases_Clases",
                        column: x => x.fkClase,
                        principalTable: "Clases",
                        principalColumn: "ClaseID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Rutinas",
                columns: table => new
                {
                    RutinaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UsuarioID = table.Column<int>(type: "int", nullable: true),
                    EntrenadorID = table.Column<int>(type: "int", nullable: true),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    Observaciones = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    fkClase = table.Column<int>(type: "int", nullable: true),
                    fkTipoRutina = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Rutinas__E76E165A11753A49", x => x.RutinaID);
                    table.ForeignKey(
                        name: "FK_Rutinas_Clases",
                        column: x => x.fkClase,
                        principalTable: "Clases",
                        principalColumn: "ClaseID");
                    table.ForeignKey(
                        name: "FK_Rutinas_TipoRutina",
                        column: x => x.fkTipoRutina,
                        principalTable: "TipoRutina",
                        principalColumn: "idTipoRutina");
                    table.ForeignKey(
                        name: "FK__Rutinas__Entrena__4AB81AF0",
                        column: x => x.EntrenadorID,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioID");
                    table.ForeignKey(
                        name: "FK__Rutinas__Usuario__49C3F6B7",
                        column: x => x.UsuarioID,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioID");
                });

            migrationBuilder.CreateTable(
                name: "horariosDeClasesProgramadas",
                columns: table => new
                {
                    idHorarioDeClaseProgramada = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkClaseProgramada = table.Column<int>(type: "int", nullable: false),
                    fkHorarioLaboral = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__horarios__873B1A4EFA42A731", x => x.idHorarioDeClaseProgramada);
                    table.ForeignKey(
                        name: "FK_horariosDeClasesProgramadas_clasesProgramadas",
                        column: x => x.fkClaseProgramada,
                        principalTable: "clasesProgramadas",
                        principalColumn: "idProgramacionClase");
                    table.ForeignKey(
                        name: "FK_horariosDeClasesProgramadas_diasDeLaSemana_horasLaborales",
                        column: x => x.fkHorarioLaboral,
                        principalTable: "diasDeLaSemana_horasLaborales",
                        principalColumn: "idHorarioLaboral");
                });

            migrationBuilder.CreateTable(
                name: "inscripcionesDeClases",
                columns: table => new
                {
                    idInscripcion = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkCliente = table.Column<int>(type: "int", nullable: false),
                    fkProgramacionClase = table.Column<int>(type: "int", nullable: false),
                    fechaDeInscripcion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fkEstadoInscripcion = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__inscripc__3D58AB69B61D8617", x => x.idInscripcion);
                    table.ForeignKey(
                        name: "FK_InscripcionesDeClases_Cliente",
                        column: x => x.fkCliente,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioID");
                    table.ForeignKey(
                        name: "FK_InscripcionesDeClases_EstadoInscripcion",
                        column: x => x.fkEstadoInscripcion,
                        principalTable: "estadosInscripciones",
                        principalColumn: "idEstadoInscripcion");
                    table.ForeignKey(
                        name: "FK_InscripcionesDeClases_ProgramacionClase",
                        column: x => x.fkProgramacionClase,
                        principalTable: "clasesProgramadas",
                        principalColumn: "idProgramacionClase");
                });

            migrationBuilder.CreateTable(
                name: "RegistrosEntrenamiento",
                columns: table => new
                {
                    RegistroID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UsuarioID = table.Column<int>(type: "int", nullable: true),
                    RutinaID = table.Column<int>(type: "int", nullable: true),
                    FechaRegistro = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Registro__B897313EAB9C2539", x => x.RegistroID);
                    table.ForeignKey(
                        name: "FK__Registros__Rutin__6FE99F9F",
                        column: x => x.RutinaID,
                        principalTable: "Rutinas",
                        principalColumn: "RutinaID");
                    table.ForeignKey(
                        name: "FK__Registros__Usuar__6EF57B66",
                        column: x => x.UsuarioID,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioID");
                });

            migrationBuilder.CreateTable(
                name: "RutinaEjercicios",
                columns: table => new
                {
                    RutinaEjercicioID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RutinaID = table.Column<int>(type: "int", nullable: true),
                    EjercicioID = table.Column<int>(type: "int", nullable: true),
                    Sets = table.Column<int>(type: "int", nullable: true),
                    Repeticiones = table.Column<int>(type: "int", nullable: true),
                    Peso = table.Column<decimal>(type: "decimal(5,2)", nullable: true),
                    Tiempo = table.Column<int>(type: "int", nullable: true),
                    MetaRepeticiones = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__RutinaEj__56420023FA3B532E", x => x.RutinaEjercicioID);
                    table.ForeignKey(
                        name: "FK__RutinaEje__Ejerc__52593CB8",
                        column: x => x.EjercicioID,
                        principalTable: "Ejercicios",
                        principalColumn: "EjercicioID");
                    table.ForeignKey(
                        name: "FK__RutinaEje__Rutin__5165187F",
                        column: x => x.RutinaID,
                        principalTable: "Rutinas",
                        principalColumn: "RutinaID");
                });

            migrationBuilder.CreateTable(
                name: "preReservasDeHorario",
                columns: table => new
                {
                    idPreReserva = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkHorarioClaseProgramada = table.Column<int>(type: "int", nullable: false),
                    fechaInicioDeLaReserva = table.Column<DateTime>(type: "datetime", nullable: false),
                    fechaDeExpiracionDeLaReserva = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__preReser__0FAC6FC5DD04E13F", x => x.idPreReserva);
                    table.ForeignKey(
                        name: "FK_preReservasDeHorario_horariosClasesProgramadas",
                        column: x => x.fkHorarioClaseProgramada,
                        principalTable: "horariosDeClasesProgramadas",
                        principalColumn: "idHorarioDeClaseProgramada");
                });

            migrationBuilder.CreateTable(
                name: "DetalleEntrenamiento",
                columns: table => new
                {
                    DetalleID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RegistroID = table.Column<int>(type: "int", nullable: true),
                    EjercicioID = table.Column<int>(type: "int", nullable: true),
                    Sets = table.Column<int>(type: "int", nullable: true),
                    Repeticiones = table.Column<int>(type: "int", nullable: true),
                    Peso = table.Column<decimal>(type: "decimal(5,2)", nullable: true),
                    Tiempo = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__DetalleE__6E19D6FA406B23BB", x => x.DetalleID);
                    table.ForeignKey(
                        name: "FK__DetalleEn__Ejerc__74AE54BC",
                        column: x => x.EjercicioID,
                        principalTable: "Ejercicios",
                        principalColumn: "EjercicioID");
                    table.ForeignKey(
                        name: "FK__DetalleEn__Regis__73BA3083",
                        column: x => x.RegistroID,
                        principalTable: "RegistrosEntrenamiento",
                        principalColumn: "RegistroID");
                });
 */
            migrationBuilder.CreateIndex(
                name: "IX_AspNetRoleClaims_RoleId",
                table: "AspNetRoleClaims",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "RoleNameIndex",
                table: "AspNetRoles",
                column: "NormalizedName",
                unique: true,
                filter: "[NormalizedName] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserClaims_UserId",
                table: "AspNetUserClaims",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserLogins_UserId",
                table: "AspNetUserLogins",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "EmailIndex",
                table: "AspNetUsers",
                column: "NormalizedEmail");

            migrationBuilder.CreateIndex(
                name: "UserNameIndex",
                table: "AspNetUsers",
                column: "NormalizedUserName",
                unique: true,
                filter: "[NormalizedUserName] IS NOT NULL");

/*             migrationBuilder.CreateIndex(
                name: "IX_beneficiosDeClase_fkClase",
                table: "beneficiosDeClase",
                column: "fkClase");

            migrationBuilder.CreateIndex(
                name: "IX_beneficiosDeClase_fkIcon",
                table: "beneficiosDeClase",
                column: "fkIcon");

            migrationBuilder.CreateIndex(
                name: "IX_Citas_EntrenadorID",
                table: "Citas",
                column: "EntrenadorID");

            migrationBuilder.CreateIndex(
                name: "IX_Citas_UsuarioID",
                table: "Citas",
                column: "UsuarioID");

            migrationBuilder.CreateIndex(
                name: "IX_Clases_fkDificultad",
                table: "Clases",
                column: "fkDificultad");

            migrationBuilder.CreateIndex(
                name: "IX_Clases_fkEstadoClase",
                table: "Clases",
                column: "fkEstadoClase");

            migrationBuilder.CreateIndex(
                name: "IX_Clases_fkIntensidad",
                table: "Clases",
                column: "fkIntensidad");

            migrationBuilder.CreateIndex(
                name: "IX_Clases_InstructorID",
                table: "Clases",
                column: "InstructorID");

            migrationBuilder.CreateIndex(
                name: "IX_clasesProgramadas_fkClase",
                table: "clasesProgramadas",
                column: "fkClase");

            migrationBuilder.CreateIndex(
                name: "IX_clasesProgramadas_fkEntrenador",
                table: "clasesProgramadas",
                column: "fkEntrenador");

            migrationBuilder.CreateIndex(
                name: "IX_clasesProgramadas_fkEstadoClaseProgramada",
                table: "clasesProgramadas",
                column: "fkEstadoClaseProgramada");

            migrationBuilder.CreateIndex(
                name: "IX_consejosParaLasClases_fkClase",
                table: "consejosParaLasClases",
                column: "fkClase");

            migrationBuilder.CreateIndex(
                name: "IX_consejosParaLasClases_fkEjercicio",
                table: "consejosParaLasClases",
                column: "fkEjercicio");

            migrationBuilder.CreateIndex(
                name: "IX_Cupones_DescuentoID",
                table: "Cupones",
                column: "DescuentoID");

            migrationBuilder.CreateIndex(
                name: "IX_DetalleEntrenamiento_EjercicioID",
                table: "DetalleEntrenamiento",
                column: "EjercicioID");

            migrationBuilder.CreateIndex(
                name: "IX_DetalleEntrenamiento_RegistroID",
                table: "DetalleEntrenamiento",
                column: "RegistroID");

            migrationBuilder.CreateIndex(
                name: "IX_diasDeLaSemana_horasLaborales_fkAño",
                table: "diasDeLaSemana_horasLaborales",
                column: "fkAño");

            migrationBuilder.CreateIndex(
                name: "IX_diasDeLaSemana_horasLaborales_fkHoraLaboral",
                table: "diasDeLaSemana_horasLaborales",
                column: "fkHoraLaboral");

            migrationBuilder.CreateIndex(
                name: "UQ_diasDeLaSemana_horasLaborales_Compuesto",
                table: "diasDeLaSemana_horasLaborales",
                columns: new[] { "fkDiaDeLaSemana", "fkHoraLaboral", "fkAño" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_EjercicioEquipos_EjercicioID",
                table: "EjercicioEquipos",
                column: "EjercicioID");

            migrationBuilder.CreateIndex(
                name: "IX_EjercicioEquipos_EquipoID",
                table: "EjercicioEquipos",
                column: "EquipoID");

            migrationBuilder.CreateIndex(
                name: "IX_Ejercicios_fkIcon",
                table: "Ejercicios",
                column: "fkIcon");

            migrationBuilder.CreateIndex(
                name: "idx_ejercicios_parametrosDeMedicion_ejercicio",
                table: "ejercicios_parametrosDeMedicion",
                column: "fkEjercicio");

            migrationBuilder.CreateIndex(
                name: "idx_ejercicios_parametrosDeMedicion_parametro",
                table: "ejercicios_parametrosDeMedicion",
                column: "fkParametro");

            migrationBuilder.CreateIndex(
                name: "IX_Equipos_fkIcon",
                table: "Equipos",
                column: "fkIcon");

            migrationBuilder.CreateIndex(
                name: "IX_estructuraDeClase_fkClase",
                table: "estructuraDeClase",
                column: "fkClase");

            migrationBuilder.CreateIndex(
                name: "IX_horariosDeClasesProgramadas_fkHorarioLaboral",
                table: "horariosDeClasesProgramadas",
                column: "fkHorarioLaboral");

            migrationBuilder.CreateIndex(
                name: "UQ_horariosDeClasesProgramadas_Compuesto",
                table: "horariosDeClasesProgramadas",
                columns: new[] { "fkClaseProgramada", "fkHorarioLaboral" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_imagesForClases_fkClase",
                table: "imagesForClases",
                column: "fkClase");

            migrationBuilder.CreateIndex(
                name: "IX_imagesForExercises_fkEjercicio",
                table: "imagesForExercises",
                column: "fkEjercicio");

            migrationBuilder.CreateIndex(
                name: "IX_inscripcionesDeClases_fkCliente",
                table: "inscripcionesDeClases",
                column: "fkCliente");

            migrationBuilder.CreateIndex(
                name: "IX_inscripcionesDeClases_fkEstadoInscripcion",
                table: "inscripcionesDeClases",
                column: "fkEstadoInscripcion");

            migrationBuilder.CreateIndex(
                name: "IX_inscripcionesDeClases_fkProgramacionClase",
                table: "inscripcionesDeClases",
                column: "fkProgramacionClase");

            migrationBuilder.CreateIndex(
                name: "IX_medidas_fkEjercicio",
                table: "medidas",
                column: "fkEjercicio");

            migrationBuilder.CreateIndex(
                name: "IX_medidas_fkParametro",
                table: "medidas",
                column: "fkParametro");

            migrationBuilder.CreateIndex(
                name: "IX_medidas_fkUsuario",
                table: "medidas",
                column: "fkUsuario");

            migrationBuilder.CreateIndex(
                name: "IX_metas_fkEjercicio",
                table: "metas",
                column: "fkEjercicio");

            migrationBuilder.CreateIndex(
                name: "IX_metas_fkIntencion",
                table: "metas",
                column: "fkIntencion");

            migrationBuilder.CreateIndex(
                name: "IX_metas_fkNivelDeLogro",
                table: "metas",
                column: "fkNivelDeLogro");

            migrationBuilder.CreateIndex(
                name: "IX_metas_fkParametro",
                table: "metas",
                column: "fkParametro");

            migrationBuilder.CreateIndex(
                name: "IX_metas_fkUsuario",
                table: "metas",
                column: "fkUsuario");

            migrationBuilder.CreateIndex(
                name: "IX_Pagos_UsuarioID",
                table: "Pagos",
                column: "UsuarioID");

            migrationBuilder.CreateIndex(
                name: "IX_parametros_unidadesDeMedida_fkUnidadDeMedida",
                table: "parametros_unidadesDeMedida",
                column: "fkUnidadDeMedida");

            migrationBuilder.CreateIndex(
                name: "IX_parametrosDeMedicion_fkIcon",
                table: "parametrosDeMedicion",
                column: "fkIcon");

            migrationBuilder.CreateIndex(
                name: "IX_preReservasDeHorario_fkHorarioClaseProgramada",
                table: "preReservasDeHorario",
                column: "fkHorarioClaseProgramada");

            migrationBuilder.CreateIndex(
                name: "IX_RegistrosEntrenamiento_RutinaID",
                table: "RegistrosEntrenamiento",
                column: "RutinaID");

            migrationBuilder.CreateIndex(
                name: "IX_RegistrosEntrenamiento_UsuarioID",
                table: "RegistrosEntrenamiento",
                column: "UsuarioID");

            migrationBuilder.CreateIndex(
                name: "IX_RutinaEjercicios_EjercicioID",
                table: "RutinaEjercicios",
                column: "EjercicioID");

            migrationBuilder.CreateIndex(
                name: "IX_RutinaEjercicios_RutinaID",
                table: "RutinaEjercicios",
                column: "RutinaID");

            migrationBuilder.CreateIndex(
                name: "IX_Rutinas_EntrenadorID",
                table: "Rutinas",
                column: "EntrenadorID");

            migrationBuilder.CreateIndex(
                name: "IX_Rutinas_fkClase",
                table: "Rutinas",
                column: "fkClase");

            migrationBuilder.CreateIndex(
                name: "IX_Rutinas_fkTipoRutina",
                table: "Rutinas",
                column: "fkTipoRutina");

            migrationBuilder.CreateIndex(
                name: "IX_Rutinas_UsuarioID",
                table: "Rutinas",
                column: "UsuarioID");

            migrationBuilder.CreateIndex(
                name: "IX_Usuarios_RolID",
                table: "Usuarios",
                column: "RolID");

            migrationBuilder.CreateIndex(
                name: "UQ__Usuarios__4EC5048011B00D5E",
                table: "Usuarios",
                column: "Telefono",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "UQ__Usuarios__6B0F5AE04376F638",
                table: "Usuarios",
                column: "NombreUsuario",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "UQ__Usuarios__A9D1053404A4BEF2",
                table: "Usuarios",
                column: "Email",
                unique: true);

 */        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AspNetRoleClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserLogins");

            migrationBuilder.DropTable(
                name: "AspNetUserRoles");

            migrationBuilder.DropTable(
                name: "AspNetUserTokens");

            migrationBuilder.DropTable(
                name: "beneficiosDeClase");

            migrationBuilder.DropTable(
                name: "Citas");

            migrationBuilder.DropTable(
                name: "citaSP");

            migrationBuilder.DropTable(
                name: "consejosParaLasClases");

            migrationBuilder.DropTable(
                name: "correosSP");

            migrationBuilder.DropTable(
                name: "Cupones");

            migrationBuilder.DropTable(
                name: "detalleDeClaseRawSP");

            migrationBuilder.DropTable(
                name: "DetalleEntrenamiento");

            migrationBuilder.DropTable(
                name: "DTOClasesProgramadaView");

            migrationBuilder.DropTable(
                name: "duracionCitas");

            migrationBuilder.DropTable(
                name: "EjercicioEquipos");

            migrationBuilder.DropTable(
                name: "ejercicios_parametrosDeMedicion");

            migrationBuilder.DropTable(
                name: "ejercicioSP");

            migrationBuilder.DropTable(
                name: "ejerciciosYParametrosDelClienteSP");

            migrationBuilder.DropTable(
                name: "estructuraDeClase");

            migrationBuilder.DropTable(
                name: "FN_ObtenerClases");

            migrationBuilder.DropTable(
                name: "imagesForClases");

            migrationBuilder.DropTable(
                name: "imagesForExercises");

            migrationBuilder.DropTable(
                name: "inscripcionesDeClases");

            migrationBuilder.DropTable(
                name: "LogErrores");

            migrationBuilder.DropTable(
                name: "medidas");

            migrationBuilder.DropTable(
                name: "metas");

            migrationBuilder.DropTable(
                name: "Pagos");

            migrationBuilder.DropTable(
                name: "parametros_unidadesDeMedida");

            migrationBuilder.DropTable(
                name: "parametrosDeMedicionSP");

            migrationBuilder.DropTable(
                name: "preReservasDeHorario");

            migrationBuilder.DropTable(
                name: "RutinaEjercicios");

            migrationBuilder.DropTable(
                name: "rutinaSP");

            migrationBuilder.DropTable(
                name: "Servicios");

            migrationBuilder.DropTable(
                name: "ultimasMedidasDeParametroSP");

            migrationBuilder.DropTable(
                name: "ultimasMetasDeParametroSP");

            migrationBuilder.DropTable(
                name: "userSP");

            migrationBuilder.DropTable(
                name: "AspNetRoles");

            migrationBuilder.DropTable(
                name: "AspNetUsers");

            migrationBuilder.DropTable(
                name: "Descuentos");

            migrationBuilder.DropTable(
                name: "RegistrosEntrenamiento");

            migrationBuilder.DropTable(
                name: "Equipos");

            migrationBuilder.DropTable(
                name: "estadosInscripciones");

            migrationBuilder.DropTable(
                name: "intenciones");

            migrationBuilder.DropTable(
                name: "nivelesDeLogro");

            migrationBuilder.DropTable(
                name: "parametrosDeMedicion");

            migrationBuilder.DropTable(
                name: "unidadesDeMedida");

            migrationBuilder.DropTable(
                name: "horariosDeClasesProgramadas");

            migrationBuilder.DropTable(
                name: "Ejercicios");

            migrationBuilder.DropTable(
                name: "Rutinas");

            migrationBuilder.DropTable(
                name: "clasesProgramadas");

            migrationBuilder.DropTable(
                name: "diasDeLaSemana_horasLaborales");

            migrationBuilder.DropTable(
                name: "iconsForParameters");

            migrationBuilder.DropTable(
                name: "TipoRutina");

            migrationBuilder.DropTable(
                name: "Clases");

            migrationBuilder.DropTable(
                name: "estadosClasesProgramadas");

            migrationBuilder.DropTable(
                name: "años");

            migrationBuilder.DropTable(
                name: "diasDeLaSemana");

            migrationBuilder.DropTable(
                name: "horasLaborales");

            migrationBuilder.DropTable(
                name: "nivelesDeDificultadDeClase");

            migrationBuilder.DropTable(
                name: "nivelesDeIntensidadDeClase");

            migrationBuilder.DropTable(
                name: "estadosDeClases");

            migrationBuilder.DropTable(
                name: "Usuarios");

            migrationBuilder.DropTable(
                name: "Roles");
        }
    }
}
