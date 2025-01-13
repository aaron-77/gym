namespace DTO.Dtos
{
    public class DTOUltimaMedidaDeParametro
    {
        public int medidaId { get; set; }
        public int fkParametro { get; set; }
        public string nombreParametro { get; set; }
        public decimal valor { get; set; }
        public DateTime fechaDeCreacion { get; set; }
        public int unidadDeMedidaId { get; set; }
        public string nombreUnidadDeMedida { get; set; }
        public int? fkEjercicio { get; set; }
        public string? nombreEjercicio { get; set; }
        public string? urlIconoParametro { get; set; }
        public string? urlIconoEjercicio { get; set; }
        public int fkUsuario { get; set; }
    }
}