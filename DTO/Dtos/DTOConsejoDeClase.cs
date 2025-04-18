using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;
using BL.Utils;

namespace DTO.Dtos
{
    public class DTOConsejoDeClase
    {
        public int FkClase { get; set; }
        public string IntroduccionDeConsejo { get; set; }
         
        public List<string> Consejos { get; set; }
        }
}
