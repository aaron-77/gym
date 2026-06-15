using System.ComponentModel.DataAnnotations;

namespace DTO.Dtos
{
    public class OTPCodeVerification
    {
        [Required(ErrorMessage = "El código es requerido")]
        public string codigo { get; set; }
        
        [Required(ErrorMessage = "El celular es requerido")]
        public string cel { get; set; }
        
        [Required(ErrorMessage = "El correo es requerido")]
        public string? correo { get; set; }
    }
}