using System;

namespace DTO.Dtos
{
    public class DTOPreReservaDeHorario
    {
        
        public int idUsuarioQueReserva { get; set; }
        public DateOnly fechaTentativa { get; set; }
        public int idHoraLaboral { get; set; }
    }
} 