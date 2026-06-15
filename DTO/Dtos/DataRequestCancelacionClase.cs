using System;

namespace DTO.Dtos
{
    public class DataRequestCancelacionClase
    {
        public int idProgramacionClase { get; set; }
        public DateTime fechaDeReferencia { get; set; }
        public int idEntrenador { get; set; }
        public int idClase { get; set; }
    }
} 