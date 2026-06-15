using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DTO.CustomValidations;

namespace DTO.Dtos
{
    public class Cita:BaseClass
    {

        [Required(ErrorMessage = "Selecciona la fecha de incio")]
        [FechaInicioMenorQueFin]
        public DateTime fechaInicioCita { get; set; }
       
        [Required(ErrorMessage = "Selecciona la fecha de finalizacion")]
        [FechaInicioMenorQueFin]
        public DateTime fechaFinCita { get; set; }
       
        [Required(ErrorMessage = "Selecciona un cliente")]
        [RegularExpression(@"^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", ErrorMessage = "Selecciona un cliente")]
        public string fkCliente { get; set; }
       
        [Required(ErrorMessage = "Selecciona un entrenador")]
        [RegularExpression(@"^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", ErrorMessage = "Selecciona un entrenador")]
        public string fkEntrenador { get; set; }
       
        [Required(ErrorMessage = "Selecciona el tipo de cita")]
        [RegularExpression(@"^(?i)(m[eé]dici[óo]n|entrenamiento\s+personal)$", ErrorMessage = "Selecciona el tipo de cita (medición o entrenamiento personal)")]
        public string tipoCita { get;set;  }

        public string? estado { get; set; }

    }
}
