using System.ComponentModel.DataAnnotations;

namespace DTO.Dtos
{
    public class DTOMedida
    {
        
        [Required(ErrorMessage = "Selecciona una medida")]
        public int? unidadDeMedidaId { get; set; }
       
        [Required(ErrorMessage = "Selecciona un usuario")]
        public string fkUsuario { get; set; }
        
        [Required(ErrorMessage = "Selecciona un parametro")]
        public int fkParametro { get; set; }
        
        public string? nombreParametro { get; set; }
        [Required(ErrorMessage = "Ingresa el valor")]
        public decimal valor { get; set; }
        
    

    }
}
