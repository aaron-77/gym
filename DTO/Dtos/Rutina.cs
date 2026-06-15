using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class Rutina
    {
        public int? RutinaId { get; set; }
        [Required(ErrorMessage = "Ingresa el cliente")]
        
        public string? UsuarioID { get; set; }
        [Required(ErrorMessage = "Ingresa el entrenador")]
        public string? EntrenadorID { get; set; }
        [Required(ErrorMessage = "Ingresa la feccha")]
        public DateTime FechaCreacion { get; set; }
        [Required(ErrorMessage = "Ingresa las observaciones")]
        public string? Observaciones { get; set; }
    }
}
