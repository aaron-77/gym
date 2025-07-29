
using System;

namespace DTO.Dtos
{
    public class DTOHorarioPreReservado
    {
        public int idPreReserva { get; set; }  
        public int idHora { get; set; }              // ID de la pre-reserva
        public DateTime fechaReservada { get; set; }         // Fecha reservada
        public TimeSpan horaInicio { get; set; }             // Hora de inicio
        public TimeSpan horaFin { get; set; }                // Hora de fin
        public int idUsuarioQueReserva { get; set; }         // ID del usuario que reserva
        public DateTime fechaDeExpiracionDeLaReserva { get; set; } // Fecha de expiración de la reserva
    }
}