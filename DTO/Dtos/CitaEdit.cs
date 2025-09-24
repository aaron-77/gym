using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DTO.CustomValidations;

namespace DTO.Dtos
{
    public class CitaEdit:BaseClass
    {
        [FechaMayorA(ErrorMessage = "Debes definir una fecha de inicio")]
        public DateTime fechaInicioCita { get; set; }
        [FechaMayorA(ErrorMessage = "Debes definir una fecha de finalización")]
        public DateTime fechaFinCita { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "Tienes que seleccionar un entrenador")]
        public int fkEntrenador { get; set; }
        
        public string? tipoCita { get; set; }
        [Required(ErrorMessage = "El estado no puede estar vacio")]
        public string estado { get; set; }


        
    }
}
