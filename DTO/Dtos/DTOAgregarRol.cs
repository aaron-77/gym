using System.ComponentModel.DataAnnotations;
// DTO para recibir la información
public class  DTOAgregarRol
{

    [Required(ErrorMessage = "El ID de usuario es obligatorio")]
    public string UserId { get; set; }

    [Required(ErrorMessage = "El rol es obligatorio")]
    public string Role { get; set; }
}
