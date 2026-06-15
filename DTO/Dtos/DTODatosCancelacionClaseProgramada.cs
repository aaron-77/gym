using System;
using System.ComponentModel.DataAnnotations;

namespace DTO.Dtos
{
    public class DTODatosCancelacionClaseProgramada
    {
        [Required(ErrorMessage = "El id de programación es obligatorio")]
        [Range(1, int.MaxValue, ErrorMessage = "El id de programación debe ser mayor a 0")]
        public int idProgramacionClase {get;set;}
        
        public int fkClase { get; set; }
        public string fkEntrenador { get; set; }
        public int cupoMaximo { get; set; }
        public int fkEstadoClaseProgramada { get; set; }
        public DateOnly fechaDeLaClase { get; set; } // Use DateTime for SQL date storage
        public string idUsuarioQueReserva { get; set; }
        public int fkHoraLaboral { get; set; }
        public int idPreservaDeHorario { get; set; }
    }
} 