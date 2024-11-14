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
        [Required(ErrorMessage = "Ingresa la duracion")]
        public int duracion { get; set; }
        [Required(ErrorMessage = "Ingresa la frecuencia de las notificaciones")]
        public int frecuenciaNotificaciones { get; set; }
    }
}
