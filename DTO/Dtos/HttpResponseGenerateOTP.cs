using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class HttpResponseGenerateOTP
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public OTPOrder data { get; set; }
        public string urlPageForUser { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseGenerateOTP()
        {
            data = new OTPOrder();
            errors = new List<ErrorModel>();
        }
    }
}
