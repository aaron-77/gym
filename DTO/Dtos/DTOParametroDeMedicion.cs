namespace DTO.Dtos
{
    public class DTOParametroDeMedicion
    {
        public int parametroMedicionId { get; set; }
        public string nombre { get; set; }
        public int fkUnidadDeMedida { get; set; }
        public string nombreUnidadDeMedida { get; set; }
        public int? fkIcon { get; set; }
        
    }
}