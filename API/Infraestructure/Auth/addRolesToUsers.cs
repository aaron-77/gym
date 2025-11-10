using Microsoft.Extensions.DependencyInjection;
using API.Services;
using Microsoft.AspNetCore.Identity;
using DTO.Dtos;
using BL.Utils;
using DataAccess.EntityFramework;

class addRolesToUsers
{
    static async Task Main(string[] args)
    {
        // Configurar servicios
        var services = new ServiceCollection();

        // Registrar Identity
        services.AddIdentity<IdentityUser, IdentityRole>()
                .AddEntityFrameworkStores<FitnessCenterDbContext>(); // tu DbContext

        // Registrar tus servicios
        services.AddScoped<AuthService>();
        services.AddScoped<JwtTokenGenerator>();
        services.AddScoped<TokensService>();
        services.AddScoped<JwtSettings>();
        services.AddHttpContextAccessor();

        var serviceProvider = services.BuildServiceProvider();

        // Ejecutar tu script
        var authService = serviceProvider.GetRequiredService<AuthService>();
        await authService.AddRoleToUserAsync("e47637e0-1971-4e46-99fb-186db0847fac", "cliente");

        Console.WriteLine("Rol asignado correctamente");
    }
}
