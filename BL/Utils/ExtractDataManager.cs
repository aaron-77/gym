using DTO.Dtos;

using System.Collections.Generic;
namespace BL.Utils
{
    public class ExtractDataManager
    {
        public static  List<DTOUnidadDeMedida> extractMeasurementUnitData(List<DTOParametroDeMedicion> parametros)
        {
            List<DTOUnidadDeMedida> unidadesDeMedida =
             parametros.Select(x => new DTOUnidadDeMedida
            {
                UnidadDeMedidaId = x.fkUnidadDeMedida,
                Nombre = x.nombreUnidadDeMedida
            }).ToList();
            
            return unidadesDeMedida;
        }
        
    }
}