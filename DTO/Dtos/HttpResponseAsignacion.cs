using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class HttpResponseAsignacion
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public AsignacionDeEjercicio data { get; set; }
        public string urlPageForUser { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseAsignacion()
        {
            errors = new List<ErrorModel>();
        }
    }
}
