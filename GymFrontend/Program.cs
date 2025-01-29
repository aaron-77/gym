using BL;
using BL.EnPointsLogic;

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
builder.Services.AddScoped<HttpCustomClient>();
builder.Services.AddScoped<EndPointsManager>();
builder.Services.AddScoped<MedidasManager>();
builder.Services.AddScoped<CitasManager>();
builder.Services.AddScoped<EjerciciosManager>();
builder.Services.AddScoped<RutinasManager>();
builder.Services.AddScoped<UsersManager>();




var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");


app.Run();
