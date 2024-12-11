using BL;
using BL.EnPointsLogic;
using BL.BackGroundWork.Jobs;
using Microsoft.EntityFrameworkCore;
using Quartz;

var builder = WebApplication.CreateBuilder(args);
builder.Configuration.AddJsonFile("appsettings.json", optional: false, reloadOnChange: false);


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


builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();


builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<DataAccess.EntityFramework.FitnessCenterDbContext>(options =>
{
    options.UseSqlServer("Server=localhost ;Authentication=SqlPassword;Integrated Security=False ;User Id=aaronlogin;Password=Terrabreak13;Database=FitnessCenterDB;TrustServerCertificate=True;Trusted_Connection=False");
});
builder.Services.AddScoped<EmailManager>();

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

// Configure the HTTP request pipeline .
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();
app.UseCors("originsPolicyOne");
app.UseAuthorization();

app.MapControllers();

app.Run();
