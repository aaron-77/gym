using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
namespace DTO.Dtos
{
    public class DTOClaseProgramada
    {
        
        public int IdProgramacionClase { get; set; }
        [Required]
        public int FkClase { get; set; }
        [Required]
        public DateTime FechaInicio { get; set; }
        [Required]
        public DateTime FechaFin { get; set; }
        [Required]
        public int FkEntrenador { get; set; }
        [Required]
        public int CupoMaximo { get; set; }
        public int FkEstadoClaseProgramada { get; set; }
        [Required]
        public string fkHorarioLaboral {get;set;}
        [Required]
        public DateTime fechaDeLaClase { get; set; }
        [Required]
        public int idUsuarioQueReserva { get; set; }
        [Required]
        public int fkHoraLaboral { get; set; }
        public int idPreservaDeHorario { get; set; }
    }
}
