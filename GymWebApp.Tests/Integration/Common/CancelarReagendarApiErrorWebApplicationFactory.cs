using System.IdentityModel.Tokens.Jwt;
using BL;
using BL.Utils;
using DTO.Dtos;
using GymWebApp.Tests.Integration.Helpers;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using FitnessCenterDbContext = DataAccess.EntityFramework.FitnessCenterDbContext;

namespace GymWebApp.Tests.Integration.Common;

/// <summary>
/// WebApplicationFactory especializada para el test de error de API
/// de CancelarReagendar. Reemplaza IHttpCustomClient con un fake que
/// lanza HttpRequestException, y provee autenticación JWT generando
/// tokens mediante JwtTokenGenerator resuelto desde DI, con userId real de BD.
/// </summary>
public class CancelarReagendarApiErrorWebApplicationFactory : GymFrontendWebApplicationFactory<GymFrontend.Program>
{
    private string? _empleadoToken;
    private string? _clienteToken;

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        base.ConfigureWebHost(builder);

        builder.ConfigureServices(services =>
        {
            // Re-registrar DbContext con la connection string de test
            // (mismo patrón que CitasApiWebApplicationFactory para robustez)
            var dbDescriptor = services.SingleOrDefault(
                d => d.ServiceType == typeof(DbContextOptions<FitnessCenterDbContext>));
            if (dbDescriptor != null)
            {
                services.Remove(dbDescriptor);
            }

            services.AddDbContext<FitnessCenterDbContext>(options =>
                options.UseSqlServer(TestContainerHelper.Instance.ConnectionString));

            // Reemplazar el IHttpCustomClient real por el fake que simula error de API
            var httpDescriptor = services.SingleOrDefault(d => d.ServiceType == typeof(IHttpCustomClient));
            if (httpDescriptor != null)
            {
                services.Remove(httpDescriptor);
            }

            services.AddScoped<IHttpCustomClient>(_ => new ApiErrorSimulatorClient());
        });
    }

    /// <summary>
    /// Autentica como empleado. Consulta el userId real desde la BD
    /// y genera un IdToken (FrontendToken) mediante JwtTokenGenerator.
    /// </summary>
    public async Task<string> AuthenticateAsync(HttpClient client)
    {
        if (string.IsNullOrEmpty(_empleadoToken))
        {
            var testUser = ConfigHelper.GetSection("TestUser");
            var email = testUser["Email"]!;
            var userData = await ObtenerUsuarioRealAsync(email);

            var userValues = new Dictionary<string, string>
            {
                { "userId", userData.Id },
                { "userName", userData.UserName },
                { "email", userData.Email },
                { "nombreCompleto", userData.NombreCompleto },
                { "curp", userData.Curp }
            };

            _empleadoToken = GenerarToken(userValues, new List<string> { userData.RoleName });
        }
        return _empleadoToken;
    }

    /// <summary>
    /// Autentica como cliente. Consulta el userId real desde la BD
    /// y genera un IdToken (FrontendToken) mediante JwtTokenGenerator.
    /// </summary>
    public async Task<string> AuthenticateAsClienteAsync(HttpClient client)
    {
        if (string.IsNullOrEmpty(_clienteToken))
        {
            var testUser = ConfigHelper.GetSection("TestUserCliente");
            var email = testUser["Email"]!;
            var userData = await ObtenerUsuarioRealAsync(email);

            var userValues = new Dictionary<string, string>
            {
                { "userId", userData.Id },
                { "userName", userData.UserName },
                { "email", userData.Email },
                { "nombreCompleto", userData.NombreCompleto },
                { "curp", userData.Curp }
            };

            _clienteToken = GenerarToken(userValues, new List<string> { userData.RoleName });
        }
        return _clienteToken;
    }

    private sealed record UserData(
        string Id,
        string UserName,
        string NombreCompleto,
        string Email,
        string Curp,
        string RoleName);

    /// <summary>
    /// Obtiene todos los datos relevantes de un usuario desde AspNetUsers
    /// incluyendo su rol real de BD.
    /// </summary>
    private static async Task<UserData> ObtenerUsuarioRealAsync(string email)
    {
        var connectionString = TestContainerHelper.Instance.ConnectionString;
        var userData = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            """
            SELECT TOP 1 u.Id, u.UserName, u.Email, u.NombreCompleto, u.Curp, r.Name AS RoleName
            FROM AspNetUsers u
            JOIN AspNetUserRoles ur ON u.Id = ur.UserId
            JOIN AspNetRoles r ON ur.RoleId = r.Id
            WHERE u.Email = @Email
            """,
            new Dictionary<string, object?> { { "@Email", email } });

        if (userData == null)
            throw new InvalidOperationException($"Usuario con email '{email}' no encontrado en BD");

        return new UserData(
            Id: (string)userData["Id"],
            UserName: (string)userData["UserName"],
            NombreCompleto: (string)userData["NombreCompleto"],
            Email: (string)userData["Email"],
            Curp: (string)userData["Curp"],
            RoleName: (string)userData["RoleName"]);
    }

    /// <summary>
    /// Genera un IdToken (FrontendToken) usando JwtTokenGenerator desde DI.
    /// </summary>
    private string GenerarToken(Dictionary<string, string> userValues, IList<string> roles)
    {
        using var scope = Services.CreateScope();
        var jwtGen = scope.ServiceProvider.GetRequiredService<JwtTokenGenerator>();

        var token = jwtGen.CreateTokenWithConfig(
            TokenType.FrontendToken,
            ssl: false,
            userValues,
            roles);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
