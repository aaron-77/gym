using BL;
using BL.Utils;
using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GymFrontend.Controllers
{
    [Route("[controller]")]
   [ApiController]
    public class ClasesController : Controller
    {
        private readonly ClasesManager _clasesManager;
        private readonly Microsoft.Extensions.Logging.ILogger<ClasesController> _logger;

        public ClasesController(ClasesManager clasesManager, Microsoft.Extensions.Logging.ILogger<ClasesController> logger)
        {
            _clasesManager = clasesManager;
            _logger = logger;
        }

        [HttpGet]
        [Route("registrarClase")]
        public async Task<IActionResult> RegistroDeClases()
        {
            try
            {
                _logger?.LogInformation("Start ClasesController.RegistroDeClases (API Based)");

                // Consultar datos desde la API en paralelo
                var taskInstructores = _clasesManager.ObtenerInstructores();
                var taskIntensidades = _clasesManager.ObtenerNivelesDeIntensidad();
                var taskDificultades = _clasesManager.ObtenerNivelesDeDificultad();

                await Task.WhenAll(taskInstructores, taskIntensidades, taskDificultades);

                var respInstructores = await taskInstructores;
                var respIntensidades = await taskIntensidades;
                var respDificultades = await taskDificultades;

                ViewBag.Instructores = respInstructores.success ? respInstructores.payload : new List<QueryUser>();
                ViewBag.Intensidades = respIntensidades.success ? respIntensidades.payload : new List<DTOIntensidad>();
                ViewBag.Dificultades = respDificultades.success ? respDificultades.payload : new List<DTODificultad>();

                return View();
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: RegistroDeClases | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error RegistroDeClases");
                ViewBag.message = "Error al cargar la vista de registro de clases.";
                
                ViewBag.Instructores = new List<QueryUser>();
                ViewBag.Intensidades = new List<DTOIntensidad>();
                ViewBag.Dificultades = new List<DTODificultad>();
                
                return View();
            }
        }

        [Authorize(Roles = "empleado")]

        [HttpGet]
        [Route("registroClasesProgramadas")]
        public IActionResult RegistroDeClasesProgramadas()
        {
            try
            {
                return View();
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] M�todo: RegistroDeClasesProgramadas | L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                ViewBag.message = "Error al cargar la vista de clases programadas.";
                return View();
            }
        }

        [Authorize(Roles = "empleado")]

        [HttpGet]
        [Route("inscripcionAClases")]
        public IActionResult InscripcionAClases()
        {
            try
            {
                return View();
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] M�todo: InscripcionAClases (GET) | L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                ViewBag.message = "Error al cargar la vista de inscripci�n a clases.";
                return View();
            }
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
                string logMessage = $"[ERROR] M�todo: InscribirAClase | L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
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
                string logMessage = $"[ERROR] M�todo: ObtenerClases | " +
                    $"L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Par�metro - Activa: {activa} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return StatusCode(500, new DTOResponse<List<DTOClaseSimple>> { success = false, message = "Error interno del servidor al obtener clases.", errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } } });
            }
        }

        [HttpGet("obtenerClasesProgramadasPorId")]
        public async Task<IActionResult> ObtenerClasesProgramadasPorId([FromQuery] int? idClase = null, [FromQuery] DateOnly? fecha = null)
        {
            // Validar el modelo (defensivo; una fecha malformada ya cortocircuita con 400 por [ApiController])
            if (!ModelState.IsValid)
            {
                return BadRequest(
                    ResponseManager.BuildResponse<List<DTOClaseProgramadaView>>(
                        false,
                        400,
                        "Datos inválidos",
                        ModelState
                            .Values.SelectMany(v => v.Errors)
                            .Select(e => new ErrorModel
                            {
                                propiedad = "NONE",
                                message = e.ErrorMessage,
                            })
                            .ToList(),
                        null
                    )
                );
            }

            try
            {
                var result = await _clasesManager.ObtenerClasesProgramadasPorId(idClase, fecha);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] M�todo: ObtenerClasesProgramadasPorId | " +
                    $"L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Par�metro - IdClase: {idClase} | " +
                    $"Par�metro - Fecha: {fecha} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
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
                _logger?.LogError(ex, "Error ObtenerEstadosDeClasesProgramdas (ClasesController) ",$"MENSAJE DE ERROR: {ex.Message} \n STACKTRACE: {ex.StackTrace} \n EXCEPCION INTERNA {ex.InnerException} \n");
                string logMessage = $"[ERROR] M�todo: ObtenerEstadosDeClasesProgramdas | " +
                    $"L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return StatusCode(500, new DTOResponse<List<DTOEstadoClaseProgramada>> { success = false, message = "Error interno del servidor al obtener estados de clases programadas.", errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } } });
            }
        }

        [HttpPost("registrarClaseProgramada")]
        public async Task<IActionResult> RegistrarClaseProgramada([FromBody] DTOFrontDatosClaseProgramada claseProgramadaRegistro)
        {
            try
            {

                var token = Request.Cookies["AuthToken"];
                var datosBackendClaseProgramada = ProcesadorDePropiedadesDeObjetos.MapProperties<DTOFrontDatosClaseProgramada, DTODatosClaseProgramada>(claseProgramadaRegistro);
                var userId = JwtTokenGenerator.GetClaimValue(token, "sub");
                datosBackendClaseProgramada.idUsuarioQueReserva = userId;  
                var result = await _clasesManager.RegistrarClaseProgramada(datosBackendClaseProgramada);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] M�todo: RegistrarClaseProgramada | " +
                    $"L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return StatusCode(500, new DTOResponse<string> { success = false, message = "Error interno del servidor al registrar clase programada.", errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } } });
            }
        }
    }
}