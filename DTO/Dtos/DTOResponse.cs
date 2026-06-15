namespace DTO.Dtos
{
    public class DTOResponse<T>
    {
        public bool success { get; set; }
        public int httpCode { get; set; }
        public string message { get; set; }
        public List<ErrorModel> errors { get; set; }
        public T payload { get; set; }

        public DTOResponse()
        {
            errors = new List<ErrorModel>();
        }
    }
}
