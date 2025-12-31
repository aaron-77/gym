using BL;
using BL.Utils;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    public class CitasController : Controller
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly FitnessCenterDbContext _db;
        private readonly ILogger<CitasController> _logger;

        public CitasController(UserManager<ApplicationUser> userManager, FitnessCenterDbContext db, ILogger<CitasController> logger)
        {
            _userManager = userManager;
            _db = db;
            _logger = logger;
        }

        [HttpPost]
        [Authorize(Roles = "empleado")]
        [Route("api/RegistrarCita")]
        public async Task<IActionResult> RegistrarCita([FromBody] DTO.Dtos.Cita cita)
        {
            DTOResponse<DTO.Dtos.Cita> respuesta;
            try
            {
                _logger.LogInformation("Start RegistrarCita fkCliente={FkCliente} fkEntrenador={FkEntrenador}", cita?.fkCliente, cita?.fkEntrenador);
                respuesta = new DTOResponse<DTO.Dtos.Cita>();
                _logger.LogInformation("Validating model state for RegistrarCita");
                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("ModelState invalid in RegistrarCita");
                    List<string> nombresCampos = new List<string>() { "fechaInicioCita", "fechaFinCita", "fkCliente", "fkEntrenador", "tipoCita" };
                    foreach (var item in ModelState.Values)
                    {
                        foreach (var item1 in item.Errors)
                        {
                            ErrorModel error = new ErrorModel();
                            string nombreCampo = nombresCampos.Where(c => item1.ErrorMessage.Contains(c)).FirstOrDefault();
                            error.propiedad = nombreCampo;
                            error.message = item1.ErrorMessage;
                            respuesta.errors.Add(error);
                        }
                    }
                    respuesta.success = false;
                    respuesta.message = "Error al registrar tu cita";
                    return BadRequest(respuesta);
                }

                await _db.Database.ExecuteSqlInterpolatedAsync($@"EXEC sp_registrarCita 
                    @usuarioID = {cita.fkCliente},
                    @entrenadorID={cita.fkEntrenador},
                    @fechaInicio={cita.fechaInicioCita},
                    @tipoCita ={cita.tipoCita},
                    @estado ={cita.estado},
                    @fechaHoraFin ={cita.fechaFinCita}
                ");
                var usuarioDeLaCita = await _userManager.Users.FirstOrDefaultAsync(u => u.Id == cita.fkCliente);

                if (usuarioDeLaCita != null)
                {
                    var emailManager = new EmailManagerMailKit("smtp.server.com", 587, "aaronlarabonfil@gmail.com", "kayxfchmpquogjgg");
                    var message = emailManager.crearEmail("Fitness Gym", "aaronlarabonfil@gmail.com", usuarioDeLaCita.NombreCompleto + usuarioDeLaCita.Apellido, usuarioDeLaCita.Email, "Has Agendado una cita", "recuerda venir a tu cita el dia " + cita.fechaInicioCita.ToString());
                    emailManager.EnviarEmail(message);
                }

                respuesta.success = true;
                respuesta.payload = cita;
                respuesta.errors = null;
                respuesta.message = "Registro exitoso";
                _logger.LogInformation("RegistrarCita completed successfully for fkCliente={FkCliente}", cita?.fkCliente);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: RegistrarCita (API/CitasController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Cita.FkCliente: {cita?.fkCliente}, FkEntrenador: {cita?.fkEntrenador} | Stack Trace: {ex.StackTrace}";
                _logger.LogError(ex, logMessage);

                respuesta = new DTOResponse<DTO.Dtos.Cita>();
                respuesta.success = false;
                respuesta.message = "no se pudo registrar tu cita";
                respuesta.payload = null;
                respuesta.errors.Add(new ErrorModel { message = ex.Message, propiedad = null });
                return BadRequest(respuesta);
            }
            return Ok(respuesta);
        }

        [HttpPost]
        [Authorize(Roles = "empleado")]
        [Route("api/registrarDuracion")]
        public async Task<IActionResult> RegistrarDuracion([FromBody] DTO.Dtos.DuracionCitasMedicion duracion)
        {
            DTOResponse<DTO.Dtos.DuracionCitasMedicion> respuesta = new DTOResponse<DTO.Dtos.DuracionCitasMedicion>();
            _logger.LogInformation("Start RegistrarDuracion Id={Id}", duracion?.Id);
            if (!ModelState.IsValid)
            {
                List<string> nombresCampos = new List<string>() { "Duracion", "Frecuencia" };
                foreach (var item in ModelState.Values)
                {
                    foreach (var item1 in item.Errors)
                    {
                        ErrorModel error = new ErrorModel();
                        string nombreCampo = nombresCampos.Where(c => item1.ErrorMessage.Contains(c)).FirstOrDefault();
                        error.propiedad = nombreCampo;
                        error.message = item1.ErrorMessage;
                        respuesta.errors.Add(error);
                    }
                }
                respuesta.success = false;
                respuesta.message = "Error al registrar la duracion";
                return BadRequest(respuesta);
            }
            try
            {
                _logger.LogInformation("Valid model state for RegistrarDuracion");
                DuracionCita duracionDB;
                if (duracion.Id > 0)
                {
                    duracionDB = await _db.DuracionCitas.FirstOrDefaultAsync();
                    if (duracionDB != null)
                    {
                        duracionDB.Duracion = duracion.duracion;
                        duracionDB.FrecuenciaNotificaciones = duracion.frecuenciaNotificaciones;
                    }
                }
                else
                {
                    duracionDB = new DuracionCita() { Duracion = duracion.duracion, FrecuenciaNotificaciones = duracion.frecuenciaNotificaciones };
                    _db.Add(duracionDB);
                }
                await _db.SaveChangesAsync();
                respuesta.success = true;
                respuesta.payload = duracion;
                respuesta.errors = null;
                respuesta.message = "Registro exitoso";
                _logger.LogInformation("RegistrarDuracion completed Id={Id}", duracion?.Id);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: RegistrarDuracion (API/CitasController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | DuracionId: {duracion?.Id} | Stack Trace: {ex.StackTrace}";
                _logger.LogError(ex, logMessage);

                respuesta.success = false;
                respuesta.message = "no se pudo registrar la duracion";
                respuesta.payload = null;
                respuesta.errors.Add(new ErrorModel { message = ex.Message, propiedad = null });
                return BadRequest(respuesta);
            }
            return Ok(respuesta);
        }

        [HttpPut]
        [Authorize(Roles = "empleado")]
        [Route("api/RegistrarCita")]
        public async Task<IActionResult> ModificarCita([FromBody] DTO.Dtos.CitaEdit cita)
        {
            DTOResponse<DTO.Dtos.CitaEdit> respuesta = new DTOResponse<DTO.Dtos.CitaEdit>();
            _logger.LogInformation("Start ModificarCita Id={Id}", cita?.Id);
            if (!ModelState.IsValid)
            {
                List<string> nombresCampos = new List<string>() { "Id", "fechaInicioCita", "fechaFinCita", "fkCliente", "fkEntrenador" };
                foreach (var item in ModelState.Values)
                {
                    foreach (var item1 in item.Errors)
                    {
                        ErrorModel error = new ErrorModel();
                        string nombreCampo = nombresCampos.Where(c => item1.ErrorMessage.Contains(c)).FirstOrDefault();
                        error.propiedad = nombreCampo;
                        error.message = item1.ErrorMessage;
                        respuesta.errors.Add(error);
                    }
                }
                respuesta.success = false;
                respuesta.message = "Error al modificar tu cita";
                return BadRequest(respuesta);
            }
            try
            {
                _logger.LogInformation("Valid model state for ModificarCita Id={Id}", cita?.Id);
                await _db.Database.ExecuteSqlInterpolatedAsync($@"EXEC sp_modificarCita 
                    @citaId = {cita.Id},
                    @entrenadorID={cita.fkEntrenador},
                    @fechaInicio={cita.fechaInicioCita},
                    @estado ={cita.estado},
                    @fechaHoraFin ={cita.fechaFinCita}
                ");
                _logger.LogInformation("ModificarCita executed for Id={Id}", cita?.Id);
                respuesta.success = true;
                respuesta.payload = cita;
                respuesta.errors = null;
                respuesta.message = "Modificacion exitosa";
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ModificarCita (API/CitasController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | CitaId: {cita?.Id} | Stack Trace: {ex.StackTrace}";
                _logger.LogError(ex, logMessage);

                respuesta.success = false;
                respuesta.message = "no se pudo modificar tu cita";
                respuesta.payload = null;
                respuesta.errors.Add(new ErrorModel { message = ex.Message, propiedad = null });
                return BadRequest(respuesta);
            }
            return Ok(respuesta);
        }

        [HttpGet]
        [Authorize(Roles = "empleado")]
        [Route("api/getDuracionCita")]
        public async Task<IActionResult> getDuracionCita()
        {
            DTOResponse<int> responseDuracion = new DTOResponse<int>();
            try
            {
                _logger.LogInformation("Start getDuracionCita");
                var result = await _db.DuracionCitas.FirstOrDefaultAsync();
                responseDuracion.success = true;
                responseDuracion.message = "consulta exitosa";
                responseDuracion.errors = null;
                if (result != null)
                {
                    responseDuracion.payload = result.Duracion;
                }
                _logger.LogInformation("getDuracionCita returned {Payload}", responseDuracion.payload);
                return Ok(responseDuracion);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: getDuracionCita (API/CitasController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                _logger.LogError(ex, logMessage);

                responseDuracion.success = false;
                responseDuracion.message = "Error al obtener la duración";
                responseDuracion.errors = new List<ErrorModel> { new ErrorModel { message = ex.Message, propiedad = null } };
                responseDuracion.payload = 0;
                return StatusCode(500, responseDuracion);
            }
        }

        [HttpGet]
        [Authorize(Roles = "empleado,cliente")]
        [Route("api/getCitasAgendadas")]
        public async Task<IActionResult> getCitasAgendadas([FromQuery] string idUsuario)
        {
            DTOResponse<List<DTO.Dtos.Cita>> responseDuracion = new DTOResponse<List<DTO.Dtos.Cita>>();
            try
            {
                _logger.LogInformation("Start getCitasAgendadas idUsuario={IdUsuario}", idUsuario);
                var result = await _db.citaSP.FromSqlInterpolated($@"EXEC sp_obtenerCitasAgendadasPorUsuario 
                    @idUsuario = {idUsuario}
                ").ToListAsync();
                responseDuracion.success = true;
                responseDuracion.message = "consulta exitosa";
                responseDuracion.errors = null;
                responseDuracion.payload = result;
                _logger.LogInformation("getCitasAgendadas returned {Count} items for {IdUsuario}", result?.Count, idUsuario);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: getCitasAgendadas (API/CitasController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | IdUsuario: {idUsuario} | Stack Trace: {ex.StackTrace}";
                _logger.LogError(ex, logMessage);

                responseDuracion.success = false;
                responseDuracion.message = "Error al consultar las citas agendadas";
                responseDuracion.errors.Add(new ErrorModel { message = ex.Message, propiedad = null });
                responseDuracion.payload = null;
            }
            return Ok(responseDuracion);
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("api/getDuracionCitasMedicion")]
        public async Task<IActionResult> getDuracionCitasMedicion()
        {
            DTOResponse<DTO.Dtos.DuracionCitasMedicion> responseDuracion = new DTOResponse<DTO.Dtos.DuracionCitasMedicion>();
            try
            {
                var result = await _db.DuracionCitas.Select
                    (d => new DuracionCitasMedicion
                    {
                        Id = d.DuracionId,
                        duracion = d.Duracion,
                        frecuenciaNotificaciones = d.FrecuenciaNotificaciones
                    }).FirstOrDefaultAsync();
                responseDuracion.success = true;
                responseDuracion.message = "consulta exitosa";
                responseDuracion.errors = null;
                responseDuracion.payload = result;

                if (result == null)
                {
                    responseDuracion.success = false;
                    responseDuracion.message = "No hay configuracion de duracion registrada aun";
                    responseDuracion.errors = null;
                    responseDuracion.payload = result;
                }
                _logger.LogInformation("getDuracionCitasMedicion payload null={IsNull}", result == null);
                return Ok(responseDuracion);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: getDuracionCitasMedicion (API/CitasController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                _logger.LogError(ex, logMessage);

                responseDuracion.success = false;
                responseDuracion.message = "Error al obtener la configuración de duración";
                responseDuracion.errors = new List<ErrorModel> { new ErrorModel { message = ex.Message, propiedad = null } };
                responseDuracion.payload = null;
                return StatusCode(500, responseDuracion);
            }
        }
    }
}
