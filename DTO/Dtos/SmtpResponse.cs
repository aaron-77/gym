namespace DTO.Dtos
{
    public class SmtpResponse
    {
        public bool IsSuccess { get; }
        public string Message { get; }

        public SmtpResponse(bool isSuccess, string message)
        {
            IsSuccess = isSuccess;
            Message = message;
        }
    }
}