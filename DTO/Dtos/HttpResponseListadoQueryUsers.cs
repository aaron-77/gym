using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class HttpResponseListadoQueryUsers
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public List<QueryUser> data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseListadoQueryUsers()
        {
            errors = new List<ErrorModel>();
        }
    }
}
