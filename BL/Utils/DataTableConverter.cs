using System.Collections.Generic;
using System.Data;
using System.Reflection;

namespace BL.Utils
{
    public static class DataTableConverter
    {

        public static DataTable ConvertToDataTable(int[] dataList)
        {
            try
            {
                // Crear un nuevo DataTable
                DataTable convertedTable =   new DataTable();
                // Agregar una columna llamada "Value" para almacenar los enteros
                convertedTable.Columns.Add("Value", typeof(int));
                // Recorrer cada arreglo de enteros en la lista
                foreach (var intValue in dataList)
                {
                        var row = convertedTable.NewRow();
                            row["Value"] = intValue;
                            convertedTable.Rows.Add(row);   
                }
                return convertedTable;
            }
            catch (System.Exception ex)
            {
                string logMessage = $"[ERROR] Método: ConvertToDataTable(int[]) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                System.Console.WriteLine(logMessage);
                throw;
            }
        }


        public static DataTable ConvertToDataTable<T>(this IEnumerable<T> dataList) where T : class
        {
            try
            {
                DataTable convertedTable = new DataTable();
                // Verificar si T es un KeyValuePair (es decir, un diccionario)

                PropertyInfo[] propertyInfo = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
                foreach (PropertyInfo prop in propertyInfo)
                {
                    convertedTable.Columns.Add(prop.Name);
                }

                foreach (T item in dataList)
                {
                    var row = convertedTable.NewRow();
                    for (int i = 0; i < propertyInfo.Length; i++)
                    {
                        string dataColumnName = propertyInfo[i].Name;
                        var valorDeLaPropiedad = ProcesadorDePropiedadesDeObjetos.obtenerValorDePropiedad(item, dataColumnName);
                        row[dataColumnName] = valorDeLaPropiedad;
                    }
                    convertedTable.Rows.Add(row);
                }


                return convertedTable;
            }
            catch (System.Exception ex)
            {
                string logMessage = $"[ERROR] Método: ConvertToDataTable<T>(IEnumerable<T>) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                System.Console.WriteLine(logMessage);
                throw;
            }
        }

        public static DataTable ConvertToDataTable(List<Dictionary<string, int>> dataList)
        {
            try
            {
                DataTable convertedTable = new DataTable();

                foreach (Dictionary<string, int> dic in dataList)
                {
                    foreach (KeyValuePair<string, int> entry in dic)
                    {
                        // Crear columnas para clave y valor
                        Type tipoDelValor = dic.Values.GetType().GetGenericArguments()[0];
                        convertedTable.Columns.Add(entry.Key, tipoDelValor);
                    }

                    var row = convertedTable.NewRow();

                    foreach (KeyValuePair<string, int> entry in dic)
                    {
                        row[entry.Key] = entry.Value;
                    }
                    convertedTable.Rows.Add(row);
                    return convertedTable;
                }
                return convertedTable;
            }
            catch (System.Exception ex)
            {
                string logMessage = $"[ERROR] Método: ConvertToDataTable(List<Dictionary<string,int>>) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                System.Console.WriteLine(logMessage);
                throw;
            }
        }

        public static DataTable ConvertToDataTable<T>(T obj)
        {
            try
            {
                if (obj == null)
                    throw new System.ArgumentNullException(nameof(obj));

                var type = typeof(T);
                var properties = type.GetProperties(BindingFlags.Public | BindingFlags.Instance);

                var table = new DataTable(type.Name);

                // Crear columnas a partir de las propiedades
                foreach (var prop in properties)
                {
                    var propType = System.Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
                    table.Columns.Add(prop.Name, propType);
                }

                // Crear una fila con los valores
                var row = table.NewRow();
                foreach (var prop in properties)
                {
                    var value = prop.GetValue(obj) ?? DBNull.Value;
                    row[prop.Name] = value;
                }

                table.Rows.Add(row);
                return table;
            }
            catch (System.Exception ex)
            {
                string logMessage = $"[ERROR] Método: ConvertToDataTable<T>(T) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                System.Console.WriteLine(logMessage);
                throw;
            }
        }
            
        }
    }
