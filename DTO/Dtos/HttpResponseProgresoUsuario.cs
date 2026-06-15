namespace DTO.Dtos
{
    public class HttpResponseProgresoUsuario
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public List<DTOItemProgreso> data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseProgresoUsuario()
        {
            errors = new List<ErrorModel>();
        }
    }
}