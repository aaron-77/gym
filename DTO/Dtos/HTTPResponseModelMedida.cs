namespace DTO.Dtos
{
    public class HTTPResponseModelMedida
    {
        public bool ok { get; set; }
        public string message { get; set; }
        public DTOMedida data { get; set; }
        public List<ErrorModel> errors { get; set; }
        public HTTPResponseModelMedida()
        {
            errors = new List<ErrorModel>();
        }
    }
}
