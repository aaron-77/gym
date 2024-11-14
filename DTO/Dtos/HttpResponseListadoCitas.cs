using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class HttpResponseListadoCitas
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public List<Cita> data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseListadoCitas()
        {
            errors = new List<ErrorModel>();
        }
    }
}
