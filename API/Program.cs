using BL;
using BL.EnPointsLogic;
using BL.BackGroundWork.Jobs;
using Microsoft.EntityFrameworkCore;
using Quartz;
using BL.Utils;
using API.Hubs;
using API.Services;
var builder = WebApplication.CreateBuilder(args);
builder.Configuration.AddJsonFile("API/appsettings.json", optional: false, reloadOnChange: false);


/* builder.WebHost.ConfigureKestrel(options =>
{
    options.ListenAnyIP(5274); // Habilitar HTTP en el puerto 5000
    // options.ListenAnyIP(5001, listenOptions => listenOptions.UseHttps()); // Deshabilitar HTTPS
});
 */// Add services to the container.
builder.Services.AddCors(options =>
{
    options.AddPolicy("originsPolicyOne", policy =>
    {
        policy.AllowAnyOrigin() // Aqu� puedes agregar los or�genes permitidos
              .AllowAnyHeader()
              .AllowAnyMethod();
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


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("originsPolicyOne");
app.UseAuthorization();
app.MapHub<ReservacionesHub>("/reservacionesRt");
app.MapControllers();

app.Run();
