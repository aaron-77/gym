using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace DataAccess
{
    // Permite a las herramientas de EF Core crear el DbContext en tiempo de diseño
    // sin ejecutar la lógica de arranque de la API (Program.cs)
    public class DesignTimeDbContextFactory : IDesignTimeDbContextFactory<DataAccess.EntityFramework.FitnessCenterDbContext>
    {
        public DataAccess.EntityFramework.FitnessCenterDbContext CreateDbContext(string[] args)
        {
            var connectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING");
            if (string.IsNullOrEmpty(connectionString))
            {
                throw new InvalidOperationException("La variable de entorno 'DB_CONNECTION_STRING' no está configurada. Configúrala antes de ejecutar comandos de EF Core (migrations).\nEj: setx DB_CONNECTION_STRING \"Server=...;Database=...;User Id=...;Password=...;\"");
            }

            var optionsBuilder = new DbContextOptionsBuilder<DataAccess.EntityFramework.FitnessCenterDbContext>();
            optionsBuilder.UseSqlServer(connectionString);

            return new DataAccess.EntityFramework.FitnessCenterDbContext(optionsBuilder.Options);
        }
    }
}
