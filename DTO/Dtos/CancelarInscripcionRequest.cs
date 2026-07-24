using System.ComponentModel.DataAnnotations;

namespace DTO.Dtos
{
    public class CancelarInscripcionRequest
    {
        [Required(ErrorMessage = "El ID de inscripción es requerido")]
        [Range(1, int.MaxValue, ErrorMessage = "El ID de inscripción debe ser mayor a 0")]
        public int IdInscripcion { get; set; }
    }
}
