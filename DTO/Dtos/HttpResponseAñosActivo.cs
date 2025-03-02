namespace DTO.Dtos
{
    public class HttpResponseAñosActivo
    {
         public bool ok { get; set; }
        public string message { get; set; }
        public List<int> data { get; set; }
        
        public List<ErrorModel> errors { get; set; }
        public HttpResponseAñosActivo()
        {
            errors = new List<ErrorModel>();
        }
    }
}