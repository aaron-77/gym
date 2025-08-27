using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace DataAccess.Migrations
{
    /// <inheritdoc />
    public partial class SeedUsuariosActualizados : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
            table: "AspNetUsers",
            keyColumn: "Id",
            keyValue: "436e5759-b9d4-4166-a623-3d910b68c9be",
            columns: new[] { "Direccion", "FechaDeNacimiento" },
            values: new object[]
            {
                "Boulevard diamante #123 entre 5ta y 6ta de aleta norte",
                new DateTime(1990, 1, 1)
            });

    
            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7a2da2f8-9fe8-480c-adee-2eb8d18d9ab7",
                columns: new[] { "Direccion", "FechaDeNacimiento" },
                values: new object[]
                {
                    "Avenida arteaga #456  entre Fabricio gomez y benito juarez",
                    new DateTime(1989, 2, 14)
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "436e5759-b9d4-4166-a623-3d910b68c9be");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7a2da2f8-9fe8-480c-adee-2eb8d18d9ab7");
        }
    }
}
