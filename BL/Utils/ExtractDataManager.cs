using DTO.Dtos;
using System.Collections.Generic;

namespace BL.Utils
{
    public class ExtractDataManager
    {
        public static List<DTOUnidadDeMedida> extractMeasurementUnitData(List<DTOParametroDeMedicion> parametros)
        {
            try
            {
                List<DTOUnidadDeMedida> unidadesDeMedida =
                 parametros.Select(x => new DTOUnidadDeMedida
                 {
                     UnidadDeMedidaId = x.fkUnidadDeMedida,
                     Nombre = x.nombreUnidadDeMedida
                 }).ToList();

                return unidadesDeMedida;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: extractMeasurementUnitData - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Parámetro: {ex.ParamName} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                throw;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: extractMeasurementUnitData | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                throw;
            }
        }

        public static List<MesyAño> ObtenerMesesYAñosDeMedida(List<DTOUltimaMedidaDeParametro> medidas)
        {
            try
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
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerMesesYAñosDeMedida - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Parámetro: {ex.ParamName} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                throw;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerMesesYAñosDeMedida | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                throw;
            }
        }

    }
}