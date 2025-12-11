using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DataAccess.Migrations
{
    /// <inheritdoc />
    public partial class RemoveFkHashEntrenador : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "fkEntrenadorHash",
                table: "clasesProgramadas");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<byte[]>(
                name: "fkEntrenadorHash",
                table: "clasesProgramadas",
                type: "varbinary(8000)",
                maxLength: 8000,
                nullable: true,
                computedColumnSql: "(hashbytes('SHA1',[fkEntrenador]))",
                stored: true);
        }
    }
}
