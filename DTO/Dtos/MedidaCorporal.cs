using System.ComponentModel.DataAnnotations;

namespace DTO.Dtos
{
    public class MedidaCorporal:BaseClass
    {
        [Required(ErrorMessage = "Ingresa el peso")]
        public decimal peso { get; set; }
        [Required(ErrorMessage = "Ingresa la altura")]
        public decimal altura { get; set; }
        [Required(ErrorMessage = "Selecciona un usuario")]
        public int fkUsuario { get; set; }
        [Required(ErrorMessage = "Es imc es obligatorio")]
        public decimal imc { get; set; }
        [Required(ErrorMessage = "Ingresa tu edad")]
        public int edad { get; set; }
        [Required(ErrorMessage = "Ingresa el genero")]
        public string genero { get; set; }

    }
}
