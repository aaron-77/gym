using System.Net;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.Json;
using System.Threading.RateLimiting;

using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Quartz;
using Serilog;

using API.Controllers;
using API.Hubs;
using API.Infraestructure;
using API.Infraestructure.Auth;
using API.Services;
using CorsConfig = API.Infraestructure.CorsServiceCollectionExtensions;
using API.Services.Validaciones;
using BL.Validaciones;
using BL;
using BL.BackGroundWork.Jobs;
using BL.EnPointsLogic;
using BL.Utils;
using DataAccess;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.Dtos;


try
{
    var builder = WebApplication.CreateBuilder(args);

    // Rate Limiting
    builder.Services.AddRateLimiter(options =>
    {
        options.AddPolicy("HealthPolicy", context =>
            RateLimitPartition.GetFixedWindowLimiter(
                partitionKey: "health",
                factory: _ => new FixedWindowRateLimiterOptions
                {
                    PermitLimit = 100,
                    Window = TimeSpan.FromMinutes(1),
                    QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                    QueueLimit = 0
                }));

        options.AddFixedWindowLimiter(policyName: "PublicPolicy", options =>
        {
            options.PermitLimit = 15;
            options.Window = TimeSpan.FromMinutes(1);
            options.QueueLimit = 0;
            options.QueueProcessingOrder = QueueProcessingOrder.OldestFirst;
        });

        options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
    });

    builder.Services.AddHealthChecks();
    // Configure Serilog
    Log.Logger = new LoggerConfiguration()
        .ReadFrom.Configuration(builder.Configuration)
        .Enrich.FromLogContext()
        .WriteTo.Console()
        .WriteTo.File("logs/api-.log", rollingInterval: RollingInterval.Day)
        .CreateLogger();
    builder.Host.UseSerilog();

    Log.Information("Iniciando API...");
    Log.Information("WebApplicationBuilder creado");

    if (builder.Environment.IsProduction() || builder.Environment.IsStaging())
    {
        builder.Services.Configure<ForwardedHeadersOptions>(options =>
        {
            options.ForwardedHeaders =
                ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto | ForwardedHeaders.XForwardedHost;
            options.KnownProxies.Add(IPAddress.Parse("127.0.0.1"));
        });
    }
    // Configuraci�n JWT

    var jwtSection = builder.Configuration.GetSection("JwtSettings");
    builder.Services.Configure<JwtSettings>(jwtSection);
    var claimsSection = builder.Configuration.GetSection("ClaimsSettings");
    builder.Services.Configure<ClaimsSettings>(claimsSection);
    Log.Information("Configuracion JWT cargada");

    // Connection String
    var dbConnectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING");

    if (string.IsNullOrEmpty(dbConnectionString))
    {
        dbConnectionString = builder.Configuration["ConnectionStrings:DefaultConnection"];
    }
    Log.Information("Connection string usado: {ConnectionString}", ResumirCadenaDeConexion(dbConnectionString));

    bool useSsl = builder.Configuration.GetValue<bool>("UseSsl");
    string aspnetcore_urls = Environment.GetEnvironmentVariable("ASPNETCORE_URLS") ?? "";
    aspnetcore_urls = aspnetcore_urls.Trim().ToLowerInvariant();
    
    if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
    {
        dbConnectionString = builder.Configuration["ConnectionStrings:windowsConnection"];
    }
    if (builder.Environment.IsProduction() || builder.Environment.IsStaging())
    {
        dbConnectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING") ?? dbConnectionString;
    }
    Log.Information("Connection string final: {ConnectionString}", ResumirCadenaDeConexion(dbConnectionString));
    Log.Information("Connection string configurado");

    if (string.IsNullOrWhiteSpace(dbConnectionString))
    {
        throw new InvalidOperationException(
            "Falta la variable de entorno DB_CONNECTION_STRING: no hay cadena de conexion disponible para este entorno. " +
            "Lance el proceso con el envoltorio de Infisical (infisical run) o complete la variable.");
    }

    var jwtSettings = jwtSection.Get<JwtSettings>();

    // Obtener clave secreta JWT con fallback seguros para entornos de dise�o (migrations)
    var secretFromEnv = Environment.GetEnvironmentVariable("SECRET_TOKEN_KEY");
    string secretKeyString = secretFromEnv
        ?? builder.Configuration["JwtSettings:Secret"]
        ?? builder.Configuration["JwtSettings:SecretKey"]
        ?? jwtSettings?.SecretKey
        ?? builder.Configuration["JwtSettings:Secret"];

    if (string.IsNullOrWhiteSpace(secretKeyString))
    {
        if (builder.Environment.IsProduction() || builder.Environment.IsStaging())
        {
            throw new InvalidOperationException(
                "Falta la variable de entorno SECRET_TOKEN_KEY: no hay clave secreta JWT para firmar tokens en este entorno. " +
                "Lance el proceso con el envoltorio de Infisical (infisical run) o complete la variable.");
        }
        secretKeyString = "__development_secret_key_replace_for_production__"; // fallback para migraciones/local
    }

    var key = Encoding.UTF8.GetBytes(secretKeyString);
    Log.Information("JWT key obtenida (o fallback) para configuraci�n");

    // Identity
    builder.Services.AddIdentity<ApplicationUser, IdentityRole>()
        .AddEntityFrameworkStores<FitnessCenterDbContext>()
        .AddDefaultTokenProviders();
    Log.Information("Identity configurado");

    // Authentication
    builder.Services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    }).AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, options =>
    {
        string audience = jwtSettings.BackendAudiencie;
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
    
    Log.Information("JWT Authentication configurado");

    //allowed oriogins contiene el dns de amazon
    var allowedOrigins = builder.Configuration
        .GetSection("AllowedCorsOrigins")
        .Get<string[]>() ?? Array.Empty<string>();
    Log.Information("CORS allowed origins: {AllowedOrigins}", string.Join(", ", allowedOrigins));

    // CORS
    builder.Services.AddCorsConfiguration(builder.Environment.IsStaging(), allowedOrigins);
    Log.Information("CORS configurado");

    // Controllers y SignalR
    builder.Services.AddControllers(options =>
    {
        options.SuppressImplicitRequiredAttributeForNonNullableReferenceTypes = true;
    });

    builder.Services.Configure<ApiBehaviorOptions>(options =>
    {
        options.InvalidModelStateResponseFactory = context =>
        {
            var errors = context.ModelState
                .Where(e => e.Value?.Errors.Count > 0)
                .SelectMany(kvp => kvp.Value!.Errors.Select(e => new ErrorModel
                {
                    message = e.ErrorMessage,
                    propiedad = kvp.Key
                }))
                .ToList();

            var response = ResponseManager.BuildResponse<object>(
                success: false,
                httpCode: 400,
                message: "Error de validación",
                errors: errors,
                payload: null
            );

            return new BadRequestObjectResult(response);
        };
    });
    builder.Services.AddSignalR();
    Log.Information("Controllers y SignalR registrados");

    // Swagger
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen();
    Log.Information("Swagger configurado");


    builder.Services.AddDbContext<DataAccess.EntityFramework.FitnessCenterDbContext>(options =>
    {
        options.UseSqlServer(dbConnectionString);
        
    });
    Log.Information("DbContext configurado");

    // Email
    var smtpSettings = builder.Configuration.GetSection("SmtpSettings");
    string smtpServer = smtpSettings["Server"];
    int smtpPort = int.TryParse(smtpSettings["Port"], out var parsedPort) ? parsedPort : 587;
    string smtpUsername = smtpSettings["Username"];
    string smtpPassword = smtpSettings["Password"];
    builder.Services.AddScoped(sp => new EmailManagerMailKit(smtpServer, smtpPort, smtpUsername, smtpPassword));
    Log.Information("Email configurado");

    // HttpClient
    builder.Services.AddScoped<AuthHeaderHandler>();
    string baseApiUrl = builder.Configuration[
        aspnetcore_urls.Contains("https") ? "EndPoints:api:ssl" : "EndPoints:api:nossl"
    ] ?? "http://localhost:5274";
    builder.Services.AddHttpClient<IHttpCustomClient, HttpCustomClient>(client =>
    {
        client.BaseAddress = new Uri(baseApiUrl);
    }).AddHttpMessageHandler<AuthHeaderHandler>();
    Log.Information("HttpClient configurado");

    // Servicios personalizados
    builder.Services.AddScoped<HorariosService>();
    builder.Services.AddHttpContextAccessor();
    builder.Services.AddScoped<UserRoleService>();
    builder.Services.AddScoped<ReservacionesHub>();
    builder.Services.AddScoped<ServicioActualizacionesDeHorariosRealTime>();
    builder.Services.AddScoped<JwtTokenGenerator>();
    builder.Services.AddScoped<AuthService>();
    builder.Services.AddScoped<TokensService>();
    builder.Services.AddScoped<IUsersService, UsersService>();
    builder.Services.AddScoped<IClasesService, ClasesService>();
    builder.Services.AddScoped<IInscripcionesService, InscripcionesService>();
    builder.Services.AddScoped<IValidadorUsuarioExistente, ValidadorUsuarioExistente>();
    builder.Services.AddScoped<IValidadorFechasInscripcionesYClasesProgramadas, ValidadorFechasInscripcionesYClasesProgramadas>();
    builder.Services.AddScoped<IValidadorClaseExistente, ValidadorClaseExistente>();
    builder.Services.AddScoped<IValidadorClaseProgramadaExistente, ValidadorClaseProgramadaExistente>();
    Log.Information("Servicios personalizados registrados");

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
    Log.Information("Quartz configurado");

    // Authorization y capas adicionales
    builder.Services.AddAuthorization();
    builder.Services.AddDataAccess();
    builder.Services.AddBusinessLayer();
    Log.Information("Authorization, DataAccess y BusinessLayer registrados");

    Log.Information("Construyendo aplicacion...");

    var app = builder.Build();
    
    Log.Information("App construida exitosamente");
    
    // Configuraci�n del pipeline
    if (app.Environment.IsDevelopment())
    {
        
        app.UseSwagger();
        app.UseSwaggerUI();
        Log.Information("Swagger habilitado (Development)");
    }
    if (app.Environment.IsStaging())
    {
        app.UseForwardedHeaders();
        app.UseSwagger(c => { 
            c.RouteTemplate = "api/swagger/{documentName}/swagger.json";
        });
        app.UseSwaggerUI(c => { 
            c.RoutePrefix = "api";
            c.SwaggerEndpoint("/api/swagger/v1/swagger.json", "FitnessGymAPI");


        });
        Log.Information("Swagger habilitado (Development)");
    }
    if (app.Environment.IsProduction() ) {
        app.UseForwardedHeaders();
    }
    
    Log.Information("HTTPS lo termina el reverse proxy de Nginx; Kestrel queda en HTTP interno");

    app.UseCors("originsPolicyOne");

    app.Use(async (context, next) =>
    {
        // Excluir endpoint público de preview del bloqueo de origins
        if (context.Request.Path.StartsWithSegments("/api/Clases/preview"))
        {
            await next();
            return;
        }

        var origin = context.Request.Headers["Origin"].ToString();
        if (string.IsNullOrEmpty(origin))
        {
            await next();
            return;
        }

        var origenPermitido = app.Environment.IsStaging()
            ? CorsConfig.EsOrigenPermitido(origin)
            : allowedOrigins.Contains(origin);

        if (!origenPermitido)
        {
            context.Response.StatusCode = StatusCodes.Status403Forbidden;
            return;
        }
        await next();
    });
    Log.Information("CORS aplicado");

    if (app.Environment.IsStaging() || app.Environment.IsProduction())
    {
        app.UseRateLimiter();
        Log.Information("Rate Limiter aplicado (Staging/Production)");
    }

    app.UseAuthentication();
    Log.Information("Authentication middleware agregado");

    app.UseAuthorization();
    Log.Information("Authorization middleware agregado");

    app.MapHub<ReservacionesHub>("/reservacionesHub");
    Log.Information("SignalR Hub mapeado");

    app.MapHealthChecks("/api/health", new HealthCheckOptions
    {
        ResponseWriter = async (context, report) =>
        {
            context.Response.ContentType = "application/json";
            var result = new { status = report.Status.ToString() };
            await JsonSerializer.SerializeAsync(context.Response.Body, result);
        }
    }).RequireRateLimiting("HealthPolicy");
    Log.Information("Health check endpoint configurado en /api/health con rate limiting (100 req/min)");

    app.MapControllers();
    Log.Information("Controllers mapeados");

    Log.Information("API lista - iniciando servidor...");

    app.Run();
}
catch (Exception ex)
{
    Log.Fatal(ex, "Error crítico al iniciar la API");
    Environment.Exit(1);
}

public partial class Program
{
    /// <summary>
    /// Resumen seguro de la cadena de conexión para logs: solo servidor y base de datos,
    /// sin credenciales (requisito de la spec 93: la jamás debe aparecer en logs).
    /// </summary>
    public static string ResumirCadenaDeConexion(string? cadena)
    {
        if (string.IsNullOrWhiteSpace(cadena)) return "(sin valor)";
        var partes = cadena.Split(';');
        var servidor = partes.FirstOrDefault(p =>
            p.Trim().StartsWith("Server=", StringComparison.OrdinalIgnoreCase) ||
            p.Trim().StartsWith("Data Source=", StringComparison.OrdinalIgnoreCase))?.Trim();
        var baseDeDatos = partes.FirstOrDefault(p =>
            p.Trim().StartsWith("Database=", StringComparison.OrdinalIgnoreCase) ||
            p.Trim().StartsWith("Initial Catalog=", StringComparison.OrdinalIgnoreCase))?.Trim();
        return $"servidor={servidor}; base={baseDeDatos}";
    }
}