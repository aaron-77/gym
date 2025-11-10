namespace DTO.Dtos
{
    public class ResponseParametroDeMedicion
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public List<DTOParametroDeMedicion> data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public ResponseParametroDeMedicion()
        {
            errors = new List<ErrorModel>();
        }
    }
}