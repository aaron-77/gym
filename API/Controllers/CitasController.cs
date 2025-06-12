using BL;
using BL.Utils;
using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    public class CitasController : Controller
    {
        [HttpPost]
        [Route("api/RegistrarCita")]

        public async Task<IActionResult> RegistrarCita([FromBody] DTO.Dtos.Cita cita)
        {
            HttpResponseCita respuesta = new HttpResponseCita();
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
                respuesta.ok = false;
                respuesta.message = "Error al registrar tu cita";
                return BadRequest(respuesta);
            }
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            try
            {
                var result = await db.Database.ExecuteSqlInterpolatedAsync($@"EXEC sp_registrarCita 
                @usuarioID = {cita.fkCliente},
                @entrenadorID={cita.fkEntrenador},
                @fechaInicio={cita.fechaInicioCita},
                @tipoCita ={cita.tipoCita},
                @estado ={cita.estado},
                @fechaHoraFin ={cita.fechaFinCita}
                ");
                var usuarioDeLaCita = db.Usuarios.Find(cita.fkCliente);

                var emailManager = new EmailManagerMailKit("smtp.server.com", 587, "aaronlarabonfil@gmail.com", "kayxfchmpquogjgg");
                var message = emailManager.crearEmail("Fitness Gym", "aaronlarabonfil@gmail.com",usuarioDeLaCita.Nombre + usuarioDeLaCita.Apellido ,usuarioDeLaCita.Email, "Has Agendado una cita", "recuerda venir a tu cita el dia " + cita.fechaInicioCita.ToString());
                emailManager.EnviarEmail(message);

                respuesta.ok = true;
                respuesta.data = cita;
                respuesta.errors = null;
                respuesta.message = "Registro exitoso";
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.message = "no se pudo registrar tu cita";
                respuesta.data = null;
                respuesta.errors.Add(new ErrorModel { message = ex.Message, propiedad = null });
                return BadRequest(respuesta);
            }
            return Ok(respuesta);
        }

        [HttpPost]
        [Route("api/registrarDuracion")]

        public async Task<IActionResult> RegistrarDuracion([FromBody] DTO.Dtos.DuracionCitasMedicion duracion)
        {
            HttpResponseDuracionCitasMedicion respuesta = new HttpResponseDuracionCitasMedicion();
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
                respuesta.ok = false;
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
                respuesta.ok = true;
                respuesta.data = duracion;
                respuesta.errors = null;
                respuesta.message = "Registro exitoso";
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.message = "no se pudo registrar la duracion";
                respuesta.data = null;
                respuesta.errors.Add(new ErrorModel { message = ex.Message, propiedad = null });
                return BadRequest(respuesta);
            }
            return Ok(respuesta);
        }


        [HttpPut]
        [Route("api/RegistrarCita")]

        public async Task<IActionResult> ModificarCita([FromBody] DTO.Dtos.CitaEdit cita)
        {
            HttpResponseCitaEdit respuesta = new HttpResponseCitaEdit();
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
                respuesta.ok = false;
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
                respuesta.ok = true;
                respuesta.data = cita;
                respuesta.errors = null;
                respuesta.message = "Modificacion exitosa";
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.message = "no se pudo modificar tu cita";
                respuesta.data = null;
                respuesta.errors.Add(new ErrorModel { message = ex.Message, propiedad = null });
                return BadRequest(respuesta);
            }
            return Ok(respuesta);
        }


        [HttpGet]
        [Route("api/getDuracionCita")]

        public async Task<IActionResult> getDuracionCita()
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            HttpResponseInt responseDuracion = new HttpResponseInt();
            var result = await db.DuracionCitas.FirstOrDefaultAsync();
            responseDuracion.ok = true;
            responseDuracion.message = "consulta exitosa";
            responseDuracion.errors = null;
            responseDuracion.data = result.Duracion;
            return Ok(responseDuracion);
        }

        [HttpGet]
        [Route("api/getCitasAgendadas")]

        public async Task<IActionResult> getCitasAgendadas([FromQuery] int idUsuario)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();

            HttpResponseListadoCitas responseDuracion = new HttpResponseListadoCitas();
            try
            {

                var result = await db.citaSP.FromSqlInterpolated($@"EXEC sp_obtenerCitasAgendadasPorUsuario 
                @idUsuario = {idUsuario}
                ").ToListAsync();
                responseDuracion.ok = true;
                responseDuracion.message = "consulta exitosa";
                responseDuracion.errors = null;
                responseDuracion.data = result;
            }
            catch (Exception ex)
            {
                responseDuracion.ok = false;
                responseDuracion.message = "Error al consultar las citas agendadas";
                responseDuracion.errors.Add(new ErrorModel { message = ex.Message, propiedad = null });
                responseDuracion.data = null;
            }

            return Ok(responseDuracion);
        }


        [HttpGet]
        [Route("api/getDuracionCitasMedicion")]

        public async Task<IActionResult> getDuracionCitasMedicion()
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            HttpResponseDuracionCitasMedicion responseDuracion = new HttpResponseDuracionCitasMedicion();
            var result = await db.DuracionCitas.Select
                (d => new DuracionCitasMedicion
                {
                    Id = d.DuracionId,
                    duracion = d.Duracion,
                    frecuenciaNotificaciones = d.FrecuenciaNotificaciones
                }).FirstOrDefaultAsync();
            responseDuracion.ok = true;
            responseDuracion.message = "consulta exitosa";
            responseDuracion.errors = null;
            responseDuracion.data = result;

            if (result == null)
            {
                responseDuracion.ok = false;
                responseDuracion.message = "No hay configuracion de duracion registrada aun";
                responseDuracion.errors = null;
                responseDuracion.data = result;
            }

            return Ok(responseDuracion);
        }
    }
}
