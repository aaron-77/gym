using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class ResponseHTTPMedida
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public MedidaCorporal data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public ResponseHTTPMedida()
        {
            errors = new List<ErrorModel>();
        }
    }
}
