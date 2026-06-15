using System.ComponentModel.DataAnnotations;
using DTO.CustomValidations;

namespace DTO.Dtos
{
    public class ConsultarRutinasRequest
    {
        [RequiredGuid(ErrorMessage = "El ID de usuario es requerido")]
        public string? UsuarioID { get; set; }
    }
}
