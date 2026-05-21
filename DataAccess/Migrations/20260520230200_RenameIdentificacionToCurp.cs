using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace DataAccess.Migrations
{
    /// <inheritdoc />
    public partial class RenameIdentificacionToCurp : Migration
    {
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.RenameColumn(
            name: "NumeroDeIdentificacion",
            table: "AspNetUsers",
            newName: "Curp");
    }

    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.RenameColumn(
            name: "Curp",
            table: "AspNetUsers",
            newName: "NumeroDeIdentificacion");
    }
    }
}
