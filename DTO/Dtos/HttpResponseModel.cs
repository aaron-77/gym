namespace DTO.Dtos

{
    public class HttpResponseModel
    {
        
        public bool ok { get; set; }
        public string message { get; set; }
        public NewUser data { get; set; }
        public List<ErrorModel> errors { get; set;}
        public HttpResponseModel() { 
            errors = new List<ErrorModel>();
        }
    }
}
