using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace GymFrontend.Controllers
{
    public class ClasesController : Controller
    {
        [HttpGet]
        [Route("registrarClase")]
        public IActionResult RegistroDeClases()
        {
            // Datos de ejemplo para los combobox
            ViewBag.Instructores = new List<dynamic>
            {
                new { Id = 1, Nombre = "Alex Rodriguez" },
                new { Id = 2, Nombre = "Sarah Johnson" },
                new { Id = 3, Nombre = "Mike Williams" },
                new { Id = 4, Nombre = "Emma Davis" }
            };

            ViewBag.Intensidades = new List<dynamic>
            {
                new { Id = 1, Nombre = "Baja" },
                new { Id = 2, Nombre = "Media" },
                new { Id = 3, Nombre = "Alta" },
                new { Id = 4, Nombre = "Extrema" }
            };

            ViewBag.Dificultades = new List<dynamic>
            {
                new { Id = 1, Nombre = "Principiante" },
                new { Id = 2, Nombre = "Intermedio" },
                new { Id = 3, Nombre = "Avanzado" },
                new { Id = 4, Nombre = "Experto" }
            };

            return View();
        }

        [HttpGet]
        [Route("registroClasesProgramadas")]
        public IActionResult RegistroDeClasesProgramadas()
        {
            return View();
        }
    }
} 