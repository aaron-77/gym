using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using DataAccess.EntityFramework;

namespace API.Controllers
{
    public class RutinasController : Controller
    {

        public IActionResult Index()
        {
            return View();
        }


        [HttpPost]
        [Route("api/registrarRutina")]

        public async Task<IActionResult> RegistrarRutina([FromBody] DTO.Dtos.Rutina rutina)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            HttpResponseRutina respuesta = new HttpResponseRutina();
            try {
                var resultado = await db.Database.ExecuteSqlInterpolatedAsync($@"EXEC sp_registrarRutina 
                @usuarioID = {rutina.UsuarioID},
                @entrenadorID={rutina.EntrenadorID},
                @fechaCreacion={rutina.FechaCreacion},
                @observaciones={rutina.Observaciones}");
                respuesta.ok = true;
                respuesta.data = rutina;
                respuesta.errors = null;
                respuesta.message = "Registro exitoso";
            }
            catch (Exception ex) {
                respuesta.ok = false;
                respuesta.data = null;
                respuesta.errors.Add(new ErrorModel() { propiedad = null, message = ex.Message });
                respuesta.message = "Error al registrar la rutina";
                return StatusCode(500, respuesta);
            }
            return Ok(respuesta);
        }

        [HttpPost]
        [Route("api/asignarEjercicio")]

        public async Task<IActionResult> asignarEjercicioARutina ([FromBody] DTO.Dtos.AsignacionDeEjercicio asignacionDeEjercicio)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            HttpResponseAsignacion respuesta = new HttpResponseAsignacion();
            try
            {
                var resultado = await db.Database.
                    ExecuteSqlInterpolatedAsync
                    ($@"EXEC sp_asignarEjercicio
                        @rutinaId={asignacionDeEjercicio.RutinaId},
                        @ejercicioId={asignacionDeEjercicio.EjercicioID},
                        @sets={asignacionDeEjercicio.Sets},
                        @peso={asignacionDeEjercicio.Peso},
                        @tiempo={asignacionDeEjercicio.Tiempo},
                        @repeticiones = {asignacionDeEjercicio.Repeticiones},
                        @metaRepeticiones={asignacionDeEjercicio.MetaRepeticiones}
                    ");
                respuesta.ok = true;
                respuesta.data = asignacionDeEjercicio;
                respuesta.errors = null;
                respuesta.message = "Registro exitoso";
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.data = null;
                respuesta.errors.Add(new ErrorModel() { propiedad = null, message = ex.Message });
                respuesta.message = "Error al asignar el ejercicio";
                return StatusCode(500, respuesta);
            }
            return Ok(respuesta);
        }

        [HttpGet]
        [Route("api/consultarRutinas")]
        public async Task<IActionResult> obtenerRutinasDeUusario([FromQuery] int UsuarioID)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            HttpResponseListadoRutinas respuesta = new HttpResponseListadoRutinas();
            try {
                respuesta.data = await db.rutinaSP.FromSqlInterpolated($@"EXEC sp_consultarRutinasDeUsuario @usuarioID={UsuarioID}").ToListAsync();
                respuesta.ok = true;
                respuesta.errors = null;
                respuesta.message = "Consulta exitosa";
            }
             catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.data = null;
                respuesta.errors.Add(new ErrorModel() { propiedad = null, message = ex.Message });
                respuesta.message = "Error al consultar las rutinas";

            }
            
            return Ok(respuesta);
        }
    }
}
