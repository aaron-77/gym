using System.ComponentModel.DataAnnotations;

namespace DTO.Dtos
{
    public class ReagendarInscripcionRequest
    {
        [Required(ErrorMessage = "El ID de inscripción es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El ID de inscripción debe ser mayor a 0")]
        public int IdInscripcion { get; set; }

        [Required(ErrorMessage = "El ID de clase programada es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El ID de clase programada debe ser mayor a 0")]
        public int IdClaseProgramada { get; set; }

        [Required(ErrorMessage = "El ID del cliente es requerido")]
        public string IdCliente { get; set; } = string.Empty;
    }
}
