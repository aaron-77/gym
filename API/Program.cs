using BL;
using BL.EnPointsLogic;
using BL.BackGroundWork.Jobs;
using Microsoft.EntityFrameworkCore;
using Quartz;
using BL.Utils;
using API.Hubs;
using API.Services;
using API.Infraestructure.Auth;
using DataAccess.EntityFramework;
using Microsoft.AspNetCore.Identity;
using DTO.Dtos;
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using DataAccess.Identity;
using API.Controllers;
using DataAccess;
using System.Runtime.InteropServices;
using System.Collections;

try
{
    Console.WriteLine("========================================");
    Console.WriteLine("INICIANDO API...");
    Console.WriteLine("========================================");

    var builder = WebApplication.CreateBuilder(args);
    Console.WriteLine("WebApplicationBuilder creado");

    // Configuración JWT
    var jwtSection = builder.Configuration.GetSection("JwtSettings");
    builder.Services.Configure<JwtSettings>(jwtSection);
    var claimsSection = builder.Configuration.GetSection("ClaimsSettings");
    builder.Services.Configure<ClaimsSettings>(claimsSection);
    Console.WriteLine("Configuracion JWT cargada");

    // Connection String
    var dbConnectionString = builder.Configuration["ConnectionStrings:DefaultConnection"];
    bool useSsl = builder.Configuration.GetValue<bool>("UseSsl");
    string aspnetcore_urls = Environment.GetEnvironmentVariable("ASPNETCORE_URLS") ?? "";
    aspnetcore_urls = aspnetcore_urls.Trim().ToLowerInvariant();
    var DB_CONNECTION_STRING = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING");
    if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
    {
        dbConnectionString = DB_CONNECTION_STRING;//builder.Configuration["ConnectionStrings:windowsConnection"];
    }
    Console.WriteLine("Connection string configurado");

    var jwtSettings = jwtSection.Get<JwtSettings>();

    // Obtener clave secreta JWT con fallback seguros para entornos de diseño (migrations)
    var secretFromEnv = Environment.GetEnvironmentVariable("SECRET_TOKEN_KEY");
    string secretKeyString = secretFromEnv
        ?? builder.Configuration["JwtSettings:Secret"]
        ?? builder.Configuration["JwtSettings:SecretKey"]
        ?? jwtSettings?.GetType().GetProperty("Secret")?.GetValue(jwtSettings)?.ToString()
        ?? jwtSettings?.GetType().GetProperty("SecretKey")?.GetValue(jwtSettings)?.ToString()
        ?? "__development_secret_key_replace_for_production__"; // fallback para migraciones/local

    var key = Encoding.UTF8.GetBytes(secretKeyString);
    Console.WriteLine("JWT key obtenida (o fallback) para configuración");

    // Identity
    builder.Services.AddIdentity<ApplicationUser, IdentityRole>()
        .AddEntityFrameworkStores<FitnessCenterDbContext>()
        .AddDefaultTokenProviders();
    Console.WriteLine("Identity configurado");

    // Authentication
    builder.Services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    }).AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, options =>
    {
        string audience = jwtSettings.BackendAudiencie;
        if (aspnetcore_urls.Contains("https"))
        {
            audience = jwtSettings.BackendAudienceSsl;
        }
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtSettings.Issuer,
            ValidAudience = audience,
            IssuerSigningKey = new SymmetricSecurityKey(key)
        };
    });
    Console.WriteLine("JWT Authentication configurado");

    var frontendUrl= builder.Configuration["EndPoints:frontend:external"];
    // CORS
    builder.Services.AddCors(options =>
    {
        options.AddPolicy("originsPolicyOne", policy =>
        {
            policy.WithOrigins(frontendUrl)
                  .AllowAnyHeader()
                  .AllowAnyMethod()
                  .AllowCredentials();
        });
    });
    Console.WriteLine("CORS configurado");

    // Controllers y SignalR
    builder.Services.AddControllers(options =>
    {
        options.SuppressImplicitRequiredAttributeForNonNullableReferenceTypes = true;
    });
    builder.Services.AddSignalR();
    Console.WriteLine("Controllers y SignalR registrados");

    // Swagger
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen();
    Console.WriteLine("Swagger configurado");

    // DbContext
    //builder.Services.AddDbContext<DataAccess.EntityFramework.FitnessCenterDbContext>(options =>
    //{
    //    options.UseSqlServer(dbConnectionString);
    //});
    Console.WriteLine("DbContext configurado");

    // Email
    var smtpSettings = builder.Configuration.GetSection("SmtpSettings");
    string smtpServer = smtpSettings["Server"];
    int smtpPort = int.Parse(smtpSettings["Port"]);
    string smtpUsername = smtpSettings["Username"];
    string smtpPassword = smtpSettings["Password"];
    builder.Services.AddScoped(sp => new EmailManagerMailKit(smtpServer, smtpPort, smtpUsername, smtpPassword));
    Console.WriteLine("Email configurado");

    // HttpClient
    builder.Services.AddScoped<AuthHeaderHandler>();
    string baseApiUrl = builder.Configuration[
        aspnetcore_urls.Contains("https") ? "EndPoints:api:ssl" : "EndPoints:api:nossl"
    ] ?? "http://localhost:5274";
    builder.Services.AddHttpClient<HttpCustomClient>(client =>
    {
        client.BaseAddress = new Uri(baseApiUrl);
    }).AddHttpMessageHandler<AuthHeaderHandler>();
    Console.WriteLine("HttpClient configurado");

    // Servicios personalizados
    builder.Services.AddScoped<HorariosService>();
    builder.Services.AddHttpContextAccessor();
    builder.Services.AddScoped<UserRoleService>();
    builder.Services.AddScoped<ReservacionesHub>();
    builder.Services.AddScoped<ServicioActualizacionesDeHorariosRealTime>();
    builder.Services.AddScoped<JwtTokenGenerator>();
    builder.Services.AddScoped<AuthService>();
    builder.Services.AddScoped<TokensService>();
    builder.Services.AddScoped<ClasesService>();
    Console.WriteLine("Servicios personalizados registrados");

    // Quartz
    builder.Services.AddQuartz(configuration => {
        configuration.UseMicrosoftDependencyInjectionJobFactory();
        var jobKey = new JobKey(name: "AppointmentRemainder");
        configuration.AddJob<RemaindersAppoinments>(opts => opts.WithIdentity(jobKey));
        configuration.AddTrigger(opts => opts
            .ForJob(jobKey)
            .WithIdentity("AppointmentRemainder-trigger")
            .WithDailyTimeIntervalSchedule(conf =>
            {
                conf.WithIntervalInHours(24)
                .OnEveryDay()
                .StartingDailyAt(TimeOfDay.HourAndMinuteOfDay(0, 0));
            }));
    });
    builder.Services.AddQuartzHostedService(option => option.WaitForJobsToComplete = true);
    builder.Services.AddQuartz(options => { options.UseMicrosoftDependencyInjectionJobFactory(); });
    Console.WriteLine("Quartz configurado");

    // Authorization y capas adicionales
    builder.Services.AddAuthorization();
    builder.Services.AddDataAccess();
    builder.Services.AddBusinessLayer();
    Console.WriteLine("Authorization, DataAccess y BusinessLayer registrados");

    Console.WriteLine("========================================");
    Console.WriteLine("CONSTRUYENDO APLICACION...");
    Console.WriteLine("========================================");
    foreach (var kv in Environment.GetEnvironmentVariables().Cast<DictionaryEntry>())
    {
        Console.WriteLine($"{kv.Key} = {kv.Value}");
    }

    var app = builder.Build();
    Console.WriteLine("App construida exitosamente");

    // Configuración del pipeline
    if (app.Environment.IsDevelopment())
    {
        app.UseSwagger();
        app.UseSwaggerUI();
        Console.WriteLine("Swagger habilitado (Development)");
    }

    app.UseHttpsRedirection();
    Console.WriteLine("HTTPS Redirection configurado");

    app.UseCors("originsPolicyOne");
    Console.WriteLine("CORS aplicado");

    app.UseAuthentication();
    Console.WriteLine("Authentication middleware agregado");

    app.UseAuthorization();
    Console.WriteLine("Authorization middleware agregado");

    app.MapHub<ReservacionesHub>("/reservacionesHub");
    Console.WriteLine("SignalR Hub mapeado");

    app.MapControllers();
    Console.WriteLine("Controllers mapeados");

    Console.WriteLine("========================================");
    Console.WriteLine("API LISTA - INICIANDO SERVIDOR...");
    Console.WriteLine("========================================");

    app.Run();
}
catch (Exception ex)
{
    Console.WriteLine("========================================");
    Console.WriteLine("ERROR CRITICO AL INICIAR API:");
    Console.WriteLine("========================================");
    Console.WriteLine("Tipo: " + ex.GetType().Name);
    Console.WriteLine("Mensaje: " + ex.Message);
    Console.WriteLine("----------------------------------------");
    Console.WriteLine("Stack Trace:");
    Console.WriteLine(ex.StackTrace);

    if (ex.InnerException != null)
    {
        Console.WriteLine("----------------------------------------");
        Console.WriteLine("Inner Exception:");
        Console.WriteLine("Tipo: " + ex.InnerException.GetType().Name);
        Console.WriteLine("Mensaje: " + ex.InnerException.Message);
        Console.WriteLine(ex.InnerException.StackTrace);
    }

    Console.WriteLine("========================================");

    Environment.Exit(1);
}