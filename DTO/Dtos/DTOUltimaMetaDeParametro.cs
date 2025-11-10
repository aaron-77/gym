namespace DTO.Dtos
{
    public class DTOUltimaMetaDeParametro
    {
        public int metaId { get; set; }
        public string intencion { get; set; }
        public string nombreParametro { get; set; }
        public string? nombreEjercicio { get; set; }
        public decimal valorObjetivo { get; set; }
        public string nombreNivelDeLogro { get; set; }
        public DateTime fechaDeInicioDeLaMeta { get; set; }
        public DateTime fechaLimite { get; set; }
        public int? fkEjercicio { get; set; }
        public int fkParametro { get; set; }
        public string fkUsuario { get; set; }
    }
}