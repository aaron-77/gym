using System.Collections.Generic;
using System.Diagnostics;
using System.Net.Http;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using BL;
using DTO.Dtos;
using GymFrontend.Models;
using Microsoft.AspNetCore.Mvc;

namespace GymFrontend.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IConfiguration _config;
        private readonly IHttpCustomClient client;
        private readonly ClasesManager _clasesManager;

        public HomeController(ILogger<HomeController> logger, IConfiguration configuration, IHttpCustomClient httpClient, ClasesManager clasesManager)
        {
            _logger = logger;
            _config = configuration;
            client = httpClient;
            _clasesManager = clasesManager;
        }

        public async Task<IActionResult> Index()
        {
            _logger?.LogInformation("HomeController.Index called");
            try
            {
                var response = await _clasesManager.ObtenerPreviewDeClases();
                if (response?.success == true && response.payload != null)
                {
                    return View(response.payload);
                }
                return View(new List<DTOClasePreview>());
            }
            catch (Exception ex)
            {
                _logger?.LogError(ex, "Error loading class previews");
                return View(new List<DTOClasePreview>());
            }
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(
                new ErrorViewModel
                {
                    RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier,
                }
            );
        }

        public async Task<IActionResult> DetalleDeClase(int idClase)
        {
            try
            {
                _logger?.LogInformation("Start HomeController.DetalleDeClase idClase={Id}", idClase);
                string endpointUrl = $"api/clases/detallesDeClase?idClase={idClase}";
                var responseString = await client.get(endpointUrl);
                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };

                var response = JsonSerializer.Deserialize<DTOResponse<DetalleDeClase>>(responseString, options);

                if (response != null && response.success)
                {
                    return View("DetalleDeClase", response.payload);
                }
                else
                {
                    return View("Error");
                }
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] M�todo: DetalleDeClase | " +
                    $"L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Par�metro - IdClase: {idClase} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return View("Error");
            }
        }
    }
}
