using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class OTPCodeVerification
    {
        public string codigo { get; set; }
        public string cel{ get; set; }
        public string? correo {  get; set; }
    }
}
