using System;
using System.Collections.Generic;

namespace DTO.Dtos
{
    public class DTOEstructuraDeClase
    {
        public int IdBloque { get; set; }
        public string NombreDeLaClase { get; set; }
        public int NumeroConsecutivoDelBloque { get; set; }
        public int DuracionMenorEnMinutos { get; set; }
        public int DuracionMayorEnMinutos { get; set; }
        public string TituloBloque { get; set; }
        public string DescripcionBloque { get; set; }
    }
}
