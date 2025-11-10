using System.Text.Json;
using System.Text.Json.Serialization;
namespace BL.Utils
{
    public class ConsejosStringToArrayConverter : JsonConverter<List<string>>
    {
        public override List<string> Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            // Lee el string crudo
            string raw = reader.GetString();

            if (string.IsNullOrWhiteSpace(raw))
                return new List<string>();

            // Lo divide por comas y limpia espacios
            return new List<string>(
                raw.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
            );
        }

        public override void Write(Utf8JsonWriter writer, List<string> value, JsonSerializerOptions options)
        {
            // Convierte la lista a un string separado por comas
            writer.WriteStringValue(string.Join(", ", value));
        }
    }
}