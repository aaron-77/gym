using Microsoft.AspNetCore.Identity;

public class ApplicationUser : IdentityUser
{
    // Puedes agregar aquí propiedades personalizadas
    
    public string NombreCompleto { get; set; }

}
