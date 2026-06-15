using DTO.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class ResponseHttpListadoUsers
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public List<ExistingUser> data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public ResponseHttpListadoUsers()
        {
            errors = new List<ErrorModel>();
        }
    }
}
