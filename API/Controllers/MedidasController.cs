using Microsoft.AspNetCore.Mvc;
using DTO.Dtos;
using DataAccess.EntityFramework;


namespace FitnessGymApi.Controllers
{
    public class MedidasController : Controller
    {
        [HttpPost]
        [Route("api/RegistrarMedida")]
        public IActionResult Index([FromBody]MedidaCorporal medida)
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
            Medida newUserDB = new Medida() {
                
                Peso = medida.peso,
                Edad = medida.edad,
                Altura = medida.altura,
                Imc = medida.imc,
                FkUsuario = medida.fkUsuario,
                Genero = medida.genero
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
    }
}
