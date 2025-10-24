using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using DataAccess.EntityFramework;
using BL.Utils;
using System.Security.Claims;
using System.IdentityModel.Tokens.Jwt;

namespace API.Controllers
{
    public class RutinasController : Controller
    {
        private JwtTokenGenerator jwtTokenGenerator;
        private readonly FitnessCenterDbContext _db;

        public RutinasController(JwtTokenGenerator _jwtTokenGenerator, FitnessCenterDbContext db)
        {
            jwtTokenGenerator = _jwtTokenGenerator;
            _db = db;
        }
        public IActionResult Index()
        {
            return View();
        }


        [Authorize(Roles = "empleado")]
        [HttpPost]
        [Route("api/registrarRutina")]

        public async Task<IActionResult> RegistrarRutina([FromBody] DTO.Dtos.Rutina rutina)
        {
            HttpResponseRutina respuesta = new HttpResponseRutina();
            try
            {
                var resultado = await _db.Database.ExecuteSqlInterpolatedAsync($@"EXEC sp_registrarRutina 
                @usuarioID = {rutina.UsuarioID},
                @entrenadorID={rutina.EntrenadorID},
                @fechaCreacion={rutina.FechaCreacion},
                @observaciones={rutina.Observaciones}");
                respuesta.ok = true;
                respuesta.data = rutina;
                respuesta.errors = null;
                respuesta.message = "Registro exitoso";
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.data = null;
                respuesta.errors.Add(new ErrorModel() { propiedad = null, message = ex.Message });
                respuesta.message = "Error al registrar la rutina";
                return StatusCode(500, respuesta);
            }
            return Ok(respuesta);
        }
        [Authorize(Roles = "empleado")]
        [HttpPost]
        [Route("api/asignarEjercicio")]

        public async Task<IActionResult> asignarEjercicioARutina([FromBody] DTO.Dtos.AsignacionDeEjercicio asignacionDeEjercicio)
        {
            HttpResponseAsignacion respuesta = new HttpResponseAsignacion();
            try
            {
                var resultado = await _db.Database.
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

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("api/consultarRutinas")]
        public async Task<IActionResult> obtenerRutinasDeUusario([FromQuery] string UsuarioID = null)
        {
             var respuesta = new DTOResponse<List<DTO.Dtos.Rutina>>();
            try
            {
                var rutinasDelCliente = await _db.rutinaSP.FromSqlInterpolated($@"EXEC [FitnessCenterDB].[dbo].sp_consultarRutinasDeUsuario @usuarioID={UsuarioID}").ToListAsync();
                respuesta = ResponseManager.BuildResponse(true, 200, "Consulta exitosa", null,rutinasDelCliente);                
            }
            catch (Exception ex)
            {
                respuesta = ResponseManager.BuildResponse<List<DTO.Dtos.Rutina>>(false, 500, "Error al consultar las rutinas", new List<ErrorModel> { new ErrorModel { propiedad = null, message = ex.Message } }, null);
            }

            return Ok(respuesta);
        }
    }
}
