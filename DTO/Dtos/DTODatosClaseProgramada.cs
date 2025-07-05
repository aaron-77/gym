using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
namespace DTO.Dtos
{
    public class DTODatosClaseProgramada
    {
        [Required(ErrorMessage = "La clase es requerida")]
        [Range(1, int.MaxValue, ErrorMessage = "El ID de la clase debe ser mayor a 0")]
        public int fkClase { get; set; }

        [Required(ErrorMessage = "El entrenador es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "Debe seleccionar un entrenador")]
        public int fkEntrenador { get; set; }

        [Required(ErrorMessage = "El cupo máximo es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El cupo máximo debe ser mayor a 0")]
        public int cupoMaximo { get; set; }

        [Required(ErrorMessage = "El estado de la clase programada es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El estado debe ser mayor a 0")]
        public int fkEstadoClaseProgramada { get; set; }

        [Required(ErrorMessage = "La fecha de la clase es requerida")]
        public DateOnly fechaDeLaClase { get; set; } // Use DateTime for SQL date storage

        [Required(ErrorMessage = "El ID del usuario que reserva es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El ID del usuario debe ser mayor a 0")]
        public int idUsuarioQueReserva { get; set; }

        [Required(ErrorMessage = "La hora laboral es requerida")]
        [Range(1, int.MaxValue, ErrorMessage = "El ID de la hora laboral debe ser mayor a 0")]
        public int fkHoraLaboral { get; set; }

        [Required(ErrorMessage = "El ID de pre-reserva de horario es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El ID de pre-reserva debe ser mayor a 0")]
        public int idPreservaDeHorario { get; set; }
    }

 
}
