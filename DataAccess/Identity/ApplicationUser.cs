using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Identity;
namespace DataAccess.Identity;

public class ApplicationUser : IdentityUser
{
    // Puedes agregar aquí propiedades personalizadasD

    public string NombreCompleto { get; set; }
    [MaxLength(50)]
    public string Apellido { get; set; }
    
    public string NumeroDeIdentificacion { get; set; }
    public string Direccion { get; set; }
    public DateTime FechaDeNacimiento { get; set; }
    public DateTime FechaDeRegistro { get; set; }

    public int? IdAntiguo { get; set; } 
    [MaxLength(50)]
    public string Estado { get; set; } = "activo"; // activo, inactivo, suspendido

}
