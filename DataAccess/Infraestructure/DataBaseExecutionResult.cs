namespace DataAccess.Infraestructure
{
    
/// <summary>
    /// Resultado de la ejecución de un procedimiento almacenado o función
    /// </summary>
    public class DatabaseExecutionResult
    {
        public Dictionary<string, object> OutputParameters { get; set; } = new Dictionary<string, object>();
        public int ReturnValue { get; set; }
        public int RecordsAffected { get; set; }
        public bool Success { get; set; } = true;
        public string ErrorMessage { get; set; }
        public Exception Exception { get; set; }
    }
}