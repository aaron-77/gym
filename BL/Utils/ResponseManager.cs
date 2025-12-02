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
            try
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
            catch (System.Exception ex)
            {
                string logMessage = $"[ERROR] Método: BuildResponse | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                System.Console.WriteLine(logMessage);
                throw;
            }
        }
    }
}
