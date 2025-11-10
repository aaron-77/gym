using System.Collections.Generic;
using DTO.Dtos;

namespace BL.Utils
{
    public static class ResponseManager
    {
        public static DTOResponse<T> BuildResponse<T>(
            bool success,
            int httpCode,
            string message,
            List<ErrorModel> errors,
            T payload)
        {
            return new DTOResponse<T>
            {
                success = success,
                httpCode = httpCode,
                message = message,
                errors = errors ?? new List<ErrorModel>(),
                payload = payload
            };
        }
    }
}
