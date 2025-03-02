using DTO.Dtos;

namespace BL.Utils
{
    public class ObjectAssembler
    {
        public static List<DTOItemProgreso> ensamblarItemsProgreso
        (List<DTOUltimaMedidaDeParametro> medidas,
        List<DTOUltimaMetaDeParametro> metas)
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
        public static List<DatosMetaDeMedida> ensamblarDatosMetaDeMedida(int[]? meses,int[]? años){
                List<DatosMetaDeMedida> datosMetaDeMedidaList = new List<DatosMetaDeMedida>();
                for(int index = 0;index < meses.Length;index ++){
                    DatosMetaDeMedida datosMetaDeMedida = new DatosMetaDeMedida();
                    datosMetaDeMedida.mes = meses[index];
                    datosMetaDeMedida.año = años[index];
                    datosMetaDeMedidaList.Add(datosMetaDeMedida);
                }
                return datosMetaDeMedidaList;
        }
    }
}