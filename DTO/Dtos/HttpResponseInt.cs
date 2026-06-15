using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class HttpResponseInt
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public int data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseInt()
        {
            errors = new List<ErrorModel>();
        }
    }
}
