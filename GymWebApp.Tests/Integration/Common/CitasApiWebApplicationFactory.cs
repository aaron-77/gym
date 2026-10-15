using System.Net.Http.Json;
using DTO.Dtos;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using GymWebApp.Tests.Integration.Common;
using FitnessCenterDbContext = DataAccess.EntityFramework.FitnessCenterDbContext;

namespace GymWebApp.Tests.Integration;

public class CitasApiWebApplicationFactory<TProgram> : WebApplicationFactory<TProgram> where TProgram : class
{
    private string? _authToken;
    private readonly string _connectionString;

    public CitasApiWebApplicationFactory()
    {
        _connectionString = TestContainerHelper.Instance.ConnectionString;
        
        // Set environment variables before the API starts
        Environment.SetEnvironmentVariable("DB_CONNECTION_STRING", _connectionString);
        Environment.SetEnvironmentVariable("SECRET_TOKEN_KEY", "__development_secret_key_replace_for_production__");
    }

    public string GetAuthToken()
    {
        return _authToken ?? throw new InvalidOperationException("Token not available. Ensure ConfigureWebHost has been called.");
    }

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseSetting("ConnectionStrings:DefaultConnection", _connectionString);

        builder.ConfigureAppConfiguration((context, config) =>
        {
            config.AddJsonFile("appsettings.Testing.json", optional: false, reloadOnChange: true);
        });

        builder.ConfigureServices(services =>
        {
            var descriptor = services.SingleOrDefault(
                d => d.ServiceType == typeof(DbContextOptions<FitnessCenterDbContext>));

            if (descriptor != null)
            {
                services.Remove(descriptor);
            }

            services.AddDbContext<FitnessCenterDbContext>(options =>
                options.UseSqlServer(_connectionString));
        });

        builder.UseEnvironment("Testing");
    }

    public async Task<string> AuthenticateAsync(HttpClient client)
    {

        try
        {

        var email = TestUsersOptions.EmpleadoEmail;
        var password = TestUsersOptions.EmpleadoPassword;

        var loginRequest = new UserCredentials
        {
            correo = email,
            contrasena = password
        };

        var response = await client.PostAsJsonAsync("/api/autenticar", loginRequest);

        if (!response.IsSuccessStatusCode)
        {
            var errorContent = await response.Content.ReadAsStringAsync();
            throw new InvalidOperationException($"Authentication failed. Status: {response.StatusCode}, Content: {errorContent}");
        }

        var content = await response.Content.ReadFromJsonAsync<DTOResponse<DTOLoggedUser>>();
        
        if (content?.payload?.AccessToken == null)
        {
            throw new InvalidOperationException("Authentication response does not contain access token");
        }

        _authToken = content.payload.AccessToken;
        return _authToken;
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }

    public async Task<string> AuthenticateAsClienteAsync(HttpClient client)
    {
        var email = TestUsersOptions.ClienteEmail;
        var password = TestUsersOptions.ClientePassword;
        
        var loginRequest = new UserCredentials
        {
            correo = email,
            contrasena = password
        };

        var response = await client.PostAsJsonAsync("/api/autenticar", loginRequest);

        if (!response.IsSuccessStatusCode)
        {
            var errorContent = await response.Content.ReadAsStringAsync();
            throw new InvalidOperationException($"Authentication failed. Status: {response.StatusCode}, Content: {errorContent}");
        }

        var content = await response.Content.ReadFromJsonAsync<DTOResponse<DTOLoggedUser>>();
        
        if (content?.payload?.AccessToken == null)
        {
            throw new InvalidOperationException("Authentication response does not contain access token");
        }

        _authToken = content.payload.AccessToken;
        return _authToken;
    }
}
