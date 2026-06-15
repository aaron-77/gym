using DTO.CustomValidations;
using System.ComponentModel.DataAnnotations;

namespace DTO.Dtos
{
    public class User:BaseClass
    {
        [Required(ErrorMessage = "Ingresa tu nombre")]
        public string Nombre { get; set; }
        [Required(ErrorMessage = "Ingresa tu apellido")]
        public string Apellido { get; set; }
        [Required(ErrorMessage = "Ingresa tu fecha de nacimiento")]
        [DataType(DataType.Date)]
        public DateTime FechaDeNacimiento { get; set; }  // Usamos DateTime para representar una fecha
        [Required(ErrorMessage = "Ingresa tu direccion")]
        public string Direccion { get; set; }
        [Required(ErrorMessage = "Ingresa tu CURP")]
        [RegularExpression(
            @"^[A-Z]{4}\d{6}[HM][A-Z]{2}[B-DF-HJ-NP-TV-Z]{3}[A-Z0-9]\d$",
            ErrorMessage = "La CURP no tiene un formato válido")]
        public string Curp { get; set; }

        [Required(ErrorMessage = "Ingresa tu correo")]
        [EmailAddress(ErrorMessage = "Correo no válido")]
        public string Correo { get; set; }
        [Required(ErrorMessage = "Ingresa tu telefono")]
        public string Telefono { get; set; }    
        [Required(ErrorMessage = "Ingresa tu contraseña")]
        public string Contrasena { get; set; }
		[Required(ErrorMessage = "Ingresa tu contraseña")]
        [ValidarPassword]
        public string ContrasenaConfirmacion { get; set; }


	}
}
