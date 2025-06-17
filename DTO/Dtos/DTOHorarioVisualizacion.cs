
using System;

namespace DTO.Dtos
{
    public class DTOHorarioVisualizacion
    {
        public int idHora { get; set; }          // ID de la hora
        public string diaDeLaSemana { get; set; } // Día de la semana
        public DateTime fechaDisponible { get; set; } // Fecha disponible
        public TimeSpan horaInicio { get; set; }  // Hora de inicio
        public TimeSpan horaFin { get; set; }     // Hora de fin
        public string tipoDeDia { get; set; }     // Tipo de día (por ejemplo, "Laboral", "Fin de semana", etc.)
    }
}