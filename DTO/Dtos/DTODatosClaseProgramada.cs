using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
namespace DTO.Dtos
{
    public class DTODatosClaseProgramada
    {
        public int fkClase { get; set; }
        public int fkEntrenador { get; set; }
        public int cupoMaximo { get; set; }
        public int fkEstadoClaseProgramada { get; set; }
        public DateOnly fechaDeLaClase { get; set; } // Use DateTime for SQL date storage
        public int idUsuarioQueReserva { get; set; }
        public int fkHoraLaboral { get; set; }
        public int idPreservaDeHorario { get; set; }
    }

 
}
