namespace DTO.Dtos
{
    public class MedidasConMetas
    {
        
        public List<DTOUltimaMedidaDeParametro> medidas { get; set; } = new List<DTOUltimaMedidaDeParametro>();
        public List<DTOUltimaMetaDeParametro> metasDeMedida { get; set; } = new List<DTOUltimaMetaDeParametro>();
        
    }
}