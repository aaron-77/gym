using Microsoft.AspNetCore.Mvc;
using DTO.Dtos;
using BL.Utils;
using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;

namespace FitnessGymApi.Controllers
{
    public class MedidasController : Controller
    {
        [HttpPost]
        [Route("api/RegistrarMedida")]
        public IActionResult Index([FromBody] DTO.Dtos.DTOMedida medida)
        {
            HTTPResponseModelMedida respuesta = new HTTPResponseModelMedida();
            if (!ModelState.IsValid)
            {
                List<string> nombresCampos = new List<string>() { "peso", "altura", "edad", "imc", "genero" };
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

                };
                respuesta.ok = false;
                respuesta.message = "Error al registrar las medidas";
                return BadRequest(respuesta);
            }

            FitnessCenterDbContext db = new FitnessCenterDbContext();

            if (medida == null)
            {

                return null;
            }
            Medida newUserDB = new Medida()
            {

                FkUsuario = medida.fkUsuario,
                FkParametro = medida.fkParametro,
                Valor = medida.valor
            };
            try
            {
                db.Add(newUserDB);
                db.SaveChanges();
                respuesta.ok = true;
                respuesta.data = medida;
                respuesta.errors = null;
                respuesta.message = "Registro exitoso";
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.data = null;
                ErrorModel error = new ErrorModel();
                error.message = ex.Message;
                respuesta.message = "No se han podido registrar las medidas";
                respuesta.errors.Add(error);
                return BadRequest(respuesta);
            }
            return Ok(respuesta);
        }

        
        [HttpGet]
        [Route("api/getParametrosDeMedicion")]
        public async Task<IActionResult> getParametrosDeMedicion([FromQuery] int idUsuario)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            ResponseParametroDeMedicion respuesta = new ResponseParametroDeMedicion();
            try
            {
                var listadoParametrosDeMedicion = await db.parametrosDeMedicionSP.FromSqlInterpolated($@"EXEC sp_obtenerParametrosDeMedicionConUnidad").ToListAsync();    
                respuesta.ok = true;
                respuesta.message = "consulta exitosa";
                respuesta.errors = null;
                respuesta.data = listadoParametrosDeMedicion;
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.message = "Error al consultar los parametros de medicion";
                respuesta.errors = null;
                respuesta.data = null;
            }
            return Ok(respuesta);
        }
        
        [HttpGet]
        [Route("api/progresoDeUsuario")]
        public async Task<IActionResult> getProgresoDelCliente([FromQuery] int idUsuario)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            HttpResponseProgresoUsuario respuesta = new HttpResponseProgresoUsuario();
            List<DTOItemProgreso> itemsProgreso = null;
            try
            {
                var ultimasMedidas = await db.ultimasMedidasDeParametroSP.FromSqlInterpolated($@"EXEC sp_obtenerUltimasMedidasDelUsuario @idUsuario={idUsuario}").ToListAsync();    
                var ultimasMetas = await db.ultimasMetasDeParametroSP.FromSqlInterpolated($@"EXEC sp_obtenerMetasActualesDelClientePorParametro @idUsuario={idUsuario}").ToListAsync();   
                itemsProgreso = ObjectAssembler.ensamblarItemsProgreso(ultimasMedidas, ultimasMetas);
                respuesta.ok = true;
                respuesta.message = "consulta exitosa";
                respuesta.errors = null;
                respuesta.data = itemsProgreso;
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.message = "Error al consultar los parametros de medicion";
                respuesta.errors = null;
                respuesta.data = itemsProgreso;
            }
            return Ok(respuesta);
        }
    }


}
