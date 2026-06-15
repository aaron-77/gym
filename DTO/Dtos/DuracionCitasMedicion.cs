using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO.Dtos
{
    public class DuracionCitasMedicion:BaseClass
    {
        [Range(1, int.MaxValue, ErrorMessage = "La duración debe ser mayor a 0")]
        [Required(ErrorMessage = "Ingresa la duracion")]
        public int duracion { get; set; }
        [Range(1, int.MaxValue, ErrorMessage = "La frecuencia debe ser mayor a 0")]
        [Required(ErrorMessage = "Ingresa la frecuencia de las notificaciones")]
        public int frecuenciaNotificaciones { get; set; }
    }
}
