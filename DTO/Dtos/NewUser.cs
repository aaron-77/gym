using System.ComponentModel.DataAnnotations;
namespace DTO.Dtos
{
    public class NewUser
    {
        

        [Required(ErrorMessage = "Ingresa tu nombre")]
        public string NombreCompleto { get; set; }
        [Required(ErrorMessage = "Ingresa tu apellido")]
        public string Apellido { get; set; }

        [Required(ErrorMessage = "Ingresa tu fecha de nacimiento")]
        public DateTime FechaDeNacimiento { get; set; }  // Usamos DateTime para representar una fecha
        [Required(ErrorMessage = "Ingresa tu direccion")]
        public string Direccion { get; set; }
        [Required(ErrorMessage = "Ingresa tu numero de identificacion")]        
        public string NumeroDeIdentificacion { get; set; }
        
        [Required(ErrorMessage = "Ingresa tu correo")]
        [EmailAddress(ErrorMessage = "Correo no válido")]
        public string Correo { get; set; }
        [Required(ErrorMessage = "Ingresa tu telefono")]
        public string Telefono { get; set; }
        [Required(ErrorMessage = "Ingresa tu contraseña")]
        public string Contrasena { get; set; }

        
        public NewUser(
        string nombreCompleto,
        DateTime fechaDeNacimiento,
        string direccion,
        string numeroDeIdentificacion,
        string correo,
        string telefono,
        string apellido,
        string contrasena
        )
        {
            NombreCompleto = nombreCompleto;
            FechaDeNacimiento = fechaDeNacimiento;
            Direccion = direccion;
            NumeroDeIdentificacion = numeroDeIdentificacion;
            Correo = correo;
            Telefono = telefono;
            Apellido = apellido;
            Contrasena = contrasena;
        }

    }
}
