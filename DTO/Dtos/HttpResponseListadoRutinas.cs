using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class HttpResponseListadoRutinas
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public List<Rutina> data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseListadoRutinas()
        {
            errors = new List<ErrorModel>();
        }
    }
}
