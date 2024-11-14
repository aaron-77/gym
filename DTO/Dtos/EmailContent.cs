using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class EmailContent
    {
        public string recipient {  get; set; }
        public string message { get; set; }
        public string? htmlMessaje { get; set; }
    }
}
