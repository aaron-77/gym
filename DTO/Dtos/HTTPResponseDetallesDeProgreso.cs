using System.Collections.Generic;

namespace DTO.Dtos
{
    public class HTTPResponseDetallesDeProgreso
    {
        
        public bool ok { get; set; }
        public string message { get; set; }
        public MedidasConMetas data { get; set; } = new MedidasConMetas();
        public List<ErrorModel> errors { get; set; }
        public HTTPResponseDetallesDeProgreso()
        {
            errors = new List<ErrorModel>();
        }
    }
}