namespace DTO.Dtos
{
    public class DTOHorariosDisponibles
    {
        public int idHora { get; set; }
        public DateTime fechaDisponible { get; set; }
        public TimeSpan horaInicio { get; set; }
        public TimeSpan horaFin { get; set; }
        public string diaDeLaSemana { get; set; } // Día de la semana
        public string tipoDeDia { get; set; } // Tipo de día (por ejemplo
        // Agrega aquí cualquier otra propiedad que tenga DTOHorarioVisualizacion excepto idPreReserva
    }
}