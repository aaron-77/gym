using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DataAccess.Migrations
{
    /// <inheritdoc />
    public partial class addedNewFkFieldsForAspnetusersRelations : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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

            migrationBuilder.AddColumn<string>(
                name: "NewUserId",
                table: "RegistrosEntrenamiento",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewUserId",
                table: "Pagos",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewFkUsuario",
                table: "metas",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewFkUsuario",
                table: "medidas",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewFkEntrenador",
                table: "clasesProgramadas",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NewInstructorId",
                table: "Clases",
                type: "nvarchar(max)",
                nullable: true);

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
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "NewEntrenadorId",
                table: "Rutinas");

            migrationBuilder.DropColumn(
                name: "NewUserId",
                table: "Rutinas");

            migrationBuilder.DropColumn(
                name: "NewUserId",
                table: "RegistrosEntrenamiento");

            migrationBuilder.DropColumn(
                name: "NewUserId",
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
                name: "NewInstructorId",
                table: "Clases");

            migrationBuilder.DropColumn(
                name: "NewEntrenadorId",
                table: "Citas");

            migrationBuilder.DropColumn(
                name: "NewUserId",
                table: "Citas");
        }
    }
}
