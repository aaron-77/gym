using API.Controllers;
using API.Hubs;
using API.Infraestructure.Auth;
using API.Services;
using BL;
using BL.BackGroundWork.Jobs;
using BL.EnPointsLogic;
using BL.Utils;
using DataAccess;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.Dtos;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Quartz;
using System.Collections;
using System.Net;
using System.Runtime.InteropServices;
using System.Text;
using Serilog;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using System.Diagnostics;
using System.Threading.RateLimiting;
using System.Text.Json;


try
{
    Console.WriteLine("========================================");
    Console.WriteLine("INICIANDO API...");
    Console.WriteLine("========================================");

    var builder = WebApplication.CreateBuilder(args);

    // Rate limiting para health check - 100 req/min
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
    Console.WriteLine("WebApplicationBuilder creado");

    if (builder.Environment.IsProduction()) { 
        builder.Services.Configure<ForwardedHeadersOptions>(options =>
    {
        options.ForwardedHeaders =
            ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto | ForwardedHeaders.XForwardedHost;
        options.KnownProxies.Add(IPAddress.Parse("127.0.0.1"));
    });
    }
    if (builder.Environment.IsStaging())
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
    Console.WriteLine("Configuracion JWT cargada");

    // Connection String
    var dbConnectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING");
    
    if (string.IsNullOrEmpty(dbConnectionString))
    {
        dbConnectionString = builder.Configuration["ConnectionStrings:DefaultConnection"];
    }
    Console.WriteLine($"[PROGRAM] Connection string usado: {dbConnectionString}");

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
    Console.WriteLine($"[PROGRAM] Connection string final: {dbConnectionString}");
    Console.WriteLine("Connection string configurado");

    var jwtSettings = jwtSection.Get<JwtSettings>();

    // Obtener clave secreta JWT con fallback seguros para entornos de dise�o (migrations)
    var secretFromEnv = Environment.GetEnvironmentVariable("SECRET_TOKEN_KEY");
    string secretKeyString = secretFromEnv
        ?? builder.Configuration["JwtSettings:Secret"]
        ?? builder.Configuration["JwtSettings:SecretKey"]
        ?? jwtSettings?.GetType().GetProperty("Secret")?.GetValue(jwtSettings)?.ToString()
        ?? jwtSettings?.GetType().GetProperty("SecretKey")?.GetValue(jwtSettings)?.ToString()
        ?? "__development_secret_key_replace_for_production__"; // fallback para migraciones/local

    var key = Encoding.UTF8.GetBytes(secretKeyString);
    Console.WriteLine("JWT key obtenida (o fallback) para configuraci�n");

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

    options.AddPolicy("public", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
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

    // Rate Limiting
    builder.Services.AddRateLimiter(options =>
    {
        options.AddFixedWindowLimiter(policyName: "PublicPolicy", options =>
        {
            options.PermitLimit = 15;
            options.Window = TimeSpan.FromMinutes(1);
            options.QueueLimit = 0;
            options.QueueProcessingOrder = QueueProcessingOrder.OldestFirst;
        });
        
        options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
    });

    builder.Services.AddDbContext<DataAccess.EntityFramework.FitnessCenterDbContext>(options =>
    {
        options.UseSqlServer(dbConnectionString);
    });
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
    builder.Services.AddHttpClient<IHttpCustomClient, HttpCustomClient>(client =>
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
    builder.Services.AddScoped<IUsersService, UsersService>();
    builder.Services.AddScoped<IClasesService, ClasesService>();
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
    
    // Configuraci�n del pipeline
    if (app.Environment.IsDevelopment())
    {
        
        app.UseSwagger();
        app.UseSwaggerUI();
        Console.WriteLine("Swagger habilitado (Development)");
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
        Console.WriteLine("Swagger habilitado (Development)");
    }
    if (app.Environment.IsProduction() ) {
        app.UseForwardedHeaders();
        if (useSsl)
        {            
            app.UseHttpsRedirection();

        }
    }

    if (app.Environment.IsDevelopment()) {
        app.UseHttpsRedirection();
    }
    
    Console.WriteLine("HTTPS Redirection configurado");

    app.Use(async (context, next) =>
    {
        // Excluir endpoint público de preview del bloqueo de origins
        if (context.Request.Path.StartsWithSegments("/api/Clases/preview"))
        {
            await next();
            return;
        }
        
        var origin = context.Request.Headers["Origin"].ToString();
        if (!string.IsNullOrEmpty(origin) && origin != frontendUrl)
        {
            context.Response.StatusCode = StatusCodes.Status403Forbidden;
            return;
        }
        await next();
    });

    app.UseCors("originsPolicyOne");
    Console.WriteLine("CORS aplicado");

    if (app.Environment.IsStaging() || app.Environment.IsProduction())
    {
        app.UseRateLimiter();
        Console.WriteLine("Rate Limiter aplicado (Staging/Production)");
    }

    app.UseAuthentication();
    Console.WriteLine("Authentication middleware agregado");

    app.UseAuthorization();
    Console.WriteLine("Authorization middleware agregado");

    app.MapHub<ReservacionesHub>("/reservacionesHub");
    Console.WriteLine("SignalR Hub mapeado");

    app.MapHealthChecks("/health", new HealthCheckOptions
    {
        ResponseWriter = async (context, report) =>
        {
            context.Response.ContentType = "application/json";
            var result = new { status = report.Status.ToString() };
            await JsonSerializer.SerializeAsync(context.Response.Body, result);
        }
    }).RequireRateLimiting("HealthPolicy");

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

public partial class Program { }