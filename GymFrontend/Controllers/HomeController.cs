using GymFrontend.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace GymFrontend.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IConfiguration _config;
        public HomeController(ILogger<HomeController> logger, IConfiguration configuration)
        {
            _logger = logger;
            _config = configuration;
        }

        public IActionResult Index()
        {

            var seccion = _config.GetValue<string>("EndPoints:Enpoint1", "vacio");
            string controllerPath = GetType().Assembly.Location;
            Console.WriteLine($"Ubicación física del controlador: {controllerPath}");
            return View("Index");
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
