using System;

namespace DTO.Dtos
{
    public class DTOClaseProgramadaView
    {
        public int idClaseProgramada { get; set; }
        public int fkClase { get; set; }
        public DateTime fechaDeLaClase { get; set; }
        public int idHora { get; set; }
        public TimeSpan horaInicio { get; set; }
        public TimeSpan horaFin { get; set; }
        public string labelHorario { get; set; }
        public int fkEntrenador { get; set; }
        public string nombreEntrenador { get; set; }
        public int cupoMaximo { get; set; }
        public int cupoDisponible { get; set; }
    }
}