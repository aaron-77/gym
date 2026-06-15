// File: DTO/Dtos/DTOReagendacionDeInscripcion.cs
using System.ComponentModel.DataAnnotations;

namespace DTO.Dtos
{
    public class DTOReagendacionDeInscripcion
    {
        [Required]
        public int idInscripcionCancelada { get; set; }

        [Required]
        public int idClaseProgramadaNueva { get; set; }

        [Required]
        public string idCliente { get; set; }
    }
}