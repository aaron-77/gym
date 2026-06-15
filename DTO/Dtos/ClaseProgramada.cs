using System;
using System.Collections.Generic;

namespace DTO.Dtos
{
    public class ClaseProgramada
    {
        public int IdProgramacionClase { get; set; }
        public string NombreClase { get; set; }
        public string DiaDeLaSemana { get; set; } // Always from the current year
        public string HoraInicio { get; set; }
        public string HoraFin { get; set; }
        public string NombreEntrenador { get; set; }
    }
}
