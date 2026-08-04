namespace DTO.Dtos
{
    public class DTOInscripcionDelCliente
    {
        public int IdInscripcion { get; set; }
        public DateTime FechaDeInscripcion { get; set; }
        public int IdClaseProgramada { get; set; }
        public int FkClase { get; set; }
        public string NombreClase { get; set; } = string.Empty;
        public DateTime FechaDeLaClase { get; set; }
        public TimeSpan HoraInicio { get; set; }
        public TimeSpan HoraFin { get; set; }
        public string NombreEntrenador { get; set; } = string.Empty;
    }
}
