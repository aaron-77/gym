using BL;
using BL.Utils;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    public class CitasController : Controller
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly FitnessCenterDbContext _db;

        public CitasController(UserManager<ApplicationUser> userManager, FitnessCenterDbContext db)
        {
            _userManager = userManager;
            _db = db;
        }

        [HttpPost]
        [Authorize(Roles = "empleado")]
        [Route("api/RegistrarCita")]
        public async Task<IActionResult> RegistrarCita([FromBody] DTO.Dtos.Cita cita)
        {
            DTOResponse<DTO.Dtos.Cita> respuesta;
            try
            {
                respuesta = new DTOResponse<DTO.Dtos.Cita>();
                if (!ModelState.IsValid)
                {
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
            }
            catch (Exception ex)
            {
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
            }
            catch (Exception ex)
            {
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
                await _db.Database.ExecuteSqlInterpolatedAsync($@"EXEC sp_modificarCita 
                    @citaId = {cita.Id},
                    @entrenadorID={cita.fkEntrenador},
                    @fechaInicio={cita.fechaInicioCita},
                    @estado ={cita.estado},
                    @fechaHoraFin ={cita.fechaFinCita}
                ");
                respuesta.success = true;
                respuesta.payload = cita;
                respuesta.errors = null;
                respuesta.message = "Modificacion exitosa";
            }
            catch (Exception ex)
            {
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
            var result = await _db.DuracionCitas.FirstOrDefaultAsync();
            responseDuracion.success = true;
            responseDuracion.message = "consulta exitosa";
            responseDuracion.errors = null;
            if (result != null)
            {
                responseDuracion.payload = result.Duracion;
            }
            return Ok(responseDuracion);
        }

        [HttpGet]
        [Authorize(Roles = "empleado,cliente")]
        [Route("api/getCitasAgendadas")]
        public async Task<IActionResult> getCitasAgendadas([FromQuery] string idUsuario)
        {
            DTOResponse<List<DTO.Dtos.Cita>> responseDuracion = new DTOResponse<List<DTO.Dtos.Cita>>();
            try
            {
                var result = await _db.citaSP.FromSqlInterpolated($@"EXEC sp_obtenerCitasAgendadasPorUsuario 
                    @idUsuario = {idUsuario}
                ").ToListAsync();
                responseDuracion.success = true;
                responseDuracion.message = "consulta exitosa";
                responseDuracion.errors = null;
                responseDuracion.payload = result;
            }
            catch (Exception ex)
            {
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
            return Ok(responseDuracion);
        }
    }
}
