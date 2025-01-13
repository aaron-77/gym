
using DTO.Enums;
namespace DTO.Dtos
{
    public class ProgresoElement
    {
        public string datoPrincipal { get; set; }
        public string datoSecundario { get; set; }
        public string titulo{get;set;}
        public string unidadDeMedida {get;set;}
        public TipoDeElemento tipoDeElemento { get; set; }
    }

    
}