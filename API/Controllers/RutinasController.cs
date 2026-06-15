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
    [ApiController]
    public class RutinasController : ControllerBase
    {
        private JwtTokenGenerator jwtTokenGenerator;
        private readonly FitnessCenterDbContext _db;
        private readonly Microsoft.Extensions.Logging.ILogger<RutinasController> _logger;

        public RutinasController(JwtTokenGenerator _jwtTokenGenerator, FitnessCenterDbContext db, Microsoft.Extensions.Logging.ILogger<RutinasController> logger)
        {
            jwtTokenGenerator = _jwtTokenGenerator;
            _db = db;
            _logger = logger;
        }

        [Authorize(Roles = "empleado")]
        [HttpPost]
        [Route("api/registrarRutina")]

        public async Task<IActionResult> RegistrarRutina([FromBody] DTO.Dtos.Rutina rutina)
        {
            HttpResponseRutina respuesta = new HttpResponseRutina();
            
            if (!ModelState.IsValid)
            {
                return BadRequest();
            }
            
            try
            {
                _logger.LogInformation("Start RegistrarRutina UsuarioID={UsuarioID}", rutina?.UsuarioID);
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
                _logger.LogError(ex, "Error en RegistrarRutina UsuarioID={UsuarioID}", rutina?.UsuarioID);
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
            if (!ModelState.IsValid)
            {
                return BadRequest();
            }

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

                var respuesta = ResponseManager.BuildResponse<AsignacionDeEjercicio>(true, 200, "Registro exitoso", null, asignacionDeEjercicio);
                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                var respuesta = ResponseManager.BuildResponse<DTO.Dtos.AsignacionDeEjercicio>(false, 500, "Error al asignar el ejercicio", new List<ErrorModel> { new ErrorModel { message = ex.Message, propiedad = null } }, null);
                return StatusCode(500, respuesta);
            }
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("api/consultarRutinas")]
        public async Task<IActionResult> obtenerRutinasDeUusario([FromQuery] ConsultarRutinasRequest request)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest();
            }
            
            var respuesta = new DTOResponse<List<DTO.Dtos.Rutina>>();
            try
            {
                var rutinasDelCliente = await _db.rutinaSP.FromSqlInterpolated($@"EXEC [FitnessCenterDB].[dbo].sp_consultarRutinasDeUsuario @usuarioID={request.UsuarioID}").ToListAsync();
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
