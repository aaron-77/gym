using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
namespace DTO.Dtos
{
    public class UserCredentials
    {
        [Required(ErrorMessage = "Introduce una cuenta de correo")]
        [EmailAddress(ErrorMessage = "El correo no es válido")]
        public string correo { get; set; }
        [Required(ErrorMessage = "No ingresaste tu contraseña")]
        public string contrasena { get; set; }
    }
}
