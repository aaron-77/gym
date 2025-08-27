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
var builder = WebApplication.CreateBuilder(args);
//builder.Configuration.AddJsonFile("API/appsettings.json", optional: false, reloadOnChange: false);
var jwtSection = builder.Configuration.GetSection("JwtSettings");
builder.Services.Configure<JwtSettings>(jwtSection);

var jwtSettings = jwtSection.Get<JwtSettings>();
var key = Encoding.UTF8.GetBytes(jwtSettings.SecretKey);
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
        ValidAudience = jwtSettings.Audience,
        IssuerSigningKey = new SymmetricSecurityKey(key)
    };
});

/* buException has occurred: CLR/System.InvalidOperationException
An unhandled exception of type 'System.InvalidOperationException' occurred in Microsoft.Extensions.DependencyInjection.Abstractions.dll: 'The service collection cannot be modified because it is read-only.'
   at Microsoft.Extensions.DependencyInjection.ServiceCollection.ThrowReadOnlyException()
   at Microsoft.Extensions.DependencyInjection.ServiceCollection.System.Collections.Generic.ICollection<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>.Add(ServiceDescriptor item)
   at ilder.WebHost.ConfigureKestrel(options =>
{
    options.ListenAnyIP(5274); // Habilitar HTTP en el puerto 5000
    // options.ListenAnyIP(5001, listenOptions => listenOptions.UseHttps()); // Deshabilitar HTTPS
});
 */// Add services to the container.


builder.Services.AddCors(options =>
{
    options.AddPolicy("originsPolicyOne", policy =>
    {
        policy.WithOrigins("http://localhost:5062") 
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials();
        
    });
});


builder.Services.AddControllers(options =>
{
  options.SuppressImplicitRequiredAttributeForNonNullableReferenceTypes = true;
});
 builder.Services.AddSignalR();
 
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();


builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<DataAccess.EntityFramework.FitnessCenterDbContext>(options =>
{
    options.UseSqlServer("Server=localhost ;Authentication=SqlPassword;Integrated Security=False ;User Id=aaronlogin;Password=Terrabreak13;Database=FitnessCenterDB;TrustServerCertificate=True;Trusted_Connection=False");
});

var smtpSettings = builder.Configuration.GetSection("SmtpSettings");
string smtpServer = smtpSettings["Server"];
int smtpPort = int.Parse(smtpSettings["Port"]);
string smtpUsername = smtpSettings["Username"];
string smtpPassword = smtpSettings["Password"];

builder.Services.AddScoped(sp => new EmailManagerMailKit(smtpServer, smtpPort, smtpUsername, smtpPassword));
builder.Services.AddScoped<HorariosService>(); 
builder.Services.AddScoped<HttpCustomClient>(); 
builder.Services.AddHttpContextAccessor(); 
builder.Services.AddScoped<EndPointsManager>();
builder.Services.AddScoped<UserRoleService>();
builder.Services.AddScoped<ReservacionesHub>();
builder.Services.AddScoped<ServicioActualizacionesDeHorariosRealTime>();  
builder.Services.AddScoped<JwtTokenGenerator>();
builder.Services.AddScoped<AuthService>();

builder.Services.AddQuartz(configuration => {
    configuration.UseMicrosoftDependencyInjectionJobFactory();

    var jobKey = new JobKey(name:"AppointmentRemainder");
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
    //.WithCronSchedule("1 * * * * ?"));


});
builder.Services.AddQuartzHostedService(option => option.WaitForJobsToComplete = true);

builder.Services.AddQuartz(options => { options.UseMicrosoftDependencyInjectionJobFactory(); });
builder.Services.AddIdentity<ApplicationUser, IdentityRole>()
    .AddEntityFrameworkStores<FitnessCenterDbContext>()
    .AddDefaultTokenProviders();

builder.Services.ConfigureApplicationCookie(options =>
{
    options.LoginPath = $"/{builder.Configuration["urls"]}/SignIn" ;
    options.AccessDeniedPath = $"/{builder.Configuration["urls"]}/SignIn";
});
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("originsPolicyOne");
app.UseAuthentication();
app.UseAuthorization();

app.MapHub<ReservacionesHub>("/reservacionesHub");
app.MapControllers();

app.Run();
