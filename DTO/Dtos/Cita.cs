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
        [Range(1, int.MaxValue, ErrorMessage = "Selecciona un cliente")]
        public int fkCliente { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "Selecciona un entrenador")]
        public int fkEntrenador { get; set; }
        [Required(ErrorMessage = "Selecciona el tipo de cita")]
        public string tipoCita { get;set;  }

        public string? estado { get; set; }

    }
}
