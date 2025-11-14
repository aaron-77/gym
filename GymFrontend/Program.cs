using System.Text;
using BL;
using BL.EnPointsLogic;
using BL.Utils;
using DTO.Dtos;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using DataAccess;
;

var builder = WebApplication.CreateBuilder(args);

Console.WriteLine("=== DEBUGGING URLS ===");
Console.WriteLine($"ASPNETCORE_URLS env: {Environment.GetEnvironmentVariable("ASPNETCORE_URLS")}");
Console.WriteLine($"ASPNETCORE_URLS config: {builder.Configuration["ASPNETCORE_URLS"]}");
Console.WriteLine($"Urls property: {string.Join(", ", builder.WebHost.GetSetting("urls") ?? "null")}");
Console.WriteLine("======================");

string aspnetcore_urls = builder.Configuration["ASPNETCORE_URLS"] ?? "";
aspnetcore_urls = aspnetcore_urls.Trim().ToLowerInvariant();

builder.Services.AddControllersWithViews();//.AddRazorRuntimeCompilation();
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<AuthHeaderHandler>();
bool useSsl = builder.Configuration.GetValue<bool>("UseSsl");

// Escoge la URL del backend según el valor de UseSsl
string BaseApiUrlForClientHttp = builder.Configuration[
    aspnetcore_urls.Contains("https") ? "EndPoints:api:ssl" : "EndPoints:api:nossl"
] ?? "http://localhost:5274";


builder.Services.AddHttpClient<HttpCustomClient>(client =>
{
    client.BaseAddress = new Uri(BaseApiUrlForClientHttp);
}).AddHttpMessageHandler<AuthHeaderHandler>();

builder.Services.AddScoped<EndPointsManager>();
builder.Services.AddScoped<MedidasManager>();
builder.Services.AddScoped<CitasManager>();
builder.Services.AddScoped<EjerciciosManager>();
builder.Services.AddScoped<RutinasManager>();
builder.Services.AddScoped<UsersManager>();
builder.Services.AddScoped<HorariosManager>(); // Eliminado
 builder.Services.AddScoped<ClasesManager>(); // Eliminado
builder.Services.AddScoped<JwtTokenGenerator>();
builder.Services.AddScoped<CookieService>();


var jwtSection = builder.Configuration.GetSection("JwtSettings");
var pagesSection = builder.Configuration.GetSection("pages");
builder.Services.Configure<JwtSettings>(jwtSection);
builder.Services.Configure<PagesSettings>(pagesSection);
var jwtSettings = jwtSection.Get<JwtSettings>();
var pagesSettings = pagesSection.Get<PagesSettings>();
var key = Encoding.UTF8.GetBytes(Environment.GetEnvironmentVariable("SECRET_TOKEN_KEY"));
var LoginPath = pagesSettings.Login;
var AccessDeniedPath = pagesSettings.Forbidden;
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    string audience = jwtSettings.FrontAudiencie;
    if (aspnetcore_urls.Contains("https")) {
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
        // Esto permite que lea el token desde una cookie en lugar de Authorization header
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


builder.Services.ConfigureApplicationCookie(options =>
{
    options.LoginPath = LoginPath;
    options.AccessDeniedPath = AccessDeniedPath;
});
builder.Services.AddAuthorization();
builder.Services.AddRazorPages();


builder.Services.AddDataAccess(); // Agregado
builder.Services.AddBusinessLayer(); // Agregado


/*
if (builder.Environment.IsDevelopment()) {
    builder.WebHost.ConfigureKestrel(options =>
    {
        options.ListenLocalhost(5062); // puerto HTTP opcional
        options.ListenLocalhost(7700, listenOptions =>
        {
            listenOptions.UseHttps();
        });
    });
} else if (builder.Environment.IsProduction()) {

    builder.WebHost.ConfigureKestrel(options =>
    {
        options.ListenLocalhost(5062); // puerto HTTP opcional
   });
}
*/
var app = builder.Build();

var logger = app.Services.GetRequiredService<ILogger<Program>>();
var config = app.Configuration;

app.Lifetime.ApplicationStarted.Register(() =>
{
    var addresses = app.Urls;
    var useSsl = config.GetValue<bool>("UseSsl");
    var jwtSettings = config.GetSection("JwtSettings").Get<JwtSettings>();
    
    Console.WriteLine("\n" + new string('=', 60));
    Console.WriteLine("?? APLICACIÓN INICIADA");
    Console.WriteLine(new string('=', 60));
    
    foreach (var address in addresses)
    {
        logger.LogInformation($"Escuchando en: {address}");
        Console.WriteLine($"  ? {address}");
    }
    
    Console.WriteLine(new string('-', 60));
    Console.WriteLine("??  CONFIGURACIÓN ACTIVA:");
    Console.WriteLine($"  • SSL Habilitado: {useSsl}");
    Console.WriteLine($"  • Issuer: {jwtSettings?.Issuer}");
    Console.WriteLine($"  • Audiencia Frontend: {(useSsl ? jwtSettings?.FrontendAudienceSsl : jwtSettings?.FrontAudiencie)}");
    Console.WriteLine($"  • Expiración Token: {jwtSettings?.ExpiryMinutes} minutos");
    Console.WriteLine(new string('=', 60) + "\n");
    
    logger.LogInformation("Configuración JWT cargada correctamente");
});

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.n
    app.UseHsts();
}


app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");


app.Run();
