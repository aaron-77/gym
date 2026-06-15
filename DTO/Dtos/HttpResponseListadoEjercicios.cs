using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class HttpResponseListadoEjercicios
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public List<Ejercicio> data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseListadoEjercicios()
        {
            errors = new List<ErrorModel>();
        }
    }
}
