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
                        options.KnownProxies.Add(IPAddress.Parse("172.17.0.1")); // gateway del bridge Docker (verificado con ip route)
                    });
                }

                builder.Services.AddControllersWithViews();

                builder.Services.AddHttpContextAccessor();

                builder.Services.AddScoped<AuthHeaderHandler>();
                bool useSsl = builder.Configuration.GetValue<bool>("UseSsl");

                // Permite que cada entorno indique cómo el frontend alcanza al API.
                // Si no hay variable de entorno, conserva la configuración existente.
                string? baseApiUrlForClientHttp = builder.Configuration["BACKEND_BASE_ADDRESS"];
                if (string.IsNullOrWhiteSpace(baseApiUrlForClientHttp))
                {
                    string apiEndpointKey = useSsl ? "EndPoints:api:ssl" : "EndPoints:api:nossl";
                    baseApiUrlForClientHttp = builder.Configuration[apiEndpointKey];
                }

                if (string.IsNullOrWhiteSpace(baseApiUrlForClientHttp))
                {
                    throw new InvalidOperationException(
                        "Falta BACKEND_BASE_ADDRESS y no se encontró EndPoints:api:ssl/nossl en la configuración.");
                }

                if (!Uri.TryCreate(baseApiUrlForClientHttp, UriKind.Absolute, out var baseApiUri) ||
                    (baseApiUri.Scheme != Uri.UriSchemeHttp && baseApiUri.Scheme != Uri.UriSchemeHttps))
                {
                    throw new InvalidOperationException(
                        "BACKEND_BASE_ADDRESS o EndPoints:api debe contener una URL absoluta HTTP o HTTPS.");
                }

                Log.Logger.Information("Base API URL: {BaseApiUrl}", baseApiUrlForClientHttp);

                builder.Services.AddHttpClient<IHttpCustomClient, HttpCustomClient>(client =>
                {
                    client.BaseAddress = baseApiUri;
                }).AddHttpMessageHandler<AuthHeaderHandler>();
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
                var jwtSection = builder.Configuration.GetSection("JwtSettings");
                var pagesSection = builder.Configuration.GetSection("pages");
                builder.Services.Configure<JwtSettings>(jwtSection);
                builder.Services.Configure<PagesSettings>(pagesSection);
                builder.Services.Configure<TestCredentialsForRealUsers>(builder.Configuration.GetSection("TestCredentialsForRealUsers"));
                var jwtSettings = jwtSection.Get<JwtSettings>()
                    ?? throw new InvalidOperationException("Falta la sección JwtSettings en la configuración.");
                var pagesSettings = pagesSection.Get<PagesSettings>()
                    ?? throw new InvalidOperationException("Falta la sección pages en la configuración.");
                if (string.IsNullOrWhiteSpace(pagesSettings.Login) || string.IsNullOrWhiteSpace(pagesSettings.Forbidden))
                {
                    throw new InvalidOperationException("pages.Login y pages.Forbidden deben estar configurados.");
                }

                var secretTokenKey = Environment.GetEnvironmentVariable("SECRET_TOKEN_KEY");
                if (string.IsNullOrWhiteSpace(secretTokenKey))
                {
                    throw new InvalidOperationException(
                        "Falta la variable de entorno SECRET_TOKEN_KEY: no hay clave secreta JWT disponible para este entorno. " +
                        "Lance el proceso con el envoltorio de Infisical (infisical run) o complete la variable.");
                }
                var key = Encoding.UTF8.GetBytes(secretTokenKey);
                var loginPath = pagesSettings.Login;
                var accessDeniedPath = pagesSettings.Forbidden;

                builder.Services.AddAuthentication(options =>
                {
                    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                }).AddJwtBearer(options =>
                {
                    string audience = jwtSettings.FrontAudiencie;
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
                builder.Services.ConfigureApplicationCookie(options =>
                {
                    options.LoginPath = loginPath;
                    options.AccessDeniedPath = accessDeniedPath;
                });
                builder.Services.AddAuthorization();

                // Connection String para el DbContext
                var dbConnectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING")
                    ?? builder.Configuration.GetConnectionString("DefaultConnection");

                if (string.IsNullOrWhiteSpace(dbConnectionString))
                {
                    throw new InvalidOperationException(
                        "Falta la variable de entorno DB_CONNECTION_STRING: no hay cadena de conexion disponible para este entorno. " +
                        "Lance el proceso con el envoltorio de Infisical (infisical run) o complete la variable.");
                }

                builder.Services.AddDbContext<DataAccess.EntityFramework.FitnessCenterDbContext>(options =>
                    options.UseSqlServer(dbConnectionString));

                builder.Services.AddRazorPages();

                builder.Services.AddDataAccess();
                builder.Services.AddBusinessLayer();

                var app = builder.Build();

                if (app.Environment.IsStaging() || app.Environment.IsProduction())
                {
                    app.UseForwardedHeaders();
                }
                var logger = app.Services.GetRequiredService<ILogger<Program>>();

                app.Lifetime.ApplicationStarted.Register(() =>
                {
                    logger.LogInformation("Frontend iniciado en {Addresses}", string.Join(", ", app.Urls));
                });

                // Configure the HTTP request pipeline.
                if (!app.Environment.IsDevelopment())
                {
                    app.UseExceptionHandler("/Home/Error");
                    app.UseHsts();
                }

                app.UseStaticFiles();

                app.UseRouting();

                app.UseAuthentication();

                app.UseAuthorization();

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
                app.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");
                await app.RunAsync();
            }
            catch (Exception ex)
            {
                Log.Fatal(ex, "Error crítico al iniciar el frontend.");
                Environment.Exit(1);
            }
        }
    }
}
