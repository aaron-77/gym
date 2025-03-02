namespace DTO.Dtos
{
    public class HttpResponseEjerciciosYParametrosDelCliente
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public List<DTOEjerciciosYParametrosDelCliente> data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseEjerciciosYParametrosDelCliente()
        {
            errors = new List<ErrorModel>();
        }
    }

   
}