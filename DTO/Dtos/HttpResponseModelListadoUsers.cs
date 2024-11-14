namespace DTO.Dtos
{
    public class HttpResponseModelListadoUsers
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public List<ExistingUser> data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HttpResponseModelListadoUsers()
        {
            errors = new List<ErrorModel>();
        }
    }
}
