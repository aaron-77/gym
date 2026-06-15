using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class HttpResponseRutina
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public Rutina data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseRutina()
        {
            errors = new List<ErrorModel>();
        }
    }
}
