using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class ResponseHttp
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public User data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public ResponseHttp()
        {
            errors = new List<ErrorModel>();
        }
    }
}
