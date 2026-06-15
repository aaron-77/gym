using DTO.Dtos;

namespace BL.Utils
{
    public class ObjectAssembler
    {
        public static List<DTOItemProgreso> ensamblarItemsProgreso
        (
           List<DTOUltimaMedidaDeParametro> medidas,
           List<DTOUltimaMetaDeParametro> metas)
        {
            try
            {
                List<DTOItemProgreso> itemsProgresoList = new List<DTOItemProgreso>();
                
                medidas.ForEach(medida =>
                {
                    DTOItemProgreso itemProgreso = new DTOItemProgreso();
                    var metaDeLaMedida = metas.FirstOrDefault(meta => meta.fkUsuario == medida.fkUsuario 
                                                                    && meta.fkParametro == medida.fkParametro 
                                                                    && meta.fkEjercicio == medida.fkEjercicio);
                    if (metaDeLaMedida == null){
                        Console.WriteLine("No se encontró una meta para la medida");
                    }
                    itemProgreso.medida = medida;
                    itemProgreso.meta = metaDeLaMedida;
                    itemsProgresoList.Add(itemProgreso);
                });
                return itemsProgresoList;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: ensamblarItemsProgreso - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Parámetro: {ex.ParamName} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                throw;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ensamblarItemsProgreso | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                throw;
            }
        }

        public static List<DatosMetaDeMedida> ensamblarDatosMetaDeMedida(int[]? meses, int[]? años)
        {
            try
            {
                List<DatosMetaDeMedida> datosMetaDeMedidaList = new List<DatosMetaDeMedida>();
                
                // Handle null cases
                if (meses == null || meses.Length == 0)
                {
                    return datosMetaDeMedidaList; // Return empty list
                }
                
                // Ensure años is not null or empty
                if (años == null || años.Length == 0)
                {
                    años = new int[] { 0 }; // Default year to avoid index issues
                }
                
                for (int index = 0; index < meses.Length; index++)
                {
                    DatosMetaDeMedida datosMetaDeMedida = new DatosMetaDeMedida();
                    datosMetaDeMedida.mes = meses[index];
                    datosMetaDeMedida.año = (index < años.Length) ? años[index] : años[años.Length - 1];
                    datosMetaDeMedidaList.Add(datosMetaDeMedida);
                }
                return datosMetaDeMedidaList;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: ensamblarDatosMetaDeMedida - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Parámetro: {ex.ParamName} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                throw;
            }
            catch (IndexOutOfRangeException ex)
            {
                string logMessage = $"[ERROR] Método: ensamblarDatosMetaDeMedida - IndexOutOfRangeException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                throw;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ensamblarDatosMetaDeMedida | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                throw;
            }
        }
    }
}