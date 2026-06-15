using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace DataAccess.Infraestructure
{    
    /// <summary>
    /// Resultado de la ejecución de un procedimiento que retorna datos
    /// </summary>
    public class DatabaseQueryResult : DatabaseExecutionResult
    {
        public DataSet DataSet { get; set; }
        public Exception Exception { get; set; }
    }
}