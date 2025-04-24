using GymFrontend.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using DTO.Dtos;
using System.Collections.Generic;
using System.Text.Json.Serialization;
using System.Net.Http;
using System.Threading.Tasks;
using BL;
using System.Text.Json;
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
            // Crear una lista de ejemplo de clases basada en las descripciones originales
            var clasesPreview = new List<DTOClasePreview>
            {
                new DTOClasePreview
                {
                    idClase = 5,
                    urlImage = "/img/hiit.jpg",
                    nombreClase = "Entrenamiento HIIT",
                    descripcionCortaClase = "Entrenamiento de intervalos de alta intensidad para maximizar la quema de caloru00edas y mejorar la salud cardiovascular."
                },
                new DTOClasePreview
                {
                    idClase = 2,
                    urlImage = "/img/strength.jpg",
                    nombreClase = "Fuerza y Potencia",
                    descripcionCortaClase = "Desarrolla mu00fasculo, aumenta la fuerza y desarrolla potencia explosiva con nuestro programa de fuerza integral."
                },
                new DTOClasePreview
                {
                    idClase = 3,
                    urlImage = "/img/crossfit.jpg",
                    nombreClase = "CrossFit",
                    descripcionCortaClase = "Combina fuerza y acondicionamiento en movimientos funcionales variados realizados a alta intensidad."
                },
                new DTOClasePreview
                {
                    idClase = 4,
                    urlImage = "/img/boxing.jpg",
                    nombreClase = "Boxeo",
                    descripcionCortaClase = "Aprende tu00e9cnicas de boxeo mientras obtienes un entrenamiento de cuerpo completo que mejora la coordinaciu00f3n y quema caloru00edas."
                },
                new DTOClasePreview
                {
                    idClase = 1,
                    urlImage = "/img/functional.jpg",
                    nombreClase = "Entrenamiento Funcional",
                    descripcionCortaClase = "Mejora tus movimientos diarios con ejercicios que simulan actividades comunes."
                },
                new DTOClasePreview
                {
                    idClase = 6,
                    urlImage = "/img/personal.jpg",
                    nombreClase = "Entrenamiento Personal",
                    descripcionCortaClase = "Obtu00e9n atenciu00f3n personalizada y entrenamientos personalizados para alcanzar tus objetivos especu00edficos de fitness."
                }
            };

            return View(clasesPreview);
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

        public async Task<IActionResult> DetalleDeClase(int idClase)
        {
            var client = new HttpCustomClient();
            string endpointUrl = $"api/clases/detallesDeClase?idClase={idClase}";
            var responseString = await client.get(endpointUrl);
            var response = JsonSerializer.Deserialize<DTOResponse<DetalleDeClase>>(responseString);

            if (response != null && response.success)
            {
                return View("DetalleDeClase", response.payload);
            }
            else
            {
                return View("Error");
            }
        }
    }
}
