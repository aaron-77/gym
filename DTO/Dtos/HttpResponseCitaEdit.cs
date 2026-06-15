using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class HttpResponseCitaEdit
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public CitaEdit data { get; set; }
        public string urlPageForUser { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseCitaEdit()
        {
            errors = new List<ErrorModel>();
        }
    }
}
