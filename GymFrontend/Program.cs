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

/* var defaultCulture = new CultureInfo("es-MX");
var localizationOptions = new RequestLocalizationOptions
{
    DefaultRequestCulture = new RequestCulture(defaultCulture),
    SupportedCultures = new List<CultureInfo> { defaultCulture },
    SupportedUICultures = new List<CultureInfo> { defaultCulture }
}; */

// Add services to the container.
builder.Services.AddControllersWithViews();//.AddRazorRuntimeCompilation();
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<AuthHeaderHandler>();
builder.Services.AddHttpClient<HttpCustomClient>(client =>
{
    client.BaseAddress = new Uri(builder.Configuration["backendAddresses:nossl"]);
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
//builder.Configuration.AddJsonFile("GymFrontend/appsettings.json", optional: false, reloadOnChange: false);

var jwtSection = builder.Configuration.GetSection("JwtSettings");
var pagesSection = builder.Configuration.GetSection("pages");
builder.Services.Configure<JwtSettings>(jwtSection);
builder.Services.Configure<PagesSettings>(pagesSection);
var jwtSettings = jwtSection.Get<JwtSettings>();
var pagesSettings = pagesSection.Get<PagesSettings>();
var key = Encoding.UTF8.GetBytes(jwtSettings.SecretKey);
var LoginPath = pagesSettings.Login;
var AccessDeniedPath = pagesSettings.Forbidden;
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtSettings.Issuer,
        ValidAudience = jwtSettings.FrontAudiencie,
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

var app = builder.Build();

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
