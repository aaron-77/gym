using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.AspNetCore.RateLimiting;
using System.Threading.RateLimiting;
using BL;
using BL.EnPointsLogic;
using BL.Utils;
using DataAccess;
using DTO.Dtos;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using System.Net;
using System.Text;
using System.Text.Json;

try
{
    Console.WriteLine("========================================");
    Console.WriteLine("INICIANDO FRONTEND...");
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
    if (builder.Environment.IsProduction())
    {
        builder.Services.Configure<ForwardedHeadersOptions>(options =>
        {
            options.ForwardedHeaders =
                ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto | ForwardedHeaders.XForwardedHost;
            options.KnownProxies.Add(IPAddress.Parse("127.0.0.1"));
        });
    }
    if (builder.Environment.IsStaging()) {
        builder.Services.Configure<ForwardedHeadersOptions>(options =>
        {
            options.ForwardedHeaders =
                ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto | ForwardedHeaders.XForwardedHost;
            options.KnownProxies.Add(IPAddress.Parse("127.0.0.1"));
        });
    }
    
    Console.WriteLine("WebApplicationBuilder creado");

    Console.WriteLine("=== DEBUGGING URLS ===");
    Console.WriteLine($"ASPNETCORE_URLS env: {Environment.GetEnvironmentVariable("ASPNETCORE_URLS")}");
    Console.WriteLine($"ASPNETCORE_URLS config: {builder.Configuration["ASPNETCORE_URLS"]}");
    Console.WriteLine($"Urls property: {string.Join(", ", builder.WebHost.GetSetting("urls") ?? "null")}");
    Console.WriteLine("======================");

    string aspnetcore_urls = builder.Configuration["ASPNETCORE_URLS"] ?? "";
    aspnetcore_urls = aspnetcore_urls.Trim().ToLowerInvariant();
    Console.WriteLine("URLs procesadas");

    builder.Services.AddControllersWithViews();
    Console.WriteLine("Controllers con Views agregados");

    builder.Services.AddHttpContextAccessor();
    Console.WriteLine("HttpContextAccessor registrado");

    builder.Services.AddScoped<AuthHeaderHandler>();
    bool useSsl = builder.Configuration.GetValue<bool>("UseSsl");
    Console.WriteLine($"SSL configurado: {useSsl}");

    // Escoge la URL del backend seg�n el valor de UseSsl
    string BaseApiUrlForClientHttp = builder.Configuration[
        aspnetcore_urls.Contains("https") ? "EndPoints:api:ssl" : "EndPoints:api:nossl"
    ] ?? "http://localhost:5274";
    Console.WriteLine($"Base API URL: {BaseApiUrlForClientHttp}");

    builder.Services.AddHttpClient<IHttpCustomClient, HttpCustomClient>(client =>
    {
        client.BaseAddress = new Uri(BaseApiUrlForClientHttp);
    }).AddHttpMessageHandler<AuthHeaderHandler>();
    Console.WriteLine("HttpClient configurado");

    // Managers
    builder.Services.AddScoped<EndPointsManager>();
    builder.Services.AddScoped<MedidasManager>();
    builder.Services.AddScoped<CitasManager>();
    builder.Services.AddScoped<EjerciciosManager>();
    builder.Services.AddScoped<RutinasManager>();
    builder.Services.AddScoped<UsersManager>();
    builder.Services.AddScoped<HorariosManager>();
    builder.Services.AddScoped<ClasesManager>();
    builder.Services.AddScoped<JwtTokenGenerator>();
    builder.Services.AddScoped<CookieService>();
    Console.WriteLine("Managers registrados");

    var jwtSection = builder.Configuration.GetSection("JwtSettings");
    var pagesSection = builder.Configuration.GetSection("pages");
    builder.Services.Configure<JwtSettings>(jwtSection);
    builder.Services.Configure<PagesSettings>(pagesSection);
    Console.WriteLine("Configuracion JWT y Pages cargada");

    var jwtSettings = jwtSection.Get<JwtSettings>();
    var pagesSettings = pagesSection.Get<PagesSettings>();
    var key = Encoding.UTF8.GetBytes(Environment.GetEnvironmentVariable("SECRET_TOKEN_KEY"));
    var LoginPath = pagesSettings.Login;
    var AccessDeniedPath = pagesSettings.Forbidden;
    Console.WriteLine($"Login Path: {LoginPath}");
    Console.WriteLine($"Access Denied Path: {AccessDeniedPath}");

    builder.Services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    }).AddJwtBearer(options =>
    {
        string audience = jwtSettings.FrontAudiencie;
        if (aspnetcore_urls.Contains("https"))
        {
            audience = jwtSettings.FrontendAudienceSsl;
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

        options.Events = new JwtBearerEvents
        {
            OnMessageReceived = context =>
            {
                var token = context.Request.Cookies["AuthToken"];
                if (!string.IsNullOrEmpty(token))
                {
                    context.Token = token;
                }
                return Task.CompletedTask;
            },
            OnChallenge = context =>
            {
                context.Response.Redirect(LoginPath);
                return Task.CompletedTask;
            },
            OnForbidden = context =>
            {
                context.Response.Redirect(AccessDeniedPath);
                return Task.CompletedTask;
            }
        };
    });
    Console.WriteLine("JWT Authentication configurado");

    builder.Services.ConfigureApplicationCookie(options =>
    {
        options.LoginPath = LoginPath;
        options.AccessDeniedPath = AccessDeniedPath;
    });
    Console.WriteLine("Application Cookie configurado");

    builder.Services.AddAuthorization();
    Console.WriteLine("Authorization agregado");

    builder.Services.AddRazorPages();
    Console.WriteLine("Razor Pages agregado");

    builder.Services.AddDataAccess();
    builder.Services.AddBusinessLayer();
    Console.WriteLine("DataAccess y BusinessLayer registrados");

    Console.WriteLine("========================================");
    Console.WriteLine("CONSTRUYENDO APLICACION...");
    Console.WriteLine("========================================");

    var app = builder.Build();
    Console.WriteLine("App construida exitosamente");

    if (app.Environment.IsStaging())
    {
        app.UseForwardedHeaders();
    }
    if (app.Environment.IsProduction())
    {
        app.UseForwardedHeaders();
    }
    var logger = app.Services.GetRequiredService<ILogger<Program>>();
    var config = app.Configuration;

    app.Lifetime.ApplicationStarted.Register(() =>
    {
        var addresses = app.Urls;
        var useSsl = config.GetValue<bool>("UseSsl");
        var jwtSettings = config.GetSection("JwtSettings").Get<JwtSettings>();

        Console.WriteLine("\n" + new string('=', 60));
        Console.WriteLine("APLICACION INICIADA");
        Console.WriteLine(new string('=', 60));

        foreach (var address in addresses)
        {
            logger.LogInformation($"Escuchando en: {address}");
            Console.WriteLine($"  {address}");
        }

        Console.WriteLine(new string('-', 60));
        Console.WriteLine("CONFIGURACION ACTIVA:");
        Console.WriteLine($"  � SSL Habilitado: {useSsl}");
        Console.WriteLine($"  � Issuer: {jwtSettings?.Issuer}");
        Console.WriteLine($"  � Audiencia Frontend: {(useSsl ? jwtSettings?.FrontendAudienceSsl : jwtSettings?.FrontAudiencie)}");
        Console.WriteLine($"  � Expiracion Token: {jwtSettings?.ExpiryMinutes} minutos");
        Console.WriteLine(new string('=', 60) + "\n");

        logger.LogInformation("Configuracion JWT cargada correctamente");
    });

    // Configure the HTTP request pipeline.
    if (!app.Environment.IsDevelopment())
    {

        app.UseExceptionHandler("/Home/Error");
        app.UseHsts();
        Console.WriteLine("Modo Production - Exception Handler y HSTS configurados");
    }
    else
    {
        Console.WriteLine("Modo Development");
    }
    if (app.Environment.IsDevelopment()) {
        if (useSsl)
        {
            app.UseHttpsRedirection();
        }
    }
    
    
    Console.WriteLine("HTTPS Redirection configurado");

    app.UseStaticFiles();
    Console.WriteLine("Static Files configurado");

    app.UseRouting();
    Console.WriteLine("Routing configurado");

    app.UseAuthentication();
    Console.WriteLine("Authentication middleware agregado");

    app.UseAuthorization();
    Console.WriteLine("Authorization middleware agregado");

    app.MapHealthChecks("/health", new HealthCheckOptions
    {
        ResponseWriter = async (context, report) =>
        {
            context.Response.ContentType = "application/json";
            var result = new { status = report.Status.ToString() };
            await JsonSerializer.SerializeAsync(context.Response.Body, result);
        }
    }).RequireRateLimiting("HealthPolicy");
    Console.WriteLine("Health check endpoint configurado en /health con rate limiting (100 req/min)");

    app.MapControllerRoute(
        name: "default",
        pattern: "{controller=Home}/{action=Index}/{id?}");
    Console.WriteLine("Controller Routes mapeadas");

    Console.WriteLine("========================================");
    Console.WriteLine("FRONTEND LISTO - INICIANDO SERVIDOR...");
    Console.WriteLine("========================================");

    app.Run();
}
catch (Exception ex)
{
    Console.WriteLine("========================================");
    Console.WriteLine("ERROR CRITICO AL INICIAR FRONTEND:");
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