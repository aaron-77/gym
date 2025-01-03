namespace DTO.Dtos
{
    public class DTOUltimaMedidaDeParametro
    {
        public int MedidaId { get; set; }
        public int FkParametro { get; set; }
        public string NombreParametro { get; set; }
        public decimal Valor { get; set; }
        public DateTime FechaDeCreacion { get; set; }
        public int UnidadDeMedidaId { get; set; }
        public string NombreUnidadDeMedida { get; set; }
        public int FkEjercicio { get; set; }
        public string NombreEjercicio { get; set; }
    }
}