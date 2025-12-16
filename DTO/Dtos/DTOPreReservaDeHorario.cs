using System;

namespace DTO.Dtos
{
    public class DTOPreReservaDeHorario
    {
        
        public string? idUsuarioQueReserva { get; set; }
        public DateOnly fechaTentativa { get; set; }
        public int idHoraLaboral { get; set; }
        // Nuevos campos requeridos por los cambios en los procedimientos almacenados
        public int? idClase { get; set; }
        public string idEntrenador { get; set; }
    }
} 