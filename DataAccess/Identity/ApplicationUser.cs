using Microsoft.AspNetCore.Identity;

public class ApplicationUser : IdentityUser
{
    // Puedes agregar aquí propiedades personalizadasD

    public string NombreCompleto { get; set; }
    public string NumeroDeIdentificacion { get; set; }
    public string Direccion { get; set; }
    public DateTime FechaDeNacimiento { get; set; }

}
