using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DataAccess.Migrations
{
    /// <inheritdoc />
    public partial class AddIdSecundario : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK__Citas__Entrenado__44FF419A",
                table: "Citas");

            migrationBuilder.DropForeignKey(
                name: "FK__Citas__UsuarioID__440B1D61",
                table: "Citas");

            migrationBuilder.DropForeignKey(
                name: "FK__Clases__Instruct__5AEE82B9",
                table: "Clases");

            migrationBuilder.DropForeignKey(
                name: "FK_ClasesProgramadas_Usuarios",
                table: "clasesProgramadas");

            migrationBuilder.DropForeignKey(
                name: "FK_horariosDeClasesProgramadas_diasDeLaSemana_horasLaborales",
                table: "horariosDeClasesProgramadas");

            migrationBuilder.DropForeignKey(
                name: "FK_InscripcionesDeClases_Cliente",
                table: "inscripcionesDeClases");

            migrationBuilder.DropForeignKey(
                name: "FK_UsuarioMedida",
                table: "medidas");

            migrationBuilder.DropForeignKey(
                name: "FK_Metas_Usuarios",
                table: "metas");

            migrationBuilder.DropForeignKey(
                name: "FK__Pagos__UsuarioID__6383C8BA",
                table: "Pagos");

            migrationBuilder.DropForeignKey(
                name: "FK_preReservasDeHorario_horariosClasesProgramadas",
                table: "preReservasDeHorario");

            migrationBuilder.DropForeignKey(
                name: "FK__Registros__Usuar__6EF57B66",
                table: "RegistrosEntrenamiento");

            migrationBuilder.DropForeignKey(
                name: "FK__Rutinas__Entrena__4AB81AF0",
                table: "Rutinas");

            migrationBuilder.DropForeignKey(
                name: "FK__Rutinas__Usuario__49C3F6B7",
                table: "Rutinas");

            migrationBuilder.DropTable(
                name: "diasDeLaSemana_horasLaborales");

            migrationBuilder.DropTable(
                name: "años");

            migrationBuilder.DropTable(
                name: "diasDeLaSemana");

            migrationBuilder.DropIndex(
                name: "IX_Rutinas_UsuarioID",
                table: "Rutinas");

            migrationBuilder.DropIndex(
                name: "IX_RegistrosEntrenamiento_UsuarioID",
                table: "RegistrosEntrenamiento");

            migrationBuilder.DropIndex(
                name: "IX_Pagos_UsuarioID",
                table: "Pagos");

            migrationBuilder.DropIndex(
                name: "UQ_horariosDeClasesProgramadas_Compuesto",
                table: "horariosDeClasesProgramadas");

            migrationBuilder.DropIndex(
                name: "IX_Citas_UsuarioID",
                table: "Citas");

            migrationBuilder.DropColumn(
                name: "NewEntrenadorId",
                table: "Rutinas");

            migrationBuilder.DropColumn(
                name: "NewUserId",
                table: "Rutinas");

            migrationBuilder.DropColumn(
                name: "UsuarioID",
                table: "Rutinas");

            migrationBuilder.DropColumn(
                name: "NewUserId",
                table: "RegistrosEntrenamiento");

            migrationBuilder.DropColumn(
                name: "UsuarioID",
                table: "RegistrosEntrenamiento");

            migrationBuilder.DropColumn(
                name: "NewUserId",
                table: "Pagos");

            migrationBuilder.DropColumn(
                name: "UsuarioID",
                table: "Pagos");

            migrationBuilder.DropColumn(
                name: "NewFkUsuario",
                table: "metas");

            migrationBuilder.DropColumn(
                name: "NewFkUsuario",
                table: "medidas");

            migrationBuilder.DropColumn(
                name: "NewFkEntrenador",
                table: "clasesProgramadas");

            migrationBuilder.DropColumn(
                name: "fechaFin",
                table: "clasesProgramadas");

            migrationBuilder.DropColumn(
                name: "fechaInicio",
                table: "clasesProgramadas");

            migrationBuilder.DropColumn(
                name: "NewInstructorId",
                table: "Clases");

            migrationBuilder.DropColumn(
                name: "NewEntrenadorId",
                table: "Citas");

            migrationBuilder.DropColumn(
                name: "NewUserId",
                table: "Citas");

            migrationBuilder.DropColumn(
                name: "UsuarioID",
                table: "Citas");

            migrationBuilder.RenameColumn(
                name: "EntrenadorID",
                table: "Rutinas",
                newName: "EntrenadorId");

            migrationBuilder.RenameIndex(
                name: "IX_Rutinas_EntrenadorID",
                table: "Rutinas",
                newName: "IX_Rutinas_EntrenadorId");

            migrationBuilder.RenameColumn(
                name: "fkHorarioClaseProgramada",
                table: "preReservasDeHorario",
                newName: "fkHoraLaboral");

            migrationBuilder.RenameIndex(
                name: "IX_preReservasDeHorario_fkHorarioClaseProgramada",
                table: "preReservasDeHorario",
                newName: "IX_preReservasDeHorario_fkHoraLaboral");

            migrationBuilder.RenameColumn(
                name: "InstructorID",
                table: "Clases",
                newName: "InstructorId");

            migrationBuilder.RenameIndex(
                name: "IX_Clases_InstructorID",
                table: "Clases",
                newName: "IX_Clases_InstructorId");

            migrationBuilder.RenameColumn(
                name: "EntrenadorID",
                table: "Citas",
                newName: "EntrenadorId");

            migrationBuilder.RenameIndex(
                name: "IX_Citas_EntrenadorID",
                table: "Citas",
                newName: "IX_Citas_EntrenadorId");

            migrationBuilder.AlterColumn<string>(
                name: "UsuarioID",
                table: "userSP",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<DateTime>(
                name: "FechaRegistro",
                table: "userSP",
                type: "datetime2",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.AlterColumn<DateTime>(
                name: "FechaNacimiento",
                table: "userSP",
                type: "datetime2",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.AlterColumn<string>(
                name: "fkUsuario",
                table: "ultimasMetasDeParametroSP",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<string>(
                name: "fkUsuario",
                table: "ultimasMedidasDeParametroSP",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<string>(
                name: "UsuarioID",
                table: "rutinaSP",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<string>(
                name: "EntrenadorID",
                table: "rutinaSP",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<string>(
                name: "EntrenadorId",
                table: "Rutinas",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "UserId",
                table: "Rutinas",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "UserId",
                table: "RegistrosEntrenamiento",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "IssuedAt",
                table: "RefreshTokens",
                type: "datetime2",
                nullable: false,
                defaultValueSql: "(sysutcdatetime())",
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValueSql: "SYSUTCDATETIME()");

            migrationBuilder.AlterColumn<Guid>(
                name: "RefreshTokenId",
                table: "RefreshTokens",
                type: "uniqueidentifier",
                nullable: false,
                defaultValueSql: "(newid())",
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier",
                oldDefaultValueSql: "NEWID()");

            migrationBuilder.AddColumn<DateOnly>(
                name: "fechaReservada",
                table: "preReservasDeHorario",
                type: "date",
                nullable: false,
                defaultValue: new DateOnly(1, 1, 1));

            migrationBuilder.AddColumn<int>(
                name: "idUsuarioQueReserva",
                table: "preReservasDeHorario",
                type: "int",
                nullable: false,
                defaultValue: 0,
                comment: "id del usuario que esta registrando la clase programada,es para saber a que usuario hay que enviarle la respuesta ya que es por tiempo real");

            migrationBuilder.AddColumn<string>(
                name: "UserId",
                table: "Pagos",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "fkUsuario",
                table: "metas",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<int>(
                name: "fkNivelDeLogro",
                table: "metas",
                type: "int",
                nullable: false,
                defaultValue: 1,
                oldClrType: typeof(int),
                oldType: "int",
                oldDefaultValueSql: "((1))");

            migrationBuilder.AlterColumn<string>(
                name: "fkUsuario",
                table: "medidas",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<string>(
                name: "fkCliente",
                table: "inscripcionesDeClases",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<DateOnly>(
                name: "fechaDeLaClase",
                table: "horariosDeClasesProgramadas",
                type: "date",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "fkEntrenador",
                table: "horariosDeClasesProgramadas",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "fkEstadoHorarioClase",
                table: "horariosDeClasesProgramadas",
                type: "int",
                nullable: false,
                defaultValue: 1);

            migrationBuilder.AlterColumn<string>(
                name: "fkEntrenador",
                table: "DTOClasesProgramadaView",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<string>(
                name: "fkEntrenador",
                table: "clasesProgramadas",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<int>(
                name: "tiempoDeDescansoEnMinutos",
                table: "Clases",
                type: "int",
                nullable: false,
                defaultValue: 15,
                oldClrType: typeof(int),
                oldType: "int",
                oldDefaultValueSql: "((15))");

            migrationBuilder.AlterColumn<int>(
                name: "duracionEnMinutosConDescansoIncluido",
                table: "Clases",
                type: "int",
                nullable: false,
                defaultValue: 60,
                oldClrType: typeof(int),
                oldType: "int",
                oldDefaultValueSql: "((60))");

            migrationBuilder.AlterColumn<string>(
                name: "InstructorId",
                table: "Clases",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "UsuarioID",
                table: "citaSP",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<string>(
                name: "EntrenadorID",
                table: "citaSP",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<string>(
                name: "EntrenadorId",
                table: "Citas",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "UserId",
                table: "Citas",
                type: "nvarchar(450)",
                maxLength: 450,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "idSecundario",
                table: "AspNetUsers",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AlterColumn<DateTime>(
                name: "IssuedAt",
                table: "AccessTokens",
                type: "datetime2",
                nullable: false,
                defaultValueSql: "(sysutcdatetime())",
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValueSql: "SYSUTCDATETIME()");

            migrationBuilder.AlterColumn<Guid>(
                name: "AccessTokenId",
                table: "AccessTokens",
                type: "uniqueidentifier",
                nullable: false,
                defaultValueSql: "(newid())",
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier",
                oldDefaultValueSql: "NEWID()");

            migrationBuilder.CreateTable(
                name: "estadosDeActividadLaboral",
                columns: table => new
                {
                    idEstadoActividadLaboral = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombreEstadoActividadLaboral = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    fechaCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fcehaModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__estadosD__F41B8ED8EC454C75", x => x.idEstadoActividadLaboral);
                });

            migrationBuilder.CreateTable(
                name: "estadosHorarioClaseProgramada",
                columns: table => new
                {
                    idEstadoHorarioClase = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombreEstadoHorario = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    fechaCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__estadosH__FE1509CB80800E66", x => x.idEstadoHorarioClase);
                });

            migrationBuilder.CreateTable(
                name: "tiposDeRecurrenciaDeDiasFestivos",
                columns: table => new
                {
                    idTipoDeRecurrenciaDeDiaFestivo = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombreTipoDeRecurrencia = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    descripcion = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    fechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    fechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__tiposDeR__3A34B1D521F4C5E6", x => x.idTipoDeRecurrenciaDeDiaFestivo);
                });

            migrationBuilder.CreateTable(
                name: "diasFestivosYDescansos",
                columns: table => new
                {
                    idDiaFestivo = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fechaFestivaODescanso = table.Column<DateOnly>(type: "date", nullable: false),
                    descripcion = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    fkEstadoActividadLaboral = table.Column<int>(type: "int", nullable: false),
                    fechaCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    fcehaModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__diasFest__A066CE26B7DC05E6", x => x.idDiaFestivo);
                    table.ForeignKey(
                        name: "FK_diasFestivosYDescansos_EstadoActividadLaboral",
                        column: x => x.fkEstadoActividadLaboral,
                        principalTable: "estadosDeActividadLaboral",
                        principalColumn: "idEstadoActividadLaboral");
                });

            migrationBuilder.CreateTable(
                name: "diasFestivosVariables",
                columns: table => new
                {
                    idDiaFestivoVariable = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    nombreDiasFestivoVariable = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    deQueSemana = table.Column<int>(type: "int", nullable: true),
                    deQueMes = table.Column<int>(type: "int", nullable: true),
                    deQueDia = table.Column<int>(type: "int", nullable: false),
                    fechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    fechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true),
                    fkTipoDeRecurrenciaDelFestivo = table.Column<int>(type: "int", nullable: false),
                    fkEstadoActividadLaboral = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__diasFest__499CE46553695ECB", x => x.idDiaFestivoVariable);
                    table.ForeignKey(
                        name: "fk_estadosDeActividdadLaboral_diasFestivosVariables",
                        column: x => x.fkEstadoActividadLaboral,
                        principalTable: "estadosDeActividadLaboral",
                        principalColumn: "idEstadoActividadLaboral");
                    table.ForeignKey(
                        name: "fk_tiposDeRecurrenciaDeDiasFestivos_diasFestivosVariables",
                        column: x => x.fkTipoDeRecurrenciaDelFestivo,
                        principalTable: "tiposDeRecurrenciaDeDiasFestivos",
                        principalColumn: "idTipoDeRecurrenciaDeDiaFestivo");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Rutinas_UserId",
                table: "Rutinas",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_RegistrosEntrenamiento_UserId",
                table: "RegistrosEntrenamiento",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Pagos_UserId",
                table: "Pagos",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_horariosDeClasesProgramadas_fkClaseProgramada",
                table: "horariosDeClasesProgramadas",
                column: "fkClaseProgramada");

            migrationBuilder.CreateIndex(
                name: "IX_horariosDeClasesProgramadas_fkEntrenador",
                table: "horariosDeClasesProgramadas",
                column: "fkEntrenador");

            migrationBuilder.CreateIndex(
                name: "IX_horariosDeClasesProgramadas_fkEstadoHorarioClase",
                table: "horariosDeClasesProgramadas",
                column: "fkEstadoHorarioClase");

            migrationBuilder.CreateIndex(
                name: "IX_Citas_UserId",
                table: "Citas",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_diasFestivosVariables_fkEstadoActividadLaboral",
                table: "diasFestivosVariables",
                column: "fkEstadoActividadLaboral");

            migrationBuilder.CreateIndex(
                name: "IX_diasFestivosVariables_fkTipoDeRecurrenciaDelFestivo",
                table: "diasFestivosVariables",
                column: "fkTipoDeRecurrenciaDelFestivo");

            migrationBuilder.CreateIndex(
                name: "fecha_unica",
                table: "diasFestivosYDescansos",
                column: "fechaFestivaODescanso",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_diasFestivosYDescansos_Fecha",
                table: "diasFestivosYDescansos",
                column: "fechaFestivaODescanso");

            migrationBuilder.CreateIndex(
                name: "IX_diasFestivosYDescansos_fkEstadoActividadLaboral",
                table: "diasFestivosYDescansos",
                column: "fkEstadoActividadLaboral");

            migrationBuilder.CreateIndex(
                name: "IX_tiposDeRecurrenciaDeDiasFestivos_Nombre",
                table: "tiposDeRecurrenciaDeDiasFestivos",
                column: "nombreTipoDeRecurrencia");

            migrationBuilder.AddForeignKey(
                name: "FK_Citas_AspNetUsers_NewEntrenadorId",
                table: "Citas",
                column: "EntrenadorId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Citas_AspNetUsers_NewUserId",
                table: "Citas",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Clases_AspNetUsers_NewInstructorId",
                table: "Clases",
                column: "InstructorId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ClasesProgramadas_AspNetUsers_NewFkEntrenador",
                table: "clasesProgramadas",
                column: "fkEntrenador",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_HorariosDeClasesProgramadas_AspNetUsers_NewFkEntrenador",
                table: "horariosDeClasesProgramadas",
                column: "fkEntrenador",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_horasLborales_horariosClasesProgramadas",
                table: "horariosDeClasesProgramadas",
                column: "fkHorarioLaboral",
                principalTable: "horasLaborales",
                principalColumn: "idHora");

            migrationBuilder.AddForeignKey(
                name: "fk_estadosClasesProgramadas_horariosDeClasesProgramadas",
                table: "horariosDeClasesProgramadas",
                column: "fkEstadoHorarioClase",
                principalTable: "estadosHorarioClaseProgramada",
                principalColumn: "idEstadoHorarioClase");

            migrationBuilder.AddForeignKey(
                name: "FK_InscripcionesDeClases_AspNetUsers_NewFkCliente",
                table: "inscripcionesDeClases",
                column: "fkCliente",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Medidas_AspNetUsers_NewFkUsuario",
                table: "medidas",
                column: "fkUsuario",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Metas_AspNetUsers_NewFkUsuario",
                table: "metas",
                column: "fkUsuario",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Pagos_AspNetUsers_NewUserId",
                table: "Pagos",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_preReservasDeHorario_horariosClasesProgramadas",
                table: "preReservasDeHorario",
                column: "fkHoraLaboral",
                principalTable: "horasLaborales",
                principalColumn: "idHora");

            migrationBuilder.AddForeignKey(
                name: "FK_RegistrosEntrenamiento_AspNetUsers_NewUserId",
                table: "RegistrosEntrenamiento",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Rutinas_AspNetUsers_NewEntrenadorId",
                table: "Rutinas",
                column: "EntrenadorId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Rutinas_AspNetUsers_NewUserId",
                table: "Rutinas",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Citas_AspNetUsers_NewEntrenadorId",
                table: "Citas");

            migrationBuilder.DropForeignKey(
                name: "FK_Citas_AspNetUsers_NewUserId",
                table: "Citas");

            migrationBuilder.DropForeignKey(
                name: "FK_Clases_AspNetUsers_NewInstructorId",
                table: "Clases");

            migrationBuilder.DropForeignKey(
                name: "FK_ClasesProgramadas_AspNetUsers_NewFkEntrenador",
                table: "clasesProgramadas");

            migrationBuilder.DropForeignKey(
                name: "FK_HorariosDeClasesProgramadas_AspNetUsers_NewFkEntrenador",
                table: "horariosDeClasesProgramadas");

            migrationBuilder.DropForeignKey(
                name: "FK_horasLborales_horariosClasesProgramadas",
                table: "horariosDeClasesProgramadas");

            migrationBuilder.DropForeignKey(
                name: "fk_estadosClasesProgramadas_horariosDeClasesProgramadas",
                table: "horariosDeClasesProgramadas");

            migrationBuilder.DropForeignKey(
                name: "FK_InscripcionesDeClases_AspNetUsers_NewFkCliente",
                table: "inscripcionesDeClases");

            migrationBuilder.DropForeignKey(
                name: "FK_Medidas_AspNetUsers_NewFkUsuario",
                table: "medidas");

            migrationBuilder.DropForeignKey(
                name: "FK_Metas_AspNetUsers_NewFkUsuario",
                table: "metas");

            migrationBuilder.DropForeignKey(
                name: "FK_Pagos_AspNetUsers_NewUserId",
                table: "Pagos");

            migrationBuilder.DropForeignKey(
                name: "FK_preReservasDeHorario_horariosClasesProgramadas",
                table: "preReservasDeHorario");

            migrationBuilder.DropForeignKey(
                name: "FK_RegistrosEntrenamiento_AspNetUsers_NewUserId",
                table: "RegistrosEntrenamiento");

            migrationBuilder.DropForeignKey(
                name: "FK_Rutinas_AspNetUsers_NewEntrenadorId",
                table: "Rutinas");

            migrationBuilder.DropForeignKey(
                name: "FK_Rutinas_AspNetUsers_NewUserId",
                table: "Rutinas");

            migrationBuilder.DropTable(
                name: "diasFestivosVariables");

            migrationBuilder.DropTable(
                name: "diasFestivosYDescansos");

            migrationBuilder.DropTable(
                name: "estadosHorarioClaseProgramada");

            migrationBuilder.DropTable(
                name: "tiposDeRecurrenciaDeDiasFestivos");

            migrationBuilder.DropTable(
                name: "estadosDeActividadLaboral");

            migrationBuilder.DropIndex(
                name: "IX_Rutinas_UserId",
                table: "Rutinas");

            migrationBuilder.DropIndex(
                name: "IX_RegistrosEntrenamiento_UserId",
                table: "RegistrosEntrenamiento");

            migrationBuilder.DropIndex(
                name: "IX_Pagos_UserId",
                table: "Pagos");

            migrationBuilder.DropIndex(
                name: "IX_horariosDeClasesProgramadas_fkClaseProgramada",
                table: "horariosDeClasesProgramadas");

            migrationBuilder.DropIndex(
                name: "IX_horariosDeClasesProgramadas_fkEntrenador",
                table: "horariosDeClasesProgramadas");

            migrationBuilder.DropIndex(
                name: "IX_horariosDeClasesProgramadas_fkEstadoHorarioClase",
                table: "horariosDeClasesProgramadas");

            migrationBuilder.DropIndex(
                name: "IX_Citas_UserId",
                table: "Citas");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "Rutinas");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "RegistrosEntrenamiento");

            migrationBuilder.DropColumn(
                name: "fechaReservada",
                table: "preReservasDeHorario");

            migrationBuilder.DropColumn(
                name: "idUsuarioQueReserva",
                table: "preReservasDeHorario");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "Pagos");

            migrationBuilder.DropColumn(
                name: "fechaDeLaClase",
                table: "horariosDeClasesProgramadas");

            migrationBuilder.DropColumn(
                name: "fkEntrenador",
                table: "horariosDeClasesProgramadas");

            migrationBuilder.DropColumn(
                name: "fkEstadoHorarioClase",
                table: "horariosDeClasesProgramadas");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "Citas");

            migrationBuilder.DropColumn(
                name: "idSecundario",
                table: "AspNetUsers");

            migrationBuilder.RenameColumn(
                name: "EntrenadorId",
                table: "Rutinas",
                newName: "EntrenadorID");

            migrationBuilder.RenameIndex(
                name: "IX_Rutinas_EntrenadorId",
                table: "Rutinas",
                newName: "IX_Rutinas_EntrenadorID");

            migrationBuilder.RenameColumn(
                name: "fkHoraLaboral",
                table: "preReservasDeHorario",
                newName: "fkHorarioClaseProgramada");

            migrationBuilder.RenameIndex(
                name: "IX_preReservasDeHorario_fkHoraLaboral",
                table: "preReservasDeHorario",
                newName: "IX_preReservasDeHorario_fkHorarioClaseProgramada");

            migrationBuilder.RenameColumn(
                name: "InstructorId",
                table: "Clases",
                newName: "InstructorID");

            migrationBuilder.RenameIndex(
                name: "IX_Clases_InstructorId",
                table: "Clases",
                newName: "IX_Clases_InstructorID");

            migrationBuilder.RenameColumn(
                name: "EntrenadorId",
                table: "Citas",
                newName: "EntrenadorID");

            migrationBuilder.RenameIndex(
                name: "IX_Citas_EntrenadorId",
                table: "Citas",
                newName: "IX_Citas_EntrenadorID");

            migrationBuilder.AlterColumn<int>(
                name: "UsuarioID",
                table: "userSP",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<DateTime>(
                name: "FechaRegistro",
                table: "userSP",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "FechaNacimiento",
                table: "userSP",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "fkUsuario",
                table: "ultimasMetasDeParametroSP",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<int>(
                name: "fkUsuario",
                table: "ultimasMedidasDeParametroSP",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<int>(
                name: "UsuarioID",
                table: "rutinaSP",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<int>(
                name: "EntrenadorID",
                table: "rutinaSP",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<int>(
                name: "EntrenadorID",
                table: "Rutinas",
                type: "int",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldMaxLength: 450,
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewEntrenadorId",
                table: "Rutinas",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewUserId",
                table: "Rutinas",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "UsuarioID",
                table: "Rutinas",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewUserId",
                table: "RegistrosEntrenamiento",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "UsuarioID",
                table: "RegistrosEntrenamiento",
                type: "int",
                nullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "IssuedAt",
                table: "RefreshTokens",
                type: "datetime2",
                nullable: false,
                defaultValueSql: "SYSUTCDATETIME()",
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValueSql: "(sysutcdatetime())");

            migrationBuilder.AlterColumn<Guid>(
                name: "RefreshTokenId",
                table: "RefreshTokens",
                type: "uniqueidentifier",
                nullable: false,
                defaultValueSql: "NEWID()",
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier",
                oldDefaultValueSql: "(newid())");

            migrationBuilder.AddColumn<string>(
                name: "NewUserId",
                table: "Pagos",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "UsuarioID",
                table: "Pagos",
                type: "int",
                nullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "fkUsuario",
                table: "metas",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldMaxLength: 450,
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "fkNivelDeLogro",
                table: "metas",
                type: "int",
                nullable: false,
                defaultValueSql: "((1))",
                oldClrType: typeof(int),
                oldType: "int",
                oldDefaultValue: 1);

            migrationBuilder.AddColumn<string>(
                name: "NewFkUsuario",
                table: "metas",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "fkUsuario",
                table: "medidas",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldMaxLength: 450,
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewFkUsuario",
                table: "medidas",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "fkCliente",
                table: "inscripcionesDeClases",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldMaxLength: 450,
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "fkEntrenador",
                table: "DTOClasesProgramadaView",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<int>(
                name: "fkEntrenador",
                table: "clasesProgramadas",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldMaxLength: 450,
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewFkEntrenador",
                table: "clasesProgramadas",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "fechaFin",
                table: "clasesProgramadas",
                type: "datetime",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "fechaInicio",
                table: "clasesProgramadas",
                type: "datetime",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AlterColumn<int>(
                name: "tiempoDeDescansoEnMinutos",
                table: "Clases",
                type: "int",
                nullable: false,
                defaultValueSql: "((15))",
                oldClrType: typeof(int),
                oldType: "int",
                oldDefaultValue: 15);

            migrationBuilder.AlterColumn<int>(
                name: "duracionEnMinutosConDescansoIncluido",
                table: "Clases",
                type: "int",
                nullable: false,
                defaultValueSql: "((60))",
                oldClrType: typeof(int),
                oldType: "int",
                oldDefaultValue: 60);

            migrationBuilder.AlterColumn<int>(
                name: "InstructorID",
                table: "Clases",
                type: "int",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldMaxLength: 450,
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewInstructorId",
                table: "Clases",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "UsuarioID",
                table: "citaSP",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<int>(
                name: "EntrenadorID",
                table: "citaSP",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<int>(
                name: "EntrenadorID",
                table: "Citas",
                type: "int",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldMaxLength: 450,
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewEntrenadorId",
                table: "Citas",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewUserId",
                table: "Citas",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "UsuarioID",
                table: "Citas",
                type: "int",
                nullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "IssuedAt",
                table: "AccessTokens",
                type: "datetime2",
                nullable: false,
                defaultValueSql: "SYSUTCDATETIME()",
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValueSql: "(sysutcdatetime())");

            migrationBuilder.AlterColumn<Guid>(
                name: "AccessTokenId",
                table: "AccessTokens",
                type: "uniqueidentifier",
                nullable: false,
                defaultValueSql: "NEWID()",
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier",
                oldDefaultValueSql: "(newid())");

            migrationBuilder.CreateTable(
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
                name: "diasDeLaSemana",
                columns: table => new
                {
                    idDia = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Activo = table.Column<bool>(type: "bit", nullable: true, defaultValueSql: "((1))"),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    FechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    nombreDia = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__diasDeLa__3E416597E1AE4B2B", x => x.idDia);
                });

            migrationBuilder.CreateTable(
                name: "diasDeLaSemana_horasLaborales",
                columns: table => new
                {
                    idHorarioLaboral = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    fkAño = table.Column<int>(type: "int", nullable: false),
                    fkDiaDeLaSemana = table.Column<int>(type: "int", nullable: false),
                    fkHoraLaboral = table.Column<int>(type: "int", nullable: false)
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

            migrationBuilder.CreateIndex(
                name: "IX_Rutinas_UsuarioID",
                table: "Rutinas",
                column: "UsuarioID");

            migrationBuilder.CreateIndex(
                name: "IX_RegistrosEntrenamiento_UsuarioID",
                table: "RegistrosEntrenamiento",
                column: "UsuarioID");

            migrationBuilder.CreateIndex(
                name: "IX_Pagos_UsuarioID",
                table: "Pagos",
                column: "UsuarioID");

            migrationBuilder.CreateIndex(
                name: "UQ_horariosDeClasesProgramadas_Compuesto",
                table: "horariosDeClasesProgramadas",
                columns: new[] { "fkClaseProgramada", "fkHorarioLaboral" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Citas_UsuarioID",
                table: "Citas",
                column: "UsuarioID");

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

            migrationBuilder.AddForeignKey(
                name: "FK__Citas__Entrenado__44FF419A",
                table: "Citas",
                column: "EntrenadorID",
                principalTable: "Usuarios",
                principalColumn: "UsuarioID");

            migrationBuilder.AddForeignKey(
                name: "FK__Citas__UsuarioID__440B1D61",
                table: "Citas",
                column: "UsuarioID",
                principalTable: "Usuarios",
                principalColumn: "UsuarioID");

            migrationBuilder.AddForeignKey(
                name: "FK__Clases__Instruct__5AEE82B9",
                table: "Clases",
                column: "InstructorID",
                principalTable: "Usuarios",
                principalColumn: "UsuarioID");

            migrationBuilder.AddForeignKey(
                name: "FK_ClasesProgramadas_Usuarios",
                table: "clasesProgramadas",
                column: "fkEntrenador",
                principalTable: "Usuarios",
                principalColumn: "UsuarioID");

            migrationBuilder.AddForeignKey(
                name: "FK_horariosDeClasesProgramadas_diasDeLaSemana_horasLaborales",
                table: "horariosDeClasesProgramadas",
                column: "fkHorarioLaboral",
                principalTable: "diasDeLaSemana_horasLaborales",
                principalColumn: "idHorarioLaboral");

            migrationBuilder.AddForeignKey(
                name: "FK_InscripcionesDeClases_Cliente",
                table: "inscripcionesDeClases",
                column: "fkCliente",
                principalTable: "Usuarios",
                principalColumn: "UsuarioID");

            migrationBuilder.AddForeignKey(
                name: "FK_UsuarioMedida",
                table: "medidas",
                column: "fkUsuario",
                principalTable: "Usuarios",
                principalColumn: "UsuarioID");

            migrationBuilder.AddForeignKey(
                name: "FK_Metas_Usuarios",
                table: "metas",
                column: "fkUsuario",
                principalTable: "Usuarios",
                principalColumn: "UsuarioID");

            migrationBuilder.AddForeignKey(
                name: "FK__Pagos__UsuarioID__6383C8BA",
                table: "Pagos",
                column: "UsuarioID",
                principalTable: "Usuarios",
                principalColumn: "UsuarioID");

            migrationBuilder.AddForeignKey(
                name: "FK_preReservasDeHorario_horariosClasesProgramadas",
                table: "preReservasDeHorario",
                column: "fkHorarioClaseProgramada",
                principalTable: "horariosDeClasesProgramadas",
                principalColumn: "idHorarioDeClaseProgramada");

            migrationBuilder.AddForeignKey(
                name: "FK__Registros__Usuar__6EF57B66",
                table: "RegistrosEntrenamiento",
                column: "UsuarioID",
                principalTable: "Usuarios",
                principalColumn: "UsuarioID");

            migrationBuilder.AddForeignKey(
                name: "FK__Rutinas__Entrena__4AB81AF0",
                table: "Rutinas",
                column: "EntrenadorID",
                principalTable: "Usuarios",
                principalColumn: "UsuarioID");

            migrationBuilder.AddForeignKey(
                name: "FK__Rutinas__Usuario__49C3F6B7",
                table: "Rutinas",
                column: "UsuarioID",
                principalTable: "Usuarios",
                principalColumn: "UsuarioID");
        }
    }
}
