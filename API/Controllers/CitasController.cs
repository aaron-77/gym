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
        public CitasController(UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
        }

        [HttpPost]
        [Authorize(Roles = "empleado")]
        [Route("api/RegistrarCita")]

        public async Task<IActionResult> RegistrarCita([FromBody] DTO.Dtos.Cita cita)
        {

            DTOResponse<DTO.Dtos.Cita> respuesta ;
            try
            {
                 respuesta = new DTOResponse<DTO.Dtos.Cita>(); // MODIFICADO: Usar DTOResponse
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
                    ;
                    respuesta.success = false; // MODIFICADO: Usar success
                    respuesta.message = "Error al registrar tu cita";
                    return BadRequest(respuesta);
                }
                FitnessCenterDbContext db = new FitnessCenterDbContext();
                var result = await db.Database.ExecuteSqlInterpolatedAsync($@"EXEC sp_registrarCita 
                @usuarioID = {cita.fkCliente},
                @entrenadorID={cita.fkEntrenador},
                @fechaInicio={cita.fechaInicioCita},
                @tipoCita ={cita.tipoCita},
                @estado ={cita.estado},
                @fechaHoraFin ={cita.fechaFinCita}
                ");
                var usuarioDeLaCita = _userManager.Users.FirstOrDefault(u => u.Id == cita.fkCliente);

                var emailManager = new EmailManagerMailKit("smtp.server.com", 587, "aaronlarabonfil@gmail.com", "kayxfchmpquogjgg");
                var message = emailManager.crearEmail("Fitness Gym", "aaronlarabonfil@gmail.com", usuarioDeLaCita.NombreCompleto + usuarioDeLaCita.Apellido, usuarioDeLaCita.Email, "Has Agendado una cita", "recuerda venir a tu cita el dia " + cita.fechaInicioCita.ToString());
                emailManager.EnviarEmail(message);

                respuesta.success = true; // MODIFICADO: Usar success
                respuesta.payload = cita; // MODIFICADO: Usar payload
                respuesta.errors = null;
                respuesta.message = "Registro exitoso";
            }
            catch (Exception ex)
            {
                respuesta = new DTOResponse<DTO.Dtos.Cita>();
                respuesta.success = false; // MODIFICADO: Usar success
                respuesta.message = "no se pudo registrar tu cita";
                respuesta.payload = null; // MODIFICADO: Usar payload
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
            DTOResponse<DTO.Dtos.DuracionCitasMedicion> respuesta = new DTOResponse<DTO.Dtos.DuracionCitasMedicion>(); // MODIFICADO: Usar DTOResponse
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
                ;
                respuesta.success = false; // MODIFICADO: Usar success
                respuesta.message = "Error al registrar la duracion";
                return BadRequest(respuesta);
            }
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            try
            {
                DuracionCita duracionDB = new DuracionCita() { Duracion = duracion.duracion, FrecuenciaNotificaciones = duracion.frecuenciaNotificaciones };
                if (duracion.Id > 0)
                {
                    duracionDB = db.DuracionCitas.FirstOrDefault();
                    duracionDB.Duracion = duracion.duracion;
                    duracionDB.FrecuenciaNotificaciones = duracion.frecuenciaNotificaciones;
                }
                else
                {
                    db.Add(duracionDB);
                }
                db.SaveChanges();
                respuesta.success = true; // MODIFICADO: Usar success
                respuesta.payload = duracion; // MODIFICADO: Usar payload
                respuesta.errors = null;
                respuesta.message = "Registro exitoso";
            }
            catch (Exception ex)
            {
                respuesta.success = false; // MODIFICADO: Usar success
                respuesta.message = "no se pudo registrar la duracion";
                respuesta.payload = null; // MODIFICADO: Usar payload
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
            DTOResponse<DTO.Dtos.CitaEdit> respuesta = new DTOResponse<DTO.Dtos.CitaEdit>(); // MODIFICADO: Usar DTOResponse
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
                ;
                respuesta.success = false; // MODIFICADO: Usar success
                respuesta.message = "Error al modificar tu cita";
                return BadRequest(respuesta);
            }
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            try
            {
                var result = await db.Database.ExecuteSqlInterpolatedAsync($@"EXEC sp_modificarCita 
                @citaId = {cita.Id},
                @entrenadorID={cita.fkEntrenador},
                @fechaInicio={cita.fechaInicioCita},
                @estado ={cita.estado},
                @fechaHoraFin ={cita.fechaFinCita}
                ");
                respuesta.success = true; // MODIFICADO: Usar success
                respuesta.payload = cita; // MODIFICADO: Usar payload
                respuesta.errors = null;
                respuesta.message = "Modificacion exitosa";
            }
            catch (Exception ex)
            {
                respuesta.success = false; // MODIFICADO: Usar success
                respuesta.message = "no se pudo modificar tu cita";
                respuesta.payload = null; // MODIFICADO: Usar payload
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
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            DTOResponse<int> responseDuracion = new DTOResponse<int>(); // MODIFICADO: Usar DTOResponse<int>
            var result = await db.DuracionCitas.FirstOrDefaultAsync();
            responseDuracion.success = true; // MODIFICADO: Usar success
            responseDuracion.message = "consulta exitosa";
            responseDuracion.errors = null;
            responseDuracion.payload = result.Duracion; // MODIFICADO: Usar payload
            return Ok(responseDuracion);
        }

        [HttpGet]
        [Authorize(Roles = "empleado,cliente")]
        [Route("api/getCitasAgendadas")]

        public async Task<IActionResult> getCitasAgendadas([FromQuery] string idUsuario) // MODIFICADO: idUsuario a string
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();

            DTOResponse<List<DTO.Dtos.Cita>> responseDuracion = new DTOResponse<List<DTO.Dtos.Cita>>(); // MODIFICADO: Usar DTOResponse<List<Cita>>
            try
            {

                var result = await db.citaSP.FromSqlInterpolated($@"EXEC sp_obtenerCitasAgendadasPorUsuario 
                @idUsuario = {idUsuario}
                ").ToListAsync();
                responseDuracion.success = true; // MODIFICADO: Usar success
                responseDuracion.message = "consulta exitosa";
                responseDuracion.errors = null;
                responseDuracion.payload = result; // MODIFICADO: Usar payload
            }
            catch (Exception ex)
            {
                responseDuracion.success = false; // MODIFICADO: Usar success
                responseDuracion.message = "Error al consultar las citas agendadas";
                responseDuracion.errors.Add(new ErrorModel { message = ex.Message, propiedad = null });
                responseDuracion.payload = null; // MODIFICADO: Usar payload
            }

            return Ok(responseDuracion);
        }


        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("api/getDuracionCitasMedicion")]
        public async Task<IActionResult> getDuracionCitasMedicion()
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            DTOResponse<DTO.Dtos.DuracionCitasMedicion> responseDuracion = new DTOResponse<DTO.Dtos.DuracionCitasMedicion>(); // MODIFICADO: Usar DTOResponse
            var result = await db.DuracionCitas.Select
                (d => new DuracionCitasMedicion
                {
                    Id = d.DuracionId,
                    duracion = d.Duracion,
                    frecuenciaNotificaciones = d.FrecuenciaNotificaciones
                }).FirstOrDefaultAsync();
            responseDuracion.success = true; // MODIFICADO: Usar success
            responseDuracion.message = "consulta exitosa";
            responseDuracion.errors = null;
            responseDuracion.payload = result; // MODIFICADO: Usar payload

            if (result == null)
            {
                responseDuracion.success = false; // MODIFICADO: Usar success
                responseDuracion.message = "No hay configuracion de duracion registrada aun";
                responseDuracion.errors = null;
                responseDuracion.payload = result; // MODIFICADO: Usar payload
            }

            return Ok(responseDuracion);
        }
    }
}
