using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
namespace DTO.Dtos
{
    public class DTODatosClaseProgramada
    {
        [Required(ErrorMessage = "La clase es obligatoria")]
        [Range(1, int.MaxValue, ErrorMessage = "El id de la clase debe ser mayor a 1")]
        public int? fkClase { get; set; }

        [Required(ErrorMessage = "El entrenador es obligatorio")]
        
        public string fkEntrenador { get; set; }

        [Required(ErrorMessage = "El cupo máximo es obligatorio")]
        [Range(1, int.MaxValue, ErrorMessage = "El cupo máximo debe ser mayor o igual a 1")]
        public int cupoMaximo { get; set; }

        [Required(ErrorMessage = "El estado de la clase programada es obligatorio")]
        [Range(1, int.MaxValue, ErrorMessage = "El estado debe ser mayor o igual a 1")]
        public int fkEstadoClaseProgramada { get; set; }

        [Required(ErrorMessage = "La fecha de la clase es obligatoria")]
        [DataType(DataType.Date, ErrorMessage = "La fecha debe ser válida")]
        [CustomValidation(typeof(DTODatosClaseProgramada), nameof(ValidarFechaNoMenorActual))]
        public DateOnly? fechaDeLaClase { get; set; }

        [Required(ErrorMessage = "El usuario que reserva es obligatorio")]
        public string idUsuarioQueReserva { get; set; }

        [Required(ErrorMessage = "La hora laboral es obligatoria")]
        [Range(1, int.MaxValue, ErrorMessage = "El id de la hora laboral debe ser mayor o igual a 0")]
        public int fkHoraLaboral { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "El id de preserva de horario debe ser mayor o igual a 0")]
        public int? idPreservaDeHorario { get; set; }

        public static ValidationResult ValidarFechaNoMenorActual(DateOnly? fecha, ValidationContext context)
        {
            if (fecha < DateOnly.FromDateTime(DateTime.Now.Date))
            {
                return new ValidationResult("La fecha de la clase no puede ser menor a la fecha actual");
            }
            return ValidationResult.Success;
        }
    }

 
}
