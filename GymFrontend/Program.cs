using System.Net;
using System.Text;
using System.Text.Json;
using System.Threading.RateLimiting;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Serilog;
using BL;
using BL.EnPointsLogic;
using BL.Utils;
using DataAccess;
using DTO.Dtos;

namespace GymFrontend
{
    public class Program
    {
        public static async Task Main(string[] args)
        {
            try
            {
                Console.WriteLine("========================================");
                Console.WriteLine("INICIANDO FRONTEND...");
                Console.WriteLine("========================================");

                var builder = WebApplication.CreateBuilder(args);
                // se añade serilog
                Log.Logger = new LoggerConfiguration()
                    .ReadFrom.Configuration(builder.Configuration)
                    .Enrich.FromLogContext()
                    .WriteTo.Console()
                    .WriteTo.File("logs/frontendlogs-.log", rollingInterval: RollingInterval.Day)
                    
                    .CreateLogger();
                builder.Host.UseSerilog();

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
                if (builder.Environment.IsProduction() || builder.Environment.IsStaging())
                {
                    builder.Services.Configure<ForwardedHeadersOptions>(options =>
                    {
                        options.ForwardedHeaders =
                            ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto | ForwardedHeaders.XForwardedHost;
                        options.KnownProxies.Add(IPAddress.Parse("127.0.0.1"));
                    });
                }

                Log.Logger.Information("WebApplicationBuilder creado");

                Log.Logger.Information("=== DEBUGGING URLS ===");
                Log.Logger.Information("ASPNETCORE_URLS env: {Urls}", Environment.GetEnvironmentVariable("ASPNETCORE_URLS"));
                Log.Logger.Information("ASPNETCORE_URLS config: {Urls}", builder.Configuration["ASPNETCORE_URLS"]);
                Log.Logger.Information("Urls property: {Urls}", string.Join(", ", builder.WebHost.GetSetting("urls") ?? "null"));
                Log.Logger.Information("======================");

                string aspnetcoreUrls = builder.Configuration["ASPNETCORE_URLS"] ?? "";
                aspnetcoreUrls = aspnetcoreUrls.Trim().ToLowerInvariant();
                Log.Logger.Information("URLs procesadas");

                builder.Services.AddControllersWithViews();
                Log.Logger.Information("Controllers con Views agregados");

                builder.Services.AddHttpContextAccessor();
                Log.Logger.Information("HttpContextAccessor registrado");

                builder.Services.AddScoped<AuthHeaderHandler>();
                bool useSsl = builder.Configuration.GetValue<bool>("UseSsl");
                Log.Logger.Information("SSL configurado: {UseSsl}", useSsl);

                // Escoge la URL del backend según si las URLs contienen https
                string baseApiUrlForClientHttp = builder.Configuration[
                    aspnetcoreUrls.Contains("https") ? "EndPoints:api:ssl" : "EndPoints:api:nossl"
                ] ?? "http://localhost:5274";
                Log.Logger.Information("Base API URL: {BaseApiUrl}", baseApiUrlForClientHttp);

                builder.Services.AddHttpClient<IHttpCustomClient, HttpCustomClient>(client =>
                {
                    client.BaseAddress = new Uri(baseApiUrlForClientHttp);
                }).AddHttpMessageHandler<AuthHeaderHandler>();
                Log.Logger.Information("HttpClient configurado");

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
                Log.Logger.Information("Managers registrados");

                var jwtSection = builder.Configuration.GetSection("JwtSettings");
                var pagesSection = builder.Configuration.GetSection("pages");
                builder.Services.Configure<JwtSettings>(jwtSection);
                builder.Services.Configure<PagesSettings>(pagesSection);
                Log.Logger.Information("Configuracion JWT y Pages cargada");

                var jwtSettings = jwtSection.Get<JwtSettings>();
                var pagesSettings = pagesSection.Get<PagesSettings>();
                var key = Encoding.UTF8.GetBytes(Environment.GetEnvironmentVariable("SECRET_TOKEN_KEY"));
                var loginPath = pagesSettings.Login;
                var accessDeniedPath = pagesSettings.Forbidden;
                Log.Logger.Information("Login Path: {LoginPath}", loginPath);
                Log.Logger.Information("Access Denied Path: {AccessDeniedPath}", accessDeniedPath);

                builder.Services.AddAuthentication(options =>
                {
                    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                }).AddJwtBearer(options =>
                {
                    string audience = jwtSettings.FrontAudiencie;
                    if (aspnetcoreUrls.Contains("https"))
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
                            context.HandleResponse();
                            context.Response.Redirect(loginPath);
                            return Task.CompletedTask;
                        },
                        OnForbidden = context =>
                        {
                            context.Response.Redirect(accessDeniedPath);
                            return Task.CompletedTask;
                        }
                    };
                });
                Log.Logger.Information("JWT Authentication configurado");

