using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using BL;
using DTO.Dtos;
using System.Threading.Tasks;
using System;
using BL.Utils;

namespace GymFrontend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ClasesController : Controller
    {
        private readonly ClasesManager _clasesManager;

        public ClasesController(ClasesManager clasesManager)
        {
            _clasesManager = clasesManager;
        }

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

        [HttpGet]
        [Route("inscripcionAClases")]
        public IActionResult InscripcionAClases()
        {
            return View();
        }

        [HttpPost]
        [Route("inscripcionAClases")]
        public async Task<IActionResult> InscribirAClase([FromBody] DTOInscripcionAClase inscripcionAClase)
        {
            try
            {
                var result = await _clasesManager.InscribirAClase(inscripcionAClase);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new DTOResponse<int?> { success = false, message = "Error interno del servidor al inscribir a clase.", errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } } });
            }
        }

        

        [HttpGet("obtenerClases")]
        public async Task<IActionResult> ObtenerClases([FromQuery] bool? activa = null)
        {
            try
            {
                var result = await _clasesManager.ObtenerClases(activa);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new DTOResponse<List<DTOClaseSimple>> { success = false, message = "Error interno del servidor al obtener clases.", errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } } });
            }
        }

        [HttpGet("obtenerClasesProgramadasPorId")]
        public async Task<IActionResult> ObtenerClasesProgramadasPorId([FromQuery] int? idClase = null)
        {
            try
            {
                var result = await _clasesManager.ObtenerClasesProgramadasPorId(idClase);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500,ResponseManager.BuildResponse<DTOResponse<List<DTOClaseProgramadaView>>> (false,500 ,"Error interno del servidor al obtener clases programadas por ID.", new List<ErrorModel> { new ErrorModel { message = ex.Message } },null));
            }
        }

        [HttpGet("obtenerEstadosDeClasesProgramdas")]
        public async Task<IActionResult> ObtenerEstadosDeClasesProgramdas()
        {
            try
            {
                var result = await _clasesManager.ObtenerEstadosDeClasesProgramdas();
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new DTOResponse<List<DTOEstadoClaseProgramada>> { success = false, message = "Error interno del servidor al obtener estados de clases programadas.", errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } } });
            }
        }

        [HttpPost("registrarClaseProgramada")]
        public async Task<IActionResult> RegistrarClaseProgramada([FromBody] DTODatosClaseProgramada claseProgramadaRegistro)
        {
            try
            {
                var result = await _clasesManager.RegistrarClaseProgramada(claseProgramadaRegistro);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new DTOResponse<string> { success = false, message = "Error interno del servidor al registrar clase programada.", errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } } });
            }
        }
    }
} 