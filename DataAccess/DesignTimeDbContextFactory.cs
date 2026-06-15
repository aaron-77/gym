using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using System;
using static System.Net.Mime.MediaTypeNames;
using static System.Net.WebRequestMethods;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace DataAccess
{
    // Permite a las herramientas de EF Core crear el DbContext en tiempo de dise�o
    // sin ejecutar la l�gica de arranque de la API (Program.cs)
    public class DesignTimeDbContextFactory : IDesignTimeDbContextFactory<FitnessCenterDbContext>
    {
        public FitnessCenterDbContext CreateDbContext(string[] args)
        {
            var connectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING");
            if (string.IsNullOrEmpty(connectionString))
            {
                throw new InvalidOperationException("La variable de entorno 'DB_CONNECTION_STRING' no est� configurada. Config�rala antes de ejecutar comandos de EF Core (migrations).\nEj: setx DB_CONNECTION_STRING \"Server=...;Database=...;User Id=...;Password=...;\"");
            }

            var optionsBuilder = new DbContextOptionsBuilder<FitnessCenterDbContext>();
            optionsBuilder.UseSqlServer(connectionString);

            return new FitnessCenterDbContext(optionsBuilder.Options);
        }
    }
}