                builder.Services.ConfigureApplicationCookie(options =>
                {
                    options.LoginPath = loginPath;
                    options.AccessDeniedPath = accessDeniedPath;
                });
                Log.Logger.Information("Application Cookie configurado");

                builder.Services.AddAuthorization();
                Log.Logger.Information("Authorization agregado");

                // Connection String para el DbContext
                var dbConnectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING")
                    ?? builder.Configuration.GetConnectionString("DefaultConnection");

                builder.Services.AddDbContext<DataAccess.EntityFramework.FitnessCenterDbContext>(options =>
                    options.UseSqlServer(dbConnectionString));
                Log.Logger.Information("DbContext configurado");

                builder.Services.AddRazorPages();
                Log.Logger.Information("Razor Pages agregado");

                builder.Services.AddDataAccess();
                builder.Services.AddBusinessLayer();
                Log.Logger.Information("DataAccess y BusinessLayer registrados");

                Log.Logger.Information("========================================");
                Log.Logger.Information("CONSTRUYENDO APLICACION...");
                Log.Logger.Information("========================================");

                var app = builder.Build();
                Log.Logger.Information("App construida exitosamente");

                if (app.Environment.IsStaging() || app.Environment.IsProduction())
                {
                    app.UseForwardedHeaders();
                }
                var logger = app.Services.GetRequiredService<ILogger<Program>>();
                var config = app.Configuration;

                app.Lifetime.ApplicationStarted.Register(() =>
                {
                    var addresses = app.Urls;
                    var useSslConfig = config.GetValue<bool>("UseSsl");
                    var jwtSettingsConfig = config.GetSection("JwtSettings").Get<JwtSettings>();

                    logger.LogInformation("");
                    logger.LogInformation("APLICACION INICIADA");
                    logger.LogInformation("");

                    foreach (var address in addresses)
                    {
                        logger.LogInformation("Escuchando en: {Address}", address);
                    }

                    logger.LogInformation("--- CONFIGURACION ACTIVA ---");
                    logger.LogInformation("SSL Habilitado: {UseSsl}", useSslConfig);
                    logger.LogInformation("Issuer: {Issuer}", jwtSettingsConfig?.Issuer);
                    logger.LogInformation("Audiencia Frontend: {Audience}", useSslConfig ? jwtSettingsConfig?.FrontendAudienceSsl : jwtSettingsConfig?.FrontAudiencie);
                    logger.LogInformation("Expiracion Token: {ExpiryMinutes} minutos", jwtSettingsConfig?.ExpiryMinutes);
                    logger.LogInformation("");

                    logger.LogInformation("Configuracion JWT cargada correctamente");
                });

                // Configure the HTTP request pipeline.
                if (!app.Environment.IsDevelopment())
                {
                    app.UseExceptionHandler("/Home/Error");
                    app.UseHsts();
                    Log.Logger.Information("Modo Production - Exception Handler y HSTS configurados");
                }
                else
                {
                    Log.Logger.Information("Modo Development");
                }
                if (app.Environment.IsDevelopment())
                {
                    if (useSsl)
                    {
                        app.UseHttpsRedirection();
                    }
                }

                Log.Logger.Information("HTTPS Redirection configurado");

                app.UseStaticFiles();
                Log.Logger.Information("Static Files configurado");

                app.UseRouting();
                Log.Logger.Information("Routing configurado");

                app.UseAuthentication();
                Log.Logger.Information("Authentication middleware agregado");

                app.UseAuthorization();
                Log.Logger.Information("Authorization middleware agregado");

                app.MapHealthChecks("/health", new HealthCheckOptions
                {
                    ResponseWriter = async (context, report) =>
                    {
                        context.Response.ContentType = "application/json";
                        var result = new { status = report.Status.ToString() };
                        await JsonSerializer.SerializeAsync(context.Response.Body, result);
                    }
                }).RequireRateLimiting("HealthPolicy");
                Log.Logger.Information("Health check endpoint configurado en /health con rate limiting (100 req/min)");

                app.MapControllers();
                app.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");
                Log.Logger.Information("Controller Routes mapeadas");

                Log.Logger.Information("========================================");
                Log.Logger.Information("FRONTEND LISTO - INICIANDO SERVIDOR...");
                Log.Logger.Information("========================================");

                await app.RunAsync();
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
        }
    }
}