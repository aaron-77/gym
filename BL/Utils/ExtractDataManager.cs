using DTO.Dtos;
using System.Collections.Generic;

namespace BL.Utils
{
    public class ExtractDataManager
    {
        public static List<DTOUnidadDeMedida> extractMeasurementUnitData(List<DTOParametroDeMedicion> parametros)
        {
            List<DTOUnidadDeMedida> unidadesDeMedida =
             parametros.Select(x => new DTOUnidadDeMedida
             {
                 UnidadDeMedidaId = x.fkUnidadDeMedida,
                 Nombre = x.nombreUnidadDeMedida
             }).ToList();

            return unidadesDeMedida;
        }
        public static List<MesyAño> ObtenerMesesYAñosDeMedida(List<DTOUltimaMedidaDeParametro> medidas)
        {
            // Filtrar y devolver una lista única de meses y años
            return medidas
                .Select(m => new MesyAño
                {
                    medidaId = m.medidaId,
                    Mes = m.fechaDeCreacion.Month,
                    Año = m.fechaDeCreacion.Year
                })
                .Distinct() // Garantizar unicidad
                .ToList();
        }

    }
}