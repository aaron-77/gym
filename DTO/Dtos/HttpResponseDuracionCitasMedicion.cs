using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class HttpResponseDuracionCitasMedicion
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public DuracionCitasMedicion data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseDuracionCitasMedicion()
        {
            errors = new List<ErrorModel>();
        }
    }
}
