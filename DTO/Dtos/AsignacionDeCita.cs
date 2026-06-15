using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class AsignacionDeCita
    {
        public int? id { get; set; }
        public int fkCliente { get; set; } 
        public DateTime fechaInicio { get; set; }
        public int fkEntrenador { get; set; }
        public DateTime fechaFin { get; set; }

        
    }
}
