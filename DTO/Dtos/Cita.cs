using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class Cita:BaseClass
    {

        [Required(ErrorMessage = "Selecciona la fecha de incio")]
        public DateTime fechaInicioCita { get; set; }
       
        [Required(ErrorMessage = "Selecciona la fecha de finalizacion")]
        public DateTime fechaFinCita { get; set; }
       
        [Required(ErrorMessage = "Selecciona un cliente")]
        public string fkCliente { get; set; }
       
        [Required(ErrorMessage = "Selecciona un entrenador")]
        public string fkEntrenador { get; set; }
       
        [Required(ErrorMessage = "Selecciona el tipo de cita")]
        public string tipoCita { get;set;  }

        public string? estado { get; set; }

    }
}
