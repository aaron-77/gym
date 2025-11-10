using DTO.Dtos;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Reflection;

namespace BL.Utils
{
    public static class SqlCommandHelper
    {
        public static SqlCommand CreateSqlCommand(SqlConnection connection, string query, CommandType commandType, params SqlParameter[] parameters)
        {
            if (connection == null)
            {
                throw new ArgumentNullException(nameof(connection), "La conexión no puede ser nula.");
            }
            if (string.IsNullOrWhiteSpace(query))
            {
                throw new ArgumentException("La consulta SQL no puede estar vacía.", nameof(query));
            }

            // Crear el comando
            SqlCommand command = connection.CreateCommand();
            command.CommandText = query;
            command.CommandType = commandType;

            // Agregar parámetros si los hay
            if (parameters != null && parameters.Length > 0)
            {
                command.Parameters.AddRange(parameters);
            }

            return command;
        }

        public static async Task<SqlDataReader> ExecuteCommandAsync(SqlCommand command)
        {
            if (command == null)
            {
                throw new ArgumentNullException(nameof(command), "El comando SQL no puede ser nulo.");
            }

            try
            {
                return await command.ExecuteReaderAsync();
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("Error al ejecutar el comando SQL.", ex);
            }
        }
        public static SqlDataReader ExecuteCommand(SqlCommand command)
        {
            if (command == null)
            {
                throw new ArgumentNullException(nameof(command), "El comando SQL no puede ser nulo.");
            }

            try
            {
                return command.ExecuteReader();
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("Error al ejecutar el comando SQL.", ex);
            }
        }

        public static List<T> MapToList<T>(SqlDataReader reader) where T : class, new()
        {
            if (reader == null)
            {
                throw new ArgumentNullException(nameof(reader), "El SqlDataReader no puede ser nulo.");
            }

            List<T> resultList = new List<T>();

            try
            {
                while (reader.Read())
                {
                    T obj = new T();

                    foreach (PropertyInfo property in typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance))
                    {
                        if (reader.HasColumn(property.Name) && !reader.IsDBNull(reader.GetOrdinal(property.Name)))
                        {
                            property.SetValue(obj, reader[property.Name]);
                        }
                    }

                    resultList.Add(obj);
                }
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException("Error al mapear los resultados a objetos.", ex);
            }

            return resultList;
        }

        public static void AddParameter(SqlCommand command, string parameterName, SqlDbType dbType, object value,int? lengthType = null)
        {
            if (command == null)
            {
                throw new ArgumentNullException(nameof(command), "El comando no puede ser nulo.");
            }

            if (string.IsNullOrWhiteSpace(parameterName))
            {
                throw new ArgumentException("El nombre del parámetro no puede estar vacío o ser nulo.", nameof(parameterName));
            }
            var parameter = command.CreateParameter();
            parameter.ParameterName = parameterName;
            parameter.SqlDbType = dbType;
            if (lengthType != null)
            {
                parameter.Size = lengthType.Value;
            }
            parameter.Value = value ?? DBNull.Value; // Si el valor es nulo, asignar DBNull
            command.Parameters.Add(parameter);
        }

        public static void AddParameters(SqlCommand command, Dictionary<string, (SqlDbType DbType, object Value, int? lengthType)> parameters)
        {
            if (command == null)
            {
                throw new ArgumentNullException(nameof(command), "El comando no puede ser nulo.");
            }

            if (parameters == null || parameters.Count == 0)
            {
                throw new ArgumentException("El diccionario de parámetros no puede estar vacío o ser nulo.", nameof(parameters));
            }

            foreach (var param in parameters)
            {
                AddParameter(command,param.Key,param.Value.DbType,param.Value.Value,param.Value.lengthType);
            }
        }

        public static bool HasColumn(this SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
                {
                    return true;
                }
            }
            return false;
        }
    }
}