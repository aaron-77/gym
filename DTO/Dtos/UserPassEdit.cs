using System.ComponentModel.DataAnnotations;

namespace DTO.Dtos
{
    public class UserPassEdit
    {
        [Required(ErrorMessage = "El correo es obligatorio.")]
        [EmailAddress(ErrorMessage = "El correo no tiene un formato válido.")]
        public string Email { get; set; }

        [Required(ErrorMessage = "La nueva contraseña es obligatoria.")]
        public string NewPassword { get; set; }

        [Required(ErrorMessage = "La confirmación de la contraseña es obligatoria.")]
        [Compare("NewPassword", ErrorMessage = "La contraseña de confirmación no coincide con la nueva contraseña.")]
        public string ConfirmPassword { get; set; }
    }
}