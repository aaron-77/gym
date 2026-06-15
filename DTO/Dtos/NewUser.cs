using System.ComponentModel.DataAnnotations;
namespace DTO.Dtos
{
    public class NewUser
    {
        

        [Required(ErrorMessage = "Ingresa tu nombre")]
        public string Nombre { get; set; }
        [Required(ErrorMessage = "Ingresa tu apellido")]
        public string Apellido { get; set; }

        [Required(ErrorMessage = "Ingresa tu fecha de nacimiento")]
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

        [Required(ErrorMessage = "Ingresa el rol para el usuario")]
        public string Rol { get; set; } = "cliente"; // Por defecto, el rol es Cliente
        [Required(ErrorMessage = "El usuario requiere un estado")]
        public string Estado { get; set; } = "activo"; // Por defecto, el estado es activo
        
        public NewUser(
        string nombre,
        DateTime fechaDeNacimiento,
        string direccion,
        string curp,
        string correo,
        string telefono,
        string apellido,
        string contrasena,
        string rol = "cliente",
        string estado = "activo"
        )
        {
            Nombre = nombre;
            FechaDeNacimiento = fechaDeNacimiento;
            Direccion = direccion;
            Curp = curp;
            Correo = correo;
            Telefono = telefono;
            Apellido = apellido;
            Contrasena = contrasena;
            Rol = rol;
            Estado = estado;
        }

    }
}
